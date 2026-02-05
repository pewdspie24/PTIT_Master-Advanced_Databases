-- MySQL dump 10.13  Distrib 8.4.8, for Linux (x86_64)
--
-- Host: localhost    Database: QuanLyDienLuc_Final
-- ------------------------------------------------------
-- Server version	8.4.8-0ubuntu0.25.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `BacGiaDien`
--

DROP TABLE IF EXISTS `BacGiaDien`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BacGiaDien` (
  `maBangGia` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `thuTuCapBac` int NOT NULL,
  `giaDienTrenKwh` decimal(10,2) DEFAULT NULL,
  `tuSoDien` int DEFAULT NULL,
  `toiSoDien` int DEFAULT NULL,
  PRIMARY KEY (`maBangGia`,`thuTuCapBac`),
  CONSTRAINT `BacGiaDien_ibfk_1` FOREIGN KEY (`maBangGia`) REFERENCES `BangGiaDien` (`ma`) ON DELETE CASCADE,
  CONSTRAINT `chk_BacGiaDien_Positive` CHECK (((`tuSoDien` >= 0) and (`giaDienTrenKwh` >= 0))),
  CONSTRAINT `chk_BacGiaDien_Range` CHECK ((`toiSoDien` > `tuSoDien`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BacGiaDien`
--

LOCK TABLES `BacGiaDien` WRITE;
/*!40000 ALTER TABLE `BacGiaDien` DISABLE KEYS */;
INSERT INTO `BacGiaDien` VALUES ('BGD001',1,1806.00,0,50),('BGD001',2,1866.00,51,100),('BGD001',3,2167.00,101,200),('BGD001',4,2729.00,201,300),('BGD001',5,3050.00,301,400),('BGD001',6,3151.00,401,NULL),('BGD002',1,2900.00,0,NULL),('BGD003',1,1850.00,0,NULL),('BGD004',1,2100.00,0,NULL);
/*!40000 ALTER TABLE `BacGiaDien` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_ValidateBacGia_BeforeInsert` BEFORE INSERT ON `BacGiaDien` FOR EACH ROW BEGIN
    -- Kiểm tra logic: Từ số phải nhỏ hơn Tới số (nếu Tới số không phải là NULL/Vô cùng)
    IF NEW.toiSoDien IS NOT NULL AND NEW.tuSoDien >= NEW.toiSoDien THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi cấu hình: Số điện bắt đầu (TuSoDien) phải nhỏ hơn số kết thúc (ToiSoDien).';
    END IF;

    -- Kiểm tra âm
    IF NEW.tuSoDien < 0 OR (NEW.toiSoDien IS NOT NULL AND NEW.toiSoDien < 0) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi cấu hình: Số điện không được âm.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `BangGiaDien`
--

DROP TABLE IF EXISTS `BangGiaDien`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BangGiaDien` (
  `ma` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tenBang` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ma`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BangGiaDien`
--

LOCK TABLES `BangGiaDien` WRITE;
/*!40000 ALTER TABLE `BangGiaDien` DISABLE KEYS */;
INSERT INTO `BangGiaDien` VALUES ('BGD001','Sinh hoat'),('BGD002','Kinh doanh'),('BGD003','San xuat'),('BGD004','Hanh chinh su nghiep');
/*!40000 ALTER TABLE `BangGiaDien` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BangLuong`
--

DROP TABLE IF EXISTS `BangLuong`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BangLuong` (
  `maNhanVien` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `thangLuong` int NOT NULL,
  `namLuong` int NOT NULL,
  `tienLuong` decimal(15,2) DEFAULT NULL,
  `tienUngTruoc` decimal(15,2) DEFAULT NULL,
  `ngayCong` int DEFAULT NULL,
  `tienThuong` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`maNhanVien`,`thangLuong`,`namLuong`),
  CONSTRAINT `BangLuong_ibfk_1` FOREIGN KEY (`maNhanVien`) REFERENCES `NhanVien` (`maNhanVien`) ON DELETE CASCADE,
  CONSTRAINT `chk_BangLuong_NgayCong` CHECK ((`ngayCong` between 0 and 31)),
  CONSTRAINT `chk_BangLuong_ThangNam` CHECK (((`thangLuong` between 1 and 12) and (`namLuong` > 2000))),
  CONSTRAINT `chk_BangLuong_TienLuong` CHECK (((`tienLuong` >= 0) and (`tienUngTruoc` >= 0) and (`tienThuong` >= 0)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BangLuong`
--

LOCK TABLES `BangLuong` WRITE;
/*!40000 ALTER TABLE `BangLuong` DISABLE KEYS */;
INSERT INTO `BangLuong` VALUES ('HT001',1,2026,13500000.00,1000000.00,26,500000.00),('HT001',11,2025,13500000.00,800000.00,26,500000.00),('HT001',12,2025,13500000.00,500000.00,26,800000.00),('HT002',1,2026,15000000.00,2000000.00,26,700000.00),('HT002',11,2025,15000000.00,1800000.00,26,700000.00),('HT002',12,2025,15000000.00,1500000.00,26,1000000.00),('HT003',1,2026,13800000.00,1000000.00,26,550000.00),('HT003',12,2025,13800000.00,500000.00,26,850000.00),('HT004',1,2026,15200000.00,2000000.00,26,750000.00),('HT004',12,2025,15200000.00,1500000.00,26,1100000.00),('KT001',1,2026,16000000.00,5000000.00,26,800000.00),('KT001',11,2025,16000000.00,4000000.00,26,800000.00),('KT001',12,2025,16000000.00,3000000.00,26,1500000.00),('KT002',1,2026,18000000.00,3000000.00,26,1000000.00),('KT002',11,2025,18000000.00,2500000.00,26,900000.00),('KT002',12,2025,18000000.00,2000000.00,26,2000000.00),('KT003',1,2026,15500000.00,2000000.00,26,700000.00),('KT003',12,2025,15500000.00,1000000.00,26,1200000.00),('KT004',1,2026,16500000.00,2000000.00,26,800000.00),('KT004',12,2025,16500000.00,1500000.00,26,1300000.00),('LD001',1,2026,14000000.00,1000000.00,26,600000.00),('LD001',11,2025,14000000.00,800000.00,26,600000.00),('LD001',12,2025,14000000.00,500000.00,26,1000000.00),('LD002',1,2026,14500000.00,1500000.00,26,650000.00),('LD002',11,2025,14500000.00,1200000.00,24,550000.00),('LD002',12,2025,14500000.00,1000000.00,26,1100000.00),('LD003',1,2026,14200000.00,1000000.00,26,600000.00),('LD003',12,2025,14200000.00,500000.00,26,1000000.00),('LD004',1,2026,14800000.00,1500000.00,26,700000.00),('LD004',12,2025,14800000.00,1000000.00,26,1200000.00),('QL001',1,2026,28000000.00,0.00,26,2500000.00),('QL001',11,2025,28000000.00,0.00,25,2000000.00),('QL001',12,2025,28000000.00,0.00,26,2500000.00),('QL002',1,2026,27000000.00,0.00,26,2000000.00),('QL002',12,2025,27000000.00,0.00,26,2000000.00),('QL003',1,2026,29000000.00,0.00,26,2500000.00),('QL003',12,2025,29000000.00,0.00,26,2500000.00),('QL004',1,2026,32000000.00,0.00,26,3000000.00),('QL004',11,2025,32000000.00,0.00,22,2500000.00),('QL004',12,2025,32000000.00,0.00,26,5000000.00),('QL005',1,2026,26000000.00,0.00,26,1500000.00),('QL005',12,2025,26000000.00,0.00,26,1500000.00),('QL006',1,2026,25500000.00,0.00,26,1500000.00),('QL006',12,2025,25500000.00,0.00,26,1500000.00),('QL007',1,2026,24000000.00,0.00,26,1200000.00),('QL007',12,2025,24000000.00,0.00,26,1200000.00),('QL008',1,2026,23500000.00,0.00,26,1200000.00),('QL008',12,2025,23500000.00,0.00,26,1200000.00);
/*!40000 ALTER TABLE `BangLuong` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ChiNhanh`
--

DROP TABLE IF EXISTS `ChiNhanh`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ChiNhanh` (
  `maChiNhanh` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `soDienThoai` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ten` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `diaChi` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `maKhuVuc` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`maChiNhanh`),
  KEY `maKhuVuc` (`maKhuVuc`),
  CONSTRAINT `ChiNhanh_ibfk_1` FOREIGN KEY (`maKhuVuc`) REFERENCES `KhuVuc` (`maKhuVuc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ChiNhanh`
--

LOCK TABLES `ChiNhanh` WRITE;
/*!40000 ALTER TABLE `ChiNhanh` DISABLE KEYS */;
INSERT INTO `ChiNhanh` VALUES ('CN001','02437980001','Chi nhanh Dien luc Hoan Kiem','So 12 Tran Hung Dao, Hoan Kiem, Ha Noi','KV001'),('CN002','02253820001','Chi nhanh Dien luc Ngo Quyen','So 08 Le Hong Phong, Ngo Quyen, Hai Phong','KV002'),('CN003','02363820001','Chi nhanh Dien luc Hai Chau','So 45 Nguyen Van Linh, Hai Chau, Da Nang','KV003'),('CN004','02838200001','Chi nhanh Dien luc Quan 1','So 18 Nguyen Hue, Quan 1, TP HCM','KV004'),('CN005','02923820001','Chi nhanh Dien luc Ninh Kieu','So 27 Hoa Binh, Ninh Kieu, Can Tho','KV005'),('CN006','02743820001','Chi nhanh Dien luc Thu Dau Mot','So 05 Yersin, Thu Dau Mot, Binh Duong','KV006'),('CN007','02203820001','Chi nhanh Dien luc TP Hai Duong','So 66 Tran Phu, TP Hai Duong, Hai Duong','KV007'),('CN008','02383820001','Chi nhanh Dien luc TP Vinh','So 09 Le Nin, TP Vinh, Nghe An','KV008'),('CN009','02583820001','Chi nhanh Dien luc Nha Trang','So 20 Tran Phu, Nha Trang, Khanh Hoa','KV009'),('CN010','02513820001','Chi nhanh Dien luc Bien Hoa','So 11 Vo Thi Sau, Bien Hoa, Dong Nai','KV010'),('CN011','02033820001','Chi nhanh Dien luc Ha Long','So 02 Nguyen Van Cu, Ha Long, Quang Ninh','KV011'),('CN012','02223820001','Chi nhanh Dien luc TP Bac Ninh','So 07 Ly Thai To, TP Bac Ninh, Bac Ninh','KV012'),('CN013','02343820001','Chi nhanh Dien luc TP Hue','So 14 Hung Vuong, TP Hue, Thua Thien Hue','KV013'),('CN014','02353820001','Chi nhanh Dien luc Tam Ky','So 33 Hung Vuong, Tam Ky, Quang Nam','KV014'),('CN015','02623820001','Chi nhanh Dien luc Buon Ma Thuot','So 60 Nguyen Tat Thanh, BMT, Dak Lak','KV015'),('CN016','02633820001','Chi nhanh Dien luc Da Lat','So 19 Tran Phu, Da Lat, Lam Dong','KV016'),('CN017','02723820001','Chi nhanh Dien luc Tan An','So 25 Hung Vuong, Tan An, Long An','KV017'),('CN018','02963820001','Chi nhanh Dien luc Long Xuyen','So 09 Tran Hung Dao, Long Xuyen, An Giang','KV018'),('CN019','02543820001','Chi nhanh Dien luc Vung Tau','So 06 Ba Cu, Vung Tau, BR-VT','KV019'),('CN020','02563820001','Chi nhanh Dien luc Quy Nhon','So 10 Tang Bat Ho, Quy Nhon, Binh Dinh','KV020');
/*!40000 ALTER TABLE `ChiNhanh` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ChiPhiCongTy`
--

DROP TABLE IF EXISTS `ChiPhiCongTy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ChiPhiCongTy` (
  `maChiNhanh` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `namTaiChinh` int NOT NULL,
  `thangTaiChinh` int NOT NULL,
  `chiPhiThang` decimal(15,2) DEFAULT NULL,
  `doanhThuThang` decimal(15,2) DEFAULT NULL,
  `loiNhuanThang` decimal(15,2) GENERATED ALWAYS AS ((`doanhThuThang` - `chiPhiThang`)) VIRTUAL,
  PRIMARY KEY (`maChiNhanh`,`namTaiChinh`,`thangTaiChinh`),
  CONSTRAINT `ChiPhiCongTy_ibfk_1` FOREIGN KEY (`maChiNhanh`) REFERENCES `ChiNhanh` (`maChiNhanh`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ChiPhiCongTy`
--

LOCK TABLES `ChiPhiCongTy` WRITE;
/*!40000 ALTER TABLE `ChiPhiCongTy` DISABLE KEYS */;
INSERT INTO `ChiPhiCongTy` (`maChiNhanh`, `namTaiChinh`, `thangTaiChinh`, `chiPhiThang`, `doanhThuThang`) VALUES ('CN001',2025,10,820000000.00,1080000000.00),('CN001',2025,11,840000000.00,1100000000.00),('CN001',2025,12,880000000.00,1150000000.00),('CN001',2026,1,850000000.00,1120000000.00),('CN002',2025,10,500000000.00,740000000.00),('CN002',2025,11,510000000.00,750000000.00),('CN002',2025,12,530000000.00,780000000.00),('CN002',2026,1,520000000.00,760000000.00),('CN003',2025,10,590000000.00,870000000.00),('CN003',2025,11,600000000.00,880000000.00),('CN003',2025,12,620000000.00,910000000.00),('CN003',2026,1,610000000.00,890000000.00),('CN004',2025,10,1180000000.00,1620000000.00),('CN004',2025,11,1190000000.00,1635000000.00),('CN004',2025,12,1220000000.00,1680000000.00),('CN004',2026,1,1200000000.00,1650000000.00),('CN005',2025,10,470000000.00,680000000.00),('CN005',2025,11,475000000.00,690000000.00),('CN005',2025,12,490000000.00,720000000.00),('CN005',2026,1,480000000.00,700000000.00),('CN006',2026,1,430000000.00,590000000.00),('CN007',2026,1,390000000.00,540000000.00),('CN008',2026,1,410000000.00,560000000.00),('CN009',2026,1,450000000.00,640000000.00),('CN010',2026,1,470000000.00,650000000.00),('CN011',2026,1,500000000.00,720000000.00),('CN012',2026,1,360000000.00,510000000.00),('CN013',2026,1,340000000.00,480000000.00),('CN014',2026,1,320000000.00,460000000.00),('CN015',2026,1,300000000.00,430000000.00),('CN016',2026,1,310000000.00,440000000.00),('CN017',2026,1,280000000.00,410000000.00),('CN018',2026,1,290000000.00,420000000.00),('CN019',2026,1,305000000.00,445000000.00),('CN020',2026,1,330000000.00,470000000.00);
/*!40000 ALTER TABLE `ChiPhiCongTy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ChiSoDienHangThang`
--

DROP TABLE IF EXISTS `ChiSoDienHangThang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ChiSoDienHangThang` (
  `maCongTo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ngayGhiNhan` date NOT NULL,
  `soDienCu` int DEFAULT NULL,
  `soDienMoi` int DEFAULT NULL,
  PRIMARY KEY (`maCongTo`,`ngayGhiNhan`),
  CONSTRAINT `ChiSoDienHangThang_ibfk_1` FOREIGN KEY (`maCongTo`) REFERENCES `CongToDien` (`maCongTo`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ChiSoDienHangThang`
--

LOCK TABLES `ChiSoDienHangThang` WRITE;
/*!40000 ALTER TABLE `ChiSoDienHangThang` DISABLE KEYS */;
INSERT INTO `ChiSoDienHangThang` VALUES ('CT_FACTORY','2025-10-31',180000,198500),('CT_FACTORY','2025-11-30',198500,217200),('CT_FACTORY','2025-12-31',217200,235800),('CT_FACTORY','2026-01-31',235800,254500),('CT_VACANT','2025-10-31',100,100),('CT_VACANT','2025-11-30',100,100),('CT_VACANT','2025-12-31',100,101),('CT_VACANT','2026-01-31',101,101),('CT001','2025-08-31',450,524),('CT001','2025-09-30',524,596),('CT001','2025-10-31',596,671),('CT001','2025-11-30',671,743),('CT001','2025-12-31',743,850),('CT001','2026-01-31',850,924),('CT002','2025-08-31',880,998),('CT002','2025-09-30',998,1110),('CT002','2025-10-31',1010,1120),('CT002','2025-11-30',1120,1200),('CT002','2025-12-31',1200,1318),('CT002','2026-01-31',1200,1318),('CT003','2026-01-31',640,705),('CT004','2025-08-31',1650,1805),('CT004','2025-09-30',1805,1973),('CT004','2025-10-31',1973,2150),('CT004','2025-11-30',2150,2338),('CT004','2025-12-31',2338,2540),('CT004','2026-01-31',2105,2320),('CT005','2025-08-31',180,258),('CT005','2025-09-30',258,340),('CT005','2025-10-31',340,422),('CT005','2025-11-30',422,430),('CT005','2025-12-31',430,440),('CT005','2026-01-31',430,498),('CT006','2026-01-31',980,1042),('CT007','2026-01-31',1505,1629),('CT008','2026-01-31',775,860),('CT009','2025-08-31',2920,3120),('CT009','2025-09-30',3120,3322),('CT009','2025-10-31',3322,3470),('CT009','2025-11-30',3470,3590),('CT009','2025-12-31',3590,3700),('CT009','2026-01-31',3320,3522),('CT010','2026-01-31',510,569),('CT011','2025-08-31',8100,8605),('CT011','2025-09-30',8605,9115),('CT011','2025-10-31',9115,9630),('CT011','2025-11-30',9630,10150),('CT011','2025-12-31',10150,10675),('CT011','2026-01-31',8900,9425),('CT012','2025-08-31',4930,5310),('CT012','2025-09-30',5310,5700),('CT012','2025-10-31',5700,6095),('CT012','2025-11-30',6095,6490),('CT012','2025-12-31',6490,6890),('CT012','2026-01-31',5400,5790),('CT013','2026-01-31',3200,3388),('CT014','2026-01-31',7800,8214),('CT015','2026-01-31',4100,4315),('CT016','2025-08-31',2200,2368),('CT016','2025-09-30',2368,2536),('CT016','2025-10-31',2536,2704),('CT016','2025-11-30',2704,2872),('CT016','2025-12-31',2872,3040),('CT016','2026-01-31',2600,2768),('CT017','2026-01-31',1750,1869),('CT018','2026-01-31',920,990),('CT019','2026-01-31',300,365),('CT020','2026-01-31',680,748),('CT021','2025-08-31',14700,14762),('CT021','2025-09-30',14762,14886),('CT021','2025-10-31',14886,15010),('CT021','2025-11-30',15010,15136),('CT021','2025-12-31',15136,15200),('CT021','2026-01-31',15200,15262),('CT022','2025-08-31',9176,9300),('CT022','2025-09-30',9300,9424),('CT022','2025-10-31',9424,9548),('CT022','2025-11-30',9548,9676),('CT022','2025-12-31',9676,9800),('CT022','2026-01-31',9800,9924),('CT023','2025-08-31',17725,17900),('CT023','2025-09-30',17900,18075),('CT023','2025-10-31',18075,18250),('CT023','2025-11-30',18250,18325),('CT023','2025-12-31',18325,18500),('CT023','2026-01-31',18500,18675),('CT024','2025-08-31',6822,6891),('CT024','2025-09-30',6891,6960),('CT024','2025-10-31',6960,7029),('CT024','2025-11-30',7029,7131),('CT024','2025-12-31',7131,7200),('CT024','2026-01-31',7200,7269),('CT025','2025-08-31',19656,20144),('CT025','2025-09-30',20144,20632),('CT025','2025-10-31',20632,21120),('CT025','2025-11-30',21120,21612),('CT025','2025-12-31',21612,22100),('CT025','2026-01-31',22100,22588),('CT026','2025-08-31',27260,27670),('CT026','2025-09-30',27670,28080),('CT026','2025-10-31',28080,28490),('CT026','2025-11-30',28490,28700),('CT026','2025-12-31',28700,28900),('CT026','2026-01-31',28900,29310),('CT027','2025-08-31',4848,5036),('CT027','2025-09-30',5036,5224),('CT027','2025-10-31',5224,5412),('CT027','2025-11-30',5412,5506),('CT027','2025-12-31',5506,5600),('CT027','2026-01-31',5600,5788),('CT028','2025-08-31',10648,11062),('CT028','2025-09-30',11062,11476),('CT028','2025-10-31',11476,11890),('CT028','2025-11-30',11890,12097),('CT028','2025-12-31',12097,12300),('CT028','2026-01-31',12300,12714);
/*!40000 ALTER TABLE `ChiSoDienHangThang` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_CheckChiSoDien_BeforeInsert` BEFORE INSERT ON `ChiSoDienHangThang` FOR EACH ROW BEGIN
    -- Validate that new meter reading is not less than old reading
    IF NEW.soDienCu IS NOT NULL AND NEW.soDienMoi < NEW.soDienCu THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Chỉ số điện mới không được nhỏ hơn chỉ số cũ.';
    END IF;
    
    -- Validate meter readings are non-negative
    IF NEW.soDienCu < 0 OR NEW.soDienMoi < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Chỉ số điện không được âm.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_LockChiSoDien_BeforeUpdate` BEFORE UPDATE ON `ChiSoDienHangThang` FOR EACH ROW BEGIN
    -- Kiểm tra xem cặp (MaCongTo, NgayGhiNhan) này đã tồn tại trong bảng HoaDon chưa
    IF EXISTS (SELECT 1 FROM HoaDon WHERE maCongTo = OLD.maCongTo AND ngayGhiNhan = OLD.ngayGhiNhan) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi nghiệp vụ: Chỉ số điện này đã được dùng để lập Hóa đơn. Vui lòng hủy Hóa đơn trước khi sửa chỉ số.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `CongToDien`
--

DROP TABLE IF EXISTS `CongToDien`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CongToDien` (
  `maCongTo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `giaMua` decimal(15,2) DEFAULT NULL,
  `hanSuDung` int DEFAULT NULL,
  `ngayLapDat` date DEFAULT NULL,
  `maCongTy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `maKhachHang` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `maNVLapDat` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`maCongTo`),
  KEY `maCongTy` (`maCongTy`),
  KEY `maKhachHang` (`maKhachHang`),
  KEY `maNVLapDat` (`maNVLapDat`),
  CONSTRAINT `CongToDien_ibfk_1` FOREIGN KEY (`maCongTy`) REFERENCES `CongTy` (`maCongTy`),
  CONSTRAINT `CongToDien_ibfk_2` FOREIGN KEY (`maKhachHang`) REFERENCES `KhachHang` (`maKhachHang`),
  CONSTRAINT `CongToDien_ibfk_3` FOREIGN KEY (`maNVLapDat`) REFERENCES `NhanVienLapDat` (`maNhanVienLapDat`),
  CONSTRAINT `chk_CongToDien_GiaMua` CHECK ((`giaMua` >= 0)),
  CONSTRAINT `chk_CongToDien_HanSuDung` CHECK ((`hanSuDung` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CongToDien`
--

LOCK TABLES `CongToDien` WRITE;
/*!40000 ALTER TABLE `CongToDien` DISABLE KEYS */;
INSERT INTO `CongToDien` VALUES ('CT_FACTORY',2500000.00,15,'2024-01-20','CTY005','KH_FACTORY','LD002'),('CT_VACANT',980000.00,12,'2025-10-01','CTY001','KH006','LD001'),('CT001',980000.00,12,'2024-02-05','CTY001','KH001','LD001'),('CT002',1050000.00,12,'2024-02-06','CTY003','KH002','LD003'),('CT003',1100000.00,15,'2024-03-03','CTY004','KH003','LD003'),('CT004',1250000.00,15,'2024-03-05','CTY006','KH004','LD002'),('CT005',950000.00,12,'2024-04-02','CTY001','KH005','LD004'),('CT006',990000.00,12,'2024-04-10','CTY019','KH006','LD001'),('CT007',1020000.00,12,'2024-05-08','CTY003','KH007','LD003'),('CT008',1080000.00,15,'2024-05-12','CTY004','KH008','LD003'),('CT009',1200000.00,15,'2024-06-01','CTY006','KH009','LD002'),('CT010',970000.00,12,'2024-06-03','CTY001','KH010','LD004'),('CT011',1350000.00,15,'2024-07-02','CTY005','KH011','LD001'),('CT012',1500000.00,15,'2024-07-05','CTY014','KH012','LD003'),('CT013',1280000.00,12,'2024-08-01','CTY010','KH013','LD003'),('CT014',1400000.00,15,'2024-08-06','CTY006','KH014','LD002'),('CT015',1320000.00,12,'2024-09-03','CTY007','KH015','LD004'),('CT016',1180000.00,12,'2025-02-05','CTY013','KH016','LD004'),('CT017',1250000.00,12,'2025-03-02','CTY012','KH017','LD001'),('CT018',1120000.00,12,'2025-04-01','CTY011','KH018','LD003'),('CT019',980000.00,12,'2025-05-01','CTY019','KH019','LD004'),('CT020',1150000.00,15,'2025-06-01','CTY005','KH020','LD001'),('CT021',920000.00,10,'2016-04-01','CTY001','KH006','LD001'),('CT022',980000.00,10,'2016-06-15','CTY002','KH007','LD003'),('CT023',1050000.00,12,'2014-03-01','CTY003','KH008','LD003'),('CT024',1100000.00,12,'2014-05-20','CTY004','KH010','LD004'),('CT025',850000.00,10,'2013-01-10','CTY001','KH011','LD001'),('CT026',900000.00,10,'2012-08-15','CTY019','KH012','LD003'),('CT027',980000.00,12,'2014-07-01','CTY005','KH013','LD003'),('CT028',1020000.00,12,'2014-09-15','CTY006','KH014','LD002');
/*!40000 ALTER TABLE `CongToDien` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CongTy`
--

DROP TABLE IF EXISTS `CongTy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CongTy` (
  `maCongTy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tenCongTy` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `xuatXu` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`maCongTy`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CongTy`
--

LOCK TABLES `CongTy` WRITE;
/*!40000 ALTER TABLE `CongTy` DISABLE KEYS */;
INSERT INTO `CongTy` VALUES ('CTY001','EMIC - Thiet bi do dien Viet Nam','Viet Nam'),('CTY002','Shikoku Electric Meter','Nhat Ban'),('CTY003','Landis+Gyr','Thuy Si'),('CTY004','Itron','My'),('CTY005','Siemens Smart Infrastructure','Duc'),('CTY006','Schneider Electric','Phap'),('CTY007','ZPA Smart Energy','Sec'),('CTY008','Hexing Electrical','Trung Quoc'),('CTY009','Holley Technology','Trung Quoc'),('CTY010','Iskraemeco','Slovenia'),('CTY011','HPL Electric & Power','An Do'),('CTY012','Apator','Ba Lan'),('CTY013','Sagemcom Metering','Phap'),('CTY014','EDMI','Singapore'),('CTY015','CIRCUTOR','Tay Ban Nha'),('CTY016','Eastron','Anh'),('CTY017','Chint Electric Meter','Trung Quoc'),('CTY018','Sanxing Electric','Trung Quoc'),('CTY019','MeterTech Viet','Viet Nam'),('CTY020','Vina Meter Solutions','Viet Nam');
/*!40000 ALTER TABLE `CongTy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `HoaDon`
--

DROP TABLE IF EXISTS `HoaDon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HoaDon` (
  `maCongTo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ngayGhiNhan` date NOT NULL,
  `trangThaiTT` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ngayLapDon` date DEFAULT NULL,
  `maKeToan` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`maCongTo`,`ngayGhiNhan`),
  KEY `maKeToan` (`maKeToan`),
  CONSTRAINT `HoaDon_ibfk_1` FOREIGN KEY (`maCongTo`, `ngayGhiNhan`) REFERENCES `ChiSoDienHangThang` (`maCongTo`, `ngayGhiNhan`),
  CONSTRAINT `HoaDon_ibfk_2` FOREIGN KEY (`maKeToan`) REFERENCES `KeToan` (`maKeToan`),
  CONSTRAINT `chk_HoaDon_TrangThai` CHECK ((`trangThaiTT` in (_utf8mb4'Chua thanh toan',_utf8mb4'Da thanh toan',_utf8mb4'Qua han',_utf8mb4'Huy')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `HoaDon`
--

LOCK TABLES `HoaDon` WRITE;
/*!40000 ALTER TABLE `HoaDon` DISABLE KEYS */;
INSERT INTO `HoaDon` VALUES ('CT_FACTORY','2025-10-31','Da thanh toan','2025-11-03','KT002'),('CT_FACTORY','2025-11-30','Da thanh toan','2025-12-03','KT002'),('CT_FACTORY','2025-12-31','Da thanh toan','2026-01-03','KT002'),('CT_FACTORY','2026-01-31','Da thanh toan','2026-02-03','KT002'),('CT_VACANT','2025-10-31','Da thanh toan','2025-11-02','KT001'),('CT_VACANT','2025-11-30','Da thanh toan','2025-12-02','KT001'),('CT_VACANT','2025-12-31','Da thanh toan','2026-01-02','KT001'),('CT_VACANT','2026-01-31','Da thanh toan','2026-02-02','KT001'),('CT001','2025-08-31','Da thanh toan','2025-09-02','KT001'),('CT001','2025-09-30','Da thanh toan','2025-10-02','KT001'),('CT001','2025-10-31','Da thanh toan','2025-11-02','KT001'),('CT001','2025-11-30','Da thanh toan','2025-12-02','KT001'),('CT001','2025-12-31','Da thanh toan','2026-01-02','KT001'),('CT001','2026-01-31','Da thanh toan','2026-02-02','KT001'),('CT002','2025-08-31','Da thanh toan','2025-09-02','KT003'),('CT002','2025-09-30','Da thanh toan','2025-10-02','KT003'),('CT002','2025-10-31','Da thanh toan','2025-11-02','KT003'),('CT002','2025-11-30','Chua thanh toan','2025-12-02','KT003'),('CT002','2025-12-31','Qua han','2026-01-02','KT003'),('CT002','2026-01-31','Chua thanh toan','2026-02-02','KT003'),('CT003','2026-01-31','Da thanh toan','2026-02-03','KT003'),('CT004','2025-08-31','Da thanh toan','2025-09-03','KT002'),('CT004','2025-09-30','Da thanh toan','2025-10-03','KT002'),('CT004','2025-10-31','Da thanh toan','2025-11-03','KT002'),('CT004','2025-11-30','Da thanh toan','2025-12-03','KT002'),('CT004','2025-12-31','Da thanh toan','2026-01-03','KT002'),('CT004','2026-01-31','Chua thanh toan','2026-02-03','KT002'),('CT005','2025-08-31','Da thanh toan','2025-09-03','KT004'),('CT005','2025-09-30','Da thanh toan','2025-10-03','KT004'),('CT005','2025-10-31','Da thanh toan','2025-11-03','KT004'),('CT005','2025-11-30','Qua han','2025-12-03','KT004'),('CT005','2025-12-31','Qua han','2026-01-03','KT004'),('CT005','2026-01-31','Da thanh toan','2026-02-03','KT004'),('CT006','2026-01-31','Da thanh toan','2026-02-04','KT001'),('CT007','2026-01-31','Chua thanh toan','2026-02-04','KT003'),('CT008','2026-01-31','Da thanh toan','2026-02-04','KT003'),('CT009','2025-08-31','Da thanh toan','2025-09-05','KT002'),('CT009','2025-09-30','Da thanh toan','2025-10-05','KT002'),('CT009','2025-10-31','Da thanh toan','2025-11-05','KT002'),('CT009','2025-11-30','Da thanh toan','2025-12-05','KT002'),('CT009','2025-12-31','Chua thanh toan','2026-01-05','KT002'),('CT009','2026-01-31','Qua han','2026-02-05','KT002'),('CT010','2026-01-31','Da thanh toan','2026-02-05','KT004'),('CT011','2025-08-31','Da thanh toan','2025-09-06','KT001'),('CT011','2025-09-30','Da thanh toan','2025-10-06','KT001'),('CT011','2025-10-31','Da thanh toan','2025-11-06','KT001'),('CT011','2025-11-30','Da thanh toan','2025-12-06','KT001'),('CT011','2025-12-31','Da thanh toan','2026-01-06','KT001'),('CT011','2026-01-31','Chua thanh toan','2026-02-06','KT001'),('CT012','2025-08-31','Da thanh toan','2025-09-06','KT003'),('CT012','2025-09-30','Da thanh toan','2025-10-06','KT003'),('CT012','2025-10-31','Da thanh toan','2025-11-06','KT003'),('CT012','2025-11-30','Chua thanh toan','2025-12-06','KT003'),('CT012','2025-12-31','Qua han','2026-01-06','KT003'),('CT012','2026-01-31','Da thanh toan','2026-02-06','KT003'),('CT013','2026-01-31','Da thanh toan','2026-02-06','KT003'),('CT014','2026-01-31','Chua thanh toan','2026-02-07','KT002'),('CT015','2026-01-31','Da thanh toan','2026-02-07','KT004'),('CT016','2025-08-31','Da thanh toan','2025-09-08','KT004'),('CT016','2025-09-30','Da thanh toan','2025-10-08','KT004'),('CT016','2025-10-31','Da thanh toan','2025-11-08','KT004'),('CT016','2025-11-30','Da thanh toan','2025-12-08','KT004'),('CT016','2025-12-31','Da thanh toan','2026-01-08','KT004'),('CT016','2026-01-31','Da thanh toan','2026-02-08','KT004'),('CT017','2026-01-31','Chua thanh toan','2026-02-08','KT001'),('CT018','2026-01-31','Da thanh toan','2026-02-08','KT003'),('CT019','2026-01-31','Da thanh toan','2026-02-09','KT004'),('CT020','2026-01-31','Chua thanh toan','2026-02-09','KT001'),('CT021','2025-08-31','Da thanh toan','2025-09-02','KT001'),('CT021','2025-09-30','Da thanh toan','2025-10-02','KT001'),('CT021','2025-10-31','Da thanh toan','2025-11-02','KT001'),('CT021','2025-11-30','Da thanh toan','2025-12-02','KT001'),('CT021','2025-12-31','Da thanh toan','2026-01-02','KT001'),('CT021','2026-01-31','Da thanh toan','2026-02-02','KT001'),('CT022','2025-08-31','Da thanh toan','2025-09-02','KT003'),('CT022','2025-09-30','Da thanh toan','2025-10-02','KT003'),('CT022','2025-10-31','Da thanh toan','2025-11-02','KT003'),('CT022','2025-11-30','Da thanh toan','2025-12-02','KT003'),('CT022','2025-12-31','Da thanh toan','2026-01-02','KT003'),('CT022','2026-01-31','Da thanh toan','2026-02-02','KT003'),('CT023','2025-08-31','Da thanh toan','2025-09-03','KT003'),('CT023','2025-09-30','Da thanh toan','2025-10-03','KT003'),('CT023','2025-10-31','Da thanh toan','2025-11-03','KT003'),('CT023','2025-11-30','Da thanh toan','2025-12-03','KT003'),('CT023','2025-12-31','Da thanh toan','2026-01-03','KT003'),('CT023','2026-01-31','Chua thanh toan','2026-02-03','KT003'),('CT024','2025-08-31','Da thanh toan','2025-09-03','KT004'),('CT024','2025-09-30','Da thanh toan','2025-10-03','KT004'),('CT024','2025-10-31','Da thanh toan','2025-11-03','KT004'),('CT024','2025-11-30','Da thanh toan','2025-12-03','KT004'),('CT024','2025-12-31','Da thanh toan','2026-01-03','KT004'),('CT024','2026-01-31','Da thanh toan','2026-02-03','KT004'),('CT025','2025-08-31','Da thanh toan','2025-09-06','KT001'),('CT025','2025-09-30','Da thanh toan','2025-10-06','KT001'),('CT025','2025-10-31','Da thanh toan','2025-11-06','KT001'),('CT025','2025-11-30','Da thanh toan','2025-12-06','KT001'),('CT025','2025-12-31','Da thanh toan','2026-01-06','KT001'),('CT025','2026-01-31','Qua han','2026-02-06','KT001'),('CT026','2025-08-31','Da thanh toan','2025-09-06','KT003'),('CT026','2025-09-30','Da thanh toan','2025-10-06','KT003'),('CT026','2025-10-31','Da thanh toan','2025-11-06','KT003'),('CT026','2025-11-30','Da thanh toan','2025-12-06','KT003'),('CT026','2025-12-31','Da thanh toan','2026-01-06','KT003'),('CT026','2026-01-31','Chua thanh toan','2026-02-06','KT003'),('CT027','2025-08-31','Da thanh toan','2025-09-07','KT003'),('CT027','2025-09-30','Da thanh toan','2025-10-07','KT003'),('CT027','2025-10-31','Da thanh toan','2025-11-07','KT003'),('CT027','2025-11-30','Da thanh toan','2025-12-07','KT003'),('CT027','2025-12-31','Da thanh toan','2026-01-07','KT003'),('CT027','2026-01-31','Da thanh toan','2026-02-07','KT003'),('CT028','2025-08-31','Da thanh toan','2025-09-07','KT002'),('CT028','2025-09-30','Da thanh toan','2025-10-07','KT002'),('CT028','2025-10-31','Da thanh toan','2025-11-07','KT002'),('CT028','2025-11-30','Da thanh toan','2025-12-07','KT002'),('CT028','2025-12-31','Da thanh toan','2026-01-07','KT002'),('CT028','2026-01-31','Da thanh toan','2026-02-07','KT002');
/*!40000 ALTER TABLE `HoaDon` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_ProtectPaidInvoice_BeforeUpdate` BEFORE UPDATE ON `HoaDon` FOR EACH ROW BEGIN
    -- Nếu hóa đơn cũ đã thanh toán, nhưng người dùng cố tình sửa dữ liệu
    IF OLD.trangThaiTT = 'Da thanh toan' AND NEW.trangThaiTT != 'Da thanh toan' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi bảo mật: Không thể sửa đổi hoặc hoàn tác trạng thái của Hóa đơn đã thanh toán.';
    END IF;
    
    -- Ngăn chặn sửa ngày lập đơn của hóa đơn đã thanh toán
    IF OLD.trangThaiTT = 'Da thanh toan' AND OLD.ngayLapDon != NEW.ngayLapDon THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Không thể thay đổi ngày lập của hóa đơn đã hoàn tất.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `HopDong`
--

DROP TABLE IF EXISTS `HopDong`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HopDong` (
  `maHopDong` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ngayKy` date DEFAULT NULL,
  `ngayBatDau` date DEFAULT NULL,
  `trangThai` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `thoiHan` int DEFAULT NULL,
  `maChiNhanh` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `maNVQuanLy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `maKhachHang` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`maHopDong`),
  KEY `maChiNhanh` (`maChiNhanh`),
  KEY `maNVQuanLy` (`maNVQuanLy`),
  KEY `maKhachHang` (`maKhachHang`),
  CONSTRAINT `HopDong_ibfk_1` FOREIGN KEY (`maChiNhanh`) REFERENCES `ChiNhanh` (`maChiNhanh`),
  CONSTRAINT `HopDong_ibfk_2` FOREIGN KEY (`maNVQuanLy`) REFERENCES `NhanVienQuanLy` (`maNhanVienQuanLy`),
  CONSTRAINT `HopDong_ibfk_3` FOREIGN KEY (`maKhachHang`) REFERENCES `KhachHang` (`maKhachHang`),
  CONSTRAINT `chk_HopDong_NgayBatDau` CHECK ((`ngayBatDau` >= `ngayKy`)),
  CONSTRAINT `chk_HopDong_ThoiHan` CHECK ((`thoiHan` > 0)),
  CONSTRAINT `chk_HopDong_TrangThai` CHECK ((`trangThai` in (_utf8mb4'Hieu luc',_utf8mb4'Het han',_utf8mb4'Huy')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `HopDong`
--

LOCK TABLES `HopDong` WRITE;
/*!40000 ALTER TABLE `HopDong` DISABLE KEYS */;
INSERT INTO `HopDong` VALUES ('HD_FACTORY','2024-01-05','2024-02-01','Hieu luc',36,'CN004','QL004','KH_FACTORY'),('HD001','2024-01-10','2024-02-01','Hieu luc',36,'CN001','QL001','KH001'),('HD002','2024-01-15','2024-02-01','Hieu luc',24,'CN002','QL002','KH002'),('HD003','2024-02-05','2024-03-01','Hieu luc',24,'CN003','QL003','KH003'),('HD004','2024-02-12','2024-03-01','Hieu luc',36,'CN004','QL004','KH004'),('HD005','2024-03-02','2024-04-01','Hieu luc',24,'CN005','QL005','KH005'),('HD006','2024-03-15','2024-04-01','Hieu luc',24,'CN001','QL001','KH006'),('HD007','2024-04-10','2024-05-01','Hieu luc',24,'CN002','QL002','KH007'),('HD008','2024-04-25','2024-05-01','Hieu luc',36,'CN003','QL003','KH008'),('HD009','2024-05-15','2024-06-01','Hieu luc',24,'CN004','QL004','KH009'),('HD010','2024-05-30','2024-06-01','Hieu luc',24,'CN005','QL005','KH010'),('HD011','2024-06-05','2024-07-01','Hieu luc',36,'CN001','QL001','KH011'),('HD012','2024-06-18','2024-07-01','Hieu luc',36,'CN002','QL002','KH012'),('HD013','2024-07-02','2024-08-01','Hieu luc',24,'CN003','QL003','KH013'),('HD014','2024-07-16','2024-08-01','Hieu luc',36,'CN004','QL004','KH014'),('HD015','2024-08-01','2024-09-01','Hieu luc',24,'CN005','QL005','KH015'),('HD016','2025-01-05','2025-02-01','Hieu luc',24,'CN009','QL006','KH016'),('HD017','2025-02-10','2025-03-01','Hieu luc',24,'CN011','QL007','KH017'),('HD018','2025-03-12','2025-04-01','Hieu luc',24,'CN020','QL008','KH018'),('HD019','2025-04-20','2025-05-01','Hieu luc',24,'CN009','QL006','KH019'),('HD020','2025-05-25','2025-06-01','Hieu luc',36,'CN011','QL007','KH020'),('HD021','2024-02-10','2024-03-01','Hieu luc',12,'CN001','QL001','KH006'),('HD022','2024-02-15','2024-03-01','Hieu luc',12,'CN002','QL002','KH007'),('HD023','2024-02-20','2024-03-10','Hieu luc',12,'CN003','QL003','KH008'),('HD024','2023-01-10','2023-02-01','Het han',12,'CN004','QL004','KH010'),('HD025','2023-12-05','2024-01-01','Het han',12,'CN005','QL005','KH005'),('HD026','2025-12-01','2026-01-01','Hieu luc',24,'CN009','QL006','KH016'),('HD027','2025-12-10','2026-01-01','Hieu luc',36,'CN011','QL007','KH017'),('HD028','2026-01-05','2026-02-01','Hieu luc',24,'CN020','QL008','KH018'),('HD029','2024-05-01','2024-06-01','Huy',12,'CN001','QL001','KH019'),('HD030','2024-06-01','2024-07-01','Huy',24,'CN004','QL004','KH020');
/*!40000 ALTER TABLE `HopDong` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_ValidateHopDong_BeforeInsert` BEFORE INSERT ON `HopDong` FOR EACH ROW BEGIN
    -- 1. Kiểm tra ngày bắt đầu không được để trống (đã có NOT NULL, nhưng check logic thêm)
    -- 2. Thời hạn phải dương
    IF NEW.thoiHan <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi hợp đồng: Thời hạn hợp đồng phải lớn hơn 0 tháng.';
    END IF;

    -- 3. (Tùy chọn) Ngày ký không được lớn hơn ngày hiện tại quá nhiều (tránh nhập sai năm 2050)
    IF YEAR(NEW.ngayKy) > YEAR(CURDATE()) + 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cảnh báo: Ngày ký hợp đồng dường như không hợp lệ (quá xa trong tương lai).';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `KeToan`
--

DROP TABLE IF EXISTS `KeToan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `KeToan` (
  `maKeToan` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `hanMucDuyet` decimal(15,2) DEFAULT NULL,
  `ccKeToan` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`maKeToan`),
  CONSTRAINT `KeToan_ibfk_1` FOREIGN KEY (`maKeToan`) REFERENCES `NhanVien` (`maNhanVien`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `KeToan`
--

LOCK TABLES `KeToan` WRITE;
/*!40000 ALTER TABLE `KeToan` DISABLE KEYS */;
INSERT INTO `KeToan` VALUES ('KT001',200000000.00,'Chung chi Ke toan vien hanh nghe'),('KT002',300000000.00,'Chung chi Ke toan truong'),('KT003',200000000.00,'Chung chi Ke toan vien hanh nghe'),('KT004',250000000.00,'Chung chi Ke toan tong hop');
/*!40000 ALTER TABLE `KeToan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `KhachHang`
--

DROP TABLE IF EXISTS `KhachHang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `KhachHang` (
  `maKhachHang` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tenKhachHang` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `maSoThue` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `diaChi` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `maChiNhanh` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `maBangGiaDien` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`maKhachHang`),
  KEY `maChiNhanh` (`maChiNhanh`),
  KEY `maBangGiaDien` (`maBangGiaDien`),
  CONSTRAINT `KhachHang_ibfk_1` FOREIGN KEY (`maChiNhanh`) REFERENCES `ChiNhanh` (`maChiNhanh`),
  CONSTRAINT `KhachHang_ibfk_2` FOREIGN KEY (`maBangGiaDien`) REFERENCES `BangGiaDien` (`ma`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `KhachHang`
--

LOCK TABLES `KhachHang` WRITE;
/*!40000 ALTER TABLE `KhachHang` DISABLE KEYS */;
INSERT INTO `KhachHang` VALUES ('KH_FACTORY','Nha may May mac Viet Tien','0311223344','Khu CN Tan Binh, Q. Tan Binh, TP HCM','CN004','BGD003'),('KH001','Nguyen Van Tuan','0109234561','So 12 Hang Bai, Hoan Kiem, Ha Noi','CN001','BGD001'),('KH002','Tran Thi Thu Ha','0209345672','So 08 Lach Tray, Ngo Quyen, Hai Phong','CN002','BGD001'),('KH003','Le Minh Quan','0309456783','So 55 Nguyen Chi Thanh, Hai Chau, Da Nang','CN003','BGD001'),('KH004','Pham Ngoc Anh','0319567894','So 20 Le Loi, Quan 1, TP HCM','CN004','BGD001'),('KH005','Vo Quoc Duy','1409678905','So 09 Hoa Binh, Ninh Kieu, Can Tho','CN005','BGD001'),('KH006','Bui Thi Mai','0109789016','So 101 Giai Phong, Hoang Mai, Ha Noi','CN001','BGD001'),('KH007','Nguyen Thanh Long','0209890127','So 12 Tran Nguyen Han, Hong Bang, Hai Phong','CN002','BGD001'),('KH008','Do Khanh Linh','0309901238','So 78 Dien Bien Phu, Thanh Khe, Da Nang','CN003','BGD001'),('KH009','Nguyen Hoang Nam','0319012349','So 35 Vo Van Tan, Quan 3, TP HCM','CN004','BGD001'),('KH010','Le Thi Ngoc','1409123450','So 66 Cach Mang Thang 8, Ninh Kieu, Can Tho','CN005','BGD001'),('KH011','Cong ty TNHH Minh Phat Trading','0101122334','So 88 Tran Duy Hung, Cau Giay, Ha Noi','CN001','BGD002'),('KH012','Cong ty Co phan Hai Phong Logistics','0202233445','So 12 Dinh Vu, Hai An, Hai Phong','CN002','BGD002'),('KH013','Cong ty TNHH Da Nang Food','0303344556','Lo A2 Nguyen Van Linh, Hai Chau, Da Nang','CN003','BGD004'),('KH014','Cong ty TNHH Sai Gon Retail','0314455667','So 19 Nam Ky Khoi Nghia, Quan 1, TP HCM','CN004','BGD004'),('KH015','Benh vien Da khoa Can Tho','1405566778','So 01 3/2, Ninh Kieu, Can Tho','CN005','BGD003'),('KH016','Khach san Bien Xanh','4206677889','So 10 Tran Phu, Nha Trang, Khanh Hoa','CN009','BGD002'),('KH017','Cong ty Du lich Ha Long Bay','5707788990','So 02 Nguyen Van Cu, Ha Long, Quang Ninh','CN011','BGD004'),('KH018','Cua hang vat lieu xay dung Quy Nhon','4108899001','So 33 Tang Bat Ho, Quy Nhon, Binh Dinh','CN020','BGD002'),('KH019','Nguyen Thi Hong','4209900112','So 05 Le Thanh Ton, Nha Trang, Khanh Hoa','CN009','BGD001'),('KH020','Tran Quang Huy','5701011223','So 18 Tran Quoc Nghien, Ha Long, Quang Ninh','CN011','BGD001');
/*!40000 ALTER TABLE `KhachHang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `KhuVuc`
--

DROP TABLE IF EXISTS `KhuVuc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `KhuVuc` (
  `maKhuVuc` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tenKhuVuc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `maVung` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`maKhuVuc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `KhuVuc`
--

LOCK TABLES `KhuVuc` WRITE;
/*!40000 ALTER TABLE `KhuVuc` DISABLE KEYS */;
INSERT INTO `KhuVuc` VALUES ('KV001','Ha Noi','024'),('KV002','Hai Phong','0225'),('KV003','Da Nang','0236'),('KV004','TP Ho Chi Minh','028'),('KV005','Can Tho','0292'),('KV006','Binh Duong','0274'),('KV007','Hai Duong','0220'),('KV008','Nghe An','0238'),('KV009','Khanh Hoa','0258'),('KV010','Dong Nai','0251'),('KV011','Quang Ninh','0203'),('KV012','Bac Ninh','0222'),('KV013','Thua Thien Hue','0234'),('KV014','Quang Nam','0235'),('KV015','Dak Lak','0262'),('KV016','Lam Dong','0263'),('KV017','Long An','0272'),('KV018','An Giang','0296'),('KV019','Ba Ria - Vung Tau','0254'),('KV020','Binh Dinh','0256');
/*!40000 ALTER TABLE `KhuVuc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `NV_HoTro_KhachHang`
--

DROP TABLE IF EXISTS `NV_HoTro_KhachHang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `NV_HoTro_KhachHang` (
  `maNVHoTro` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `maKhachHang` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ngayHoTro` datetime NOT NULL,
  `lyDoHoTro` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`maNVHoTro`,`maKhachHang`,`ngayHoTro`),
  KEY `maKhachHang` (`maKhachHang`),
  CONSTRAINT `NV_HoTro_KhachHang_ibfk_1` FOREIGN KEY (`maNVHoTro`) REFERENCES `NhanVienHoTro` (`maNhanVienHoTro`),
  CONSTRAINT `NV_HoTro_KhachHang_ibfk_2` FOREIGN KEY (`maKhachHang`) REFERENCES `KhachHang` (`maKhachHang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NV_HoTro_KhachHang`
--

LOCK TABLES `NV_HoTro_KhachHang` WRITE;
/*!40000 ALTER TABLE `NV_HoTro_KhachHang` DISABLE KEYS */;
INSERT INTO `NV_HoTro_KhachHang` VALUES ('HT001','KH001','2026-01-05 09:15:00','Huong dan tra cuu hoa don dien tu va ky thanh toan'),('HT001','KH002','2025-12-15 14:20:00','Kiem tra lai chi so dien, xac nhan khong co su co'),('HT001','KH002','2026-01-11 09:05:00','Ho tro dang ky thanh toan tu dong qua ngan hang'),('HT001','KH005','2026-01-15 16:30:00','Canh bao cat dien do qua han thanh toan'),('HT001','KH006','2026-01-06 14:20:00','Kiem tra thong tin chu hop dong, cap nhat so dien thoai'),('HT001','KH011','2025-12-05 09:30:00','Hen lich kiem tra va thay cong to moi'),('HT001','KH012','2026-01-14 09:45:00','Giai dap ve chuyen doi bang gia dien kinh doanh'),('HT001','KH014','2026-01-20 15:40:00','Giai dap ve uu dai gia dien gio thap diem'),('HT001','KH017','2025-03-05 09:30:00','Cai dat ung dung tra cuu hoa don va thanh toan'),('HT001','KH017','2026-01-19 15:35:00','Ho tro tra cuu lich su thanh toan 6 thang gan nhat'),('HT001','KH020','2026-01-22 13:05:00','Giai dap ve quy dinh tre han/qua han thanh toan'),('HT002','KH002','2025-12-10 09:30:00','Phan anh hoa don tang dot bien, yeu cau kiem tra cong to'),('HT002','KH002','2026-01-25 16:15:00','Canh bao hoa don qua han thanh toan'),('HT002','KH003','2026-01-24 10:10:00','Xac minh chi so, gui anh chung minh'),('HT002','KH004','2026-01-07 16:40:00','Huong dan dang ky nhan thong bao qua Zalo OA'),('HT002','KH007','2026-01-29 13:45:00','Tu van thu tuc gia han va doi loai hop dong'),('HT002','KH009','2026-01-10 15:50:00','Giai dap ve muc gia dien sinh hoat theo bac'),('HT002','KH011','2026-01-13 10:00:00','Tu van thu tuc cap dien moi cho co so kinh doanh'),('HT002','KH014','2026-01-12 10:20:00','Huong dan xuat hoa don GTGT dang ky dien tu'),('HT002','KH014','2026-01-15 11:30:00','Ho tro xuat hoa don GTGT theo ky'),('HT002','KH016','2025-02-10 10:00:00','Huong dan su dung dich vu khach hang doanh nghiep'),('HT002','KH018','2026-01-20 10:40:00','Huong dan cach doc chi so cong to va bao cao chi so'),('HT003','KH002','2026-01-08 10:45:00','Huong dan tiet kiem dien, giai thich muc tieu thu cao'),('HT003','KH003','2026-01-07 10:05:00','Giai dap thac mac chi so dien tang bat thuong'),('HT003','KH003','2026-01-17 15:20:00','Tranh chap chi so ghi, khach hang khong dong y'),('HT003','KH006','2026-01-28 09:15:00','Yeu cau gia han hop dong dien sap het han'),('HT003','KH007','2026-01-12 17:05:00','Huong dan xac nhan bien ban ghi chi so'),('HT003','KH008','2026-01-09 11:10:00','Ho tro cap lai ma khach hang/ma hop dong'),('HT003','KH008','2026-01-16 11:25:00','Bao cao nhap nhay dien ap thuong xuyen'),('HT003','KH011','2026-01-10 14:00:00','Xac nhan hoan tat thay cong to, cung cap so moi'),('HT003','KH013','2026-01-14 16:15:00','Tiep nhan yeu cau dieu chinh thong tin cong ty tren hop dong'),('HT003','KH016','2026-01-18 09:20:00','Tiep nhan phan anh nhap nhay dien ap, hen kiem tra'),('HT004','KH005','2025-12-20 08:50:00','Phan anh loi thanh toan truc tuyen, yeu cau ho tro'),('HT004','KH005','2026-01-08 08:30:00','Tiep nhan yeu cau doi lich ghi chi so do khach vang nha'),('HT004','KH008','2026-01-23 14:50:00','Cap nhat: Da kiem tra, do loi luoi dien khu vuc'),('HT004','KH010','2026-01-11 13:25:00','Tiep nhan phan anh mat dien cuc bo, chuyen bo phan ky thuat'),('HT004','KH011','2025-11-20 11:00:00','Yeu cau thay the cong to cu, da qua han bao tri'),('HT004','KH015','2026-01-16 14:10:00','Huong dan ho so ap dung bang gia hanh chinh su nghiep'),('HT004','KH019','2026-01-21 08:55:00','Tiep nhan yeu cau doi vi tri lap dat cong to (khao sat)');
/*!40000 ALTER TABLE `NV_HoTro_KhachHang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `NhanVien`
--

DROP TABLE IF EXISTS `NhanVien`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `NhanVien` (
  `maNhanVien` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `maSoThue` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ngaySinh` date DEFAULT NULL,
  `ho` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tenDem` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tenRieng` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `maNhanVienQuanLy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `maChiNhanh` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trangThai` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Dang lam viec',
  PRIMARY KEY (`maNhanVien`),
  KEY `maChiNhanh` (`maChiNhanh`),
  KEY `fk_nv_quanly` (`maNhanVienQuanLy`),
  CONSTRAINT `fk_nv_quanly` FOREIGN KEY (`maNhanVienQuanLy`) REFERENCES `NhanVienQuanLy` (`maNhanVienQuanLy`) ON DELETE SET NULL,
  CONSTRAINT `NhanVien_ibfk_1` FOREIGN KEY (`maChiNhanh`) REFERENCES `ChiNhanh` (`maChiNhanh`),
  CONSTRAINT `chk_NhanVien_TrangThai` CHECK ((`trangThai` in (_utf8mb4'Dang lam viec',_utf8mb4'Nghi viec',_utf8mb4'Nghi tam thoi')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NhanVien`
--

LOCK TABLES `NhanVien` WRITE;
/*!40000 ALTER TABLE `NhanVien` DISABLE KEYS */;
INSERT INTO `NhanVien` VALUES ('HT001','0104971111','ngoc.do.ht@dienluc.vn','1997-04-05','Do','Bao','Ngoc','QL001','CN001','Dang lam viec'),('HT002','0314972222','vy.nguyen.ht@dienluc.vn','1998-06-12','Nguyen','Thanh','Vy','QL004','CN004','Dang lam viec'),('HT003','0304973333','anh.bui.ht@dienluc.vn','1996-01-29','Bui','Khanh','Anh','QL003','CN003','Dang lam viec'),('HT004','1404974444','kiet.tran.ht@dienluc.vn','1995-11-11','Tran','Gia','Kiet','QL005','CN005','Dang lam viec'),('KT001','0102951111','lan.nguyen.kt@dienluc.vn','1992-03-18','Nguyen','Thi','Lan','QL001','CN001','Dang lam viec'),('KT002','0312952222','phuc.tran.kt@dienluc.vn','1991-05-09','Tran','Minh','Phuc','QL004','CN004','Dang lam viec'),('KT003','0302953333','mai.le.kt@dienluc.vn','1993-08-22','Le','Thuy','Mai','QL003','CN003','Dang lam viec'),('KT004','1402954444','duy.pham.kt@dienluc.vn','1990-10-30','Pham','Quang','Duy','QL005','CN005','Dang lam viec'),('LD001','0103961111','tuan.nguyen.ld@dienluc.vn','1996-02-14','Nguyen','Anh','Tuan','QL001','CN001','Dang lam viec'),('LD002','0313962222','khang.vo.ld@dienluc.vn','1995-12-19','Vo','Dinh','Khang','QL004','CN004','Dang lam viec'),('LD003','0303963333','dat.tran.ld@dienluc.vn','1994-07-07','Tran','Tien','Dat','QL003','CN003','Dang lam viec'),('LD004','1403964444','hung.le.ld@dienluc.vn','1997-09-25','Le','Quoc','Hung','QL005','CN005','Dang lam viec'),('NV_QUIT01','0106002222','quit.tran@dienluc.vn','1992-03-20','Tran','Thi','Lan','QL004','CN004','Nghi viec'),('NV_TEMP01','0105001111','temp.nguyen@dienluc.vn','1994-06-15','Nguyen','Van','Binh','QL001','CN001','Nghi tam thoi'),('QL001','0101861234','huy.nguyen@dienluc.vn','1986-04-12','Nguyen','Van','Huy',NULL,'CN001','Dang lam viec'),('QL002','0201872345','thao.le@dienluc.vn','1987-09-03','Le','Thi','Thao',NULL,'CN002','Dang lam viec'),('QL003','0301853456','nam.tran@dienluc.vn','1985-01-21','Tran','Quang','Nam',NULL,'CN003','Dang lam viec'),('QL004','0311884567','minh.pham@dienluc.vn','1988-07-15','Pham','Duc','Minh',NULL,'CN004','Dang lam viec'),('QL005','1401895678','linh.do@dienluc.vn','1989-11-28','Do','Thi','Linh',NULL,'CN005','Dang lam viec'),('QL006','4201906789','khoa.ngo@dienluc.vn','1990-02-10','Ngo','Quoc','Khoa',NULL,'CN009','Dang lam viec'),('QL007','5701917890','son.bui@dienluc.vn','1991-06-06','Bui','Thanh','Son',NULL,'CN011','Dang lam viec'),('QL008','4101928901','ha.vo@dienluc.vn','1992-12-01','Vo','Ngoc','Ha',NULL,'CN020','Dang lam viec');
/*!40000 ALTER TABLE `NhanVien` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_ProtectNhanVien_BeforeDelete` BEFORE DELETE ON `NhanVien` FOR EACH ROW BEGIN
    -- Kiểm tra nếu nhân viên là Quản lý trong Hợp đồng (using correct column name)
    IF EXISTS (SELECT 1 FROM HopDong WHERE maNVQuanLy = OLD.maNhanVien) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Không thể xóa: Nhân viên đang quản lý Hợp đồng. Vui lòng chuyển trạng thái nghỉ việc.';
    END IF;

    -- Kiểm tra nếu nhân viên là Kế toán trong Hóa đơn
    IF EXISTS (SELECT 1 FROM HoaDon WHERE maKeToan = OLD.maNhanVien) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Không thể xóa: Nhân viên đã lập Hóa đơn tài chính. Vui lòng chuyển trạng thái nghỉ việc.';
    END IF;
    
    -- Kiểm tra nếu nhân viên đã lắp đặt công tơ
    IF EXISTS (SELECT 1 FROM CongToDien WHERE maNVLapDat = OLD.maNhanVien) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Không thể xóa: Nhân viên đã lắp đặt công tơ. Vui lòng chuyển trạng thái nghỉ việc.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `NhanVienHoTro`
--

DROP TABLE IF EXISTS `NhanVienHoTro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `NhanVienHoTro` (
  `maNhanVienHoTro` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `kenhHoTro` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `capDoHoTro` int DEFAULT NULL,
  PRIMARY KEY (`maNhanVienHoTro`),
  CONSTRAINT `NhanVienHoTro_ibfk_1` FOREIGN KEY (`maNhanVienHoTro`) REFERENCES `NhanVien` (`maNhanVien`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NhanVienHoTro`
--

LOCK TABLES `NhanVienHoTro` WRITE;
/*!40000 ALTER TABLE `NhanVienHoTro` DISABLE KEYS */;
INSERT INTO `NhanVienHoTro` VALUES ('HT001','Tong dai 1900xxxx',2),('HT002','Zalo OA',3),('HT003','Email ho tro',2),('HT004','Tai quay giao dich',3);
/*!40000 ALTER TABLE `NhanVienHoTro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `NhanVienLapDat`
--

DROP TABLE IF EXISTS `NhanVienLapDat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `NhanVienLapDat` (
  `maNhanVienLapDat` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `soTheKyThuat` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ccAnToanDien` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`maNhanVienLapDat`),
  CONSTRAINT `NhanVienLapDat_ibfk_1` FOREIGN KEY (`maNhanVienLapDat`) REFERENCES `NhanVien` (`maNhanVien`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NhanVienLapDat`
--

LOCK TABLES `NhanVienLapDat` WRITE;
/*!40000 ALTER TABLE `NhanVienLapDat` DISABLE KEYS */;
INSERT INTO `NhanVienLapDat` VALUES ('LD001','KTV-HN-02841','ATD-B1'),('LD002','KTV-HCM-03112','ATD-B1'),('LD003','KTV-DN-01977','ATD-B1'),('LD004','KTV-CT-01420','ATD-B2');
/*!40000 ALTER TABLE `NhanVienLapDat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `NhanVienQuanLy`
--

DROP TABLE IF EXISTS `NhanVienQuanLy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `NhanVienQuanLy` (
  `maNhanVienQuanLy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `thamNien` int DEFAULT NULL,
  `trinhDoVanHoa` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`maNhanVienQuanLy`),
  CONSTRAINT `NhanVienQuanLy_ibfk_1` FOREIGN KEY (`maNhanVienQuanLy`) REFERENCES `NhanVien` (`maNhanVien`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NhanVienQuanLy`
--

LOCK TABLES `NhanVienQuanLy` WRITE;
/*!40000 ALTER TABLE `NhanVienQuanLy` DISABLE KEYS */;
INSERT INTO `NhanVienQuanLy` VALUES ('QL001',12,'Dai hoc'),('QL002',11,'Dai hoc'),('QL003',13,'Dai hoc'),('QL004',10,'Sau dai hoc'),('QL005',9,'Dai hoc'),('QL006',8,'Dai hoc'),('QL007',7,'Cao dang'),('QL008',6,'Dai hoc');
/*!40000 ALTER TABLE `NhanVienQuanLy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SDT_KhachHang`
--

DROP TABLE IF EXISTS `SDT_KhachHang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SDT_KhachHang` (
  `maKhachHang` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `soDienThoai` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`maKhachHang`,`soDienThoai`),
  CONSTRAINT `SDT_KhachHang_ibfk_1` FOREIGN KEY (`maKhachHang`) REFERENCES `KhachHang` (`maKhachHang`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SDT_KhachHang`
--

LOCK TABLES `SDT_KhachHang` WRITE;
/*!40000 ALTER TABLE `SDT_KhachHang` DISABLE KEYS */;
INSERT INTO `SDT_KhachHang` VALUES ('KH_FACTORY','02838999888'),('KH001','0961234567'),('KH002','0972345678'),('KH003','0983456789'),('KH004','0904567890'),('KH005','0915678901'),('KH006','0926789012'),('KH007','0937890123'),('KH008','0948901234'),('KH009','0959012345'),('KH010','0960123456'),('KH011','02838211234'),('KH012','02253821111'),('KH013','02363823333'),('KH014','02838224444'),('KH015','02923825555'),('KH016','02583826666'),('KH017','02033827777'),('KH018','02563828888'),('KH019','0908123009'),('KH020','0919123010');
/*!40000 ALTER TABLE `SDT_KhachHang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SDT_NhanVien`
--

DROP TABLE IF EXISTS `SDT_NhanVien`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SDT_NhanVien` (
  `maNhanVien` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `soDienThoai` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`maNhanVien`,`soDienThoai`),
  CONSTRAINT `SDT_NhanVien_ibfk_1` FOREIGN KEY (`maNhanVien`) REFERENCES `NhanVien` (`maNhanVien`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SDT_NhanVien`
--

LOCK TABLES `SDT_NhanVien` WRITE;
/*!40000 ALTER TABLE `SDT_NhanVien` DISABLE KEYS */;
INSERT INTO `SDT_NhanVien` VALUES ('HT001','0916123005'),('HT002','0926123006'),('HT003','0936123007'),('HT004','0946123008'),('KT001','0988123123'),('KT002','0909123789'),('KT003','0918123898'),('KT004','0978123456'),('LD001','0967123001'),('LD002','0976123002'),('LD003','0986123003'),('LD004','0906123004'),('QL001','0903123456'),('QL002','0912233445'),('QL003','0934567890'),('QL004','0907888999'),('QL005','0914555666'),('QL006','0987111222'),('QL007','0962333444'),('QL008','0979555666');
/*!40000 ALTER TABLE `SDT_NhanVien` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'QuanLyDienLuc_Final'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_BaoCaoTaiChinh` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_BaoCaoTaiChinh`(
    IN p_Thang INT, 
    IN p_Nam INT, 
    IN p_MaChiNhanh VARCHAR(20)
)
BEGIN
    DECLARE v_DoanhThuHeThong DECIMAL(15, 2) DEFAULT 0;
    DECLARE v_Done INT DEFAULT 0;
    DECLARE v_MaCongTo VARCHAR(20);
    DECLARE v_NgayGhiNhan DATE;
    DECLARE v_TienDon DECIMAL(15, 2);
    
    -- Cursor to iterate through all invoices for the branch in the specified month
    DECLARE cur_HoaDon CURSOR FOR
        SELECT hd.maCongTo, hd.ngayGhiNhan
        FROM HoaDon hd
        JOIN ChiSoDienHangThang cs ON hd.maCongTo = cs.maCongTo AND hd.ngayGhiNhan = cs.ngayGhiNhan
        JOIN CongToDien ct ON cs.maCongTo = ct.maCongTo
        JOIN KhachHang kh ON ct.maKhachHang = kh.maKhachHang
        WHERE MONTH(hd.ngayLapDon) = p_Thang 
          AND YEAR(hd.ngayLapDon) = p_Nam
          AND kh.maChiNhanh = p_MaChiNhanh;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_Done = 1;

    -- 1. Calculate total revenue by calling sp_TinhTienDien for each invoice
    OPEN cur_HoaDon;
    
    read_loop: LOOP
        FETCH cur_HoaDon INTO v_MaCongTo, v_NgayGhiNhan;
        
        IF v_Done = 1 THEN
            LEAVE read_loop;
        END IF;
        
        -- Calculate bill amount for this invoice
        CALL sp_TinhTienDien(v_MaCongTo, v_NgayGhiNhan, v_TienDon);
        SET v_DoanhThuHeThong = v_DoanhThuHeThong + IFNULL(v_TienDon, 0);
    END LOOP;
    
    CLOSE cur_HoaDon;

    -- 2. Lấy Chi phí và Update Doanh thu vào bảng ChiPhiCongTy
    -- Bước này giúp đồng bộ dữ liệu tính toán được vào bảng báo cáo
    UPDATE ChiPhiCongTy
    SET doanhThuThang = IFNULL(v_DoanhThuHeThong, 0)
    WHERE maChiNhanh = p_MaChiNhanh AND namTaiChinh = p_Nam AND thangTaiChinh = p_Thang;

    -- 3. Hiển thị kết quả cuối cùng
    SELECT * FROM ChiPhiCongTy 
    WHERE maChiNhanh = p_MaChiNhanh AND namTaiChinh = p_Nam AND thangTaiChinh = p_Thang;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_CanhBaoBaoTri` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_CanhBaoBaoTri`()
BEGIN
    SELECT 
        ct.maCongTo,
        ct.ngayLapDat,
        ct.hanSuDung AS NienHan_Nam,
        TIMESTAMPDIFF(YEAR, ct.ngayLapDat, CURDATE()) AS DaSuDung_Nam,
        kh.diaChi AS DiaChiLapDat
    FROM CongToDien ct
    JOIN KhachHang kh ON ct.maKhachHang = kh.maKhachHang
    WHERE TIMESTAMPDIFF(YEAR, ct.ngayLapDat, CURDATE()) >= ct.hanSuDung;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_TinhTienDien` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_TinhTienDien`(
    IN p_MaCongTo VARCHAR(20),
    IN p_NgayGhiNhan DATE,
    OUT p_TongTien DECIMAL(15, 2)
)
BEGIN
    DECLARE v_MaBangGia VARCHAR(20);
    DECLARE v_SanLuong INT;
    DECLARE v_TienDien DECIMAL(15, 2) DEFAULT 0;
    DECLARE v_SanLuongConLai INT;
    DECLARE v_SoKwhTrongBac INT;
    DECLARE v_Done INT DEFAULT 0;
    
    -- Cursor variables
    DECLARE v_ThuTuBac INT;
    DECLARE v_GiaDien DECIMAL(10, 2);
    DECLARE v_TuSo INT;
    DECLARE v_ToiSo INT;
    
    -- Cursor to iterate through price tiers in order
    DECLARE cur_BacGia CURSOR FOR
        SELECT thuTuCapBac, giaDienTrenKwh, tuSoDien, toiSoDien
        FROM BacGiaDien
        WHERE maBangGia = v_MaBangGia
        ORDER BY thuTuCapBac ASC;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_Done = 1;

    -- 1. Get consumption and applicable price table
    SELECT 
        (cs.soDienMoi - cs.soDienCu), kh.maBangGiaDien
    INTO 
        v_SanLuong, v_MaBangGia
    FROM ChiSoDienHangThang cs
    JOIN CongToDien ct ON cs.maCongTo = ct.maCongTo
    JOIN KhachHang kh ON ct.maKhachHang = kh.maKhachHang
    WHERE cs.maCongTo = p_MaCongTo AND cs.ngayGhiNhan = p_NgayGhiNhan;

    -- Check if data exists
    IF v_SanLuong IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không tìm thấy chỉ số điện cho công tơ và ngày ghi nhận này.';
    END IF;

    -- 2. Calculate electricity bill using tiered pricing
    SET v_SanLuongConLai = v_SanLuong;
    
    OPEN cur_BacGia;
    
    read_loop: LOOP
        FETCH cur_BacGia INTO v_ThuTuBac, v_GiaDien, v_TuSo, v_ToiSo;
        
        IF v_Done = 1 OR v_SanLuongConLai <= 0 THEN
            LEAVE read_loop;
        END IF;
        
        -- Calculate kWh in this tier
        -- For the last tier (toiSo = NULL means unlimited), use all remaining consumption
        IF v_ToiSo IS NULL THEN
            SET v_SoKwhTrongBac = v_SanLuongConLai;
        ELSE
            -- Use LEAST to get minimum of (tier range, remaining consumption)
            SET v_SoKwhTrongBac = LEAST(v_ToiSo - v_TuSo, v_SanLuongConLai);
        END IF;
        
        -- Add charge for this tier
        SET v_TienDien = v_TienDien + (v_SoKwhTrongBac * v_GiaDien);
        
        -- Reduce remaining consumption
        SET v_SanLuongConLai = v_SanLuongConLai - v_SoKwhTrongBac;
    END LOOP;
    
    CLOSE cur_BacGia;

    -- 3. Return result via OUT parameter
    SET p_TongTien = v_TienDien;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-05 17:16:46
