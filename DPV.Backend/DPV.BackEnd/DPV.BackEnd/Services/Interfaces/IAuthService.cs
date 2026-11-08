using System.Threading.Tasks;
using DPV.BackEnd.DTOs.Requests;
using DPV.BackEnd.DTOs.Responses;

namespace DPV.BackEnd.Services.Interfaces
{
    public interface IAuthService
    {
        Task<BaseResponse<string>> LoginAsync(LoginRequest request);
        Task<BaseResponse<string>> RegisterAsync(RegisterRequest request);
        Task<BaseResponse<string>> ForgotPasswordAsync(ForgotPasswordRequest request);
    }
}
