from models import db

class KhachHang(db.Model):
    """Customer model - Khách hàng"""
    __tablename__ = 'KhachHang'
    
    maKhachHang = db.Column(db.String(20), primary_key=True)
    tenKhachHang = db.Column(db.String(100))
    maSoThue = db.Column(db.String(20))
    diaChi = db.Column(db.String(255))
    maChiNhanh = db.Column(db.String(20), db.ForeignKey('ChiNhanh.maChiNhanh'))
    maBangGiaDien = db.Column(db.String(20), db.ForeignKey('BangGiaDien.ma'))
    
    # Relationships
    chi_nhanh = db.relationship('ChiNhanh', backref='khach_hang')
    bang_gia = db.relationship('BangGiaDien', backref='khach_hang')
    sdt = db.relationship('SDT_KhachHang', backref='khach_hang', cascade='all, delete-orphan')
    cong_to = db.relationship('CongToDien', backref='khach_hang')
    hop_dong = db.relationship('HopDong', backref='khach_hang')
    
    def __repr__(self):
        return f'<KhachHang {self.maKhachHang}: {self.tenKhachHang}>'


class SDT_KhachHang(db.Model):
    """Customer phone numbers"""
    __tablename__ = 'SDT_KhachHang'
    
    maKhachHang = db.Column(db.String(20), db.ForeignKey('KhachHang.maKhachHang'), primary_key=True)
    soDienThoai = db.Column(db.String(15), primary_key=True)
    
    def __repr__(self):
        return f'<SDT {self.maKhachHang}: {self.soDienThoai}>'
