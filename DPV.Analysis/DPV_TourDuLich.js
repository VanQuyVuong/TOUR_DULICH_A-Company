/*
 * DPV_TourDuLich - MYSQL TO MONGODB
 * Nguon chuan: DPV_TourDuLich_FINAL.sql
 * Tong so bang/collection: 56
 *
 * Script tao collection va cac index tuong ung.
 * MongoDB khong tu dong thuc thi foreign key nhu MySQL.
 */

const DATABASE_NAME = "DPV_TourDuLich";
const targetDb = db.getSiblingDB(DATABASE_NAME);


const collectionDefinitions = [
  {
    name: "TAI_KHOAN",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_tai_khoan" } },
      { key: { ten_dang_nhap: 1 }, options: { unique: true, name: "uq_tk_ten_dang_nhap" } },
      { key: { email: 1 }, options: { unique: true, name: "uq_tk_email" } }
    ]
  },
  {
    name: "VAI_TRO",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_vai_tro" } },
      { key: { ma_vai_tro: 1 }, options: { unique: true, name: "uq_vt_ma" } }
    ]
  },
  {
    name: "QUYEN",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_quyen" } },
      { key: { ma_quyen: 1 }, options: { unique: true, name: "uq_q_ma" } }
    ]
  },
  {
    name: "TAI_KHOAN_VAI_TRO",
    indexes: [
      {
        key: { tai_khoan_id: 1, vai_tro_id: 1 },
        options: { unique: true, name: "pk_tai_khoan_vai_tro" }
      }
    ]
  },
  {
    name: "VAI_TRO_QUYEN",
    indexes: [
      {
        key: { vai_tro_id: 1, quyen_id: 1 },
        options: { unique: true, name: "pk_vai_tro_quyen" }
      }
    ]
  },
  {
    name: "NHAN_VIEN",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_nhan_vien" } },
      { key: { tai_khoan_id: 1 }, options: { unique: true, name: "uq_nv_tk" } },
      { key: { ma_nhan_vien: 1 }, options: { unique: true, name: "uq_nv_ma" } }
    ]
  },
  {
    name: "BAN",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_ban" } },
      { key: { ma_ban: 1 }, options: { unique: true, name: "uq_ban_ma" } }
    ]
  },
  {
    name: "NHAN_VIEN_BAN",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_nhan_vien_ban" } }
    ]
  },
  {
    name: "CHUYEN_MON_HDV",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_chuyen_mon_hdv" } }
    ]
  },
  {
    name: "NGON_NGU",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_ngon_ngu" } },
      { key: { ma_ngon_ngu: 1 }, options: { unique: true, name: "uq_nn_ma" } }
    ]
  },
  {
    name: "NHAN_VIEN_NGON_NGU",
    indexes: [
      {
        key: { nhan_vien_id: 1, ngon_ngu_id: 1 },
        options: { unique: true, name: "pk_nhan_vien_ngon_ngu" }
      }
    ]
  },
  {
    name: "KHACH_HANG",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_khach_hang" } },
      { key: { tai_khoan_id: 1 }, options: { unique: true, name: "uq_kh_tk" } },
      { key: { ma_khach_hang: 1 }, options: { unique: true, name: "uq_kh_ma" } }
    ]
  },
  {
    name: "QUOC_GIA",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_quoc_gia" } },
      { key: { ma_quoc_gia: 1 }, options: { unique: true, name: "uq_qg_ma" } },
      { key: { ten_quoc_gia: 1 }, options: { unique: true, name: "uq_qg_ten" } }
    ]
  },
  {
    name: "TINH_THANH",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_tinh_thanh" } },
      {
        key: { quoc_gia_id: 1, ten_tinh_thanh: 1 },
        options: { unique: true, name: "uq_tt_qg_ten" }
      }
    ]
  },

  // PHAN 2 SE NOI TIEP TAI DAY
];


 
  {
    name: "DIA_DIEM",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_dia_diem" } },
      { key: { tinh_thanh_id: 1, ten_dia_diem: 1 }, options: { unique: true, name: "uq_dd_tt_ten" } }
    ]
  },
  {
    name: "LOAI_TOUR",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_loai_tour" } },
      { key: { ma_loai_tour: 1 }, options: { unique: true, name: "uq_ltt_ma" } },
      { key: { ten_loai_tour: 1 }, options: { unique: true, name: "uq_ltt_ten" } }
    ]
  },
  {
    name: "TOUR",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_tour" } },
      { key: { ma_tour: 1 }, options: { unique: true, name: "uq_tour_ma" } },
      { key: { trang_thai: 1 }, options: { name: "idx_tour_trang_thai" } },
      { key: { loai_tour_id: 1 }, options: { name: "idx_tour_loai_tour" } }
    ]
  },
  {
    name: "TOUR_DIA_DIEM",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_tour_dia_diem" } },
      { key: { tour_id: 1, thu_tu: 1 }, options: { unique: true, name: "uq_tdd" } }
    ]
  },
  {
    name: "DOT_KHOI_HANH",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_dot_khoi_hanh" } },
      { key: { ma_dot: 1 }, options: { unique: true, name: "uq_dot_ma" } },
      { key: { tour_id: 1 }, options: { name: "idx_dot_tour" } },
      { key: { ngay_khoi_hanh: 1 }, options: { name: "idx_dot_ngay" } }
    ]
  },
  {
    name: "LICH_TRINH",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_lich_trinh" } },
      { key: { dot_khoi_hanh_id: 1, ngay_thu: 1, thu_tu: 1 }, options: { unique: true, name: "uq_lt" } }
    ]
  },
  {
    name: "PHAN_CONG_HDV",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_phan_cong_hdv" } }
    ]
  },
  {
    name: "TIEN_TRINH_TOUR",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_tien_trinh_tour" } }
    ]
  },
  {
    name: "HINH_ANH_TIEN_TRINH",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_hinh_anh_tien_trinh" } }
    ]
  },
  {
    name: "CHINH_SACH_HUY",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_chinh_sach_huy" } }
    ]
  },
  {
    name: "QUY_TAC_HUY",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_quy_tac_huy" } }
    ]
  },
  {
    name: "BOOKING",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_booking" } },
      { key: { ma_booking: 1 }, options: { unique: true, name: "uq_booking_ma" } },
      { key: { khach_hang_id: 1 }, options: { name: "idx_booking_khach" } },
      { key: { dot_khoi_hanh_id: 1 }, options: { name: "idx_booking_dot" } }
    ]
  },
  {
    name: "HANH_KHACH",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_hanh_khach" } }
    ]
  },

  // PHAN 3 SE NOI TIEP TAI DAY

  {
    name: "THANH_TOAN",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_thanh_toan" } },
      { key: { ma_giao_dich: 1 }, options: { unique: true, name: "uq_tt_ma" } },
      { key: { booking_id: 1 }, options: { name: "idx_thanh_toan_booking" } },
    ],
  },
  {
    name: "DOI_SOAT_GIAO_DICH",
    indexes: [
      {
        key: { id: 1 },
        options: { unique: true, name: "pk_doi_soat_giao_dich" },
      },
      { key: { thanh_toan_id: 1 }, options: { name: "fk_dsgd_thanh_toan" } },
      { key: { nguoi_doi_soat_id: 1 }, options: { name: "fk_dsgd_nhan_vien" } },
    ],
  },
  {
    name: "HUY_BOOKING",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_huy_booking" } },
      { key: { booking_id: 1 }, options: { name: "fk_huy_booking_booking" } },
      {
        key: { nguoi_huy_id: 1 },
        options: { name: "fk_huy_booking_nhan_vien" },
      },
    ],
  },
  {
    name: "HOAN_TIEN",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_hoan_tien" } },
      { key: { booking_id: 1 }, options: { name: "fk_hoan_tien_booking" } },
      {
        key: { huy_booking_id: 1 },
        options: { name: "fk_hoan_tien_huy_booking" },
      },
      {
        key: { nguoi_xu_ly_id: 1 },
        options: { name: "fk_hoan_tien_nhan_vien" },
      },
    ],
  },
  {
    name: "YEU_CAU_TOUR_RIENG",
    indexes: [
      {
        key: { id: 1 },
        options: { unique: true, name: "pk_yeu_cau_tour_rieng" },
      },
      { key: { ma_yeu_cau: 1 }, options: { unique: true, name: "uq_yc_ma" } },
      { key: { khach_hang_id: 1 }, options: { name: "idx_yc_tour_khach" } },
    ],
  },
  {
    name: "YEU_CAU_TOUR_DIA_DIEM",
    indexes: [
      {
        key: { id: 1 },
        options: { unique: true, name: "pk_yeu_cau_tour_dia_diem" },
      },
      {
        key: { yeu_cau_tour_id: 1, thu_tu: 1 },
        options: { unique: true, name: "uq_yctdd" },
      },
      { key: { dia_diem_id: 1 }, options: { name: "fk_yctdd_dia_diem" } },
    ],
  },
  {
    name: "PHAN_CONG_YEU_CAU_TOUR",
    indexes: [
      {
        key: { id: 1 },
        options: { unique: true, name: "pk_phan_cong_yeu_cau_tour" },
      },
      { key: { yeu_cau_tour_id: 1 }, options: { name: "fk_pc_yct_yeu_cau" } },
      { key: { ban_id: 1 }, options: { name: "fk_pc_yct_ban" } },
      {
        key: { nguoi_phan_cong_id: 1 },
        options: { name: "fk_pc_yct_nguoi_phan_cong" },
      },
      {
        key: { nguoi_tiep_nhan_id: 1 },
        options: { name: "fk_pc_yct_nguoi_tiep_nhan" },
      },
    ],
  },
  {
    name: "BAO_GIA_TOUR_RIENG",
    indexes: [
      {
        key: { id: 1 },
        options: { unique: true, name: "pk_bao_gia_tour_rieng" },
      },
      { key: { ma_bao_gia: 1 }, options: { unique: true, name: "uq_bg_ma" } },
      {
        key: { yeu_cau_tour_id: 1, phien_ban: 1 },
        options: { unique: true, name: "uq_bg_phien" },
      },
      { key: { nguoi_lap_id: 1 }, options: { name: "fk_bg_nguoi_lap" } },
    ],
  },
  {
    name: "CHI_TIET_BAO_GIA",
    indexes: [
      {
        key: { id: 1 },
        options: { unique: true, name: "pk_chi_tiet_bao_gia" },
      },
      { key: { bao_gia_id: 1 }, options: { name: "fk_ctbg_bao_gia" } },
    ],
  },
  {
    name: "TOUR_TU_YEU_CAU",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_tour_tu_yeu_cau" } },
      { key: { yeu_cau_tour_id: 1 }, options: { name: "fk_ttyc_yeu_cau" } },
      { key: { bao_gia_id: 1 }, options: { name: "fk_ttyc_bao_gia" } },
      { key: { tour_id: 1 }, options: { name: "fk_ttyc_tour" } },
      { key: { nguoi_tao_id: 1 }, options: { name: "fk_ttyc_nguoi_tao" } },
    ],
  },
  {
    name: "THANH_TOAN",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_thanh_toan" } },
      { key: { ma_giao_dich: 1 }, options: { unique: true, name: "uq_tt_ma" } },
      { key: { booking_id: 1 }, options: { name: "idx_thanh_toan_booking" } }
    ]
  },
  {
    name: "DOI_SOAT_GIAO_DICH",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_doi_soat_giao_dich" } }
    ]
  },
  {
    name: "HUY_BOOKING",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_huy_booking" } }
    ]
  },
  {
    name: "HOAN_TIEN",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_hoan_tien" } }
    ]
  },
  {
    name: "YEU_CAU_TOUR_RIENG",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_yeu_cau_tour_rieng" } },
      { key: { ma_yeu_cau: 1 }, options: { unique: true, name: "uq_yc_ma" } },
      { key: { khach_hang_id: 1 }, options: { name: "idx_yc_tour_khach" } }
    ]
  },
  {
    name: "YEU_CAU_TOUR_DIA_DIEM",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_yeu_cau_tour_dia_diem" } },
      { key: { yeu_cau_tour_id: 1, thu_tu: 1 }, options: { unique: true, name: "uq_yctdd" } }
    ]
  },
  {
    name: "PHAN_CONG_YEU_CAU_TOUR",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_phan_cong_yeu_cau_tour" } }
    ]
  },
  {
    name: "BAO_GIA_TOUR_RIENG",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_bao_gia_tour_rieng" } },
      { key: { ma_bao_gia: 1 }, options: { unique: true, name: "uq_bg_ma" } },
      { key: { yeu_cau_tour_id: 1, phien_ban: 1 }, options: { unique: true, name: "uq_bg_phien" } }
    ]
  },
  {
    name: "CHI_TIET_BAO_GIA",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_chi_tiet_bao_gia" } }
    ]
  },


  // PHAN 4 SE NOI TIEP TAI DAY

  {
    name: "TOUR_TU_YEU_CAU",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_tour_tu_yeu_cau" } }
    ]
  },
  {
    name: "NGAN_SACH_DOT",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_ngan_sach_dot" } }
    ]
  },
  {
    name: "CHI_TIET_NGAN_SACH",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_chi_tiet_ngan_sach" } }
    ]
  },
  {
    name: "CHI_PHI",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_chi_phi" } },
      { key: { dot_khoi_hanh_id: 1 }, options: { name: "idx_chi_phi_dot" } }
    ]
  },
  {
    name: "CHUNG_TU_CHI_PHI",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_chung_tu_chi_phi" } }
    ]
  },
  {
    name: "DUYET_CHI_PHI",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_duyet_chi_phi" } }
    ]
  },
  {
    name: "SU_CO_TOUR",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_su_co_tour" } },
      { key: { dot_khoi_hanh_id: 1 }, options: { name: "idx_su_co_dot" } }
    ]
  },
  {
    name: "CHUNG_TU_SU_CO",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_chung_tu_su_co" } }
    ]
  },
  {
    name: "THAY_DOI_LICH_TRINH",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_thay_doi_lich_trinh" } }
    ]
  },
  {
    name: "PHAN_HOI_THAY_DOI",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_phan_hoi_thay_doi" } },
      { key: { thay_doi_id: 1, booking_id: 1 }, options: { unique: true, name: "uq_phtd" } }
    ]
  },
  {
    name: "HUY_DOT_KHOI_HANH",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_huy_dot_khoi_hanh" } }
    ]
  },
  {
    name: "CHUYEN_BOOKING",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_chuyen_booking" } }
    ]
  },
  {
    name: "DANH_GIA_TOUR",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_danh_gia_tour" } },
      { key: { booking_id: 1, khach_hang_id: 1 }, options: { unique: true, name: "uq_dgt" } }
    ]
  },

  // PHAN 5 SE NOI TIEP TAI DAY

  {
    name: "TOUR_YEU_THICH",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_tour_yeu_thich" } },
      { key: { khach_hang_id: 1, tour_id: 1 }, options: { unique: true, name: "uq_tyt" } }
    ]
  },
  {
    name: "THONG_BAO",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_thong_bao" } },
      { key: { nguoi_nhan_id: 1, da_doc: 1 }, options: { name: "idx_thong_bao" } }
    ]
  },
  {
    name: "NHAT_KY_HE_THONG",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_nhat_ky_he_thong" } }
    ]
  },
  {
    name: "LIEN_HE",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_lien_he" } }
    ]
  },
  {
    name: "PHIEN_DANG_NHAP",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_phien_dang_nhap" } },
      { key: { refresh_token_hash: 1 }, options: { unique: true, name: "uq_pdn_token" } },
      { key: { tai_khoan_id: 1 }, options: { name: "idx_phien_tk" } }
    ]
  },
  {
    name: "DAT_LAI_MAT_KHAU",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_dat_lai_mat_khau" } },
      { key: { token_hash: 1 }, options: { unique: true, name: "uq_dlm_token" } },
      { key: { tai_khoan_id: 1 }, options: { name: "idx_reset_tk" } }
    ]
  },
  {
    name: "LICH_SU_VAI_TRO",
    indexes: [
      { key: { id: 1 }, options: { unique: true, name: "pk_lich_su_vai_tro" } },
      { key: { tai_khoan_id: 1 }, options: { name: "idx_ls_vaitro_tk" } }
    ]
  }
];
