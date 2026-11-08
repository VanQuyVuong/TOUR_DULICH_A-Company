-- =========================================================
-- DPV_TourDuLich - FINAL DATABASE V2
-- MySQL 8.0+
-- 56 bảng: 52 bảng gốc + LOAI_TOUR + PHIEN_DANG_NHAP + DAT_LAI_MAT_KHAU + LICH_SU_VAI_TRO
-- =========================================================
DROP DATABASE IF EXISTS DPV_TourDuLich;

CREATE DATABASE IF NOT EXISTS DPV_TourDuLich
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE DPV_TourDuLich;


-- =========================================================
-- 1. BẢNG TAI - KHOAN
-- =========================================================

CREATE TABLE IF NOT EXISTS TAI_KHOAN (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ten_dang_nhap VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'HOAT_DONG',
    lan_dang_nhap_cuoi DATETIME NULL,
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ngay_cap_nhat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE uq_tk_ten_dang_nhap(ten_dang_nhap),
    UNIQUE uq_tk_email(email)
);


-- =========================================================
-- 2. BẢNG VAI - TRO
-- =========================================================

CREATE TABLE IF NOT EXISTS VAI_TRO (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ma_vai_tro VARCHAR(50) NOT NULL,
    ten_vai_tro VARCHAR(100) NOT NULL,
    mo_ta TEXT NULL,
    UNIQUE uq_vt_ma(ma_vai_tro)
);


-- =========================================================
-- 3. BẢNG QUYEN
-- =========================================================

CREATE TABLE IF NOT EXISTS QUYEN (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ma_quyen VARCHAR(100) NOT NULL,
    ten_quyen VARCHAR(150) NOT NULL,
    nhom_quyen VARCHAR(100),
    mo_ta TEXT,
    UNIQUE uq_q_ma(ma_quyen)
);


-- =========================================================
-- 4. BẢNG TAI - KHOAN - VAI - TRO
-- =========================================================

CREATE TABLE IF NOT EXISTS TAI_KHOAN_VAI_TRO (
    tai_khoan_id BIGINT NOT NULL,
    vai_tro_id BIGINT NOT NULL,
    ngay_gan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(tai_khoan_id,vai_tro_id)
);


-- =========================================================
-- 5. BẢNG VAI - TRO - QUYEN
-- =========================================================

CREATE TABLE IF NOT EXISTS VAI_TRO_QUYEN (
    vai_tro_id BIGINT NOT NULL,
    quyen_id BIGINT NOT NULL,
    PRIMARY KEY(vai_tro_id,quyen_id),
    FOREIGN KEY(vai_tro_id) REFERENCES VAI_TRO(id)
            ON DELETE CASCADE,
    FOREIGN KEY(quyen_id) REFERENCES QUYEN(id)
            ON DELETE CASCADE
);


-- =========================================================
-- 6. BẢNG NHAN - VIEN
-- =========================================================

CREATE TABLE IF NOT EXISTS NHAN_VIEN (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tai_khoan_id BIGINT NOT NULL,
    ma_nhan_vien VARCHAR(50) NOT NULL,
    ho_ten VARCHAR(150) NOT NULL,
    ngay_sinh DATE,
    gioi_tinh VARCHAR(20),
    so_dien_thoai VARCHAR(20),
    dia_chi VARCHAR(500),
    ngay_vao_lam DATE,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'DANG_LAM_VIEC',
    ghi_chu TEXT,
    UNIQUE uq_nv_tk(tai_khoan_id),
    UNIQUE uq_nv_ma(ma_nhan_vien),
    FOREIGN KEY(tai_khoan_id) REFERENCES TAI_KHOAN(id)
);


-- =========================================================
-- 7. BẢNG BAN
-- =========================================================

CREATE TABLE IF NOT EXISTS BAN (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ma_ban VARCHAR(50) NOT NULL,
    ten_ban VARCHAR(255) NOT NULL,
    mo_ta TEXT,
    linh_vuc_phu_trach VARCHAR(255),
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'HOAT_DONG',
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE uq_ban_ma(ma_ban)
);


-- =========================================================
-- 8. BẢNG NHAN - VIEN - BAN
-- =========================================================

CREATE TABLE IF NOT EXISTS NHAN_VIEN_BAN (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nhan_vien_id BIGINT NOT NULL,
    ban_id BIGINT NOT NULL,
    vai_tro_trong_ban VARCHAR(30) NOT NULL DEFAULT 'NHAN_VIEN',
    ngay_bat_dau DATE NOT NULL,
    ngay_ket_thuc DATE,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'DANG_THAM_GIA',
    FOREIGN KEY(nhan_vien_id) REFERENCES NHAN_VIEN(id),
    FOREIGN KEY(ban_id) REFERENCES BAN(id)
);


-- =========================================================
-- 9. BẢNG CHUYEN - MON - HDV
-- =========================================================

CREATE TABLE IF NOT EXISTS CHUYEN_MON_HDV (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nhan_vien_id BIGINT NOT NULL,
    ten_chuyen_mon VARCHAR(255) NOT NULL,
    cap_do VARCHAR(50),
    ghi_chu TEXT,
    FOREIGN KEY(nhan_vien_id) REFERENCES NHAN_VIEN(id)
            ON DELETE CASCADE
);


-- =========================================================
-- 10. BẢNG NGON - NGU
-- =========================================================

CREATE TABLE IF NOT EXISTS NGON_NGU (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ma_ngon_ngu VARCHAR(20) NOT NULL,
    ten_ngon_ngu VARCHAR(100) NOT NULL,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'HOAT_DONG',
    UNIQUE uq_nn_ma(ma_ngon_ngu)
);


-- =========================================================
-- 11. BẢNG NHAN - VIEN - NGON - NGU
-- =========================================================

CREATE TABLE IF NOT EXISTS NHAN_VIEN_NGON_NGU (
    nhan_vien_id BIGINT NOT NULL,
    ngon_ngu_id BIGINT NOT NULL,
    trinh_do VARCHAR(50),
    PRIMARY KEY(nhan_vien_id,ngon_ngu_id),
    FOREIGN KEY(nhan_vien_id) REFERENCES NHAN_VIEN(id)
            ON DELETE CASCADE,
    FOREIGN KEY(ngon_ngu_id) REFERENCES NGON_NGU(id)
);


-- =========================================================
-- 12. BẢNG KHACH - HANG
-- =========================================================

CREATE TABLE IF NOT EXISTS KHACH_HANG (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tai_khoan_id BIGINT NOT NULL,
    ma_khach_hang VARCHAR(50) NOT NULL,
    ho_ten VARCHAR(150) NOT NULL,
    ngay_sinh DATE,
    gioi_tinh VARCHAR(20),
    so_dien_thoai VARCHAR(20),
    dia_chi VARCHAR(500),
    quoc_tich VARCHAR(100),
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE uq_kh_tk(tai_khoan_id),
    UNIQUE uq_kh_ma(ma_khach_hang),
    FOREIGN KEY(tai_khoan_id) REFERENCES TAI_KHOAN(id)
);


-- =========================================================
-- 13. BẢNG QUOC - GIA
-- =========================================================

CREATE TABLE IF NOT EXISTS QUOC_GIA (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ma_quoc_gia VARCHAR(10) NOT NULL,
    ten_quoc_gia VARCHAR(150) NOT NULL,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'HOAT_DONG',
    UNIQUE uq_qg_ma(ma_quoc_gia),
    UNIQUE uq_qg_ten(ten_quoc_gia)
);


-- =========================================================
-- 14. BẢNG TINH - THANH
-- =========================================================

CREATE TABLE IF NOT EXISTS TINH_THANH (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    quoc_gia_id BIGINT NOT NULL,
    ma_tinh_thanh VARCHAR(30),
    ten_tinh_thanh VARCHAR(150) NOT NULL,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'HOAT_DONG',
    UNIQUE uq_tt_qg_ten(quoc_gia_id, ten_tinh_thanh),
    FOREIGN KEY(quoc_gia_id) REFERENCES QUOC_GIA(id)
);


-- =========================================================
-- 15. BẢNG DIA - DIEM
-- =========================================================

CREATE TABLE IF NOT EXISTS DIA_DIEM (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tinh_thanh_id BIGINT NOT NULL,
    ma_dia_diem VARCHAR(50),
    ten_dia_diem VARCHAR(255) NOT NULL,
    dia_chi VARCHAR(500),
    mo_ta TEXT,
    loai_dia_diem VARCHAR(100),
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'HOAT_DONG',
    UNIQUE uq_dd_tt_ten(tinh_thanh_id, ten_dia_diem),
    FOREIGN KEY(tinh_thanh_id) REFERENCES TINH_THANH(id)
);


-- =========================================================
-- 16. BẢNG LOAI - TOUR
-- =========================================================

CREATE TABLE IF NOT EXISTS LOAI_TOUR (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ma_loai_tour VARCHAR(50) NOT NULL,
    ten_loai_tour VARCHAR(150) NOT NULL,
    mo_ta TEXT,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'HOAT_DONG',
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ngay_cap_nhat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE uq_ltt_ma(ma_loai_tour),
    UNIQUE uq_ltt_ten(ten_loai_tour)
);


-- 17. BẢNG TOUR
-- =========================================================

CREATE TABLE IF NOT EXISTS TOUR (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ma_tour VARCHAR(50) NOT NULL,
    ten_tour VARCHAR(255) NOT NULL,
    mo_ta_ngan VARCHAR(500),
    mo_ta TEXT,
    so_ngay INT NOT NULL,
    so_dem INT NOT NULL DEFAULT 0,
    gia_nguoi_lon DECIMAL(15,2) NOT NULL,
    gia_tre_em DECIMAL(15,2),
    gia_em_be DECIMAL(15,2),
    so_nguoi_toi_thieu INT NOT NULL DEFAULT 1,
    so_nguoi_toi_da INT,
    loai_tour_id BIGINT NOT NULL,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'NHAP',
    nguoi_tao_id BIGINT NOT NULL,
    nguoi_duyet_id BIGINT,
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ngay_duyet DATETIME,
    UNIQUE uq_tour_ma(ma_tour),
    FOREIGN KEY(nguoi_tao_id) REFERENCES NHAN_VIEN(id),
    FOREIGN KEY(nguoi_duyet_id) REFERENCES NHAN_VIEN(id)
            ON DELETE SET NULL,
    FOREIGN KEY(loai_tour_id) REFERENCES LOAI_TOUR(id)
);


-- =========================================================
-- 18. BẢNG TOUR - DIA - DIEM
-- =========================================================

CREATE TABLE IF NOT EXISTS TOUR_DIA_DIEM (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tour_id BIGINT NOT NULL,
    dia_diem_id BIGINT NOT NULL,
    thu_tu INT NOT NULL,
    ghi_chu TEXT,
    UNIQUE uq_tdd(tour_id,thu_tu),
    FOREIGN KEY(tour_id) REFERENCES TOUR(id)
            ON DELETE CASCADE,
    FOREIGN KEY(dia_diem_id) REFERENCES DIA_DIEM(id)
);


-- =========================================================
-- 19. BẢNG DOT - KHOI - HANH
-- =========================================================

CREATE TABLE IF NOT EXISTS DOT_KHOI_HANH (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tour_id BIGINT NOT NULL,
    ma_dot VARCHAR(50) NOT NULL,
    ngay_khoi_hanh DATETIME NOT NULL,
    ngay_ket_thuc DATETIME NOT NULL,
    so_cho_toi_da INT NOT NULL,
    so_cho_da_dat INT NOT NULL DEFAULT 0,
    gia_nguoi_lon DECIMAL(15,2) NOT NULL,
    gia_tre_em DECIMAL(15,2),
    gia_em_be DECIMAL(15,2),
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'MO_DANG_KY',
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE uq_dot_ma(ma_dot),
    CONSTRAINT chk_dot_cho CHECK(so_cho_toi_da>0 AND so_cho_da_dat>=0 AND so_cho_da_dat<=so_cho_toi_da),
    CONSTRAINT chk_dot_ngay CHECK(ngay_ket_thuc > ngay_khoi_hanh),
    FOREIGN KEY(tour_id) REFERENCES TOUR(id)
);


-- =========================================================
-- 20. BẢNG LICH - TRINH
-- =========================================================

CREATE TABLE IF NOT EXISTS LICH_TRINH (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dot_khoi_hanh_id BIGINT NOT NULL,
    ngay_thu INT NOT NULL,
    tieu_de VARCHAR(255) NOT NULL,
    noi_dung TEXT,
    dia_diem_id BIGINT,
    gio_bat_dau TIME,
    gio_ket_thuc TIME,
    thu_tu INT NOT NULL DEFAULT 1,
    UNIQUE uq_lt(dot_khoi_hanh_id,ngay_thu,thu_tu),
    FOREIGN KEY(dot_khoi_hanh_id) REFERENCES DOT_KHOI_HANH(id)
            ON DELETE CASCADE,
    FOREIGN KEY(dia_diem_id) REFERENCES DIA_DIEM(id)
            ON DELETE SET NULL
);


-- =========================================================
-- 21. BẢNG PHAN - CONG - HDV
-- =========================================================

CREATE TABLE IF NOT EXISTS PHAN_CONG_HDV (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dot_khoi_hanh_id BIGINT NOT NULL,
    nhan_vien_id BIGINT NOT NULL,
    vai_tro VARCHAR(50) NOT NULL DEFAULT 'HDV',
    ngay_phan_cong DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'DA_PHAN_CONG',
    ghi_chu TEXT,
    FOREIGN KEY(dot_khoi_hanh_id) REFERENCES DOT_KHOI_HANH(id)
            ON DELETE CASCADE,
    FOREIGN KEY(nhan_vien_id) REFERENCES NHAN_VIEN(id)
);


-- =========================================================
-- 22. BẢNG TIEN - TRINH - TOUR
-- =========================================================

CREATE TABLE IF NOT EXISTS TIEN_TRINH_TOUR (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dot_khoi_hanh_id BIGINT NOT NULL,
    nhan_vien_id BIGINT NOT NULL,
    lich_trinh_id BIGINT,
    noi_dung TEXT NOT NULL,
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(dot_khoi_hanh_id) REFERENCES DOT_KHOI_HANH(id)
            ON DELETE CASCADE,
    FOREIGN KEY(nhan_vien_id) REFERENCES NHAN_VIEN(id),
    FOREIGN KEY(lich_trinh_id) REFERENCES LICH_TRINH(id)
            ON DELETE SET NULL
);


-- =========================================================
-- 23. BẢNG HINH - ANH - TIEN - TRINH
-- =========================================================

CREATE TABLE IF NOT EXISTS HINH_ANH_TIEN_TRINH (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tien_trinh_id BIGINT NOT NULL,
    duong_dan VARCHAR(500) NOT NULL,
    mo_ta VARCHAR(255),
    FOREIGN KEY(tien_trinh_id) REFERENCES TIEN_TRINH_TOUR(id)
            ON DELETE CASCADE
);


-- =========================================================
-- 24. BẢNG CHINH - SACH - HUY
-- =========================================================

CREATE TABLE IF NOT EXISTS CHINH_SACH_HUY (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ten_chinh_sach VARCHAR(255) NOT NULL,
    mo_ta TEXT,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'HOAT_DONG',
    ngay_ap_dung DATETIME NOT NULL,
    ngay_ket_thuc DATETIME
);


-- =========================================================
-- 25. BẢNG QUY - TAC - HUY
-- =========================================================

CREATE TABLE IF NOT EXISTS QUY_TAC_HUY (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    chinh_sach_huy_id BIGINT NOT NULL,
    tu_so_ngay INT NOT NULL,
    den_so_ngay INT,
    phan_tram_hoan DECIMAL(5,2) NOT NULL,
    ghi_chu TEXT,
    CONSTRAINT chk_qth_hoan CHECK(phan_tram_hoan BETWEEN 0 AND 100),
    FOREIGN KEY(chinh_sach_huy_id) REFERENCES CHINH_SACH_HUY(id)
            ON DELETE CASCADE
);


-- =========================================================
-- 26. BẢNG BOOKING
-- =========================================================

CREATE TABLE IF NOT EXISTS BOOKING (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ma_booking VARCHAR(50) NOT NULL,
    khach_hang_id BIGINT NOT NULL,
    dot_khoi_hanh_id BIGINT NOT NULL,
    chinh_sach_huy_id BIGINT,
    thoi_gian_dat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    thoi_gian_het_han_giu_cho DATETIME,
    so_nguoi_lon INT NOT NULL DEFAULT 0,
    so_tre_em INT NOT NULL DEFAULT 0,
    so_em_be INT NOT NULL DEFAULT 0,
    tong_so_nguoi INT NOT NULL,
    gia_nguoi_lon DECIMAL(15,2) NOT NULL,
    gia_tre_em DECIMAL(15,2),
    gia_em_be DECIMAL(15,2),
    tong_tien DECIMAL(15,2) NOT NULL,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'CHO_THANH_TOAN',
    ghi_chu TEXT,
    UNIQUE uq_booking_ma(ma_booking),
    CONSTRAINT chk_booking_nguoi CHECK(tong_so_nguoi>0),
    FOREIGN KEY(khach_hang_id) REFERENCES KHACH_HANG(id),
    FOREIGN KEY(dot_khoi_hanh_id) REFERENCES DOT_KHOI_HANH(id),
    FOREIGN KEY(chinh_sach_huy_id) REFERENCES CHINH_SACH_HUY(id)
            ON DELETE SET NULL
);


-- =========================================================
-- 27. BẢNG HANH - KHACH
-- =========================================================

CREATE TABLE IF NOT EXISTS HANH_KHACH (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    ho_ten VARCHAR(150) NOT NULL,
    ngay_sinh DATE,
    gioi_tinh VARCHAR(20),
    loai_hanh_khach VARCHAR(30) NOT NULL,
    so_giay_to VARCHAR(100),
    quoc_tich VARCHAR(100),
    so_dien_thoai VARCHAR(20),
    email VARCHAR(255),
    la_nguoi_lien_he BOOLEAN NOT NULL DEFAULT FALSE,
    ghi_chu TEXT,
    FOREIGN KEY(booking_id) REFERENCES BOOKING(id)
            ON DELETE CASCADE
);


-- =========================================================
-- 28. BẢNG THANH - TOAN
-- =========================================================

CREATE TABLE IF NOT EXISTS THANH_TOAN (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    ma_giao_dich VARCHAR(100) NOT NULL,
    so_tien DECIMAL(15,2) NOT NULL,
    phuong_thuc VARCHAR(50) NOT NULL,
    loai_thanh_toan VARCHAR(30) NOT NULL,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'CHO_THANH_TOAN',
    thoi_gian_thanh_toan DATETIME,
    du_lieu_giao_dich JSON,
    ghi_chu TEXT,
    UNIQUE uq_tt_ma(ma_giao_dich),
    FOREIGN KEY(booking_id) REFERENCES BOOKING(id)
);


-- =========================================================
-- 29. BẢNG DOI - SOAT - GIAO - DICH
-- =========================================================

CREATE TABLE IF NOT EXISTS DOI_SOAT_GIAO_DICH (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    thanh_toan_id BIGINT NOT NULL,
    nguoi_doi_soat_id BIGINT NOT NULL,
    trang_thai VARCHAR(30) NOT NULL,
    ghi_chu TEXT,
    thoi_gian_doi_soat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(thanh_toan_id) REFERENCES THANH_TOAN(id),
    FOREIGN KEY(nguoi_doi_soat_id) REFERENCES NHAN_VIEN(id)
);


-- =========================================================
-- 30. BẢNG HUY - BOOKING
-- =========================================================

CREATE TABLE IF NOT EXISTS HUY_BOOKING (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    nguoi_huy_id BIGINT,
    loai_nguoi_huy VARCHAR(30) NOT NULL,
    ly_do TEXT NOT NULL,
    thoi_gian_huy DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    phan_tram_hoan DECIMAL(5,2) NOT NULL DEFAULT 0,
    so_tien_hoan_du_kien DECIMAL(15,2) NOT NULL DEFAULT 0,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'CHO_XU_LY',
    FOREIGN KEY(booking_id) REFERENCES BOOKING(id),
    FOREIGN KEY(nguoi_huy_id) REFERENCES NHAN_VIEN(id)
            ON DELETE SET NULL
);


-- =========================================================
-- 31. BẢNG HOAN - TIEN
-- =========================================================

CREATE TABLE IF NOT EXISTS HOAN_TIEN (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    huy_booking_id BIGINT,
    so_tien DECIMAL(15,2) NOT NULL,
    ly_do TEXT,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'CHO_XU_LY',
    nguoi_xu_ly_id BIGINT,
    thoi_gian_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    thoi_gian_hoan DATETIME,
    ma_giao_dich_hoan VARCHAR(100),
    ghi_chu TEXT,
    FOREIGN KEY(booking_id) REFERENCES BOOKING(id),
    FOREIGN KEY(huy_booking_id) REFERENCES HUY_BOOKING(id)
            ON DELETE SET NULL,
    FOREIGN KEY(nguoi_xu_ly_id) REFERENCES NHAN_VIEN(id)
            ON DELETE SET NULL
);


-- =========================================================
-- 32. BẢNG YEU - CAU - TOUR - RIENG
-- =========================================================

CREATE TABLE IF NOT EXISTS YEU_CAU_TOUR_RIENG (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ma_yeu_cau VARCHAR(50) NOT NULL,
    khach_hang_id BIGINT NOT NULL,
    ten_yeu_cau VARCHAR(255) NOT NULL,
    ngay_khoi_hanh_du_kien DATE,
    ngay_ket_thuc_du_kien DATE,
    so_nguoi_lon INT NOT NULL DEFAULT 1,
    so_tre_em INT NOT NULL DEFAULT 0,
    so_em_be INT NOT NULL DEFAULT 0,
    ngan_sach_du_kien DECIMAL(15,2),
    yeu_cau_dac_biet TEXT,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'MOI_TAO',
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ngay_cap_nhat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE uq_yc_ma(ma_yeu_cau),
    FOREIGN KEY(khach_hang_id) REFERENCES KHACH_HANG(id)
);


-- =========================================================
-- 33. BẢNG YEU - CAU - TOUR - DIA - DIEM
-- =========================================================

CREATE TABLE IF NOT EXISTS YEU_CAU_TOUR_DIA_DIEM (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    yeu_cau_tour_id BIGINT NOT NULL,
    dia_diem_id BIGINT NOT NULL,
    thu_tu INT NOT NULL,
    so_ngay_du_kien INT,
    ghi_chu TEXT,
    UNIQUE uq_yctdd(yeu_cau_tour_id,thu_tu),
    FOREIGN KEY(yeu_cau_tour_id) REFERENCES YEU_CAU_TOUR_RIENG(id)
            ON DELETE CASCADE,
    FOREIGN KEY(dia_diem_id) REFERENCES DIA_DIEM(id)
);


-- =========================================================
-- 34. BẢNG PHAN - CONG - YEU - CAU - TOUR
-- =========================================================

CREATE TABLE IF NOT EXISTS PHAN_CONG_YEU_CAU_TOUR (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    yeu_cau_tour_id BIGINT NOT NULL,
    ban_id BIGINT NOT NULL,
    nguoi_phan_cong_id BIGINT NOT NULL,
    nguoi_tiep_nhan_id BIGINT,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'CHO_TIEP_NHAN',
    ngay_phan_cong DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ngay_phan_hoi DATETIME,
    ghi_chu TEXT,
    FOREIGN KEY(yeu_cau_tour_id) REFERENCES YEU_CAU_TOUR_RIENG(id)
            ON DELETE CASCADE,
    FOREIGN KEY(ban_id) REFERENCES BAN(id),
    FOREIGN KEY(nguoi_phan_cong_id) REFERENCES NHAN_VIEN(id),
    FOREIGN KEY(nguoi_tiep_nhan_id) REFERENCES NHAN_VIEN(id)
            ON DELETE SET NULL
);


-- =========================================================
-- 35. BẢNG BAO - GIA - TOUR - RIENG
-- =========================================================

CREATE TABLE IF NOT EXISTS BAO_GIA_TOUR_RIENG (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    yeu_cau_tour_id BIGINT NOT NULL,
    ma_bao_gia VARCHAR(50) NOT NULL,
    phien_ban INT NOT NULL,
    tong_so_tien DECIMAL(15,2) NOT NULL,
    thoi_gian_hieu_luc_den DATETIME,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'NHAP',
    nguoi_lap_id BIGINT NOT NULL,
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ghi_chu TEXT,
    UNIQUE uq_bg_ma(ma_bao_gia),
    UNIQUE uq_bg_phien(yeu_cau_tour_id,phien_ban),
    FOREIGN KEY(yeu_cau_tour_id) REFERENCES YEU_CAU_TOUR_RIENG(id),
    FOREIGN KEY(nguoi_lap_id) REFERENCES NHAN_VIEN(id)
);


-- =========================================================
-- 36. BẢNG CHI - TIET - BAO - GIA
-- =========================================================

CREATE TABLE IF NOT EXISTS CHI_TIET_BAO_GIA (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    bao_gia_id BIGINT NOT NULL,
    ten_hang_muc VARCHAR(255) NOT NULL,
    so_luong DECIMAL(10,2) NOT NULL DEFAULT 1,
    don_gia DECIMAL(15,2) NOT NULL,
    thanh_tien DECIMAL(15,2) NOT NULL,
    ghi_chu TEXT,
    FOREIGN KEY(bao_gia_id) REFERENCES BAO_GIA_TOUR_RIENG(id)
            ON DELETE CASCADE
);


-- =========================================================
-- 37. BẢNG TOUR - TU - YEU - CAU
-- =========================================================

CREATE TABLE IF NOT EXISTS TOUR_TU_YEU_CAU (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    yeu_cau_tour_id BIGINT NOT NULL,
    bao_gia_id BIGINT NOT NULL,
    tour_id BIGINT NOT NULL,
    nguoi_tao_id BIGINT NOT NULL,
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(yeu_cau_tour_id) REFERENCES YEU_CAU_TOUR_RIENG(id),
    FOREIGN KEY(bao_gia_id) REFERENCES BAO_GIA_TOUR_RIENG(id),
    FOREIGN KEY(tour_id) REFERENCES TOUR(id),
    FOREIGN KEY(nguoi_tao_id) REFERENCES NHAN_VIEN(id)
);


-- =========================================================
-- 38. BẢNG NGAN - SACH - DOT
-- =========================================================

CREATE TABLE IF NOT EXISTS NGAN_SACH_DOT (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dot_khoi_hanh_id BIGINT NOT NULL,
    tong_ngan_sach DECIMAL(15,2) NOT NULL,
    nguoi_lap_id BIGINT NOT NULL,
    ngay_lap DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ghi_chu TEXT,
    FOREIGN KEY(dot_khoi_hanh_id) REFERENCES DOT_KHOI_HANH(id),
    FOREIGN KEY(nguoi_lap_id) REFERENCES NHAN_VIEN(id)
);


-- =========================================================
-- 39. BẢNG CHI - TIET - NGAN - SACH
-- =========================================================

CREATE TABLE IF NOT EXISTS CHI_TIET_NGAN_SACH (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ngan_sach_id BIGINT NOT NULL,
    ten_hang_muc VARCHAR(255) NOT NULL,
    so_tien_du_kien DECIMAL(15,2) NOT NULL,
    ghi_chu TEXT,
    FOREIGN KEY(ngan_sach_id) REFERENCES NGAN_SACH_DOT(id)
            ON DELETE CASCADE
);


-- =========================================================
-- 40. BẢNG CHI - PHI
-- =========================================================

CREATE TABLE IF NOT EXISTS CHI_PHI (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dot_khoi_hanh_id BIGINT NOT NULL,
    nguoi_tao_id BIGINT NOT NULL,
    ten_chi_phi VARCHAR(255) NOT NULL,
    so_tien DECIMAL(15,2) NOT NULL,
    loai_chi_phi VARCHAR(50) NOT NULL,
    la_phat_sinh BOOLEAN NOT NULL DEFAULT FALSE,
    thoi_gian_chi DATETIME NOT NULL,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'CHO_DUYET',
    ghi_chu TEXT,
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_cp_tien CHECK(so_tien>=0),
    FOREIGN KEY(dot_khoi_hanh_id) REFERENCES DOT_KHOI_HANH(id),
    FOREIGN KEY(nguoi_tao_id) REFERENCES NHAN_VIEN(id)
);


-- =========================================================
-- 41. BẢNG CHUNG - TU - CHI - PHI
-- =========================================================

CREATE TABLE IF NOT EXISTS CHUNG_TU_CHI_PHI (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    chi_phi_id BIGINT NOT NULL,
    loai_chung_tu VARCHAR(50) NOT NULL,
    duong_dan VARCHAR(500) NOT NULL,
    mo_ta VARCHAR(255),
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(chi_phi_id) REFERENCES CHI_PHI(id)
            ON DELETE CASCADE
);


-- =========================================================
-- 42. BẢNG DUYET - CHI - PHI
-- =========================================================

CREATE TABLE IF NOT EXISTS DUYET_CHI_PHI (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    chi_phi_id BIGINT NOT NULL,
    nguoi_duyet_id BIGINT NOT NULL,
    hanh_dong VARCHAR(30) NOT NULL,
    ghi_chu TEXT,
    thoi_gian DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(chi_phi_id) REFERENCES CHI_PHI(id),
    FOREIGN KEY(nguoi_duyet_id) REFERENCES NHAN_VIEN(id)
);


-- =========================================================
-- 43. BẢNG SU - CO - TOUR
-- =========================================================

CREATE TABLE IF NOT EXISTS SU_CO_TOUR (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dot_khoi_hanh_id BIGINT NOT NULL,
    nguoi_bao_cao_id BIGINT NOT NULL,
    tieu_de VARCHAR(255) NOT NULL,
    mo_ta TEXT NOT NULL,
    loai_su_co VARCHAR(50) NOT NULL,
    muc_do VARCHAR(30) NOT NULL,
    thoi_gian_xay_ra DATETIME NOT NULL,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'MOI',
    phuong_an_xu_ly TEXT,
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(dot_khoi_hanh_id) REFERENCES DOT_KHOI_HANH(id),
    FOREIGN KEY(nguoi_bao_cao_id) REFERENCES NHAN_VIEN(id)
);


-- =========================================================
-- 44. BẢNG CHUNG - TU - SU - CO
-- =========================================================

CREATE TABLE IF NOT EXISTS CHUNG_TU_SU_CO (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    su_co_id BIGINT NOT NULL,
    loai_chung_tu VARCHAR(50) NOT NULL,
    duong_dan VARCHAR(500) NOT NULL,
    mo_ta VARCHAR(255),
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(su_co_id) REFERENCES SU_CO_TOUR(id)
            ON DELETE CASCADE
);


-- =========================================================
-- 45. BẢNG THAY - DOI - LICH - TRINH
-- =========================================================

CREATE TABLE IF NOT EXISTS THAY_DOI_LICH_TRINH (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dot_khoi_hanh_id BIGINT NOT NULL,
    su_co_id BIGINT,
    nguoi_de_xuat_id BIGINT NOT NULL,
    noi_dung_cu TEXT,
    noi_dung_moi TEXT NOT NULL,
    ly_do TEXT NOT NULL,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'CHO_DUYET',
    ngay_de_xuat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ngay_xu_ly DATETIME,
    FOREIGN KEY(dot_khoi_hanh_id) REFERENCES DOT_KHOI_HANH(id),
    FOREIGN KEY(su_co_id) REFERENCES SU_CO_TOUR(id)
            ON DELETE SET NULL,
    FOREIGN KEY(nguoi_de_xuat_id) REFERENCES NHAN_VIEN(id)
);


-- =========================================================
-- 46. BẢNG PHAN - HOI - THAY - DOI
-- =========================================================

CREATE TABLE IF NOT EXISTS PHAN_HOI_THAY_DOI (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    thay_doi_id BIGINT NOT NULL,
    booking_id BIGINT NOT NULL,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'CHO_PHAN_HOI',
    thoi_gian_phan_hoi DATETIME,
    ghi_chu TEXT,
    UNIQUE uq_phtd(thay_doi_id,booking_id),
    FOREIGN KEY(thay_doi_id) REFERENCES THAY_DOI_LICH_TRINH(id)
            ON DELETE CASCADE,
    FOREIGN KEY(booking_id) REFERENCES BOOKING(id)
);


-- =========================================================
-- 47. BẢNG HUY - DOT - KHOI - HANH
-- =========================================================

CREATE TABLE IF NOT EXISTS HUY_DOT_KHOI_HANH (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dot_khoi_hanh_id BIGINT NOT NULL,
    su_co_id BIGINT,
    nguoi_huy_id BIGINT NOT NULL,
    ly_do TEXT NOT NULL,
    thoi_gian_huy DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'DA_HUY',
    phuong_an_xu_ly VARCHAR(50) NOT NULL,
    ghi_chu TEXT,
    FOREIGN KEY(dot_khoi_hanh_id) REFERENCES DOT_KHOI_HANH(id),
    FOREIGN KEY(su_co_id) REFERENCES SU_CO_TOUR(id)
            ON DELETE SET NULL,
    FOREIGN KEY(nguoi_huy_id) REFERENCES NHAN_VIEN(id)
);


-- =========================================================
-- 48. BẢNG CHUYEN - BOOKING
-- =========================================================

CREATE TABLE IF NOT EXISTS CHUYEN_BOOKING (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    dot_khoi_hanh_cu_id BIGINT NOT NULL,
    dot_khoi_hanh_moi_id BIGINT NOT NULL,
    ly_do TEXT NOT NULL,
    nguoi_xu_ly_id BIGINT NOT NULL,
    thoi_gian_chuyen DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'CHO_XAC_NHAN',
    ghi_chu TEXT,
    FOREIGN KEY(booking_id) REFERENCES BOOKING(id),
    FOREIGN KEY(dot_khoi_hanh_cu_id) REFERENCES DOT_KHOI_HANH(id),
    FOREIGN KEY(dot_khoi_hanh_moi_id) REFERENCES DOT_KHOI_HANH(id),
    FOREIGN KEY(nguoi_xu_ly_id) REFERENCES NHAN_VIEN(id)
);


-- =========================================================
-- 49. BẢNG DANH - GIA - TOUR
-- =========================================================

CREATE TABLE IF NOT EXISTS DANH_GIA_TOUR (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT NOT NULL,
    khach_hang_id BIGINT NOT NULL,
    so_sao INT NOT NULL,
    noi_dung TEXT,
    ngay_danh_gia DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'HIEN_THI',
    UNIQUE uq_dgt(booking_id,khach_hang_id),
    CONSTRAINT chk_dgt_sao CHECK(so_sao BETWEEN 1 AND 5),
    FOREIGN KEY(booking_id) REFERENCES BOOKING(id),
    FOREIGN KEY(khach_hang_id) REFERENCES KHACH_HANG(id)
);


-- =========================================================
-- 50. BẢNG TOUR - YEU - THICH
-- =========================================================

CREATE TABLE IF NOT EXISTS TOUR_YEU_THICH (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    khach_hang_id BIGINT NOT NULL,
    tour_id BIGINT NOT NULL,
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE uq_tyt(khach_hang_id,tour_id),
    FOREIGN KEY(khach_hang_id) REFERENCES KHACH_HANG(id)
            ON DELETE CASCADE,
    FOREIGN KEY(tour_id) REFERENCES TOUR(id)
            ON DELETE CASCADE
);


-- =========================================================
-- 51. BẢNG THONG - BAO
-- =========================================================

CREATE TABLE IF NOT EXISTS THONG_BAO (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nguoi_nhan_id BIGINT NOT NULL,
    tieu_de VARCHAR(255) NOT NULL,
    noi_dung TEXT NOT NULL,
    loai_thong_bao VARCHAR(50) NOT NULL,
    da_doc BOOLEAN NOT NULL DEFAULT FALSE,
    duong_dan VARCHAR(500),
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(nguoi_nhan_id) REFERENCES TAI_KHOAN(id)
            ON DELETE CASCADE
);


-- =========================================================
-- 52. BẢNG NHAT - KY - HE - THONG
-- =========================================================

CREATE TABLE IF NOT EXISTS NHAT_KY_HE_THONG (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tai_khoan_id BIGINT,
    hanh_dong VARCHAR(255) NOT NULL,
    ten_bang VARCHAR(100),
    id_ban_ghi BIGINT,
    du_lieu_cu JSON,
    du_lieu_moi JSON,
    dia_chi_ip VARCHAR(50),
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(tai_khoan_id) REFERENCES TAI_KHOAN(id)
            ON DELETE SET NULL
);


-- =========================================================
-- 53. BẢNG LIEN - HE
-- =========================================================

CREATE TABLE IF NOT EXISTS LIEN_HE (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    khach_hang_id BIGINT,
    ho_ten VARCHAR(150) NOT NULL,
    email VARCHAR(255),
    so_dien_thoai VARCHAR(20),
    chu_de VARCHAR(255) NOT NULL,
    noi_dung TEXT NOT NULL,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'MOI',
    nguoi_xu_ly_id BIGINT,
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ngay_xu_ly DATETIME,
    FOREIGN KEY(khach_hang_id) REFERENCES KHACH_HANG(id)
            ON DELETE SET NULL,
    FOREIGN KEY(nguoi_xu_ly_id) REFERENCES NHAN_VIEN(id)
            ON DELETE SET NULL
);


-- =========================================================
-- 54. BẢNG PHIEN - DANG - NHAP
-- =========================================================

CREATE TABLE IF NOT EXISTS PHIEN_DANG_NHAP (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tai_khoan_id BIGINT NOT NULL,
    refresh_token_hash VARCHAR(255) NOT NULL,
    thoi_gian_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    thoi_gian_het_han DATETIME NOT NULL,
    thoi_gian_dang_xuat DATETIME,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'DANG_HOAT_DONG',
    dia_chi_ip VARCHAR(50),
    user_agent VARCHAR(500),
    UNIQUE uq_pdn_token(refresh_token_hash),
    FOREIGN KEY(tai_khoan_id) REFERENCES TAI_KHOAN(id) ON DELETE CASCADE
);

-- 55. BẢNG DAT - LAI - MAT - KHAU
-- =========================================================

CREATE TABLE IF NOT EXISTS DAT_LAI_MAT_KHAU (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tai_khoan_id BIGINT NOT NULL,
    token_hash VARCHAR(255) NOT NULL,
    thoi_gian_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    thoi_gian_het_han DATETIME NOT NULL,
    thoi_gian_su_dung DATETIME,
    trang_thai VARCHAR(30) NOT NULL DEFAULT 'CHUA_SU_DUNG',
    UNIQUE uq_dlm_token(token_hash),
    FOREIGN KEY(tai_khoan_id) REFERENCES TAI_KHOAN(id) ON DELETE CASCADE
);

-- 56. BẢNG LICH - SU - VAI - TRO
-- =========================================================

CREATE TABLE IF NOT EXISTS LICH_SU_VAI_TRO (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tai_khoan_id BIGINT NOT NULL,
    vai_tro_id BIGINT NOT NULL,
    hanh_dong VARCHAR(30) NOT NULL,
    thoi_gian_bat_dau DATETIME,
    thoi_gian_ket_thuc DATETIME,
    nguoi_thuc_hien_id BIGINT,
    ly_do TEXT,
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(tai_khoan_id) REFERENCES TAI_KHOAN(id),
    FOREIGN KEY(vai_tro_id) REFERENCES VAI_TRO(id),
    FOREIGN KEY(nguoi_thuc_hien_id) REFERENCES NHAN_VIEN(id) ON DELETE SET NULL
);

-- INDEX
-- =========================================================

CREATE INDEX idx_booking_khach ON BOOKING(khach_hang_id);
CREATE INDEX idx_booking_dot ON BOOKING(dot_khoi_hanh_id);
CREATE INDEX idx_chi_phi_dot ON CHI_PHI(dot_khoi_hanh_id);
CREATE INDEX idx_su_co_dot ON SU_CO_TOUR(dot_khoi_hanh_id);
CREATE INDEX idx_thong_bao ON THONG_BAO(nguoi_nhan_id,da_doc);
CREATE INDEX idx_tour_trang_thai ON TOUR(trang_thai);
CREATE INDEX idx_tour_loai_tour ON TOUR(loai_tour_id);
CREATE INDEX idx_dot_tour ON DOT_KHOI_HANH(tour_id);
CREATE INDEX idx_dot_ngay ON DOT_KHOI_HANH(ngay_khoi_hanh);
CREATE INDEX idx_nv_ban_nv ON NHAN_VIEN_BAN(nhan_vien_id);
CREATE INDEX idx_nv_ban_ban ON NHAN_VIEN_BAN(ban_id);
CREATE INDEX idx_yc_tour_khach ON YEU_CAU_TOUR_RIENG(khach_hang_id);
CREATE INDEX idx_thanh_toan_booking ON THANH_TOAN(booking_id);
CREATE INDEX idx_phien_tk ON PHIEN_DANG_NHAP(tai_khoan_id);
CREATE INDEX idx_reset_tk ON DAT_LAI_MAT_KHAU(tai_khoan_id);
CREATE INDEX idx_ls_vaitro_tk ON LICH_SU_VAI_TRO(tai_khoan_id);


-- =========================================================
-- DỮ LIỆU KHỞI TẠO
-- =========================================================

INSERT INTO LOAI_TOUR(ma_loai_tour,ten_loai_tour,mo_ta) VALUES
('THAM_QUAN','Tham quan','Tour tham quan, khám phá các điểm đến'),
('NGHI_DUONG','Nghỉ dưỡng','Tour nghỉ dưỡng'),
('KHAI_PHA','Khám phá','Tour khám phá, trải nghiệm'),
('VAN_HOA','Văn hóa','Tour trải nghiệm văn hóa, lịch sử'),
('MAO_HIEM','Mạo hiểm','Tour trải nghiệm, hoạt động mạo hiểm'),
('TOUR_RIENG','Tour riêng','Tour được thiết kế theo yêu cầu khách hàng');

INSERT INTO VAI_TRO(ma_vai_tro,ten_vai_tro,mo_ta) VALUES
('ADMIN','Quản trị viên','Quản lý toàn bộ hệ thống'),
('QUAN_LY_TONG','Quản lý tổng','Quản lý tổng thể'),
('TRUONG_BAN','Trưởng ban','Quản lý một ban'),
('HDV','Hướng dẫn viên','Thực hiện tour'),
('NHAN_VIEN','Nhân viên','Nhân viên nội bộ'),
('KHACH_HANG','Khách hàng','Người sử dụng dịch vụ');
