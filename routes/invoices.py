from flask import Blueprint, render_template, request, redirect, url_for, flash
from sqlalchemy import text, func
from datetime import datetime, timedelta
from models import db, HoaDon, ChiSoDienHangThang, CongToDien, KhachHang, SDT_KhachHang, KeToan, NhanVien

bp = Blueprint('invoices', __name__, url_prefix='/invoices')

@bp.route('/')
def list():
    """List all invoices with filters"""
    status_filter = request.args.get('status', '')
    
    query = db.session.query(
        HoaDon.maCongTo,
        HoaDon.ngayGhiNhan,
        HoaDon.ngayLapDon,
        HoaDon.trangThaiTT,
        KhachHang.tenKhachHang,
        (ChiSoDienHangThang.soDienMoi - ChiSoDienHangThang.soDienCu).label('tieuThu')
    ).join(
        ChiSoDienHangThang, 
        (HoaDon.maCongTo == ChiSoDienHangThang.maCongTo) & 
        (HoaDon.ngayGhiNhan == ChiSoDienHangThang.ngayGhiNhan)
    ).join(
        CongToDien, ChiSoDienHangThang.maCongTo == CongToDien.maCongTo
    ).join(
        KhachHang, CongToDien.maKhachHang == KhachHang.maKhachHang
    )
    
    if status_filter:
        query = query.filter(HoaDon.trangThaiTT == status_filter)
    
    invoices = query.order_by(HoaDon.ngayLapDon.desc()).all()
    
    return render_template('invoices/list.html', 
                         invoices=invoices,
                         status_filter=status_filter)


@bp.route('/overdue')
def overdue():
    """List overdue invoices (>days threshold)"""
    # Get threshold from user or use default
    days_threshold = request.args.get('days', type=int) or 30
    
    query = text("""
        SELECT 
            hd.maCongTo,
            ANY_VALUE(kh.maKhachHang) AS maKhachHang,
            ANY_VALUE(kh.tenKhachHang) AS tenKhachHang,
            ANY_VALUE(kh.diaChi) AS diaChi,
            GROUP_CONCAT(DISTINCT sdt.soDienThoai SEPARATOR ', ') AS soDienThoai,
            hd.ngayLapDon,
            DATEDIFF(CURDATE(), hd.ngayLapDon) AS SoNgayTre
        FROM HoaDon hd
        JOIN ChiSoDienHangThang cs ON hd.maCongTo = cs.maCongTo AND hd.ngayGhiNhan = cs.ngayGhiNhan
        JOIN CongToDien ct ON cs.maCongTo = ct.maCongTo
        JOIN KhachHang kh ON ct.maKhachHang = kh.maKhachHang
        LEFT JOIN SDT_KhachHang sdt ON kh.maKhachHang = sdt.maKhachHang
        WHERE hd.trangThaiTT = 'Chua thanh toan'
          AND DATEDIFF(CURDATE(), hd.ngayLapDon) > :days_threshold
        GROUP BY hd.maCongTo, hd.ngayLapDon
        ORDER BY SoNgayTre DESC
    """)
    
    result = db.session.execute(query, {'days_threshold': days_threshold})
    overdue_invoices = result.fetchall()
    
    return render_template('invoices/overdue.html', 
                         overdue_invoices=overdue_invoices,
                         days_threshold=days_threshold)


@bp.route('/update-status/<string:meter_id>/<string:date>', methods=['POST'])
def update_status(meter_id, date):
    """Update invoice payment status"""
    new_status = request.form.get('status')
    
    try:
        invoice = HoaDon.query.filter_by(
            maCongTo=meter_id,
            ngayGhiNhan=datetime.strptime(date, '%Y-%m-%d').date()
        ).first_or_404()
        
        invoice.trangThaiTT = new_status
        db.session.commit()
        
        flash('Cập nhật trạng thái hóa đơn thành công!', 'success')
    except Exception as e:
        db.session.rollback()
        flash(f'Lỗi: {str(e)}', 'danger')
    
    return redirect(url_for('invoices.list'))


@bp.route('/add', methods=['GET', 'POST'])
def add():
    """Add new invoice"""
    if request.method == 'POST':
        try:
            query = text("""
                INSERT INTO HoaDon (maCongTo, ngayGhiNhan, trangThaiTT, ngayLapDon, maKeToan)
                VALUES (:ma_cong_to, :ngay_ghi_nhan, :trang_thai, :ngay_lap_don, :ma_ke_toan)
            """)
            
            db.session.execute(query, {
                'ma_cong_to': request.form['maCongTo'],
                'ngay_ghi_nhan': request.form['ngayGhiNhan'],
                'trang_thai': request.form.get('trangThaiTT', 'Chua thanh toan'),
                'ngay_lap_don': request.form.get('ngayLapDon', datetime.now().date()),
                'ma_ke_toan': request.form['maKeToan']
            })
            db.session.commit()
            
            flash('Thêm hóa đơn thành công!', 'success')
            return redirect(url_for('invoices.list'))
        except Exception as e:
            db.session.rollback()
            flash(f'Lỗi: {str(e)}', 'danger')
    
    # Get available meter readings that don't have invoices yet
    available_readings = db.session.query(
        ChiSoDienHangThang.maCongTo,
        ChiSoDienHangThang.ngayGhiNhan,
        KhachHang.tenKhachHang,
        (ChiSoDienHangThang.soDienMoi - ChiSoDienHangThang.soDienCu).label('tieuThu')
    ).join(
        CongToDien, ChiSoDienHangThang.maCongTo == CongToDien.maCongTo
    ).join(
        KhachHang, CongToDien.maKhachHang == KhachHang.maKhachHang
    ).outerjoin(
        HoaDon,
        (ChiSoDienHangThang.maCongTo == HoaDon.maCongTo) &
        (ChiSoDienHangThang.ngayGhiNhan == HoaDon.ngayGhiNhan)
    ).filter(
        HoaDon.maCongTo.is_(None)  # Only readings without invoices
    ).all()
    
    # Get accountants
    accountants = db.session.query(
        NhanVien.maNhanVien,
        NhanVien.ho,
        NhanVien.tenRieng
    ).join(
        KeToan, NhanVien.maNhanVien == KeToan.maKeToan
    ).all()
    
    return render_template('invoices/form.html',
                         available_readings=available_readings,
                         accountants=accountants,
                         today=datetime.now().strftime('%Y-%m-%d'))


@bp.route('/calculate/<string:meter_id>/<string:date>')
def calculate(meter_id, date):
    """Calculate bill amount for meter reading"""
    try:
        # Calculate electricity bill using tiered pricing
        query = text("""
            SELECT 
                cs.maCongTo,
                cs.ngayGhiNhan,
                (cs.soDienMoi - cs.soDienCu) AS sanLuong,
                kh.maBangGiaDien,
                kh.tenKhachHang
            FROM ChiSoDienHangThang cs
            JOIN CongToDien ct ON cs.maCongTo = ct.maCongTo
            JOIN KhachHang kh ON ct.maKhachHang = kh.maKhachHang
            WHERE cs.maCongTo = :meter_id AND cs.ngayGhiNhan = :date
        """)
        
        result = db.session.execute(query, {'meter_id': meter_id, 'date': date})
        reading = result.fetchone()
        
        if not reading:
            flash('Không tìm thấy chỉ số điện', 'danger')
            return redirect(url_for('invoices.list'))
        
        san_luong = reading.sanLuong
        ma_bang_gia = reading.maBangGiaDien
        
        # Get price tiers
        tier_query = text("""
            SELECT thuTuCapBac, giaDienTrenKwh, tuSoDien, toiSoDien
            FROM BacGiaDien
            WHERE maBangGia = :ma_bang_gia
            ORDER BY thuTuCapBac ASC
        """)
        
        tiers = db.session.execute(tier_query, {'ma_bang_gia': ma_bang_gia}).fetchall()
        
        # Calculate total cost
        tong_tien = 0
        remaining = san_luong
        
        for tier in tiers:
            if remaining <= 0:
                break
            
            if tier.toiSoDien is None:
                # Last tier - unlimited
                kwh_in_tier = remaining
            else:
                kwh_in_tier = min(tier.toiSoDien - tier.tuSoDien, remaining)
            
            tong_tien += kwh_in_tier * float(tier.giaDienTrenKwh)
            remaining -= kwh_in_tier
        
        return render_template('invoices/calculate.html',
                             meter_id=meter_id,
                             date=date,
                             tong_tien=tong_tien,
                             customer_name=reading.tenKhachHang,
                             consumption=san_luong)
    except Exception as e:
        flash(f'Lỗi tính tiền: {str(e)}', 'danger')
        return redirect(url_for('invoices.list'))
