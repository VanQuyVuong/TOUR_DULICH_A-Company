using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using DPV.BackEnd.DTOs.Requests;
using DPV.BackEnd.DTOs.Responses;
using DPV.BackEnd.Services.Interfaces;

namespace DPV.BackEnd.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IAuthService _authService;

        public AuthController(IAuthService authService)
        {
            _authService = authService;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(BaseResponse<object>.Error("Invalid request data"));
            }

            var response = await _authService.LoginAsync(request);
            if (!response.Success)
            {
                return Unauthorized(response);
            }

            return Ok(response);
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequest request)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(BaseResponse<object>.Error("Invalid request data"));
            }

            var response = await _authService.RegisterAsync(request);
            if (!response.Success)
            {
                return BadRequest(response);
            }

            return Ok(response);
        }

        [HttpPost("forgot-password")]
        public async Task<IActionResult> ForgotPassword([FromBody] ForgotPasswordRequest request)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(BaseResponse<object>.Error("Invalid request data"));
            }

            var response = await _authService.ForgotPasswordAsync(request);
            if (!response.Success)
            {
                return BadRequest(response);
            }

            return Ok(response);
        }
    }
}
