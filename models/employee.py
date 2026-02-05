from models import db

class NhanVien(db.Model):
    """Employee model - Nhân viên"""
    __tablename__ = 'NhanVien'
    
    maNhanVien = db.Column(db.String(20), primary_key=True)
    maSoThue = db.Column(db.String(20))
    email = db.Column(db.String(100))
    ngaySinh = db.Column(db.Date)
    ho = db.Column(db.String(50))
    tenDem = db.Column(db.String(50))
    tenRieng = db.Column(db.String(50))
    maNhanVienQuanLy = db.Column(db.String(20), db.ForeignKey('NhanVienQuanLy.maNhanVienQuanLy'))
    maChiNhanh = db.Column(db.String(20), db.ForeignKey('ChiNhanh.maChiNhanh'))
    trangThai = db.Column(db.String(50), default='Dang lam viec')
    
    # Relationships
    chi_nhanh = db.relationship('ChiNhanh', backref='nhan_vien')
    sdt = db.relationship('SDT_NhanVien', backref='nhan_vien', cascade='all, delete-orphan')
    
    @property
    def ho_ten(self):
        """Full name property"""
        return f"{self.ho} {self.tenDem} {self.tenRieng}".strip()
    
    def __repr__(self):
        return f'<NhanVien {self.maNhanVien}: {self.ho_ten}>'


class SDT_NhanVien(db.Model):
    """Employee phone numbers"""
    __tablename__ = 'SDT_NhanVien'
    
    maNhanVien = db.Column(db.String(20), db.ForeignKey('NhanVien.maNhanVien'), primary_key=True)
    soDienThoai = db.Column(db.String(15), primary_key=True)


class NhanVienQuanLy(db.Model):
    """Manager - Nhân viên quản lý"""
    __tablename__ = 'NhanVienQuanLy'
    
    maNhanVienQuanLy = db.Column(db.String(20), db.ForeignKey('NhanVien.maNhanVien'), primary_key=True)
    thamNien = db.Column(db.Integer)
    trinhDoVanHoa = db.Column(db.String(50))
    
    # Relationship
    nhan_vien = db.relationship('NhanVien', foreign_keys=[maNhanVienQuanLy], backref='quan_ly_info')


class NhanVienLapDat(db.Model):
    """Installation technician - Nhân viên lắp đặt"""
    __tablename__ = 'NhanVienLapDat'
    
    maNhanVienLapDat = db.Column(db.String(20), db.ForeignKey('NhanVien.maNhanVien'), primary_key=True)
    soTheKyThuat = db.Column(db.String(50))
    ccAnToanDien = db.Column(db.String(100))
    
    # Relationship
    nhan_vien = db.relationship('NhanVien', foreign_keys=[maNhanVienLapDat], backref='lap_dat_info')


class NhanVienHoTro(db.Model):
    """Support staff - Nhân viên hỗ trợ"""
    __tablename__ = 'NhanVienHoTro'
    
    maNhanVienHoTro = db.Column(db.String(20), db.ForeignKey('NhanVien.maNhanVien'), primary_key=True)
    kenhHoTro = db.Column(db.String(50))
    capDoHoTro = db.Column(db.Integer)
    
    # Relationship
    nhan_vien = db.relationship('NhanVien', foreign_keys=[maNhanVienHoTro], backref='ho_tro_info')


class KeToan(db.Model):
    """Accountant - Kế toán"""
    __tablename__ = 'KeToan'
    
    maKeToan = db.Column(db.String(20), db.ForeignKey('NhanVien.maNhanVien'), primary_key=True)
    hanMucDuyet = db.Column(db.Numeric(15, 2))
    ccKeToan = db.Column(db.String(100))
    
    # Relationship
    nhan_vien = db.relationship('NhanVien', foreign_keys=[maKeToan], backref='ke_toan_info')
