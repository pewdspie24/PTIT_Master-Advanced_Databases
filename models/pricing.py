from models import db

class BangGiaDien(db.Model):
    """Electricity pricing table - Bảng giá điện"""
    __tablename__ = 'BangGiaDien'
    
    ma = db.Column(db.String(20), primary_key=True)
    tenBang = db.Column(db.String(100))
    
    # Relationships
    bac_gia = db.relationship('BacGiaDien', backref='bang_gia', cascade='all, delete-orphan')
    
    def __repr__(self):
        return f'<BangGiaDien {self.ma}: {self.tenBang}>'


class BacGiaDien(db.Model):
    """Electricity pricing tier - Bậc giá điện"""
    __tablename__ = 'BacGiaDien'
    
    maBangGia = db.Column(db.String(20), db.ForeignKey('BangGiaDien.ma'), primary_key=True)
    thuTuCapBac = db.Column(db.Integer, primary_key=True)
    giaDienTrenKwh = db.Column(db.Numeric(10, 2))
    tuSoDien = db.Column(db.Integer)
    toiSoDien = db.Column(db.Integer)
    
    def __repr__(self):
        return f'<BacGiaDien {self.maBangGia} - Bậc {self.thuTuCapBac}>'
