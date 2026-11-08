namespace DPV.BackEnd.Models.Entities
{
    public class TaiKhoan
    {
        public long Id { get; set; }
        public string TenDangNhap { get; set; } = string.Empty;
        public string Email { get; set; }= string.Empty;
        public string Passwordhash { get; set; }= string.Empty;

        public string TrangThai { get; set; }= "HOAT_DONG"; 
        public DateTime? LanDangNhapCuoi { get; set; }
        public DateTime NgayTao { get; set; } 
        public DateTime NgayCapNhat { get; set; }

    }
}
