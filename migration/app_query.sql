-- them moi khach hang
START TRANSACTION;
    -- 1. Thêm thông tin cơ bản
    INSERT INTO KhachHang (maKhachHang, tenKhachHang, maSoThue, diaChi, maChiNhanh, maBangGiaDien)
    VALUES ('KH001', 'Nguyễn Văn A', 'MST123456789', '123 Đường A, Quận 1', 'CN_HCM01', 'BG_SINHHOAT');

    -- 2. Thêm số điện thoại (Có thể insert nhiều dòng nếu khách có nhiều số)
    INSERT INTO SDT_KhachHang (maKhachHang, soDienThoai)
    VALUES ('KH001', '0909123456'), ('KH001', '0918123456');
COMMIT;

-- truy van thong tin khach hang theo tu khoa tren ma khach hang hoac so dien thoai
SELECT 
    kh.maKhachHang,
    kh.tenKhachHang,
    kh.diaChi, 
    GROUP_CONCAT(sdt.soDienThoai SEPARATOR ', ') as DanhSachSDT,
    bg.tenBang as LoaiGiaDien
FROM KhachHang kh
LEFT JOIN SDT_KhachHang sdt ON kh.maKhachHang = sdt.maKhachHang
JOIN BangGiaDien bg ON kh.maBangGiaDien = bg.ma
WHERE kh.maKhachHang LIKE '%TuKhoa%' 
   OR kh.tenKhachHang LIKE '%TuKhoa%'
   OR sdt.soDienThoai LIKE '%TuKhoa%'
GROUP BY kh.maKhachHang;

-- cap nhat dia chi khach hang
UPDATE KhachHang
SET diaChi = '456 Đường B, Quận 2'
WHERE maKhachHang = 'KH001';

-- them moi nhan vien ky thuat lap dat
START TRANSACTION;
    -- 1. Insert vào bảng Cha
    INSERT INTO NhanVien (maNhanVien, maSoThue, email, ngaySinh, ho, tenDem, tenRieng, maChiNhanh)
    VALUES ('NV_LD01', '8000123456', 'nv01@dienluc.vn', '1990-01-01', 'Nguyen', 'Van', 'A', 'CN_HCM01');

    -- 2. Insert vào bảng Con (Kỹ thuật lắp đặt)
    INSERT INTO NhanVienLapDat (maNhanVienLapDat, soTheKyThuat, ccAnToanDien)
    VALUES ('NV_LD01', 'THE_KT_001', 'ChungChi_ATD_Cap5');
COMMIT;

-- truy van danh sach nhan vien theo chi nhanh va vai tro
SELECT 
    nv.maNhanVien, 
    CONCAT(nv.ho, ' ', nv.tenDem, ' ', nv.tenRieng) AS HoTen,
    cn.ten AS ChiNhanh,
    CASE 
        WHEN ql.maNhanVienQuanLy IS NOT NULL THEN 'Quản Lý'
        WHEN kt.maKeToan IS NOT NULL THEN 'Kế Toán'
        WHEN ld.maNhanVienLapDat IS NOT NULL THEN 'Lắp Đặt'
        WHEN ht.maNhanVienHoTro IS NOT NULL THEN 'Hỗ Trợ'
        ELSE 'Nhân viên khác'
    END AS VaiTro
FROM NhanVien nv
JOIN ChiNhanh cn ON nv.maChiNhanh = cn.maChiNhanh
LEFT JOIN NhanVienQuanLy ql ON nv.maNhanVien = ql.maNhanVienQuanLy
LEFT JOIN KeToan kt ON nv.maNhanVien = kt.maKeToan
LEFT JOIN NhanVienLapDat ld ON nv.maNhanVien = ld.maNhanVienLapDat
LEFT JOIN NhanVienHoTro ht ON nv.maNhanVien = ht.maNhanVienHoTro
WHERE nv.maChiNhanh = 'CN_HCM01';

-- them moi cong to dien cho khach hang
INSERT INTO CongToDien (maCongTo, giaMua, hanSuDung, ngayLapDat, maCongTy, maKhachHang, maNhanVienLapDat)
VALUES 
('CT_2024_001', 500000, 10, '2024-02-01', 'CTY_PANASONIC', 'KH001', 'NV_LD01');

-- gia han them 2 nam cho cong to dien
UPDATE CongToDien
SET hanSuDung = hanSuDung + 2 -- Gia hạn thêm 2 năm
WHERE maCongTo = 'CT_2024_001';

-- cap nhat gia dien cho bang gia sinh hoat, cap bac 6
UPDATE BacGiaDien
SET giaDienTrenKwh = 3500
WHERE maBangGia = 'BG_SINHHOAT' 
  AND thuTuCapBac = 6;

-- truy van hop dong sap het han trong 30 ngay
SELECT 
    hd.maHopDong, 
    kh.maKhachHang,
    kh.tenKhachHang,
    hd.ngayBatDau, 
    DATE_ADD(hd.ngayBatDau, INTERVAL hd.thoiHan MONTH) AS NgayHetHan
FROM HopDong hd
JOIN KhachHang kh ON hd.maKhachHang = kh.maKhachHang
WHERE DATE_ADD(hd.ngayBatDau, INTERVAL hd.thoiHan MONTH) <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) -- Sắp hết hạn trong 30 ngày
  AND hd.trangThai = 'HieuLuc';

-- them moi ho tro khach hang tu nhan vien ho tro
INSERT INTO NV_HoTro_KhachHang (maNVHoTro, maKhachHang, ngayHoTro, lyDoHoTro)
VALUES ('NV_HT_01', 'KH001', NOW(), 'Báo sự cố mất điện cục bộ tại nhà riêng');

-- truy van lich su ho tro khach hang
SELECT 
    ht.ngayHoTro, 
    ht.lyDoHoTro, 
    CONCAT(nv.ho, ' ', nv.tenRieng) AS NhanVienXuLy
FROM NV_HoTro_KhachHang ht
JOIN NhanVien nv ON ht.maNVHoTro = nv.maNhanVien
WHERE ht.maKhachHang = 'KH001'
ORDER BY ht.ngayHoTro DESC;

-- cap nhat trang thai thanh toan hoa don dien
UPDATE HoaDon
SET trangThaiTT = 'Da thanh toan'
-- Có thể thêm cột ngayThanhToan vào bảng HoaDon nếu cần
WHERE maCongTo = 'CT_2024_001' 
  AND ngayGhiNhan = '2024-02-15'; -- Xác định chính xác hóa đơn tháng nào

-- truy van danh sach hoa don qua han
SELECT 
    hd.maCongTo,
    kh.maKhachHang,
    kh.tenKhachHang,
    kh.diaChi,
    sdt.soDienThoai,
    hd.ngayLapDon,
    DATEDIFF(CURDATE(), hd.ngayLapDon) AS SoNgayTre
FROM HoaDon hd
JOIN ChiSoDienHangThang cs ON hd.maCongTo = cs.maCongTo AND hd.ngayGhiNhan = cs.ngayGhiNhan
JOIN CongToDien ct ON cs.maCongTo = ct.maCongTo
JOIN KhachHang kh ON ct.maKhachHang = kh.maKhachHang
LEFT JOIN SDT_KhachHang sdt ON kh.maKhachHang = sdt.maKhachHang
WHERE hd.trangThaiTT = 'Chua thanh toan'
  AND DATEDIFF(CURDATE(), hd.ngayLapDon) > 30; -- Quá hạn 30 ngày

-- truy van cong to co san luong tieu thu thang nay tang gap doi thang truoc
SELECT 
    t1.maCongTo,
    kh.tenKhachHang,
    kh.diaChi,
    (t1.soDienMoi - t1.soDienCu) AS SanLuongThangNay,
    (t2.soDienMoi - t2.soDienCu) AS SanLuongThangTruoc,
    ((t1.soDienMoi - t1.soDienCu) - (t2.soDienMoi - t2.soDienCu)) AS ChenhLech
FROM ChiSoDienHangThang t1
JOIN ChiSoDienHangThang t2 ON t1.maCongTo = t2.maCongTo
JOIN CongToDien ct ON t1.maCongTo = ct.maCongTo
JOIN KhachHang kh ON ct.maKhachHang = kh.maKhachHang
WHERE YEAR(t1.ngayGhiNhan) = YEAR(CURDATE()) 
  AND MONTH(t1.ngayGhiNhan) = MONTH(CURDATE())                    -- Tháng hiện tại
  AND DATE_FORMAT(t2.ngayGhiNhan, '%Y-%m') = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m')  -- Tháng trước
  -- Điều kiện: Tăng gấp 2 lần (200%)
  AND (t1.soDienMoi - t1.soDienCu) > 2 * (t2.soDienMoi - t2.soDienCu)
ORDER BY ChenhLech DESC;

-- them moi bang luong nhan vien
INSERT INTO BangLuong (maNhanVien, thangLuong, namLuong, tienLuong, tienUngTruoc, ngayCong, tienThuong)
VALUES 
('NV001', 2, 2024, 15000000, 0, 22, 1000000),
('NV002', 2, 2024, 12000000, 2000000, 20, 500000);
-- Có thể insert nhiều dòng 1 lúc

-- truy van bang luong nhan vien theo thang nam
SELECT 
    bl.thangLuong, 
    bl.namLuong, 
    bl.tienLuong AS LuongThucLinh, 
    bl.tienThuong, 
    bl.tienUngTruoc,
    (bl.tienLuong + bl.tienThuong - bl.tienUngTruoc) AS TongNhanDuoc
FROM BangLuong bl
WHERE bl.maNhanVien = 'NV001'
  AND bl.thangLuong = 2 AND bl.namLuong = 2024;

-- truy van san luong tieu thu dien thang gan nhat cua khach hang
SELECT 
    DATE_FORMAT(cs.ngayGhiNhan, '%m/%Y') AS Thang,
    (cs.soDienMoi - cs.soDienCu) AS SanLuongTieuThu,
    hd.trangThaiTT
FROM ChiSoDienHangThang cs
JOIN HoaDon hd ON cs.maCongTo = hd.maCongTo AND cs.ngayGhiNhan = hd.ngayGhiNhan
JOIN CongToDien ct ON cs.maCongTo = ct.maCongTo
WHERE ct.maKhachHang = 'KH001' -- ID của khách hàng đang đăng nhập
ORDER BY cs.ngayGhiNhan DESC
LIMIT 12;

-- truy van so hop dong ky moi cua nhan vien quan ly trong thang hien tai
SELECT 
    nv.maNhanVien,
    CONCAT(nv.ho, ' ', nv.tenRieng) AS HoTen,
    COUNT(hd.maHopDong) AS SoHopDongKyMoi
FROM NhanVienQuanLy ql
JOIN NhanVien nv ON ql.maNhanVienQuanLy = nv.maNhanVien
JOIN HopDong hd ON ql.maNhanVienQuanLy = hd.maNVQuanLy
WHERE MONTH(hd.ngayKy) = MONTH(CURDATE()) 
  AND YEAR(hd.ngayKy) = YEAR(CURDATE())
GROUP BY nv.maNhanVien
ORDER BY SoHopDongKyMoi DESC;

-- truy van so cong to da lap dat trong thang hien tai cua nhan vien lap dat
SELECT 
    nv.maNhanVien,
    CONCAT(nv.ho, ' ', nv.tenRieng) AS HoTen,
    COUNT(ct.maCongTo) AS SoCongToDaLap
FROM NhanVienLapDat ld
JOIN NhanVien nv ON ld.maNhanVienLapDat = nv.maNhanVien
JOIN CongToDien ct ON ld.maNhanVienLapDat = ct.maNVLapDat
WHERE MONTH(ct.ngayLapDat) = MONTH(CURDATE())
  AND YEAR(ct.ngayLapDat) = YEAR(CURDATE())
GROUP BY nv.maNhanVien
ORDER BY SoCongToDaLap DESC;

-- truy van ty le phan bo khach hang theo loai hinh su dung dien
SELECT 
    bg.tenBang AS LoaiHinhSuDung,
    COUNT(kh.maKhachHang) AS SoLuongKhach,
    (COUNT(kh.maKhachHang) * 100.0 / (SELECT COUNT(*) FROM KhachHang)) AS TyLePhanTram
FROM KhachHang kh
JOIN BangGiaDien bg ON kh.maBangGiaDien = bg.ma
JOIN ChiNhanh cn ON kh.maChiNhanh = cn.maChiNhanh
WHERE cn.maChiNhanh = 'CN_HCM01'
GROUP BY bg.tenBang;

-- truy van du bao doanh thu thang toi cua tung chi nhanh
SELECT 
    cn.ten AS ChiNhanh,
    AVG(hd.doanhThuThang) AS DoanhThuDuBao
FROM ChiPhiCongTy hd
JOIN ChiNhanh cn ON hd.maChiNhanh = cn.maChiNhanh
WHERE hd.namTaiChinh = YEAR(CURDATE())
  AND hd.thangTaiChinh >= MONTH(CURDATE()) - 3
GROUP BY cn.maChiNhanh;