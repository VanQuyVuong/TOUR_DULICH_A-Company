using DPV.BackEnd.Models.Entities;
using Microsoft.EntityFrameworkCore;


namespace DPV.BackEnd.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }
        public DbSet<TaiKhoan> TaiKhoans =>Set<TaiKhoan>();
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<TaiKhoan>(entity =>
            {
                entity.ToTable("TAI_KHOAN");

                entity.HasKey(x => x.Id);
                entity.Property(x => x.Id).HasColumnName("id");
                entity.Property(x => x.TenDangNhap).HasColumnName("ten_dang_nhap");
                entity.Property(x => x.Email).HasColumnName("email");
                entity.Property(x => x.Passwordhash).HasColumnName("password_hash");
                entity.Property(x => x.TrangThai).HasColumnName("trang_thai");
                entity.Property(x => x.LanDangNhapCuoi).HasColumnName("lan_dang_nhap_cuoi");
                entity.Property(x => x.NgayTao).HasColumnName("ngay_tao");
                entity.Property(x => x.NgayCapNhat).HasColumnName("ngay_cap_nhat");
            });
        }
            
    }
}
