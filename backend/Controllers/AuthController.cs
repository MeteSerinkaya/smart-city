using ErzurumAkilliSehirAPI.Data;
using ErzurumAkilliSehirAPI.Entity;
using ErzurumAkilliSehirAPI.Models.Api;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;


[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly JwtService _jwtService;

    public AuthController(AppDbContext context, JwtService jwtService)
    {
        _context = context;
        _jwtService = jwtService;
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginRequestModel model)
    {
        Console.WriteLine($"Login denemesi: {model.Username}");

        var user = await _context.UserAccounts
            .FirstOrDefaultAsync(u => u.UserName.ToLower() == model.Username.ToLower());

        if (user == null)
        {
            Console.WriteLine("Kullanıcı bulunamadı!");
            return Unauthorized("Invalid username or password");
        }

        Console.WriteLine($"Kullanıcı bulundu: {user.UserName}, Rol: {user.Role}");

        var isPasswordValid = PasswordHasher.VerifyPassword(model.Password, user.Password);
        Console.WriteLine($"Şifre doğrulama sonucu: {isPasswordValid}");

        if (!isPasswordValid)
            return Unauthorized("Invalid username or password");

        var token = _jwtService.GenerateToken(user.UserName, user.Role);

        return Ok(new LoginResponseModel
        {
            UserName = user.UserName,
            AccessToken = token,
            ExpiresIn = 3600,
        });
    }
    [HttpPost("seed-admin")]
    public IActionResult SeedAdmin()
    {
        var username = "admin";
        var rawPassword = "Admin123!";
        var role = "Admin";

        // Aynı kullanıcı varsa tekrar ekleme
        if (_context.UserAccounts.Any(u => u.UserName == username))
        {
            return BadRequest("Admin already exists.");
        }

        var hashedPassword = PasswordHasher.HashPassword(rawPassword);

        var user = new UserAccount
        {
            UserName = username,
            Password = hashedPassword,
            Role = role
        };

        _context.UserAccounts.Add(user);
        _context.SaveChanges();

        return Ok("Admin user created successfully.");
    }


    [Authorize(Roles = "admin")]
    [HttpGet("admin-only")]
    public IActionResult AdminOnly()
    {
        return Ok("You are admin!");
    }
}
