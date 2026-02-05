from flask import Blueprint, render_template, request, flash, redirect, url_for
from sqlalchemy import text
from datetime import datetime
from models import db, KhachHang, HoaDon, CongToDien, NhanVien

bp = Blueprint('dashboard', __name__, url_prefix='/dashboard')

@bp.route('/')
def index():
    """Dashboard home page with statistics"""
    
    # Get basic statistics
    total_customers = KhachHang.query.count()
    total_employees = NhanVien.query.count()
    total_meters = CongToDien.query.count()
    total_invoices = HoaDon.query.count()
    
    # Get unpaid invoices count
    unpaid_invoices = HoaDon.query.filter_by(trangThaiTT='Chua thanh toan').count()
    
    # Get recent invoices (last 10)
    recent_invoices = db.session.query(
        HoaDon.maCongTo,
        HoaDon.ngayLapDon,
        HoaDon.trangThaiTT,
        KhachHang.tenKhachHang
    ).join(
        CongToDien, HoaDon.maCongTo == CongToDien.maCongTo
    ).join(
        KhachHang, CongToDien.maKhachHang == KhachHang.maKhachHang
    ).order_by(HoaDon.ngayLapDon.desc()).limit(10).all()
    
    return render_template('dashboard/index.html',
                         total_customers=total_customers,
                         total_employees=total_employees,
                         total_meters=total_meters,
                         total_invoices=total_invoices,
                         unpaid_invoices=unpaid_invoices,
                         recent_invoices=recent_invoices)


@bp.route('/stats')
def stats():
    """Advanced statistics and charts"""
    return render_template('dashboard/stats.html')


@bp.route('/customer-distribution')
def customer_distribution():
    """Query customer distribution by electricity usage type"""
    from models import ChiNhanh
    branch_id = request.args.get('branch') or 'CN_HCM01'
    
    query = text("""
        SELECT 
            bg.tenBang AS LoaiHinhSuDung,
            COUNT(kh.maKhachHang) AS SoLuongKhach,
            (COUNT(kh.maKhachHang) * 100.0 / (SELECT COUNT(*) FROM KhachHang WHERE maChiNhanh = :branch_id)) AS TyLePhanTram
        FROM KhachHang kh
        JOIN BangGiaDien bg ON kh.maBangGiaDien = bg.ma
        WHERE kh.maChiNhanh = :branch_id
        GROUP BY bg.tenBang
    """)
    
    result = db.session.execute(query, {'branch_id': branch_id})
    distribution = result.fetchall()
    
    branches = ChiNhanh.query.all()
    
    return render_template('dashboard/customer_distribution.html',
                         distribution=distribution,
                         branch_id=branch_id,
                         branches=branches)


@bp.route('/revenue-forecast')
def revenue_forecast():
    """Query revenue forecast for next month by branch"""
    # Get parameters from user or use defaults
    lookback_months = request.args.get('lookback', type=int) or 3
    year = request.args.get('year', type=int) or datetime.now().year
    
    query = text("""
        SELECT 
            cn.ten AS ChiNhanh,
            AVG(hd.doanhThuThang) AS DoanhThuDuBao
        FROM ChiPhiCongTy hd
        JOIN ChiNhanh cn ON hd.maChiNhanh = cn.maChiNhanh
        WHERE hd.namTaiChinh = :year
          AND hd.thangTaiChinh >= :start_month
        GROUP BY cn.maChiNhanh
    """)
    
    current_month = datetime.now().month
    start_month = max(1, current_month - lookback_months)
    
    result = db.session.execute(query, {'year': year, 'start_month': start_month})
    forecast = result.fetchall()
    
    return render_template('dashboard/revenue_forecast.html',
                         forecast=forecast,
                         lookback_months=lookback_months,
                         selected_year=year)


@bp.route('/financial-report')
def financial_report():
    """Generate financial report using stored procedure sp_BaoCaoTaiChinh"""
    from models import ChiNhanh
    
    # Get parameters from query string or use defaults
    month = request.args.get('month', type=int) or datetime.now().month
    year = request.args.get('year', type=int) or datetime.now().year
    branch_id = request.args.get('branch', 'CN_HCM01')
    
    try:
        # Call stored procedure
        query = text("CALL sp_BaoCaoTaiChinh(:month, :year, :branch)")
        result = db.session.execute(query, {
            'month': month,
            'year': year,
            'branch': branch_id
        })
        
        # Fetch the result
        report_data = result.fetchall()
        
        # Get all branches for the filter dropdown
        branches = ChiNhanh.query.all()
        
        return render_template('dashboard/financial_report.html',
                             report_data=report_data,
                             branches=branches,
                             selected_month=month,
                             selected_year=year,
                             selected_branch=branch_id)
    except Exception as e:
        flash(f'Lỗi tạo báo cáo: {str(e)}', 'danger')
        return redirect(url_for('dashboard.index'))
