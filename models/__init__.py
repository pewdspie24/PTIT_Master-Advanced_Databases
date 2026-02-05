# Database initialization - import this in models
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# Import all models so SQLAlchemy can resolve relationships
# Order matters: import base models first, then dependent models
from models.branch import ChiNhanh, KhuVuc
from models.pricing import BangGiaDien, BacGiaDien
from models.employee import NhanVien, SDT_NhanVien, NhanVienQuanLy, NhanVienLapDat, NhanVienHoTro, KeToan
from models.customer import KhachHang, SDT_KhachHang
from models.meter import CongToDien, ChiSoDienHangThang, CongTy
from models.contract import HopDong
from models.invoice import HoaDon
