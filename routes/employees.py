from flask import Blueprint, render_template, request, redirect, url_for, flash
from sqlalchemy import case, text
from datetime import datetime
from models import db, NhanVien, NhanVienQuanLy, NhanVienLapDat, NhanVienHoTro, KeToan, ChiNhanh

bp = Blueprint('employees', __name__, url_prefix='/employees')

@bp.route('/')
def list():
    """List all employees by role"""
    branch_filter = request.args.get('branch', '')
    role_filter = request.args.get('role', '')
    
    # Query with role detection
    query = db.session.query(
        NhanVien.maNhanVien,
        NhanVien.ho,
        NhanVien.tenDem,
        NhanVien.tenRieng,
        NhanVien.email,
        NhanVien.trangThai,
        ChiNhanh.ten.label('tenChiNhanh'),
        case(
            (NhanVienQuanLy.maNhanVienQuanLy.isnot(None), 'Quản Lý'),
            (KeToan.maKeToan.isnot(None), 'Kế Toán'),
            (NhanVienLapDat.maNhanVienLapDat.isnot(None), 'Lắp Đặt'),
            (NhanVienHoTro.maNhanVienHoTro.isnot(None), 'Hỗ Trợ'),
            else_='Nhân viên khác'
        ).label('vaiTro')
    ).join(
        ChiNhanh, NhanVien.maChiNhanh == ChiNhanh.maChiNhanh
    ).outerjoin(
        NhanVienQuanLy, NhanVien.maNhanVien == NhanVienQuanLy.maNhanVienQuanLy
    ).outerjoin(
        KeToan, NhanVien.maNhanVien == KeToan.maKeToan
    ).outerjoin(
        NhanVienLapDat, NhanVien.maNhanVien == NhanVienLapDat.maNhanVienLapDat
    ).outerjoin(
        NhanVienHoTro, NhanVien.maNhanVien == NhanVienHoTro.maNhanVienHoTro
    )
    
    if branch_filter:
        query = query.filter(NhanVien.maChiNhanh == branch_filter)
    
    employees = query.all()
    branches = ChiNhanh.query.all()
    
    return render_template('employees/list.html', 
                         employees=employees,
                         branches=branches,
                         branch_filter=branch_filter)


@bp.route('/<string:id>')
def detail(id):
    """View employee details"""
    employee = NhanVien.query.get_or_404(id)
    return render_template('employees/detail.html', employee=employee)


@bp.route('/edit/<string:id>', methods=['GET', 'POST'])
def edit(id):
    """Edit existing employee"""
    employee = NhanVien.query.get_or_404(id)
    
    if request.method == 'POST':
        try:
            role = request.form['role']
            
            # Update parent table
            query_nv = text("""
                UPDATE NhanVien 
                SET maSoThue = :mst, email = :email, ngaySinh = :ngay_sinh, 
                    ho = :ho, tenDem = :ten_dem, tenRieng = :ten_rieng, maChiNhanh = :ma_chi_nhanh
                WHERE maNhanVien = :ma_nv
            """)
            
            db.session.execute(query_nv, {
                'ma_nv': id,
                'mst': request.form['maSoThue'],
                'email': request.form['email'],
                'ngay_sinh': request.form['ngaySinh'],
                'ho': request.form['ho'],
                'ten_dem': request.form.get('tenDem', ''),
                'ten_rieng': request.form['tenRieng'],
                'ma_chi_nhanh': request.form['maChiNhanh']
            })
            
            # Update role-specific table
            if role == 'LapDat':
                db.session.execute(text("DELETE FROM NhanVienLapDat WHERE maNhanVienLapDat = :ma_nv"), {'ma_nv': id})
                query_role = text("""
                    INSERT INTO NhanVienLapDat (maNhanVienLapDat, soTheKyThuat, ccAnToanDien)
                    VALUES (:ma_nv, :the_kt, :cc_atd)
                    ON DUPLICATE KEY UPDATE soTheKyThuat = :the_kt, ccAnToanDien = :cc_atd
                """)
                db.session.execute(query_role, {
                    'ma_nv': id,
                    'the_kt': request.form['soTheKyThuat'],
                    'cc_atd': request.form['ccAnToanDien']
                })
            
            db.session.commit()
            flash('Cập nhật nhân viên thành công!', 'success')
            return redirect(url_for('employees.detail', id=id))
        except Exception as e:
            db.session.rollback()
            flash(f'Lỗi: {str(e)}', 'danger')
    
    branches = ChiNhanh.query.all()
    return render_template('employees/edit.html', employee=employee, branches=branches)


@bp.route('/add', methods=['GET', 'POST'])
def add():
    """Add new employee (technical installation staff)"""
    if request.method == 'POST':
        try:
            role = request.form['role']
            
            # Insert into parent table
            query_nv = text("""
                INSERT INTO NhanVien (maNhanVien, maSoThue, email, ngaySinh, ho, tenDem, tenRieng, maChiNhanh)
                VALUES (:ma_nv, :mst, :email, :ngay_sinh, :ho, :ten_dem, :ten_rieng, :ma_chi_nhanh)
            """)
            
            db.session.execute(query_nv, {
                'ma_nv': request.form['maNhanVien'],
                'mst': request.form['maSoThue'],
                'email': request.form['email'],
                'ngay_sinh': request.form['ngaySinh'],
                'ho': request.form['ho'],
                'ten_dem': request.form.get('tenDem', ''),
                'ten_rieng': request.form['tenRieng'],
                'ma_chi_nhanh': request.form['maChiNhanh']
            })
            
            # Insert into role-specific table
            if role == 'LapDat':
                query_role = text("""
                    INSERT INTO NhanVienLapDat (maNhanVienLapDat, soTheKyThuat, ccAnToanDien)
                    VALUES (:ma_nv, :the_kt, :cc_atd)
                """)
                db.session.execute(query_role, {
                    'ma_nv': request.form['maNhanVien'],
                    'the_kt': request.form['soTheKyThuat'],
                    'cc_atd': request.form['ccAnToanDien']
                })
            elif role == 'QuanLy':
                query_role = text("""
                    INSERT INTO NhanVienQuanLy (maNhanVienQuanLy, maBacQuanLy)
                    VALUES (:ma_nv, :bac_ql)
                """)
                db.session.execute(query_role, {
                    'ma_nv': request.form['maNhanVien'],
                    'bac_ql': request.form.get('maBacQuanLy', 1)
                })
            elif role == 'HoTro':
                query_role = text("""
                    INSERT INTO NhanVienHoTro (maNhanVienHoTro, loaiHoTro)
                    VALUES (:ma_nv, :loai_ht)
                """)
                db.session.execute(query_role, {
                    'ma_nv': request.form['maNhanVien'],
                    'loai_ht': request.form.get('loaiHoTro', 'KhachHang')
                })
            elif role == 'KeToan':
                query_role = text("""
                    INSERT INTO KeToan (maKeToan, chungChiKeToan)
                    VALUES (:ma_nv, :cc_kt)
                """)
                db.session.execute(query_role, {
                    'ma_nv': request.form['maNhanVien'],
                    'cc_kt': request.form.get('chungChiKeToan', '')
                })
            
            db.session.commit()
            flash('Thêm nhân viên thành công!', 'success')
            return redirect(url_for('employees.detail', id=request.form['maNhanVien']))
        except Exception as e:
            db.session.rollback()
            flash(f'Lỗi: {str(e)}', 'danger')
    
    branches = ChiNhanh.query.all()
    return render_template('employees/form.html', branches=branches)


@bp.route('/performance/managers')
def managers_performance():
    """Query number of contracts signed by managers in specified month"""
    # Get parameters from user or use defaults
    month = request.args.get('month', type=int) or datetime.now().month
    year = request.args.get('year', type=int) or datetime.now().year
    
    query = text("""
        SELECT 
            nv.maNhanVien,
            CONCAT(nv.ho, ' ', nv.tenRieng) AS HoTen,
            COUNT(hd.maHopDong) AS SoHopDongKyMoi
        FROM NhanVienQuanLy ql
        JOIN NhanVien nv ON ql.maNhanVienQuanLy = nv.maNhanVien
        JOIN HopDong hd ON ql.maNhanVienQuanLy = hd.maNVQuanLy
        WHERE MONTH(hd.ngayKy) = :month
          AND YEAR(hd.ngayKy) = :year
        GROUP BY nv.maNhanVien
        ORDER BY SoHopDongKyMoi DESC
    """)
    
    result = db.session.execute(query, {'month': month, 'year': year})
    managers_stats = result.fetchall()
    
    return render_template('employees/managers_performance.html',
                         managers_stats=managers_stats,
                         selected_month=month,
                         selected_year=year)


@bp.route('/performance/installers')
def installers_performance():
    """Query number of meters installed by technicians in specified month"""
    # Get parameters from user or use defaults
    month = request.args.get('month', type=int) or datetime.now().month
    year = request.args.get('year', type=int) or datetime.now().year
    
    query = text("""
        SELECT 
            nv.maNhanVien,
            CONCAT(nv.ho, ' ', nv.tenRieng) AS HoTen,
            COUNT(ct.maCongTo) AS SoCongToDaLap
        FROM NhanVienLapDat ld
        JOIN NhanVien nv ON ld.maNhanVienLapDat = nv.maNhanVien
        JOIN CongToDien ct ON ld.maNhanVienLapDat = ct.maNVLapDat
        WHERE MONTH(ct.ngayLapDat) = :month
          AND YEAR(ct.ngayLapDat) = :year
        GROUP BY nv.maNhanVien
        ORDER BY SoCongToDaLap DESC
    """)
    
    result = db.session.execute(query, {'month': month, 'year': year})
    installers_stats = result.fetchall()
    
    return render_template('employees/installers_performance.html',
                         installers_stats=installers_stats,
                         selected_month=month,
                         selected_year=year)
