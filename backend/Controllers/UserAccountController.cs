using ErzurumAkilliSehirAPI.Data;
using ErzurumAkilliSehirAPI.Models.Api;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

[Route("api/[controller]")]
[ApiController]
public class UserAccountController : ControllerBase
{
    private readonly JwtService _jwtService;
    private readonly AppDbContext _context;

    public UserAccountController(JwtService jwtService)
    {
        _jwtService = jwtService;
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginRequestModel model)
    {
        var user = await _context.UserAccounts.FirstOrDefaultAsync(u => u.UserName == model.Username);
        if (user == null || !PasswordHasher.VerifyPassword(model.Password, user.Password))
            return Unauthorized("Invalid username or password");

        var token = _jwtService.GenerateToken(user.UserName, user.Role);

        return Ok(new LoginResponseModel
        {
            UserName = user.UserName,
            AccessToken = token,
            ExpiresIn = 3600
        });
    }

}
