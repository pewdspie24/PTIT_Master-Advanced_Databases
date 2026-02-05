from flask import Blueprint, render_template, request, redirect, url_for, flash
from sqlalchemy import text
from datetime import datetime
from models import db, HopDong, KhachHang, NhanVien

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
    """Query contracts expiring in specified days"""
    # Get parameters from user or use defaults
    days_threshold = request.args.get('days', type=int) or 30
    
    query = text("""
        SELECT 
            hd.maHopDong, 
            kh.maKhachHang,
            kh.tenKhachHang,
            hd.ngayBatDau, 
            DATE_ADD(hd.ngayBatDau, INTERVAL hd.thoiHan MONTH) AS NgayHetHan
        FROM HopDong hd
        JOIN KhachHang kh ON hd.maKhachHang = kh.maKhachHang
        WHERE DATE_ADD(hd.ngayBatDau, INTERVAL hd.thoiHan MONTH) <= DATE_ADD(CURDATE(), INTERVAL :days_threshold DAY)
          AND hd.trangThai = 'HieuLuc'
        ORDER BY NgayHetHan ASC
    """)
    
    result = db.session.execute(query, {'days_threshold': days_threshold})
    expiring_contracts = result.fetchall()
    
    return render_template('contracts/expiring.html', 
                         expiring_contracts=expiring_contracts,
                         days_threshold=days_threshold,
                         now=datetime.now)


@bp.route('/<string:id>')
def detail(id):
    """View contract details"""
    contract = HopDong.query.get_or_404(id)
    return render_template('contracts/detail.html', contract=contract)


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
