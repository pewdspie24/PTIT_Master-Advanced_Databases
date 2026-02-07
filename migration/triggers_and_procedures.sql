-- =====================================================
-- Triggers and Stored Procedures for QuanLyDienLuc_Final
-- Created: 2026-02-04
-- =====================================================

USE QuanLyDienLuc_Final;

DELIMITER $$

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Trigger: Validate meter readings before insert
DROP TRIGGER IF EXISTS `trg_CheckChiSoDien_BeforeInsert`$$
CREATE TRIGGER `trg_CheckChiSoDien_BeforeInsert` 
BEFORE INSERT ON `ChiSoDienHangThang` 
FOR EACH ROW 
BEGIN
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
END$$

-- Trigger: Protect employee from deletion if they have critical references
DROP TRIGGER IF EXISTS `trg_ProtectNhanVien_BeforeDelete`$$
CREATE TRIGGER `trg_ProtectNhanVien_BeforeDelete` 
BEFORE DELETE ON `NhanVien` 
FOR EACH ROW 
BEGIN
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
END$$

-- Trigger: Prevent modification of paid invoices
DROP TRIGGER IF EXISTS `trg_ProtectPaidInvoice_BeforeUpdate`$$
CREATE TRIGGER trg_ProtectPaidInvoice_BeforeUpdate
BEFORE UPDATE ON HoaDon
FOR EACH ROW
BEGIN
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
END$$

-- Trigger: Prevent modification of meter readings used in invoices
DROP TRIGGER IF EXISTS `trg_LockChiSoDien_BeforeUpdate`$$
CREATE TRIGGER trg_LockChiSoDien_BeforeUpdate
BEFORE UPDATE ON ChiSoDienHangThang
FOR EACH ROW
BEGIN
    -- Kiểm tra xem cặp (MaCongTo, NgayGhiNhan) này đã tồn tại trong bảng HoaDon chưa
    IF EXISTS (SELECT 1 FROM HoaDon WHERE maCongTo = OLD.maCongTo AND ngayGhiNhan = OLD.ngayGhiNhan) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi nghiệp vụ: Chỉ số điện này đã được dùng để lập Hóa đơn. Vui lòng hủy Hóa đơn trước khi sửa chỉ số.';
    END IF;
END$$

-- Trigger: Validate pricing tiers before insert
DROP TRIGGER IF EXISTS `trg_ValidateBacGia_BeforeInsert`$$
CREATE TRIGGER trg_ValidateBacGia_BeforeInsert
BEFORE INSERT ON BacGiaDien
FOR EACH ROW
BEGIN
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
END$$

-- Trigger: Validate contract data before insert
DROP TRIGGER IF EXISTS `trg_ValidateHopDong_BeforeInsert`$$
CREATE TRIGGER trg_ValidateHopDong_BeforeInsert
BEFORE INSERT ON HopDong
FOR EACH ROW
BEGIN
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
END$$

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

-- Procedure: Calculate electricity bill based on tiered pricing
DROP PROCEDURE IF EXISTS `sp_TinhTienDien`$$
CREATE PROCEDURE `sp_TinhTienDien`(
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
END$$

-- Procedure: Generate financial report for a branch
DROP PROCEDURE IF EXISTS `sp_BaoCaoTaiChinh`$$
CREATE PROCEDURE `sp_BaoCaoTaiChinh`(
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
          AND kh.maChiNhanh COLLATE utf8mb4_unicode_ci = p_MaChiNhanh COLLATE utf8mb4_unicode_ci;
    
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
    WHERE maChiNhanh COLLATE utf8mb4_unicode_ci = p_MaChiNhanh COLLATE utf8mb4_unicode_ci 
      AND namTaiChinh = p_Nam 
      AND thangTaiChinh = p_Thang;

    -- 3. Hiển thị kết quả cuối cùng
    SELECT * FROM ChiPhiCongTy 
    WHERE maChiNhanh COLLATE utf8mb4_unicode_ci = p_MaChiNhanh COLLATE utf8mb4_unicode_ci 
      AND namTaiChinh = p_Nam 
      AND thangTaiChinh = p_Thang;
END$$

-- Procedure: Alert for meters that need maintenance
DROP PROCEDURE IF EXISTS `sp_CanhBaoBaoTri`$$
CREATE PROCEDURE `sp_CanhBaoBaoTri`()
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
END$$

DELIMITER ;

-- =====================================================
-- END OF FILE
-- =====================================================
