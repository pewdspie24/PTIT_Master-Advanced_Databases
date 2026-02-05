from models import db

class HopDong(db.Model):
    """Contract model - Hợp đồng"""
    __tablename__ = 'HopDong'
    
    maHopDong = db.Column(db.String(20), primary_key=True)
    ngayKy = db.Column(db.Date)
    ngayBatDau = db.Column(db.Date)
    trangThai = db.Column(db.String(50))
    thoiHan = db.Column(db.Integer)
    maChiNhanh = db.Column(db.String(20), db.ForeignKey('ChiNhanh.maChiNhanh'))
    maNVQuanLy = db.Column(db.String(20), db.ForeignKey('NhanVienQuanLy.maNhanVienQuanLy'))
    maKhachHang = db.Column(db.String(20), db.ForeignKey('KhachHang.maKhachHang'))
    
    # Relationships
    chi_nhanh = db.relationship('ChiNhanh', backref='hop_dong')
    nv_quan_ly = db.relationship('NhanVienQuanLy', backref='hop_dong')
    
    def __repr__(self):
        return f'<HopDong {self.maHopDong}>'
