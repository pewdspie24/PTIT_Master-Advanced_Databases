from flask import Blueprint, render_template, request, redirect, url_for, flash
from sqlalchemy import text, func
from datetime import datetime, timedelta
from models import db, HoaDon, ChiSoDienHangThang, CongToDien, KhachHang, SDT_KhachHang

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


@bp.route('/calculate/<string:meter_id>/<string:date>')
def calculate(meter_id, date):
    """Calculate bill amount using stored procedure sp_TinhTienDien"""
    try:
        # Call stored procedure
        query = text("""
            CALL sp_TinhTienDien(:meter_id, :date, @tong_tien);
            SELECT @tong_tien AS tongTien;
        """)
        
        db.session.execute(query, {'meter_id': meter_id, 'date': date})
        result = db.session.execute(text("SELECT @tong_tien AS tongTien"))
        tong_tien = result.fetchone()[0]
        
        return render_template('invoices/calculate.html',
                             meter_id=meter_id,
                             date=date,
                             tong_tien=tong_tien)
    except Exception as e:
        flash(f'Lỗi tính tiền: {str(e)}', 'danger')
        return redirect(url_for('invoices.list'))
