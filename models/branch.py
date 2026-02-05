from models import db

class ChiNhanh(db.Model):
    """Branch model - Chi nhánh"""
    __tablename__ = 'ChiNhanh'
    
    maChiNhanh = db.Column(db.String(20), primary_key=True)
    soDienThoai = db.Column(db.String(15))
    ten = db.Column(db.String(100))
    diaChi = db.Column(db.String(255))
    maKhuVuc = db.Column(db.String(20), db.ForeignKey('KhuVuc.maKhuVuc'))
    
    # Relationships
    khu_vuc = db.relationship('KhuVuc', backref='chi_nhanh')
    
    def __repr__(self):
        return f'<ChiNhanh {self.maChiNhanh}: {self.ten}>'


class KhuVuc(db.Model):
    """Region model - Khu vực"""
    __tablename__ = 'KhuVuc'
    
    maKhuVuc = db.Column(db.String(20), primary_key=True)
    tenKhuVuc = db.Column(db.String(100))
    maVung = db.Column(db.String(20))
    
    def __repr__(self):
        return f'<KhuVuc {self.maKhuVuc}: {self.tenKhuVuc}>'
