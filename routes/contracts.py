from flask import Blueprint, render_template, request, redirect, url_for, flash
from sqlalchemy import text
from datetime import datetime
from models import db, HopDong, KhachHang, NhanVien, ChiNhanh, NhanVienQuanLy

bp = Blueprint('contracts', __name__, url_prefix='/contracts')

@bp.route('/')
def list():
    """List all contracts"""
    contracts = db.session.query(
        HopDong.maHopDong,
        HopDong.ngayBatDau,
        HopDong.thoiHan,
        HopDong.trangThai,
        KhachHang.tenKhachHang
    ).join(
        KhachHang, HopDong.maKhachHang == KhachHang.maKhachHang
    ).order_by(HopDong.ngayBatDau.desc()).all()
    
    return render_template('contracts/list.html', contracts=contracts)


@bp.route('/expiring')
def expiring():
    """Query contracts expiring in specified years"""
    # Get parameters from user or use defaults
    years_threshold = request.args.get('years', type=int) or 1
    
    query = text("""
        SELECT 
            hd.maHopDong, 
            kh.maKhachHang,
            kh.tenKhachHang,
            hd.ngayBatDau, 
            DATE_ADD(hd.ngayBatDau, INTERVAL hd.thoiHan YEAR) AS NgayHetHan
        FROM HopDong hd
        JOIN KhachHang kh ON hd.maKhachHang = kh.maKhachHang
        WHERE DATE_ADD(hd.ngayBatDau, INTERVAL hd.thoiHan YEAR) BETWEEN CURDATE() 
          AND DATE_ADD(CURDATE(), INTERVAL :years_threshold YEAR)
          AND hd.trangThai = 'Hieu luc'
        ORDER BY NgayHetHan ASC
    """)
    
    result = db.session.execute(query, {'years_threshold': years_threshold})
    expiring_contracts = result.fetchall()
    
    return render_template('contracts/expiring.html', 
                         expiring_contracts=expiring_contracts,
                         years_threshold=years_threshold,
                         now=datetime.now)


@bp.route('/<string:id>')
def detail(id):
    """View contract details"""
    contract_data = db.session.query(
        HopDong.maHopDong,
        HopDong.ngayKy,
        HopDong.ngayBatDau,
        HopDong.trangThai,
        HopDong.thoiHan,
        KhachHang.tenKhachHang,
        ChiNhanh.ten.label('tenChiNhanh'),
        NhanVien.ho,
        NhanVien.tenRieng
    ).join(
        KhachHang, HopDong.maKhachHang == KhachHang.maKhachHang
    ).join(
        ChiNhanh, HopDong.maChiNhanh == ChiNhanh.maChiNhanh
    ).join(
        NhanVien, HopDong.maNVQuanLy == NhanVien.maNhanVien
    ).filter(
        HopDong.maHopDong == id
    ).first_or_404()
    
    return render_template('contracts/detail.html', contract=contract_data)


@bp.route('/add', methods=['GET', 'POST'])
def add():
    """Add new contract"""
    if request.method == 'POST':
        try:
            query = text("""
                INSERT INTO HopDong (maHopDong, ngayKy, ngayBatDau, trangThai, thoiHan, maChiNhanh, maNVQuanLy, maKhachHang)
                VALUES (:ma_hd, :ngay_ky, :ngay_bat_dau, :trang_thai, :thoi_han, :ma_chi_nhanh, :ma_nv_ql, :ma_kh)
            """)
            
            db.session.execute(query, {
                'ma_hd': request.form['maHopDong'],
                'ngay_ky': request.form['ngayKy'],
                'ngay_bat_dau': request.form['ngayBatDau'],
                'trang_thai': request.form.get('trangThai', 'Hieu luc'),
                'thoi_han': request.form['thoiHan'],
                'ma_chi_nhanh': request.form['maChiNhanh'],
                'ma_nv_ql': request.form['maNVQuanLy'],
                'ma_kh': request.form['maKhachHang']
            })
            db.session.commit()
            
            flash('Thêm hợp đồng thành công!', 'success')
            return redirect(url_for('contracts.detail', id=request.form['maHopDong']))
        except Exception as e:
            db.session.rollback()
            flash(f'Lỗi: {str(e)}', 'danger')
    
    # Get data for dropdowns
    customers = KhachHang.query.all()
    branches = ChiNhanh.query.all()
    managers = db.session.query(
        NhanVien.maNhanVien,
        NhanVien.ho,
        NhanVien.tenRieng
    ).join(
        NhanVienQuanLy, NhanVien.maNhanVien == NhanVienQuanLy.maNhanVienQuanLy
    ).all()
    
    return render_template('contracts/form.html',
                         customers=customers,
                         branches=branches,
                         managers=managers,
                         contract=None)


@bp.route('/edit/<string:id>', methods=['GET', 'POST'])
def edit(id):
    """Edit existing contract"""
    contract = HopDong.query.get_or_404(id)
    
    if request.method == 'POST':
        try:
            query = text("""
                UPDATE HopDong 
                SET ngayKy = :ngay_ky, 
                    ngayBatDau = :ngay_bat_dau, 
                    trangThai = :trang_thai, 
                    thoiHan = :thoi_han,
                    maChiNhanh = :ma_chi_nhanh,
                    maNVQuanLy = :ma_nv_ql,
                    maKhachHang = :ma_kh
                WHERE maHopDong = :ma_hd
            """)
            
            db.session.execute(query, {
                'ma_hd': id,
                'ngay_ky': request.form['ngayKy'],
                'ngay_bat_dau': request.form['ngayBatDau'],
                'trang_thai': request.form['trangThai'],
                'thoi_han': request.form['thoiHan'],
                'ma_chi_nhanh': request.form['maChiNhanh'],
                'ma_nv_ql': request.form['maNVQuanLy'],
                'ma_kh': request.form['maKhachHang']
            })
            db.session.commit()
            
            flash('Cập nhật hợp đồng thành công!', 'success')
            return redirect(url_for('contracts.detail', id=id))
        except Exception as e:
            db.session.rollback()
            flash(f'Lỗi: {str(e)}', 'danger')
    
    # Get data for dropdowns
    customers = KhachHang.query.all()
    branches = ChiNhanh.query.all()
    managers = db.session.query(
        NhanVien.maNhanVien,
        NhanVien.ho,
        NhanVien.tenRieng
    ).join(
        NhanVienQuanLy, NhanVien.maNhanVien == NhanVienQuanLy.maNhanVienQuanLy
    ).all()
    
    return render_template('contracts/form.html',
                         customers=customers,
                         branches=branches,
                         managers=managers,
                         contract=contract)


@bp.route('/support/add', methods=['GET', 'POST'])
def add_support():
    """Add customer support record"""
    if request.method == 'POST':
        try:
            query = text("""
                INSERT INTO NV_HoTro_KhachHang (maNVHoTro, maKhachHang, ngayHoTro, lyDoHoTro)
                VALUES (:ma_nv, :ma_kh, :ngay, :ly_do)
            """)
            
            db.session.execute(query, {
                'ma_nv': request.form['maNVHoTro'],
                'ma_kh': request.form['maKhachHang'],
                'ngay': datetime.now(),
                'ly_do': request.form['lyDoHoTro']
            })
            db.session.commit()
            
            flash('Thêm hỗ trợ khách hàng thành công!', 'success')
            return redirect(url_for('contracts.support_history', customer_id=request.form['maKhachHang']))
        except Exception as e:
            db.session.rollback()
            flash(f'Lỗi: {str(e)}', 'danger')
    
    # Get support staff and customers for form
    support_staff = db.session.query(
        NhanVien.maNhanVien,
        NhanVien.ho,
        NhanVien.tenRieng
    ).join(
        db.session.query(text('maNhanVienHoTro')).select_from(text('NhanVienHoTro'))
    ).all()
    
    customers = KhachHang.query.all()
    
    return render_template('contracts/support_form.html',
                         support_staff=support_staff,
                         customers=customers)


@bp.route('/support/<string:customer_id>')
def support_history(customer_id):
    """Query customer support history"""
    query = text("""
        SELECT 
            ht.ngayHoTro, 
            ht.lyDoHoTro, 
            CONCAT(nv.ho, ' ', nv.tenRieng) AS NhanVienXuLy
        FROM NV_HoTro_KhachHang ht
        JOIN NhanVien nv ON ht.maNVHoTro = nv.maNhanVien
        WHERE ht.maKhachHang = :customer_id
        ORDER BY ht.ngayHoTro DESC
    """)
    
    result = db.session.execute(query, {'customer_id': customer_id})
    support_history = result.fetchall()
    
    customer = KhachHang.query.get_or_404(customer_id)
    
    return render_template('contracts/support_history.html',
                         support_history=support_history,
                         customer=customer)
