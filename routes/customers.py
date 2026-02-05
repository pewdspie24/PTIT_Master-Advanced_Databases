from flask import Blueprint, render_template, request, redirect, url_for, flash
from sqlalchemy import or_, func
from models import db, KhachHang, SDT_KhachHang, BangGiaDien, ChiNhanh

bp = Blueprint('customers', __name__, url_prefix='/customers')

@bp.route('/')
def list():
    """List all customers with search functionality"""
    search = request.args.get('search', '')
    page = request.args.get('page', 1, type=int)
    per_page = 20
    
    query = db.session.query(
        KhachHang.maKhachHang,
        KhachHang.tenKhachHang,
        KhachHang.diaChi,
        BangGiaDien.tenBang.label('loaiGiaDien'),
        func.group_concat(SDT_KhachHang.soDienThoai.op('SEPARATOR')(', ')).label('danhSachSDT')
    ).outerjoin(
        SDT_KhachHang, KhachHang.maKhachHang == SDT_KhachHang.maKhachHang
    ).join(
        BangGiaDien, KhachHang.maBangGiaDien == BangGiaDien.ma
    )
    
    if search:
        # Search by customer ID, name, or phone
        query = query.filter(
            or_(
                KhachHang.maKhachHang.like(f'%{search}%'),
                KhachHang.tenKhachHang.like(f'%{search}%'),
                SDT_KhachHang.soDienThoai.like(f'%{search}%')
            )
        )
    
    query = query.group_by(KhachHang.maKhachHang)
    
    # Paginate results
    customers = query.paginate(page=page, per_page=per_page, error_out=False)
    
    return render_template('customers/list.html', 
                         customers=customers, 
                         search=search)


@bp.route('/<string:id>')
def detail(id):
    """View customer details"""
    customer = KhachHang.query.get_or_404(id)
    return render_template('customers/detail.html', customer=customer)


@bp.route('/add', methods=['GET', 'POST'])
def add():
    """Add new customer"""
    if request.method == 'POST':
        try:
            # Create customer
            customer = KhachHang(
                maKhachHang=request.form['maKhachHang'],
                tenKhachHang=request.form['tenKhachHang'],
                maSoThue=request.form.get('maSoThue'),
                diaChi=request.form['diaChi'],
                maChiNhanh=request.form['maChiNhanh'],
                maBangGiaDien=request.form['maBangGiaDien']
            )
            db.session.add(customer)
            
            # Add phone numbers
            phones = request.form.getlist('soDienThoai[]')
            for phone in phones:
                if phone.strip():
                    sdt = SDT_KhachHang(
                        maKhachHang=customer.maKhachHang,
                        soDienThoai=phone.strip()
                    )
                    db.session.add(sdt)
            
            db.session.commit()
            flash('Thêm khách hàng thành công!', 'success')
            return redirect(url_for('customers.detail', id=customer.maKhachHang))
        except Exception as e:
            db.session.rollback()
            flash(f'Lỗi: {str(e)}', 'danger')
    
    # Get branches and pricing tables for form
    branches = ChiNhanh.query.all()
    pricing_tables = BangGiaDien.query.all()
    
    return render_template('customers/form.html', 
                         branches=branches,
                         pricing_tables=pricing_tables)


@bp.route('/edit/<string:id>', methods=['GET', 'POST'])
def edit(id):
    """Edit customer"""
    customer = KhachHang.query.get_or_404(id)
    
    if request.method == 'POST':
        try:
            customer.tenKhachHang = request.form['tenKhachHang']
            customer.maSoThue = request.form.get('maSoThue')
            customer.diaChi = request.form['diaChi']
            customer.maChiNhanh = request.form['maChiNhanh']
            customer.maBangGiaDien = request.form['maBangGiaDien']
            
            db.session.commit()
            flash('Cập nhật khách hàng thành công!', 'success')
            return redirect(url_for('customers.detail', id=id))
        except Exception as e:
            db.session.rollback()
            flash(f'Lỗi: {str(e)}', 'danger')
    
    branches = ChiNhanh.query.all()
    pricing_tables = BangGiaDien.query.all()
    
    return render_template('customers/form.html', 
                         customer=customer,
                         branches=branches,
                         pricing_tables=pricing_tables)
