using System;
using System.Threading.Tasks;
using DPV.BackEnd.DTOs.Requests;
using DPV.BackEnd.DTOs.Responses;
using DPV.BackEnd.Helpers;
using DPV.BackEnd.Services.Interfaces;
using DPV.BackEnd.Data;
using DPV.BackEnd.Models.Entities;
using Microsoft.EntityFrameworkCore;


namespace DPV.BackEnd.Services.Implementations
{
    public class AuthService : IAuthService
    {

        private readonly AppDbContext _dbContext;

        public AuthService(AppDbContext dbContext)
        {
            _dbContext = dbContext;
        }
        public Task<BaseResponse<string>> LoginAsync(LoginRequest request)
        {
            // TODO: Query from Database to get User by Email
            // var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Email == request.Email);
            
            // Mock Data
            var mockDbPasswordHash = SecurityHelper.HashPassword("password123");

            if (request.Email != "admin@test.com")
            {
                return Task.FromResult(BaseResponse<string>.Error("Invalid email or password"));
            }

            var isPasswordValid = SecurityHelper.VerifyPassword(request.Password, mockDbPasswordHash);

            if (!isPasswordValid)
            {
                return Task.FromResult(BaseResponse<string>.Error("Invalid email or password"));
            }

            // TODO: Generate JWT Token
            var mockToken = "mock_jwt_token_for_" + request.Email;

            return Task.FromResult(BaseResponse<string>.Ok(mockToken, "Login successful"));
        }

        public async Task<BaseResponse<string>> RegisterAsync(RegisterRequest request)
        {
            var email = request.Email.Trim().ToLowerInvariant();
            var useraname = request.Username.Trim();
            var accountExists = await _dbContext.TaiKhoans.AnyAsync(x=> x.Email == email ||
                x.TenDangNhap == useraname);
            if (accountExists)
            {
                return BaseResponse<string>.Error("Email hoặc tên đăng nhập đã tồn tại");

            }
            var now = DateTime.UtcNow;
            var taiKhoan = new TaiKhoan
            {
                TenDangNhap = useraname,
                Email = email,
                Passwordhash = SecurityHelper.HashPassword(request.Password),
                TrangThai = "HOAT_DONG",
                NgayCapNhat= now,
                NgayTao = now

            };

            _dbContext.TaiKhoans.Add(taiKhoan);
            await _dbContext.SaveChangesAsync();

            return BaseResponse<string>.Ok(taiKhoan.Id.ToString(), "Đăng ký thành công");


        }

        public Task<BaseResponse<string>> ForgotPasswordAsync(ForgotPasswordRequest request)
        {
            // TODO: Check if user exists
            
            // Generate OTP
            var otp = SecurityHelper.GenerateOTP(6);
            
            // Generate Reset Token
            var token = SecurityHelper.GenerateRandomToken();

            Console.WriteLine($"[AuthService] Reset password requested for {request.Email}. OTP: {otp}, Token: {token}");

            // TODO: Send OTP via Email

            return Task.FromResult(BaseResponse<string>.Ok(token, "OTP sent to your email"));
        }
    }
}
