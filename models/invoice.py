from models import db

class HoaDon(db.Model):
    """Invoice model - Hóa đơn"""
    __tablename__ = 'HoaDon'
    
    maCongTo = db.Column(db.String(20), primary_key=True)
    ngayGhiNhan = db.Column(db.Date, primary_key=True)
    trangThaiTT = db.Column(db.String(50))
    ngayLapDon = db.Column(db.Date)
    maKeToan = db.Column(db.String(20), db.ForeignKey('KeToan.maKeToan'))
    
    # Foreign key to ChiSoDienHangThang (composite)
    __table_args__ = (
        db.ForeignKeyConstraint(
            ['maCongTo', 'ngayGhiNhan'],
            ['ChiSoDienHangThang.maCongTo', 'ChiSoDienHangThang.ngayGhiNhan']
        ),
    )
    
    # Relationships
    ke_toan = db.relationship('KeToan', backref='hoa_don')
    
    def __repr__(self):
        return f'<HoaDon {self.maCongTo} - {self.ngayGhiNhan}>'
