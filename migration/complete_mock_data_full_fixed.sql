-- =====================================================
-- COMPLETE MOCK DATA for QuanLyDienLuc_Final
-- Includes: Base data + Enhanced test scenarios
-- Created: 2026-02-05
-- =====================================================

USE QuanLyDienLuc_Final;
SET FOREIGN_KEY_CHECKS = 0;

-- Clear all existing data
TRUNCATE TABLE NV_HoTro_KhachHang;
TRUNCATE TABLE ChiPhiCongTy;
TRUNCATE TABLE HoaDon;
TRUNCATE TABLE ChiSoDienHangThang;
TRUNCATE TABLE CongToDien;
TRUNCATE TABLE HopDong;
TRUNCATE TABLE SDT_KhachHang;
TRUNCATE TABLE KhachHang;
TRUNCATE TABLE BangLuong;
TRUNCATE TABLE SDT_NhanVien;
TRUNCATE TABLE NhanVienHoTro;
TRUNCATE TABLE NhanVienLapDat;
TRUNCATE TABLE KeToan;
TRUNCATE TABLE NhanVienQuanLy;
TRUNCATE TABLE NhanVien;
TRUNCATE TABLE CongTy;
TRUNCATE TABLE BacGiaDien;
TRUNCATE TABLE BangGiaDien;
TRUNCATE TABLE ChiNhanh;
TRUNCATE TABLE KhuVuc;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- SECTION 1: REFERENCE DATA
-- =====================================================

-- KhuVuc (~20) - maVung là mã vùng điện thoại cố định VN
INSERT INTO KhuVuc (maKhuVuc, tenKhuVuc, maVung) VALUES
('KV001','Ha Noi','024'),
('KV002','Hai Phong','0225'),
('KV003','Da Nang','0236'),
('KV004','TP Ho Chi Minh','028'),
('KV005','Can Tho','0292'),
('KV006','Binh Duong','0274'),
('KV007','Hai Duong','0220'),
('KV008','Nghe An','0238'),
('KV009','Khanh Hoa','0258'),
('KV010','Dong Nai','0251'),
('KV011','Quang Ninh','0203'),
('KV012','Bac Ninh','0222'),
('KV013','Thua Thien Hue','0234'),
('KV014','Quang Nam','0235'),
('KV015','Dak Lak','0262'),
('KV016','Lam Dong','0263'),
('KV017','Long An','0272'),
('KV018','An Giang','0296'),
('KV019','Ba Ria - Vung Tau','0254'),
('KV020','Binh Dinh','0256');

-- ChiNhanh (~20)
INSERT INTO ChiNhanh (maChiNhanh, soDienThoai, ten, diaChi, maKhuVuc) VALUES
('CN001','02437980001','Chi nhanh Dien luc Hoan Kiem','So 12 Tran Hung Dao, Hoan Kiem, Ha Noi','KV001'),
('CN002','02253820001','Chi nhanh Dien luc Ngo Quyen','So 08 Le Hong Phong, Ngo Quyen, Hai Phong','KV002'),
('CN003','02363820001','Chi nhanh Dien luc Hai Chau','So 45 Nguyen Van Linh, Hai Chau, Da Nang','KV003'),
('CN004','02838200001','Chi nhanh Dien luc Quan 1','So 18 Nguyen Hue, Quan 1, TP HCM','KV004'),
('CN005','02923820001','Chi nhanh Dien luc Ninh Kieu','So 27 Hoa Binh, Ninh Kieu, Can Tho','KV005'),
-- ('CN006','02743820001','Chi nhanh Dien luc Thu Dau Mot','So 05 Yersin, Thu Dau Mot, Binh Duong','KV006'),
-- ('CN007','02203820001','Chi nhanh Dien luc TP Hai Duong','So 66 Tran Phu, TP Hai Duong, Hai Duong','KV007'),
-- ('CN008','02383820001','Chi nhanh Dien luc TP Vinh','So 09 Le Nin, TP Vinh, Nghe An','KV008'),
('CN009','02583820001','Chi nhanh Dien luc Nha Trang','So 20 Tran Phu, Nha Trang, Khanh Hoa','KV009'),
-- ('CN010','02513820001','Chi nhanh Dien luc Bien Hoa','So 11 Vo Thi Sau, Bien Hoa, Dong Nai','KV010'),
('CN011','02033820001','Chi nhanh Dien luc Ha Long','So 02 Nguyen Van Cu, Ha Long, Quang Ninh','KV011'),
-- ('CN012','02223820001','Chi nhanh Dien luc TP Bac Ninh','So 07 Ly Thai To, TP Bac Ninh, Bac Ninh','KV012'),
-- ('CN013','02343820001','Chi nhanh Dien luc TP Hue','So 14 Hung Vuong, TP Hue, Thua Thien Hue','KV013'),
-- ('CN014','02353820001','Chi nhanh Dien luc Tam Ky','So 33 Hung Vuong, Tam Ky, Quang Nam','KV014'),
-- ('CN015','02623820001','Chi nhanh Dien luc Buon Ma Thuot','So 60 Nguyen Tat Thanh, BMT, Dak Lak','KV015'),
-- ('CN016','02633820001','Chi nhanh Dien luc Da Lat','So 19 Tran Phu, Da Lat, Lam Dong','KV016'),
-- ('CN017','02723820001','Chi nhanh Dien luc Tan An','So 25 Hung Vuong, Tan An, Long An','KV017'),
-- ('CN018','02963820001','Chi nhanh Dien luc Long Xuyen','So 09 Tran Hung Dao, Long Xuyen, An Giang','KV018'),
-- ('CN019','02543820001','Chi nhanh Dien luc Vung Tau','So 06 Ba Cu, Vung Tau, BR-VT','KV019'),
('CN020','02563820001','Chi nhanh Dien luc Quy Nhon','So 10 Tang Bat Ho, Quy Nhon, Binh Dinh','KV020');

-- BangGiaDien (4 types)
INSERT INTO BangGiaDien (ma, tenBang) VALUES
('BGD001','Sinh hoat'),
('BGD002','Kinh doanh'),
('BGD003','San xuat'),
('BGD004','Hanh chinh su nghiep');

-- BacGiaDien (Tiered pricing structure)
INSERT INTO BacGiaDien (maBangGia, thuTuCapBac, giaDienTrenKwh, tuSoDien, toiSoDien) VALUES
('BGD001', 1, 1806.00,   0,  50),
('BGD001', 2, 1866.00,  51, 100),
('BGD001', 3, 2167.00, 101, 200),
('BGD001', 4, 2729.00, 201, 300),
('BGD001', 5, 3050.00, 301, 400),
('BGD001', 6, 3151.00, 401, NULL),
('BGD002', 1, 2900.00,   0, NULL),
('BGD003', 1, 1850.00,   0, NULL),
('BGD004', 1, 2100.00,   0, NULL);

-- CongTy (~20) - Meter manufacturers
INSERT INTO CongTy (maCongTy, tenCongTy, xuatXu) VALUES
('CTY001','EMIC - Thiet bi do dien Viet Nam','Viet Nam'),
('CTY002','Shikoku Electric Meter','Nhat Ban'),
('CTY003','Landis+Gyr','Thuy Si'),
('CTY004','Itron','My'),
('CTY005','Siemens Smart Infrastructure','Duc'),
('CTY006','Schneider Electric','Phap'),
('CTY007','ZPA Smart Energy','Sec'),
('CTY008','Hexing Electrical','Trung Quoc'),
('CTY009','Holley Technology','Trung Quoc'),
('CTY010','Iskraemeco','Slovenia'),
('CTY011','HPL Electric & Power','An Do'),
('CTY012','Apator','Ba Lan'),
('CTY013','Sagemcom Metering','Phap'),
('CTY014','EDMI','Singapore'),
('CTY015','CIRCUTOR','Tay Ban Nha'),
('CTY016','Eastron','Anh'),
('CTY017','Chint Electric Meter','Trung Quoc'),
('CTY018','Sanxing Electric','Trung Quoc'),
('CTY019','MeterTech Viet','Viet Nam'),
('CTY020','Vina Meter Solutions','Viet Nam');

-- =====================================================
-- SECTION 2: EMPLOYEES
-- =====================================================

-- Manager employees
INSERT INTO NhanVien (maNhanVien, maSoThue, email, ngaySinh, ho, tenDem, tenRieng, maNhanVienQuanLy, maChiNhanh, trangThai) VALUES
('QL001','0101861234','huy.nguyen@dienluc.vn','1986-04-12','Nguyen','Van','Huy',NULL,'CN001','Dang lam viec'),
('QL002','0201872345','thao.le@dienluc.vn','1987-09-03','Le','Thi','Thao',NULL,'CN002','Dang lam viec'),
('QL003','0301853456','nam.tran@dienluc.vn','1985-01-21','Tran','Quang','Nam',NULL,'CN003','Dang lam viec'),
('QL004','0311884567','minh.pham@dienluc.vn','1988-07-15','Pham','Duc','Minh',NULL,'CN004','Dang lam viec'),
('QL005','1401895678','linh.do@dienluc.vn','1989-11-28','Do','Thi','Linh',NULL,'CN005','Dang lam viec'),
('QL006','4201906789','khoa.ngo@dienluc.vn','1990-02-10','Ngo','Quoc','Khoa',NULL,'CN009','Dang lam viec'),
('QL007','5701917890','son.bui@dienluc.vn','1991-06-06','Bui','Thanh','Son',NULL,'CN011','Dang lam viec'),
('QL008','4101928901','ha.vo@dienluc.vn','1992-12-01','Vo','Ngoc','Ha',NULL,'CN020','Dang lam viec');

INSERT INTO NhanVienQuanLy (maNhanVienQuanLy, thamNien, trinhDoVanHoa) VALUES
('QL001', 12, 'Dai hoc'),
('QL002', 11, 'Dai hoc'),
('QL003', 13, 'Dai hoc'),
('QL004', 10, 'Sau dai hoc'),
('QL005',  9, 'Dai hoc'),
('QL006',  8, 'Dai hoc'),
('QL007',  7, 'Cao dang'),
('QL008',  6, 'Dai hoc');

-- Other employees
INSERT INTO NhanVien (maNhanVien, maSoThue, email, ngaySinh, ho, tenDem, tenRieng, maNhanVienQuanLy, maChiNhanh, trangThai) VALUES
('KT001','0102951111','lan.nguyen.kt@dienluc.vn','1992-03-18','Nguyen','Thi','Lan','QL001','CN001','Dang lam viec'),
('KT002','0312952222','phuc.tran.kt@dienluc.vn','1991-05-09','Tran','Minh','Phuc','QL004','CN004','Dang lam viec'),
('KT003','0302953333','mai.le.kt@dienluc.vn','1993-08-22','Le','Thuy','Mai','QL003','CN003','Dang lam viec'),
('KT004','1402954444','duy.pham.kt@dienluc.vn','1990-10-30','Pham','Quang','Duy','QL005','CN005','Dang lam viec'),
('LD001','0103961111','tuan.nguyen.ld@dienluc.vn','1996-02-14','Nguyen','Anh','Tuan','QL001','CN001','Dang lam viec'),
('LD002','0313962222','khang.vo.ld@dienluc.vn','1995-12-19','Vo','Dinh','Khang','QL004','CN004','Dang lam viec'),
('LD003','0303963333','dat.tran.ld@dienluc.vn','1994-07-07','Tran','Tien','Dat','QL003','CN003','Dang lam viec'),
('LD004','1403964444','hung.le.ld@dienluc.vn','1997-09-25','Le','Quoc','Hung','QL005','CN005','Dang lam viec'),
('HT001','0104971111','ngoc.do.ht@dienluc.vn','1997-04-05','Do','Bao','Ngoc','QL001','CN001','Dang lam viec'),
('HT002','0314972222','vy.nguyen.ht@dienluc.vn','1998-06-12','Nguyen','Thanh','Vy','QL004','CN004','Dang lam viec'),
('HT003','0304973333','anh.bui.ht@dienluc.vn','1996-01-29','Bui','Khanh','Anh','QL003','CN003','Dang lam viec'),
('HT004','1404974444','kiet.tran.ht@dienluc.vn','1995-11-11','Tran','Gia','Kiet','QL005','CN005','Dang lam viec'),
('NV_TEMP01','0105001111','temp.nguyen@dienluc.vn','1994-06-15','Nguyen','Van','Binh','QL001','CN001','Nghi tam thoi'),
('NV_QUIT01','0106002222','quit.tran@dienluc.vn','1992-03-20','Tran','Thi','Lan','QL004','CN004','Nghi viec');

INSERT INTO KeToan (maKeToan, hanMucDuyet, ccKeToan) VALUES
('KT001', 200000000.00, 'Chung chi Ke toan vien hanh nghe'),
('KT002', 300000000.00, 'Chung chi Ke toan truong'),
('KT003', 200000000.00, 'Chung chi Ke toan vien hanh nghe'),
('KT004', 250000000.00, 'Chung chi Ke toan tong hop');

INSERT INTO NhanVienLapDat (maNhanVienLapDat, soTheKyThuat, ccAnToanDien) VALUES
('LD001','KTV-HN-02841','ATD-B1'),
('LD002','KTV-HCM-03112','ATD-B1'),
('LD003','KTV-DN-01977','ATD-B1'),
('LD004','KTV-CT-01420','ATD-B2');

INSERT INTO NhanVienHoTro (maNhanVienHoTro, kenhHoTro, capDoHoTro) VALUES
('HT001','Tong dai 1900xxxx',2),
('HT002','Zalo OA',3),
('HT003','Email ho tro',2),
('HT004','Tai quay giao dich',3);

INSERT INTO SDT_NhanVien (maNhanVien, soDienThoai) VALUES
('QL001','0903123456'),('QL002','0912233445'),('QL003','0934567890'),('QL004','0907888999'),
('QL005','0914555666'),('QL006','0987111222'),('QL007','0962333444'),('QL008','0979555666'),
('KT001','0988123123'),('KT002','0909123789'),('KT003','0918123898'),('KT004','0978123456'),
('LD001','0967123001'),('LD002','0976123002'),('LD003','0986123003'),('LD004','0906123004'),
('HT001','0916123005'),('HT002','0926123006'),('HT003','0936123007'),('HT004','0946123008');

-- =====================================================
-- SECTION 3: CUSTOMERS
-- =====================================================

INSERT INTO KhachHang (maKhachHang, tenKhachHang, maSoThue, diaChi, maChiNhanh, maBangGiaDien) VALUES
('KH001','Nguyen Van Tuan','0109234561','So 12 Hang Bai, Hoan Kiem, Ha Noi','CN001','BGD001'),
('KH002','Tran Thi Thu Ha','0209345672','So 08 Lach Tray, Ngo Quyen, Hai Phong','CN002','BGD001'),
('KH003','Le Minh Quan','0309456783','So 55 Nguyen Chi Thanh, Hai Chau, Da Nang','CN003','BGD001'),
('KH004','Pham Ngoc Anh','0319567894','So 20 Le Loi, Quan 1, TP HCM','CN004','BGD001'),
('KH005','Vo Quoc Duy','1409678905','So 09 Hoa Binh, Ninh Kieu, Can Tho','CN005','BGD001'),
('KH006','Bui Thi Mai','0109789016','So 101 Giai Phong, Hoang Mai, Ha Noi','CN001','BGD001'),
('KH007','Nguyen Thanh Long','0209890127','So 12 Tran Nguyen Han, Hong Bang, Hai Phong','CN002','BGD001'),
('KH008','Do Khanh Linh','0309901238','So 78 Dien Bien Phu, Thanh Khe, Da Nang','CN003','BGD001'),
('KH009','Nguyen Hoang Nam','0319012349','So 35 Vo Van Tan, Quan 3, TP HCM','CN004','BGD001'),
('KH010','Le Thi Ngoc','1409123450','So 66 Cach Mang Thang 8, Ninh Kieu, Can Tho','CN005','BGD001'),
('KH011','Cong ty TNHH Minh Phat Trading','0101122334','So 88 Tran Duy Hung, Cau Giay, Ha Noi','CN001','BGD002'),
('KH012','Cong ty Co phan Hai Phong Logistics','0202233445','So 12 Dinh Vu, Hai An, Hai Phong','CN002','BGD002'),
('KH013','Cong ty TNHH Da Nang Food','0303344556','Lo A2 Nguyen Van Linh, Hai Chau, Da Nang','CN003','BGD004'),
('KH014','Cong ty TNHH Sai Gon Retail','0314455667','So 19 Nam Ky Khoi Nghia, Quan 1, TP HCM','CN004','BGD004'),
('KH015','Benh vien Da khoa Can Tho','1405566778','So 01 3/2, Ninh Kieu, Can Tho','CN005','BGD003'),
('KH016','Khach san Bien Xanh','4206677889','So 10 Tran Phu, Nha Trang, Khanh Hoa','CN009','BGD002'),
('KH017','Cong ty Du lich Ha Long Bay','5707788990','So 02 Nguyen Van Cu, Ha Long, Quang Ninh','CN011','BGD004'),
('KH018','Cua hang vat lieu xay dung Quy Nhon','4108899001','So 33 Tang Bat Ho, Quy Nhon, Binh Dinh','CN020','BGD002'),
('KH019','Nguyen Thi Hong','4209900112','So 05 Le Thanh Ton, Nha Trang, Khanh Hoa','CN009','BGD001'),
('KH020','Tran Quang Huy','5701011223','So 18 Tran Quoc Nghien, Ha Long, Quang Ninh','CN011','BGD001'),
('KH_FACTORY','Nha may May mac Viet Tien','0311223344','Khu CN Tan Binh, Q. Tan Binh, TP HCM','CN004','BGD003');

INSERT INTO SDT_KhachHang (maKhachHang, soDienThoai) VALUES
('KH001','0961234567'),('KH002','0972345678'),('KH003','0983456789'),('KH004','0904567890'),
('KH005','0915678901'),('KH006','0926789012'),('KH007','0937890123'),('KH008','0948901234'),
('KH009','0959012345'),('KH010','0960123456'),('KH011','02838211234'),('KH012','02253821111'),
('KH013','02363823333'),('KH014','02838224444'),('KH015','02923825555'),('KH016','02583826666'),
('KH017','02033827777'),('KH018','02563828888'),('KH019','0908123009'),('KH020','0919123010'),
('KH_FACTORY','02838999888');

-- =====================================================
-- SECTION 4: CONTRACTS
-- =====================================================

INSERT INTO HopDong (maHopDong, ngayKy, ngayBatDau, trangThai, thoiHan, maChiNhanh, maNVQuanLy, maKhachHang) VALUES
('HD001','2016-03-01','2021-04-01','Hieu luc',6,'CN001','QL001','KH001'),
('HD002','2018-10-01','2022-11-20','Hieu luc',5,'CN002','QL002','KH002'),
('HD003','2014-07-01','2019-08-10','Hieu luc',7,'CN003','QL003','KH003'),
('HD004','2019-12-01','2021-02-01','Hieu luc',6,'CN004','QL004','KH004'),
('HD005','2012-08-01','2016-10-01','Hieu luc',10,'CN005','QL005','KH005'),

('HD006','2011-03-01','2018-06-01','Hieu luc',8,'CN001','QL001','KH006'),
('HD021','2011-03-01','2019-06-01','Hieu luc',7,'CN001','QL001','KH006'),

('HD007','2013-07-01','2019-12-15','Hieu luc',6,'CN002','QL002','KH007'),
('HD022','2013-07-01','2020-12-15','Hieu luc',6,'CN002','QL002','KH007'),

('HD008','2010-01-01','2016-07-01','Hieu luc',10,'CN003','QL003','KH008'),
('HD023','2010-01-01','2017-07-01','Hieu luc',9,'CN003','QL003','KH008'),

('HD009','2017-01-01','2021-03-01','Hieu luc',5,'CN004','QL004','KH009'),

('HD010','2012-09-01','2018-01-15','Hieu luc',8,'CN005','QL005','KH010'),
('HD024','2012-09-01','2013-01-15','Het han',6,'CN004','QL004','KH010'),

('HD011','2011-05-01','2017-05-01','Hieu luc',9,'CN001','QL001','KH011'),

('HD012','2014-08-01','2019-10-01','Hieu luc',7,'CN002','QL002','KH012'),

('HD013','2016-05-01','2021-12-01','Hieu luc',5,'CN003','QL003','KH013'),

('HD014','2018-04-01','2021-06-01','Hieu luc',5,'CN004','QL004','KH014'),

('HD015','2018-02-01','2020-04-01','Hieu luc',6,'CN005','QL005','KH015'),

('HD016','2015-09-01','2019-12-01','Hieu luc',7,'CN009','QL006','KH016'),

('HD017','2020-10-01','2022-12-01','Hieu luc',5,'CN011','QL007','KH017'),

('HD018','2014-01-01','2019-03-01','Hieu luc',7,'CN020','QL008','KH018'),

('HD019','2017-06-01','2021-09-01','Hieu luc',5,'CN009','QL006','KH019'),

('HD020','2024-01-01','2024-03-01','Hieu luc',5,'CN011','QL007','KH020'),

('HD025','2012-08-01','2012-10-01','Het han',10,'CN005','QL005','KH005'),

('HD029','2017-06-01','2017-09-01','Huy',6,'CN001','QL001','KH019'),
('HD030','2024-01-01','2024-03-01','Huy',7,'CN004','QL004','KH020'),

('HD_FACTORY','2014-12-01','2018-02-01','Hieu luc',8,'CN004','QL004','KH_FACTORY');

-- =====================================================
-- SECTION 5: METERS
-- =====================================================

INSERT INTO CongToDien (maCongTo, giaMua, hanSuDung, ngayLapDat, maCongTy, maKhachHang, maNVLapDat) VALUES
('CT001',  980000.00,12,'2016-03-18','CTY001','KH001','LD001'),
('CT002', 1050000.00,12,'2018-11-02','CTY003','KH002','LD003'),
('CT003', 1100000.00,15,'2014-07-25','CTY004','KH003','LD003'),
('CT004', 1250000.00,15,'2020-01-14','CTY006','KH004','LD002'),
('CT005',  950000.00,12,'2012-09-09','CTY001','KH005','LD004'),

('CT006',  990000.00,12,'2019-05-21','CTY019','KH006','LD001'),
('CT021',  920000.00,10,'2011-04-15','CTY001','KH006','LD001'),
('CT_VACANT',980000.00,12,'2018-09-10','CTY001','KH006','LD001'),

('CT007', 1020000.00,12,'2015-12-03','CTY003','KH007','LD003'),
('CT022',  980000.00,10,'2013-08-19','CTY002','KH007','LD003'),

('CT008', 1080000.00,15,'2021-06-17','CTY004','KH008','LD003'),
('CT023', 1050000.00,12,'2010-02-11','CTY003','KH008','LD003'),

('CT009', 1200000.00,15,'2017-02-08','CTY006','KH009','LD002'),

('CT010',  970000.00,12,'2013-10-27','CTY001','KH010','LD004'),
('CT024', 1100000.00,12,'2012-12-07','CTY004','KH010','LD004'),

('CT011', 1350000.00,15,'2022-04-11','CTY005','KH011','LD001'),
('CT025',  850000.00,10,'2011-06-03','CTY001','KH011','LD001'),

('CT012', 1500000.00,15,'2019-08-30','CTY014','KH012','LD003'),
('CT026',  900000.00,10,'2014-09-22','CTY019','KH012','LD003'),

('CT013', 1280000.00,12,'2016-06-06','CTY010','KH013','LD003'),
('CT027',  980000.00,12,'2016-11-30','CTY005','KH013','LD003'),

('CT014', 1400000.00,15,'2023-01-19','CTY006','KH014','LD002'),
('CT028', 1020000.00,12,'2018-05-26','CTY006','KH014','LD002'),

('CT015', 1320000.00,12,'2018-03-12','CTY007','KH015','LD004'),

('CT016', 1180000.00,12,'2015-09-24','CTY013','KH016','LD004'),

('CT017', 1250000.00,12,'2020-11-05','CTY012','KH017','LD001'),

('CT018', 1120000.00,12,'2014-01-28','CTY011','KH018','LD003'),

('CT019',  980000.00,12,'2017-07-16','CTY019','KH019','LD004'),

('CT020', 1150000.00,15,'2024-02-02','CTY005','KH020','LD001'),

('CT_FACTORY',2500000.00,15,'2015-01-05','CTY005','KH_FACTORY','LD002');


-- =====================================================
-- SECTION 6: METER READINGS (6 months history)
-- =====================================================

-- Historical readings (Aug-Dec 2025)
INSERT INTO ChiSoDienHangThang (maCongTo, ngayGhiNhan, soDienCu, soDienMoi) VALUES
-- CT001: Normal stable usage
('CT001','2025-08-31',  450,  524),('CT001','2025-09-30',  524,  596),
('CT001','2025-10-31',  596,  671),('CT001','2025-11-30',  671,  743),('CT001','2025-12-31',  743,  850),
-- CT002: ABNORMAL - doubled consumption
('CT002','2025-08-31',  880,  998),('CT002','2025-09-30',  998, 1110),
('CT002','2025-10-31', 1010, 1120),('CT002','2025-11-30', 1120, 1200),('CT002','2025-12-31', 1200, 1318),
-- CT004: Gradual increase (business expansion)
('CT004','2025-08-31', 1650, 1805),('CT004','2025-09-30', 1805, 1973),
('CT004','2025-10-31', 1973, 2150),('CT004','2025-11-30', 2150, 2338),('CT004','2025-12-31', 2338, 2540),
-- CT005: SUDDEN DROP - vacancy
('CT005','2025-08-31',  180,  258),('CT005','2025-09-30',  258,  340),
('CT005','2025-10-31',  340,  422),('CT005','2025-11-30',  422,  430),('CT005','2025-12-31',  430,  440),
-- CT009: Seasonal variations
('CT009','2025-08-31', 2920, 3120),('CT009','2025-09-30', 3120, 3322),
('CT009','2025-10-31', 3322, 3470),('CT009','2025-11-30', 3470, 3590),('CT009','2025-12-31', 3590, 3700),
-- CT011: Large business - stable
('CT011','2025-08-31', 8100, 8605),('CT011','2025-09-30', 8605, 9115),
('CT011','2025-10-31', 9115, 9630),('CT011','2025-11-30', 9630,10150),('CT011','2025-12-31',10150,10675),
-- CT012: Manufacturing
('CT012','2025-08-31', 4930, 5310),('CT012','2025-09-30', 5310, 5700),
('CT012','2025-10-31', 5700, 6095),('CT012','2025-11-30', 6095, 6490),('CT012','2025-12-31', 6490, 6890),
-- CT016: Hotel
('CT016','2025-08-31', 2200, 2368),('CT016','2025-09-30', 2368, 2536),
('CT016','2025-10-31', 2536, 2704),('CT016','2025-11-30', 2704, 2872),('CT016','2025-12-31', 2872, 3040),
-- Old meters
('CT021','2025-08-31', 14700, 14762),('CT021','2025-09-30', 14762, 14886),
('CT021','2025-10-31', 14886, 15010),('CT021','2025-11-30', 15010, 15136),('CT021','2025-12-31', 15136, 15200),
('CT022','2025-08-31', 9176, 9300),('CT022','2025-09-30', 9300, 9424),
('CT022','2025-10-31', 9424, 9548),('CT022','2025-11-30', 9548, 9676),('CT022','2025-12-31', 9676, 9800),
('CT023','2025-08-31', 17725, 17900),('CT023','2025-09-30', 17900, 18075),
('CT023','2025-10-31', 18075, 18250),('CT023','2025-11-30', 18250, 18325),('CT023','2025-12-31', 18325, 18500),
('CT024','2025-08-31', 6822, 6891),('CT024','2025-09-30', 6891, 6960),
('CT024','2025-10-31', 6960, 7029),('CT024','2025-11-30', 7029, 7131),('CT024','2025-12-31', 7131, 7200),
('CT025','2025-08-31', 19656, 20144),('CT025','2025-09-30', 20144, 20632),
('CT025','2025-10-31', 20632, 21120),('CT025','2025-11-30', 21120, 21612),('CT025','2025-12-31', 21612, 22100),
('CT026','2025-08-31', 27260, 27670),('CT026','2025-09-30', 27670, 28080),
('CT026','2025-10-31', 28080, 28490),('CT026','2025-11-30', 28490, 28700),('CT026','2025-12-31', 28700, 28900),
('CT027','2025-08-31', 4848, 5036),('CT027','2025-09-30', 5036, 5224),
('CT027','2025-10-31', 5224, 5412),('CT027','2025-11-30', 5412, 5506),('CT027','2025-12-31', 5506, 5600),
('CT028','2025-08-31', 10648, 11062),('CT028','2025-09-30', 11062, 11476),
('CT028','2025-10-31', 11476, 11890),('CT028','2025-11-30', 11890, 12097),('CT028','2025-12-31', 12097, 12300),
-- Vacant property
('CT_VACANT','2025-10-31', 100, 100),('CT_VACANT','2025-11-30', 100, 100),('CT_VACANT','2025-12-31', 100, 101),
-- Factory
('CT_FACTORY','2025-10-31', 180000, 198500),('CT_FACTORY','2025-11-30', 198500, 217200),('CT_FACTORY','2025-12-31', 217200, 235800);

-- Current month readings (Jan 2026)
INSERT INTO ChiSoDienHangThang (maCongTo, ngayGhiNhan, soDienCu, soDienMoi) VALUES
('CT001','2026-01-31',  850,  924),('CT002','2026-01-31', 1200, 1318),
('CT003','2026-01-31',  640,  705),('CT004','2026-01-31', 2105, 2320),
('CT005','2026-01-31',  430,  498),('CT006','2026-01-31',  980, 1042),
('CT007','2026-01-31', 1505, 1629),('CT008','2026-01-31',  775,  860),
('CT009','2026-01-31', 3320, 3522),('CT010','2026-01-31',  510,  569),
('CT011','2026-01-31', 8900, 9425),('CT012','2026-01-31', 5400, 5790),
('CT013','2026-01-31', 3200, 3388),('CT014','2026-01-31', 7800, 8214),
('CT015','2026-01-31', 4100, 4315),('CT016','2026-01-31', 2600, 2768),
('CT017','2026-01-31', 1750, 1869),('CT018','2026-01-31',  920,  990),
('CT019','2026-01-31',  300,  365),('CT020','2026-01-31',  680,  748),
('CT021','2026-01-31', 15200, 15262),('CT022','2026-01-31',  9800, 9924),
('CT023','2026-01-31', 18500, 18675),('CT024','2026-01-31',  7200, 7269),
('CT025','2026-01-31', 22100, 22588),('CT026','2026-01-31', 28900, 29310),
('CT027','2026-01-31',  5600, 5788),('CT028','2026-01-31', 12300, 12714),
('CT_VACANT','2026-01-31', 101, 101),('CT_FACTORY','2026-01-31', 235800, 254500);

-- =====================================================
-- SECTION 7: INVOICES
-- =====================================================

-- Historical invoices (Aug-Dec 2025)
INSERT INTO HoaDon (maCongTo, ngayGhiNhan, trangThaiTT, ngayLapDon, maKeToan) VALUES
-- August 2025
('CT001','2025-08-31','Da thanh toan','2025-09-02','KT001'),
('CT002','2025-08-31','Da thanh toan','2025-09-02','KT003'),
('CT004','2025-08-31','Da thanh toan','2025-09-03','KT002'),
('CT005','2025-08-31','Da thanh toan','2025-09-03','KT004'),
('CT009','2025-08-31','Da thanh toan','2025-09-05','KT002'),
('CT011','2025-08-31','Da thanh toan','2025-09-06','KT001'),
('CT012','2025-08-31','Da thanh toan','2025-09-06','KT003'),
('CT016','2025-08-31','Da thanh toan','2025-09-08','KT004'),
-- September 2025
('CT001','2025-09-30','Da thanh toan','2025-10-02','KT001'),
('CT002','2025-09-30','Da thanh toan','2025-10-02','KT003'),
('CT004','2025-09-30','Da thanh toan','2025-10-03','KT002'),
('CT005','2025-09-30','Da thanh toan','2025-10-03','KT004'),
('CT009','2025-09-30','Da thanh toan','2025-10-05','KT002'),
('CT011','2025-09-30','Da thanh toan','2025-10-06','KT001'),
('CT012','2025-09-30','Da thanh toan','2025-10-06','KT003'),
('CT016','2025-09-30','Da thanh toan','2025-10-08','KT004'),
-- October 2025
('CT001','2025-10-31','Da thanh toan','2025-11-02','KT001'),
('CT002','2025-10-31','Da thanh toan','2025-11-02','KT003'),
('CT004','2025-10-31','Da thanh toan','2025-11-03','KT002'),
('CT005','2025-10-31','Da thanh toan','2025-11-03','KT004'),
('CT009','2025-10-31','Da thanh toan','2025-11-05','KT002'),
('CT011','2025-10-31','Da thanh toan','2025-11-06','KT001'),
('CT012','2025-10-31','Da thanh toan','2025-11-06','KT003'),
('CT016','2025-10-31','Da thanh toan','2025-11-08','KT004'),
-- November 2025 (Mix of paid and pending)
('CT001','2025-11-30','Da thanh toan','2025-12-02','KT001'),
('CT002','2025-11-30','Chua thanh toan','2025-12-02','KT003'),
('CT004','2025-11-30','Da thanh toan','2025-12-03','KT002'),
('CT005','2025-11-30','Qua han','2025-12-03','KT004'),
('CT009','2025-11-30','Da thanh toan','2025-12-05','KT002'),
('CT011','2025-11-30','Da thanh toan','2025-12-06','KT001'),
('CT012','2025-11-30','Chua thanh toan','2025-12-06','KT003'),
('CT016','2025-11-30','Da thanh toan','2025-12-08','KT004'),
-- December 2025 (More overdue cases)
('CT001','2025-12-31','Da thanh toan','2026-01-02','KT001'),
('CT002','2025-12-31','Qua han','2026-01-02','KT003'),
('CT004','2025-12-31','Da thanh toan','2026-01-03','KT002'),
('CT005','2025-12-31','Qua han','2026-01-03','KT004'),
('CT009','2025-12-31','Chua thanh toan','2026-01-05','KT002'),
('CT011','2025-12-31','Da thanh toan','2026-01-06','KT001'),
('CT012','2025-12-31','Qua han','2026-01-06','KT003'),
('CT016','2025-12-31','Da thanh toan','2026-01-08','KT004'),
-- Old meters historical invoices
('CT021','2025-08-31','Da thanh toan','2025-09-02','KT001'),
('CT021','2025-09-30','Da thanh toan','2025-10-02','KT001'),
('CT021','2025-10-31','Da thanh toan','2025-11-02','KT001'),
('CT021','2025-11-30','Da thanh toan','2025-12-02','KT001'),
('CT021','2025-12-31','Da thanh toan','2026-01-02','KT001'),
('CT022','2025-08-31','Da thanh toan','2025-09-02','KT003'),
('CT022','2025-09-30','Da thanh toan','2025-10-02','KT003'),
('CT022','2025-10-31','Da thanh toan','2025-11-02','KT003'),
('CT022','2025-11-30','Da thanh toan','2025-12-02','KT003'),
('CT022','2025-12-31','Da thanh toan','2026-01-02','KT003'),
('CT023','2025-08-31','Da thanh toan','2025-09-03','KT003'),
('CT023','2025-09-30','Da thanh toan','2025-10-03','KT003'),
('CT023','2025-10-31','Da thanh toan','2025-11-03','KT003'),
('CT023','2025-11-30','Da thanh toan','2025-12-03','KT003'),
('CT023','2025-12-31','Da thanh toan','2026-01-03','KT003'),
('CT024','2025-08-31','Da thanh toan','2025-09-03','KT004'),
('CT024','2025-09-30','Da thanh toan','2025-10-03','KT004'),
('CT024','2025-10-31','Da thanh toan','2025-11-03','KT004'),
('CT024','2025-11-30','Da thanh toan','2025-12-03','KT004'),
('CT024','2025-12-31','Da thanh toan','2026-01-03','KT004'),
('CT025','2025-08-31','Da thanh toan','2025-09-06','KT001'),
('CT025','2025-09-30','Da thanh toan','2025-10-06','KT001'),
('CT025','2025-10-31','Da thanh toan','2025-11-06','KT001'),
('CT025','2025-11-30','Da thanh toan','2025-12-06','KT001'),
('CT025','2025-12-31','Da thanh toan','2026-01-06','KT001'),
('CT026','2025-08-31','Da thanh toan','2025-09-06','KT003'),
('CT026','2025-09-30','Da thanh toan','2025-10-06','KT003'),
('CT026','2025-10-31','Da thanh toan','2025-11-06','KT003'),
('CT026','2025-11-30','Da thanh toan','2025-12-06','KT003'),
('CT026','2025-12-31','Da thanh toan','2026-01-06','KT003'),
('CT027','2025-08-31','Da thanh toan','2025-09-07','KT003'),
('CT027','2025-09-30','Da thanh toan','2025-10-07','KT003'),
('CT027','2025-10-31','Da thanh toan','2025-11-07','KT003'),
('CT027','2025-11-30','Da thanh toan','2025-12-07','KT003'),
('CT027','2025-12-31','Da thanh toan','2026-01-07','KT003'),
('CT028','2025-08-31','Da thanh toan','2025-09-07','KT002'),
('CT028','2025-09-30','Da thanh toan','2025-10-07','KT002'),
('CT028','2025-10-31','Da thanh toan','2025-11-07','KT002'),
('CT028','2025-11-30','Da thanh toan','2025-12-07','KT002'),
('CT028','2025-12-31','Da thanh toan','2026-01-07','KT002'),
('CT_VACANT','2025-10-31','Da thanh toan','2025-11-02','KT001'),
('CT_VACANT','2025-11-30','Da thanh toan','2025-12-02','KT001'),
('CT_VACANT','2025-12-31','Da thanh toan','2026-01-02','KT001'),
('CT_FACTORY','2025-10-31','Da thanh toan','2025-11-03','KT002'),
('CT_FACTORY','2025-11-30','Da thanh toan','2025-12-03','KT002'),
('CT_FACTORY','2025-12-31','Da thanh toan','2026-01-03','KT002');

-- Current month invoices (Jan 2026)
INSERT INTO HoaDon (maCongTo, ngayGhiNhan, trangThaiTT, ngayLapDon, maKeToan) VALUES
('CT001','2026-01-31','Da thanh toan','2026-02-02','KT001'),
('CT002','2026-01-31','Chua thanh toan','2026-02-02','KT003'),
('CT003','2026-01-31','Da thanh toan','2026-02-03','KT003'),
('CT004','2026-01-31','Chua thanh toan','2026-02-03','KT002'),
('CT005','2026-01-31','Da thanh toan','2026-02-03','KT004'),
('CT006','2026-01-31','Da thanh toan','2026-02-04','KT001'),
('CT007','2026-01-31','Chua thanh toan','2026-02-04','KT003'),
('CT008','2026-01-31','Da thanh toan','2026-02-04','KT003'),
('CT009','2026-01-31','Qua han','2026-02-05','KT002'),
('CT010','2026-01-31','Da thanh toan','2026-02-05','KT004'),
('CT011','2026-01-31','Chua thanh toan','2026-02-06','KT001'),
('CT012','2026-01-31','Da thanh toan','2026-02-06','KT003'),
('CT013','2026-01-31','Da thanh toan','2026-02-06','KT003'),
('CT014','2026-01-31','Chua thanh toan','2026-02-07','KT002'),
('CT015','2026-01-31','Da thanh toan','2026-02-07','KT004'),
('CT016','2026-01-31','Da thanh toan','2026-02-08','KT004'),
('CT017','2026-01-31','Chua thanh toan','2026-02-08','KT001'),
('CT018','2026-01-31','Da thanh toan','2026-02-08','KT003'),
('CT019','2026-01-31','Da thanh toan','2026-02-09','KT004'),
('CT020','2026-01-31','Chua thanh toan','2026-02-09','KT001'),
('CT021','2026-01-31','Da thanh toan','2026-02-02','KT001'),
('CT022','2026-01-31','Da thanh toan','2026-02-02','KT003'),
('CT023','2026-01-31','Chua thanh toan','2026-02-03','KT003'),
('CT024','2026-01-31','Da thanh toan','2026-02-03','KT004'),
('CT025','2026-01-31','Qua han','2026-02-06','KT001'),
('CT026','2026-01-31','Chua thanh toan','2026-02-06','KT003'),
('CT027','2026-01-31','Da thanh toan','2026-02-07','KT003'),
('CT028','2026-01-31','Da thanh toan','2026-02-07','KT002'),
('CT_VACANT','2026-01-31','Da thanh toan','2026-02-02','KT001'),
('CT_FACTORY','2026-01-31','Da thanh toan','2026-02-03','KT002');

-- =====================================================
-- SECTION 8: PAYROLL (Multi-month)
-- =====================================================

-- January 2026
INSERT INTO BangLuong (maNhanVien, thangLuong, namLuong, tienLuong, tienUngTruoc, ngayCong, tienThuong) VALUES
('QL001',1,2026,28000000.00,  0.00,26,2500000.00),
('QL002',1,2026,27000000.00,  0.00,26,2000000.00),
('QL003',1,2026,29000000.00,  0.00,26,2500000.00),
('QL004',1,2026,32000000.00,  0.00,26,3000000.00),
('QL005',1,2026,26000000.00,  0.00,26,1500000.00),
('QL006',1,2026,25500000.00,  0.00,26,1500000.00),
('QL007',1,2026,24000000.00,  0.00,26,1200000.00),
('QL008',1,2026,23500000.00,  0.00,26,1200000.00),
('KT001',1,2026,16000000.00,5000000.00,26, 800000.00),
('KT002',1,2026,18000000.00,3000000.00,26,1000000.00),
('KT003',1,2026,15500000.00,2000000.00,26, 700000.00),
('KT004',1,2026,16500000.00,2000000.00,26, 800000.00),
('LD001',1,2026,14000000.00,1000000.00,26, 600000.00),
('LD002',1,2026,14500000.00,1500000.00,26, 650000.00),
('LD003',1,2026,14200000.00,1000000.00,26, 600000.00),
('LD004',1,2026,14800000.00,1500000.00,26, 700000.00),
('HT001',1,2026,13500000.00,1000000.00,26, 500000.00),
('HT002',1,2026,15000000.00,2000000.00,26, 700000.00),
('HT003',1,2026,13800000.00,1000000.00,26, 550000.00),
('HT004',1,2026,15200000.00,2000000.00,26, 750000.00);

-- December 2025
INSERT INTO BangLuong (maNhanVien, thangLuong, namLuong, tienLuong, tienUngTruoc, ngayCong, tienThuong) VALUES
('QL001',12,2025,28000000.00,  0.00,26,2500000.00),
('QL002',12,2025,27000000.00,  0.00,26,2000000.00),
('QL003',12,2025,29000000.00,  0.00,26,2500000.00),
('QL004',12,2025,32000000.00,  0.00,26,5000000.00),
('QL005',12,2025,26000000.00,  0.00,26,1500000.00),
('QL006',12,2025,25500000.00,  0.00,26,1500000.00),
('QL007',12,2025,24000000.00,  0.00,26,1200000.00),
('QL008',12,2025,23500000.00,  0.00,26,1200000.00),
('KT001',12,2025,16000000.00,3000000.00,26,1500000.00),
('KT002',12,2025,18000000.00,2000000.00,26,2000000.00),
('KT003',12,2025,15500000.00,1000000.00,26,1200000.00),
('KT004',12,2025,16500000.00,1500000.00,26,1300000.00),
('LD001',12,2025,14000000.00, 500000.00,26,1000000.00),
('LD002',12,2025,14500000.00,1000000.00,26,1100000.00),
('LD003',12,2025,14200000.00, 500000.00,26,1000000.00),
('LD004',12,2025,14800000.00,1000000.00,26,1200000.00),
('HT001',12,2025,13500000.00, 500000.00,26, 800000.00),
('HT002',12,2025,15000000.00,1500000.00,26,1000000.00),
('HT003',12,2025,13800000.00, 500000.00,26, 850000.00),
('HT004',12,2025,15200000.00,1500000.00,26,1100000.00);

-- November 2025 (partial data)
INSERT INTO BangLuong (maNhanVien, thangLuong, namLuong, tienLuong, tienUngTruoc, ngayCong, tienThuong) VALUES
('QL001',11,2025,28000000.00,  0.00,25,2000000.00),
('QL004',11,2025,32000000.00,  0.00,22,2500000.00),
('KT001',11,2025,16000000.00,4000000.00,26, 800000.00),
('KT002',11,2025,18000000.00,2500000.00,26, 900000.00),
('LD001',11,2025,14000000.00, 800000.00,26, 600000.00),
('LD002',11,2025,14500000.00,1200000.00,24, 550000.00),
('HT001',11,2025,13500000.00, 800000.00,26, 500000.00),
('HT002',11,2025,15000000.00,1800000.00,26, 700000.00);

-- =====================================================
-- SECTION 9: FINANCIAL DATA
-- =====================================================

-- January 2026
INSERT INTO ChiPhiCongTy (maChiNhanh, namTaiChinh, thangTaiChinh, chiPhiThang, doanhThuThang) VALUES
('CN001',2026,1, 850000000.00,1120000000.00),
('CN002',2026,1, 520000000.00, 760000000.00),
('CN003',2026,1, 610000000.00, 890000000.00),
('CN004',2026,1,1200000000.00,1650000000.00),
('CN005',2026,1, 480000000.00, 700000000.00),
-- ('CN006',2026,1, 430000000.00, 590000000.00),
-- ('CN007',2026,1, 390000000.00, 540000000.00),
-- ('CN008',2026,1, 410000000.00, 560000000.00),
('CN009',2026,1, 450000000.00, 640000000.00),
-- ('CN010',2026,1, 470000000.00, 650000000.00),
('CN011',2026,1, 500000000.00, 720000000.00),
-- ('CN012',2026,1, 360000000.00, 510000000.00),
-- ('CN013',2026,1, 340000000.00, 480000000.00),
-- ('CN014',2026,1, 320000000.00, 460000000.00),
-- ('CN015',2026,1, 300000000.00, 430000000.00),
-- ('CN016',2026,1, 310000000.00, 440000000.00),
-- ('CN017',2026,1, 280000000.00, 410000000.00),
-- ('CN018',2026,1, 290000000.00, 420000000.00),
-- ('CN019',2026,1, 305000000.00, 445000000.00),
('CN020',2026,1, 330000000.00, 470000000.00);

-- Q4 2025
INSERT INTO ChiPhiCongTy (maChiNhanh, namTaiChinh, thangTaiChinh, chiPhiThang, doanhThuThang) VALUES
('CN001',2025,10, 820000000.00,1080000000.00),
('CN002',2025,10, 500000000.00, 740000000.00),
('CN003',2025,10, 590000000.00, 870000000.00),
('CN004',2025,10,1180000000.00,1620000000.00),
('CN005',2025,10, 470000000.00, 680000000.00),
('CN001',2025,11, 840000000.00,1100000000.00),
('CN002',2025,11, 510000000.00, 750000000.00),
('CN003',2025,11, 600000000.00, 880000000.00),
('CN004',2025,11,1190000000.00,1635000000.00),
('CN005',2025,11, 475000000.00, 690000000.00),
('CN001',2025,12, 880000000.00,1150000000.00),
('CN002',2025,12, 530000000.00, 780000000.00),
('CN003',2025,12, 620000000.00, 910000000.00),
('CN004',2025,12,1220000000.00,1680000000.00),
('CN005',2025,12, 490000000.00, 720000000.00);

-- =====================================================
-- SECTION 10: SUPPORT TICKETS
-- =====================================================

INSERT INTO NV_HoTro_KhachHang (maNVHoTro, maKhachHang, ngayHoTro, lyDoHoTro) VALUES
-- January 2026 tickets
('HT001','KH001','2026-01-05 09:15:00','Huong dan tra cuu hoa don dien tu va ky thanh toan'),
('HT001','KH006','2026-01-06 14:20:00','Kiem tra thong tin chu hop dong, cap nhat so dien thoai'),
('HT003','KH003','2026-01-07 10:05:00','Giai dap thac mac chi so dien tang bat thuong'),
('HT002','KH004','2026-01-07 16:40:00','Huong dan dang ky nhan thong bao qua Zalo OA'),
('HT004','KH005','2026-01-08 08:30:00','Tiep nhan yeu cau doi lich ghi chi so do khach vang nha'),
('HT003','KH008','2026-01-09 11:10:00','Ho tro cap lai ma khach hang/ma hop dong'),
('HT002','KH009','2026-01-10 15:50:00','Giai dap ve muc gia dien sinh hoat theo bac'),
('HT001','KH002','2026-01-11 09:05:00','Ho tro dang ky thanh toan tu dong qua ngan hang'),
('HT004','KH010','2026-01-11 13:25:00','Tiep nhan phan anh mat dien cuc bo, chuyen bo phan ky thuat'),
('HT003','KH007','2026-01-12 17:05:00','Huong dan xac nhan bien ban ghi chi so'),
('HT002','KH011','2026-01-13 10:00:00','Tu van thu tuc cap dien moi cho co so kinh doanh'),
('HT001','KH012','2026-01-14 09:45:00','Giai dap ve chuyen doi bang gia dien kinh doanh'),
('HT003','KH013','2026-01-14 16:15:00','Tiep nhan yeu cau dieu chinh thong tin cong ty tren hop dong'),
('HT002','KH014','2026-01-15 11:30:00','Ho tro xuat hoa don GTGT theo ky'),
('HT004','KH015','2026-01-16 14:10:00','Huong dan ho so ap dung bang gia hanh chinh su nghiep'),
('HT003','KH016','2026-01-18 09:20:00','Tiep nhan phan anh nhap nhay dien ap, hen kiem tra'),
('HT001','KH017','2026-01-19 15:35:00','Ho tro tra cuu lich su thanh toan 6 thang gan nhat'),
('HT002','KH018','2026-01-20 10:40:00','Huong dan cach doc chi so cong to va bao cao chi so'),
('HT004','KH019','2026-01-21 08:55:00','Tiep nhan yeu cau doi vi tri lap dat cong to (khao sat)'),
('HT001','KH020','2026-01-22 13:05:00','Giai dap ve quy dinh tre han/qua han thanh toan'),
-- Additional tickets for problem customers
('HT002','KH002','2025-12-10 09:30:00','Phan anh hoa don tang dot bien, yeu cau kiem tra cong to'),
('HT001','KH002','2025-12-15 14:20:00','Kiem tra lai chi so dien, xac nhan khong co su co'),
('HT003','KH002','2026-01-08 10:45:00','Huong dan tiet kiem dien, giai thich muc tieu thu cao'),
('HT002','KH002','2026-01-25 16:15:00','Canh bao hoa don qua han thanh toan'),
('HT004','KH011','2025-11-20 11:00:00','Yeu cau thay the cong to cu, da qua han bao tri'),
('HT001','KH011','2025-12-05 09:30:00','Hen lich kiem tra va thay cong to moi'),
('HT003','KH011','2026-01-10 14:00:00','Xac nhan hoan tat thay cong to, cung cap so moi'),
('HT002','KH014','2026-01-12 10:20:00','Huong dan xuat hoa don GTGT dang ky dien tu'),
('HT001','KH014','2026-01-20 15:40:00','Giai dap ve uu dai gia dien gio thap diem'),
('HT003','KH006','2026-01-28 09:15:00','Yeu cau gia han hop dong dien sap het han'),
('HT002','KH007','2026-01-29 13:45:00','Tu van thu tuc gia han va doi loai hop dong'),
('HT004','KH005','2025-12-20 08:50:00','Phan anh loi thanh toan truc tuyen, yeu cau ho tro'),
('HT001','KH005','2026-01-15 16:30:00','Canh bao cat dien do qua han thanh toan'),
('HT003','KH008','2026-01-16 11:25:00','Bao cao nhap nhay dien ap thuong xuyen'),
('HT004','KH008','2026-01-23 14:50:00','Cap nhat: Da kiem tra, do loi luoi dien khu vuc'),
('HT002','KH016','2025-02-10 10:00:00','Huong dan su dung dich vu khach hang doanh nghiep'),
('HT001','KH017','2025-03-05 09:30:00','Cai dat ung dung tra cuu hoa don va thanh toan'),
('HT003','KH003','2026-01-17 15:20:00','Tranh chap chi so ghi, khach hang khong dong y'),
('HT002','KH003','2026-01-24 10:10:00','Xac minh chi so, gui anh chung minh');

-- =====================================================

-- =====================================================
-- SECTION 11: ADDITIONAL DATASET (KH021-KH040) + METERS + READINGS + INVOICES
-- Notes:
--   - Added 20 new customers (KH021-KH040) with realistic addresses/phone numbers.
--   - Added 22 new meters (CT029-CT050). Some customers have 2 meters to cover "multiple meters per customer".
--   - Added readings for 2026-01-31 and 2026-02-28 for all new meters.
--   - Added invoices for all new meters in January 2026 (ngayGhiNhan = 2026-01-31).
--   - For Feb 2026: CT029-CT038 have readings but intentionally NO invoices (case: "chi so chua co hoa don").
-- =====================================================

INSERT INTO KhachHang (maKhachHang, tenKhachHang, maSoThue, diaChi, maChiNhanh, maBangGiaDien) VALUES
('KH021', 'Hoang Anh Tuan', '0109234571', 'So 55 Pham Van Dong, Bac Tu Liem, Ha Noi', 'CN001', 'BGD001'),
('KH022', 'Do Thi Mai', '0109234572', 'So 18 Nguyen Van Cu, Long Bien, Ha Noi', 'CN001', 'BGD001'),
('KH023', 'Cong ty TNHH May Moc Minh Phat', '0109234573', 'Lo A3 KCN Thang Long, Dong Anh, Ha Noi', 'CN001', 'BGD004'),
('KH024', 'Vu Duc Hieu', '0208456121', 'So 120 Le Loi, Ngo Quyen, Hai Phong', 'CN002', 'BGD001'),
('KH025', 'Tran Thi Thu Ha', '0208456122', 'So 7 Tran Phu, Hong Bang, Hai Phong', 'CN002', 'BGD001'),
('KH026', 'Cong ty Co phan Dong Lan Logistics', '0208456123', 'So 89 Lach Tray, Ngo Quyen, Hai Phong', 'CN002', 'BGD003'),
('KH027', 'Le Van Nam', '0403189001', 'So 23 Nguyen Van Linh, Hai Chau, Da Nang', 'CN003', 'BGD001'),
('KH028', 'Nguyen Thi Kim Ngan', '0403189002', 'So 14 Hoang Dieu, Hai Chau, Da Nang', 'CN003', 'BGD001'),
('KH029', 'Cong ty TNHH Nha Hang Bien Xanh', '0403189003', 'So 2 Vo Nguyen Giap, Son Tra, Da Nang', 'CN003', 'BGD002'),
('KH030', 'Pham Minh Duc', '0312345671', 'So 58 Dien Bien Phu, Binh Thanh, TP HCM', 'CN004', 'BGD001'),
('KH031', 'Nguyen Thi Thanh Truc', '0312345672', 'So 19 Nguyen Dinh Chieu, Quan 3, TP HCM', 'CN004', 'BGD001'),
('KH032', 'Cong ty CP San Xuat Bao Bi An Phat', '0312345673', 'KCN Tan Tao, Binh Tan, TP HCM', 'CN004', 'BGD004'),
('KH033', 'Bui Gia Bao', '1804567891', 'So 101 Le Dai Hanh, Ninh Kieu, Can Tho', 'CN005', 'BGD001'),
('KH034', 'Le Thi My Duyen', '1804567892', 'So 8 Hoa Binh, Ninh Kieu, Can Tho', 'CN005', 'BGD001'),
('KH035', 'Cong ty TNHH Che Bien Thuy San Mekong', '1804567893', 'KCN Tra Noc, Binh Thuy, Can Tho', 'CN005', 'BGD003'),
('KH036', 'Tran Quang Huy', '4201122331', 'So 12 Tran Phu, Nha Trang, Khanh Hoa', 'CN009', 'BGD001'),
('KH037', 'Cong ty TNHH Khach San SunSea', '4201122332', 'So 5 Hung Vuong, Nha Trang, Khanh Hoa', 'CN009', 'BGD002'),
('KH038', 'Phan Thi Ngoc', '5702233441', 'So 77 Tran Quoc Nghien, Ha Long, Quang Ninh', 'CN011', 'BGD001'),
('KH039', 'Cong ty CP Than Dai Phuc', '5702233442', 'KCN Cai Lan, Ha Long, Quang Ninh', 'CN011', 'BGD004'),
('KH040', 'Nguyen Van Binh', '4103344551', 'So 9 An Duong Vuong, Quy Nhon, Binh Dinh', 'CN020', 'BGD001');

INSERT INTO SDT_KhachHang (maKhachHang, soDienThoai) VALUES
('KH021', '0965123011'),
('KH022', '0912348801'),
('KH023', '02437561234'),
('KH023', '0915888999'),
('KH024', '0977123024'),
('KH025', '0903123025'),
('KH026', '02253669988'),
('KH027', '0935123027'),
('KH028', '0988123028'),
('KH029', '02363771234'),
('KH030', '0909123030'),
('KH031', '0978123031'),
('KH032', '02838771234'),
('KH033', '0916123033'),
('KH034', '0949123034'),
('KH035', '02923681234'),
('KH036', '02583811234'),
('KH037', '02583821234'),
('KH038', '02033691234'),
('KH039', '02033881234'),
('KH040', '02563861234');

INSERT INTO HopDong (maHopDong, ngayKy, ngayBatDau, thoiHan, trangThai, maChiNhanh, maKhachHang, maNVQuanLy) VALUES
('HD031','2016-03-12','2022-04-01',5,'Hieu luc','CN001','KH021','QL001'),
('HD032','2017-07-05','2021-07-25',6,'Hieu luc','CN001','KH022','QL001'),
('HD033','2014-09-18','2020-10-20',6,'Hieu luc','CN001','KH023','QL001'),

('HD034','2019-01-10','2022-02-01',5,'Hieu luc','CN002','KH024','QL002'),
('HD035','2020-05-03','2021-05-28',6,'Hieu luc','CN002','KH025','QL002'),
('HD036','2015-11-22','2020-12-15',6,'Hieu luc','CN002','KH026','QL002'),

('HD037','2013-04-09','2024-04-30',5,'Hieu luc','CN003','KH027','QL003'),
('HD038','2018-06-14','2021-07-01',6,'Hieu luc','CN003','KH028','QL003'),
('HD039','2012-02-01','2019-02-20',7,'Hieu luc','CN003','KH029','QL003'),

('HD040','2021-08-05','2022-08-25',5,'Hieu luc','CN004','KH030','QL004'),
('HD041','2016-10-12','2021-11-01',5,'Hieu luc','CN004','KH031','QL004'),
('HD042','2014-12-03','2020-01-10',6,'Hieu luc','CN004','KH032','QL004'),

('HD043','2019-09-01','2021-09-20',5,'Hieu luc','CN005','KH033','QL005'),
('HD044','2011-05-07','2016-05-25',10,'Hieu luc','CN005','KH034','QL005'),
('HD045','2017-11-11','2021-12-05',6,'Hieu luc','CN005','KH035','QL005'),

('HD046','2013-08-15','2019-09-01',7,'Hieu luc','CN009','KH036','QL006'),
('HD047','2018-03-20','2021-04-10',6,'Hieu luc','CN009','KH037','QL006'),

('HD048','2012-06-02','2016-06-18',10,'Hieu luc','CN011','KH038','QL007'),
('HD049','2022-01-08','2022-02-01',5,'Hieu luc','CN011','KH039','QL007'),
('HD050','2015-04-01','2020-04-20',6,'Hieu luc','CN020','KH040','QL008');


INSERT INTO CongToDien (maCongTo, giaMua, hanSuDung, ngayLapDat, maCongTy, maKhachHang, maNVLapDat) VALUES
('CT029', 980000.00, 12, '2016-03-20', 'CTY001', 'KH021', 'LD001'),
('CT030', 1100000.00, 12, '2016-03-28', 'CTY003', 'KH021', 'LD001'),

('CT031', 990000.00, 12, '2017-07-15', 'CTY001', 'KH022', 'LD001'),

('CT032', 1450000.00, 10, '2014-10-05', 'CTY005', 'KH023', 'LD001'),

('CT033', 975000.00, 12, '2019-01-20', 'CTY001', 'KH024', 'LD003'),

('CT034', 1000000.00, 12, '2020-05-15', 'CTY002', 'KH025', 'LD003'),

('CT035', 1500000.00, 10, '2015-12-01', 'CTY004', 'KH026', 'LD003'),

('CT036', 980000.00, 12, '2013-04-18', 'CTY003', 'KH027', 'LD003'),

('CT037', 980000.00, 12, '2018-06-22', 'CTY001', 'KH028', 'LD003'),

('CT038', 1350000.00, 10, '2012-02-10', 'CTY005', 'KH029', 'LD003'),

('CT039', 990000.00, 12, '2021-08-15', 'CTY002', 'KH030', 'LD002'),

('CT040', 995000.00, 12, '2016-10-22', 'CTY003', 'KH031', 'LD002'),

('CT041', 1600000.00, 10, '2014-12-15', 'CTY004', 'KH032', 'LD002'),
('CT042', 1550000.00, 10, '2014-12-28', 'CTY005', 'KH032', 'LD002'),

('CT043', 980000.00, 12, '2019-09-10', 'CTY001', 'KH033', 'LD004'),

('CT044', 980000.00, 12, '2011-05-15', 'CTY003', 'KH034', 'LD004'),

('CT045', 1500000.00, 10, '2017-11-25', 'CTY004', 'KH035', 'LD004'),

('CT046', 990000.00, 12, '2013-08-22', 'CTY001', 'KH036', 'LD003'),

('CT047', 1350000.00, 10, '2018-03-30', 'CTY005', 'KH037', 'LD003'),

('CT048', 980000.00, 12, '2012-06-10', 'CTY002', 'KH038', 'LD003'),

('CT049', 1700000.00, 10, '2022-01-20', 'CTY004', 'KH039', 'LD003'),

('CT050', 980000.00, 12, '2015-04-10', 'CTY003', 'KH040', 'LD003');


INSERT INTO ChiSoDienHangThang (maCongTo, ngayGhiNhan, soDienCu, soDienMoi) VALUES
('CT029', '2026-01-31', 82, 200),
('CT029', '2026-02-28', 200, 381),
('CT030', '2026-01-31', 166, 258),
('CT030', '2026-02-28', 258, 356),
('CT031', '2026-01-31', 210, 427),
('CT031', '2026-02-28', 427, 531),
('CT032', '2026-01-31', 93, 1886),
('CT032', '2026-02-28', 1886, 2604),
('CT033', '2026-01-31', 232, 441),
('CT033', '2026-02-28', 441, 575),
('CT034', '2026-01-31', 9, 111),
('CT034', '2026-02-28', 111, 302),
('CT035', '2026-01-31', 107, 850),
('CT035', '2026-02-28', 850, 1942),
('CT036', '2026-01-31', 23, 244),
('CT036', '2026-02-28', 244, 432),
('CT037', '2026-01-31', 15, 239),
('CT037', '2026-02-28', 239, 350),
('CT038', '2026-01-31', 242, 1299),
('CT038', '2026-02-28', 1299, 3190),
('CT039', '2026-01-31', 160, 389),
('CT039', '2026-02-28', 389, 484),
('CT040', '2026-01-31', 147, 376),
('CT040', '2026-02-28', 376, 557),
('CT041', '2026-01-31', 12, 1064),
('CT041', '2026-02-28', 1064, 1759),
('CT042', '2026-01-31', 142, 1014),
('CT042', '2026-02-28', 1014, 2207),
('CT043', '2026-01-31', 107, 223),
('CT043', '2026-02-28', 223, 441),
('CT044', '2026-01-31', 30, 256),
('CT044', '2026-02-28', 256, 414),
('CT045', '2026-01-31', 143, 2139),
('CT045', '2026-02-28', 2139, 3109),
('CT046', '2026-01-31', 26, 254),
('CT046', '2026-02-28', 254, 480),
('CT047', '2026-01-31', 163, 1147),
('CT047', '2026-02-28', 1147, 2509),
('CT048', '2026-01-31', 24, 244),
('CT048', '2026-02-28', 244, 506),
('CT049', '2026-01-31', 16, 1771),
('CT049', '2026-02-28', 1771, 2493),
('CT050', '2026-01-31', 158, 290),
('CT050', '2026-02-28', 290, 497);

INSERT INTO HoaDon (maCongTo, ngayGhiNhan, trangThaiTT, ngayLapDon, maKeToan) VALUES
('CT029', '2026-01-31', 'Da thanh toan', '2026-02-02', 'KT001'),
('CT030', '2026-01-31', 'Da thanh toan', '2026-02-02', 'KT001'),
('CT031', '2026-01-31', 'Da thanh toan', '2026-02-02', 'KT001'),
('CT032', '2026-01-31', 'Da thanh toan', '2026-02-02', 'KT001'),
('CT033', '2026-01-31', 'Qua han', '2026-02-02', 'KT001'),
('CT034', '2026-01-31', 'Da thanh toan', '2026-02-02', 'KT001'),
('CT035', '2026-01-31', 'Chua thanh toan', '2026-02-02', 'KT001'),
('CT036', '2026-01-31', 'Da thanh toan', '2026-02-02', 'KT002'),
('CT037', '2026-01-31', 'Chua thanh toan', '2026-02-02','KT002'),
('CT038', '2026-01-31', 'Da thanh toan', '2026-02-02', 'KT002'),
('CT039', '2026-01-31', 'Qua han', '2026-02-02', 'KT003'),
('CT040', '2026-01-31', 'Da thanh toan', '2026-02-02', 'KT003'),
('CT041', '2026-01-31', 'Chua thanh toan', '2026-02-02','KT003'),
('CT042', '2026-01-31', 'Da thanh toan', '2026-02-02',  'KT003'),
('CT043', '2026-01-31', 'Da thanh toan', '2026-02-02',  'KT004'),
('CT044', '2026-01-31', 'Chua thanh toan', '2026-02-02','KT004'),
('CT045', '2026-01-31', 'Qua han', '2026-02-02', 'KT004'),
('CT046', '2026-01-31', 'Chua thanh toan', '2026-02-02', 'KT001'),
('CT047', '2026-01-31', 'Chua thanh toan', '2026-02-02', 'KT001'),
('CT048', '2026-01-31', 'Chua thanh toan', '2026-02-02', 'KT001'),
('CT049', '2026-01-31', 'Chua thanh toan', '2026-02-02',  'KT001'),
('CT050', '2026-01-31', 'Qua han', '2026-02-02',  'KT001'),
('CT039', '2026-02-28', 'Chua thanh toan', '2026-03-02',  'KT003'),
('CT040', '2026-02-28', 'Da thanh toan', '2026-03-02', 'KT003'),
('CT041', '2026-02-28', 'Chua thanh toan', '2026-03-02',  'KT003'),
('CT042', '2026-02-28', 'Chua thanh toan', '2026-03-02',  'KT003'),
('CT043', '2026-02-28', 'Chua thanh toan', '2026-03-02',  'KT004'),
('CT044', '2026-02-28', 'Chua thanh toan', '2026-03-02',  'KT004'),
('CT045', '2026-02-28', 'Chua thanh toan', '2026-03-02',  'KT004'),
('CT046', '2026-02-28', 'Chua thanh toan', '2026-03-02',  'KT001'),
('CT047', '2026-02-28', 'Chua thanh toan', '2026-03-02',  'KT001'),
('CT048', '2026-02-28', 'Chua thanh toan', '2026-03-02',  'KT001'),
('CT049', '2026-02-28', 'Chua thanh toan', '2026-03-02', 'KT001'),
('CT050', '2026-02-28', 'Da thanh toan', '2026-03-02','KT001');

INSERT INTO NV_HoTro_KhachHang (maNVHoTro, maKhachHang, ngayHoTro, lyDoHoTro) VALUES
('HT001', 'KH021', '2026-01-10', 'Ho tro dang ky thanh toan dien tu'),
('HT002', 'KH023', '2026-01-14', 'Kiem tra cong to co dau hieu nhay so'),
('HT003', 'KH024', '2026-01-18', 'Tu van bieu gia dien phu hop'),
('HT004', 'KH029', '2026-01-22', 'Cap nhat thong tin hop dong va dia chi'),
('HT001', 'KH030', '2026-01-26', 'Huong dan tra cuu hoa don tren ung dung'),
('HT002', 'KH032', '2026-01-30', 'Ho tro doi so dien thoai lien he'),
('HT003', 'KH033', '2026-02-03', 'Kiem tra lich ghi chi so thang'),
('HT004', 'KH036', '2026-02-07', 'Tiep nhan phan anh ve hoa don'),
('HT001', 'KH038', '2026-02-11', 'Ho tro tao tai khoan khach hang'),
('HT002', 'KH040', '2026-02-15', 'Huong dan thu tuc tach cong to');


-- DATA SUMMARY
-- =====================================================
SET FOREIGN_KEY_CHECKS = 1;

SELECT '========================================' AS '';
SELECT '✓ COMPLETE MOCK DATA LOADED SUCCESSFULLY!' AS Status;
SELECT '========================================' AS '';
SELECT '' AS '';
SELECT 'Data Statistics:' AS '';
SELECT '-------------------' AS '';
SELECT 'Meter readings' AS Item, COUNT(*) AS Count FROM ChiSoDienHangThang
UNION ALL SELECT 'Invoices', COUNT(*) FROM HoaDon
UNION ALL SELECT 'Customers', COUNT(*) FROM KhachHang
UNION ALL SELECT 'Meters', COUNT(*) FROM CongToDien
UNION ALL SELECT 'Contracts', COUNT(*) FROM HopDong
UNION ALL SELECT 'Employees', COUNT(*) FROM NhanVien
UNION ALL SELECT 'Support tickets', COUNT(*) FROM NV_HoTro_KhachHang;

SELECT '' AS '';
SELECT 'Key Test Scenarios:' AS '';
SELECT '-------------------' AS '';
SELECT '✓ 6 months meter reading history (Aug 2025 - Jan 2026)' AS Scenario
UNION ALL SELECT '✓ Abnormal usage patterns (CT002, CT005, CT009)'
UNION ALL SELECT '✓ Overdue invoices (5-6 cases)'
UNION ALL SELECT '✓ Maintenance alerts (6 critical meters)'
UNION ALL SELECT '✓ Contract expiry scenarios'
UNION ALL SELECT '✓ Multi-month payroll data'
UNION ALL SELECT '✓ Edge cases (zero consumption, factory)'
UNION ALL SELECT '✓ 100+ meter readings for testing';
