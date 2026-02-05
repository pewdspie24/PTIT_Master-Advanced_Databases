from flask import Blueprint, render_template, request, redirect, url_for, flash
from sqlalchemy import text
from models import db, NhanVien

bp = Blueprint('salaries', __name__, url_prefix='/salaries')

@bp.route('/')
def list():
    """List all salary records"""
    query = text("""
        SELECT 
            bl.maNhanVien,
            CONCAT(nv.ho, ' ', nv.tenRieng) AS HoTen,
            bl.thangLuong,
            bl.namLuong,
            bl.tienLuong,
            bl.tienThuong,
            bl.tienUngTruoc,
            (bl.tienLuong + bl.tienThuong - bl.tienUngTruoc) AS TongNhanDuoc
        FROM BangLuong bl
        JOIN NhanVien nv ON bl.maNhanVien = nv.maNhanVien
        ORDER BY bl.namLuong DESC, bl.thangLuong DESC
        LIMIT 100
    """)
    
    result = db.session.execute(query)
    salaries = result.fetchall()
    
    return render_template('salaries/list.html', salaries=salaries)


@bp.route('/employee/<string:employee_id>')
def employee_salary(employee_id):
    """Query employee salary history"""
    month = request.args.get('month', type=int)
    year = request.args.get('year', type=int)
    
    query_str = """
        SELECT 
            bl.thangLuong, 
            bl.namLuong, 
            bl.tienLuong AS LuongThucLinh, 
            bl.tienThuong, 
            bl.tienUngTruoc,
            bl.ngayCong,
            (bl.tienLuong + bl.tienThuong - bl.tienUngTruoc) AS TongNhanDuoc
        FROM BangLuong bl
        WHERE bl.maNhanVien = :employee_id
    """
    
    params = {'employee_id': employee_id}
    
    if month and year:
        query_str += " AND bl.thangLuong = :month AND bl.namLuong = :year"
        params['month'] = month
        params['year'] = year
    
    query_str += " ORDER BY bl.namLuong DESC, bl.thangLuong DESC"
    
    query = text(query_str)
    result = db.session.execute(query, params)
    salary_history = result.fetchall()
    
    employee = NhanVien.query.get_or_404(employee_id)
    
    return render_template('salaries/employee_salary.html',
                         salary_history=salary_history,
                         employee=employee)


@bp.route('/add', methods=['GET', 'POST'])
def add():
    """Add new salary records"""
    if request.method == 'POST':
        try:
            # Can add multiple salary records
            employee_ids = request.form.getlist('maNhanVien[]')
            months = request.form.getlist('thangLuong[]')
            years = request.form.getlist('namLuong[]')
            salaries = request.form.getlist('tienLuong[]')
            advances = request.form.getlist('tienUngTruoc[]')
            work_days = request.form.getlist('ngayCong[]')
            bonuses = request.form.getlist('tienThuong[]')
            
            for i in range(len(employee_ids)):
                query = text("""
                    INSERT INTO BangLuong (maNhanVien, thangLuong, namLuong, tienLuong, tienUngTruoc, ngayCong, tienThuong)
                    VALUES (:ma_nv, :thang, :nam, :luong, :ung_truoc, :ngay_cong, :thuong)
                """)
                
                db.session.execute(query, {
                    'ma_nv': employee_ids[i],
                    'thang': months[i],
                    'nam': years[i],
                    'luong': salaries[i],
                    'ung_truoc': advances[i] if advances[i] else 0,
                    'ngay_cong': work_days[i],
                    'thuong': bonuses[i] if bonuses[i] else 0
                })
            
            db.session.commit()
            flash('Thêm bảng lương thành công!', 'success')
            return redirect(url_for('salaries.list'))
        except Exception as e:
            db.session.rollback()
            flash(f'Lỗi: {str(e)}', 'danger')
    
    employees = NhanVien.query.filter_by(trangThai='DangLamViec').all()
    return render_template('salaries/form.html', employees=employees)
