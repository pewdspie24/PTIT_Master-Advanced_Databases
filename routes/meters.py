from flask import Blueprint, render_template, request, redirect, url_for, flash
from sqlalchemy import text, func
from datetime import datetime, timedelta
from models import db, CongToDien, ChiSoDienHangThang, KhachHang, NhanVienLapDat, NhanVien

bp = Blueprint('meters', __name__, url_prefix='/meters')

@bp.route('/')
def list():
    """List all electric meters"""
    meters = db.session.query(
        CongToDien.maCongTo,
        CongToDien.ngayLapDat,
        CongToDien.hanSuDung,
        KhachHang.tenKhachHang,
        KhachHang.diaChi
    ).join(
        KhachHang, CongToDien.maKhachHang == KhachHang.maKhachHang
    ).all()
    
    return render_template('meters/list.html', meters=meters)


@bp.route('/<string:id>')
def detail(id):
    """View meter details and consumption history"""
    meter = CongToDien.query.get_or_404(id)
    
    # Get consumption history
    consumption_history = db.session.query(
        ChiSoDienHangThang.ngayGhiNhan,
        ChiSoDienHangThang.soDienCu,
        ChiSoDienHangThang.soDienMoi,
        (ChiSoDienHangThang.soDienMoi - ChiSoDienHangThang.soDienCu).label('tieuThu')
    ).filter(
        ChiSoDienHangThang.maCongTo == id
    ).order_by(
        ChiSoDienHangThang.ngayGhiNhan.desc()
    ).limit(12).all()
    
    return render_template('meters/detail.html', 
                         meter=meter,
                         consumption_history=consumption_history)


@bp.route('/maintenance-alerts')
def maintenance_alerts():
    """Show meters requiring maintenance using stored procedure"""
    # Call stored procedure sp_CanhBaoBaoTri
    result = db.session.execute(text("CALL sp_CanhBaoBaoTri()"))
    alerts = result.fetchall()
    
    return render_template('meters/maintenance_alerts.html', alerts=alerts)


@bp.route('/abnormal-consumption')
def abnormal_consumption():
    """Show meters with abnormal consumption (doubled from previous month)"""
    # Get parameters from user or use defaults
    current_month = request.args.get('month', type=int) or datetime.now().month
    current_year = request.args.get('year', type=int) or datetime.now().year
    
    # Calculate previous month/year
    if current_month == 1:
        prev_month = 12
        prev_year = current_year - 1
    else:
        prev_month = current_month - 1
        prev_year = current_year
    
    # Query for meters with consumption doubled from specified month
    query = text("""
        SELECT 
            t1.maCongTo,
            kh.tenKhachHang,
            kh.diaChi,
            (t1.soDienMoi - t1.soDienCu) AS SanLuongThangNay,
            (t2.soDienMoi - t2.soDienCu) AS SanLuongThangTruoc,
            ((t1.soDienMoi - t1.soDienCu) - (t2.soDienMoi - t2.soDienCu)) AS ChenhLech
        FROM ChiSoDienHangThang t1
        JOIN ChiSoDienHangThang t2 ON t1.maCongTo = t2.maCongTo
        JOIN CongToDien ct ON t1.maCongTo = ct.maCongTo
        JOIN KhachHang kh ON ct.maKhachHang = kh.maKhachHang
        WHERE YEAR(t1.ngayGhiNhan) = :current_year
          AND MONTH(t1.ngayGhiNhan) = :current_month
          AND YEAR(t2.ngayGhiNhan) = :prev_year
          AND MONTH(t2.ngayGhiNhan) = :prev_month
          AND (t1.soDienMoi - t1.soDienCu) > 2 * (t2.soDienMoi - t2.soDienCu)
        ORDER BY ChenhLech DESC
    """)
    
    result = db.session.execute(query, {
        'current_year': current_year,
        'current_month': current_month,
        'prev_year': prev_year,
        'prev_month': prev_month
    })
    abnormal_meters = result.fetchall()
    
    return render_template('meters/abnormal_consumption.html', 
                         abnormal_meters=abnormal_meters,
                         selected_month=current_month,
                         selected_year=current_year)


@bp.route('/edit/<string:id>', methods=['GET', 'POST'])
def edit(id):
    """Edit existing electric meter"""
    meter = CongToDien.query.get_or_404(id)
    
    if request.method == 'POST':
        try:
            query = text("""
                UPDATE CongToDien 
                SET giaMua = :gia_mua, hanSuDung = :han_su_dung, 
                    ngayLapDat = :ngay_lap_dat, maCongTy = :ma_cong_ty,
                    maKhachHang = :ma_khach_hang, maNVLapDat = :ma_nv_lap_dat
                WHERE maCongTo = :ma_cong_to
            """)
            
            db.session.execute(query, {
                'ma_cong_to': id,
                'gia_mua': request.form['giaMua'],
                'han_su_dung': request.form['hanSuDung'],
                'ngay_lap_dat': request.form['ngayLapDat'],
                'ma_cong_ty': request.form['maCongTy'],
                'ma_khach_hang': request.form['maKhachHang'],
                'ma_nv_lap_dat': request.form['maNhanVienLapDat']
            })
            db.session.commit()
            
            flash('Cập nhật công tơ điện thành công!', 'success')
            return redirect(url_for('meters.detail', id=id))
        except Exception as e:
            db.session.rollback()
            flash(f'Lỗi: {str(e)}', 'danger')
    
    customers = KhachHang.query.all()
    installers = db.session.query(
        NhanVien.maNhanVien,
        NhanVien.ho,
        NhanVien.tenRieng
    ).join(
        NhanVienLapDat, NhanVien.maNhanVien == NhanVienLapDat.maNhanVienLapDat
    ).all()
    companies = db.session.execute(text("SELECT DISTINCT maCongTy, tenCongTy FROM CongTy")).fetchall()
    
    return render_template('meters/edit.html',
                         meter=meter,
                         customers=customers,
                         installers=installers,
                         companies=companies)


@bp.route('/add', methods=['GET', 'POST'])
def add():
    """Add new electric meter for customer"""
    if request.method == 'POST':
        try:
            query = text("""
                INSERT INTO CongToDien (maCongTo, giaMua, hanSuDung, ngayLapDat, maCongTy, maKhachHang, maNhanVienLapDat)
                VALUES (:ma_cong_to, :gia_mua, :han_su_dung, :ngay_lap_dat, :ma_cong_ty, :ma_khach_hang, :ma_nv_lap_dat)
            """)
            
            db.session.execute(query, {
                'ma_cong_to': request.form['maCongTo'],
                'gia_mua': request.form['giaMua'],
                'han_su_dung': request.form['hanSuDung'],
                'ngay_lap_dat': request.form.get('ngayLapDat', datetime.now().date()),
                'ma_cong_ty': request.form['maCongTy'],
                'ma_khach_hang': request.form['maKhachHang'],
                'ma_nv_lap_dat': request.form['maNhanVienLapDat']
            })
            db.session.commit()
            
            flash('Thêm công tơ điện thành công!', 'success')
            return redirect(url_for('meters.detail', id=request.form['maCongTo']))
        except Exception as e:
            db.session.rollback()
            flash(f'Lỗi: {str(e)}', 'danger')
    
    # Get customers and installation technicians for form
    customers = KhachHang.query.all()
    
    installers = db.session.query(
        NhanVien.maNhanVien,
        NhanVien.ho,
        NhanVien.tenRieng
    ).join(
        NhanVienLapDat, NhanVien.maNhanVien == NhanVienLapDat.maNhanVienLapDat
    ).all()
    
    # Get list of meter companies
    companies = db.session.execute(text("SELECT DISTINCT maCongTy, tenCongTy FROM CongTy")).fetchall()
    
    return render_template('meters/form.html',
                         customers=customers,
                         installers=installers,
                         companies=companies)


@bp.route('/extend-warranty/<string:id>', methods=['POST'])
def extend_warranty(id):
    """Extend meter warranty by specified years"""
    try:
        years = int(request.form.get('years', 2))
        
        query = text("""
            UPDATE CongToDien
            SET hanSuDung = hanSuDung + :years
            WHERE maCongTo = :ma_cong_to
        """)
        
        db.session.execute(query, {
            'years': years,
            'ma_cong_to': id
        })
        db.session.commit()
        
        flash(f'Gia hạn công tơ thêm {years} năm thành công!', 'success')
    except Exception as e:
        db.session.rollback()
        flash(f'Lỗi: {str(e)}', 'danger')
    
    return redirect(url_for('meters.detail', id=id))
