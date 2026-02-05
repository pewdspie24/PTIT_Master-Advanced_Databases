from flask import Blueprint, render_template, request, redirect, url_for, flash
from sqlalchemy import text
from models import db, BangGiaDien, BacGiaDien

bp = Blueprint('pricing', __name__, url_prefix='/pricing')

@bp.route('/')
def list():
    """List all pricing tables and tiers"""
    pricing_tables = BangGiaDien.query.all()
    return render_template('pricing/list.html', pricing_tables=pricing_tables)


@bp.route('/<string:table_id>')
def detail(table_id):
    """View pricing table details"""
    pricing_table = BangGiaDien.query.get_or_404(table_id)
    
    # Get all price tiers for this table
    tiers = BacGiaDien.query.filter_by(maBangGia=table_id).order_by(BacGiaDien.thuTuCapBac).all()
    
    return render_template('pricing/detail.html',
                         pricing_table=pricing_table,
                         tiers=tiers)


@bp.route('/update-tier', methods=['POST'])
def update_tier():
    """Update electricity price for specific tier"""
    try:
        query = text("""
            UPDATE BacGiaDien
            SET giaDienTrenKwh = :gia_moi
            WHERE maBangGia = :ma_bang 
              AND thuTuCapBac = :cap_bac
        """)
        
        db.session.execute(query, {
            'gia_moi': request.form['giaDienTrenKwh'],
            'ma_bang': request.form['maBangGia'],
            'cap_bac': request.form['thuTuCapBac']
        })
        db.session.commit()
        
        flash('Cập nhật giá điện thành công!', 'success')
    except Exception as e:
        db.session.rollback()
        flash(f'Lỗi: {str(e)}', 'danger')
    
    return redirect(url_for('pricing.detail', table_id=request.form['maBangGia']))
