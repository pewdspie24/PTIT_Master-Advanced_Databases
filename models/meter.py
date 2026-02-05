from models import db

class CongToDien(db.Model):
    """Electric meter model - Công tơ điện"""
    __tablename__ = 'CongToDien'
    
    maCongTo = db.Column(db.String(20), primary_key=True)
    giaMua = db.Column(db.Numeric(15, 2))
    hanSuDung = db.Column(db.Integer)
    ngayLapDat = db.Column(db.Date)
    maCongTy = db.Column(db.String(20), db.ForeignKey('CongTy.maCongTy'))
    maKhachHang = db.Column(db.String(20), db.ForeignKey('KhachHang.maKhachHang'))
    maNVLapDat = db.Column(db.String(20), db.ForeignKey('NhanVienLapDat.maNhanVienLapDat'))
    
    # Relationships
    cong_ty = db.relationship('CongTy', backref='cong_to')
    chi_so = db.relationship('ChiSoDienHangThang', backref='cong_to', cascade='all, delete-orphan')
    
    def __repr__(self):
        return f'<CongToDien {self.maCongTo}>'


class ChiSoDienHangThang(db.Model):
    """Monthly meter reading - Chỉ số điện hàng tháng"""
    __tablename__ = 'ChiSoDienHangThang'
    
    maCongTo = db.Column(db.String(20), db.ForeignKey('CongToDien.maCongTo'), primary_key=True)
    ngayGhiNhan = db.Column(db.Date, primary_key=True)
    soDienCu = db.Column(db.Integer)
    soDienMoi = db.Column(db.Integer)
    
    # Relationships
    hoa_don = db.relationship('HoaDon', backref='chi_so_dien', uselist=False)
    
    @property
    def tieu_thu(self):
        """Calculate consumption"""
        if self.soDienMoi and self.soDienCu:
            return self.soDienMoi - self.soDienCu
        return 0
    
    def __repr__(self):
        return f'<ChiSoDien {self.maCongTo} - {self.ngayGhiNhan}>'


class CongTy(db.Model):
    """Meter company - Công ty sản xuất công tơ"""
    __tablename__ = 'CongTy'
    
    maCongTy = db.Column(db.String(20), primary_key=True)
    tenCongTy = db.Column(db.String(100))
    xuatXu = db.Column(db.String(50))
    
    def __repr__(self):
        return f'<CongTy {self.maCongTy}: {self.tenCongTy}>'
