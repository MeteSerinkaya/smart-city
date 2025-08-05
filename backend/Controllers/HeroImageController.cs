using ErzurumAkilliSehirAPI.Data;
using ErzurumAkilliSehirAPI.Models;
using ErzurumAkilliSehirAPI.Models.Api;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ErzurumAkilliSehirAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [AllowAnonymous]
    public class HeroImageController : ControllerBase
    {
        private readonly IWebHostEnvironment _env;
        private readonly AppDbContext _db;

        public HeroImageController(IWebHostEnvironment env, AppDbContext db)
        {
            _env = env;
            _db = db;
        }

        [HttpGet]
        public async Task<IActionResult> GetAllImages()
        {
            var images = await _db.HeroImages.OrderByDescending(h => h.CreatedAt).ToListAsync();
            return Ok(images);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetImageById(int id)
        {
            var image = await _db.HeroImages.FindAsync(id);
            if (image == null) return NotFound();
            return Ok(image);
        }

        [HttpPost]
        public async Task<IActionResult> AddHeroImage([FromBody] HeroImage heroImage)
        {
            if (heroImage == null) return BadRequest();

            heroImage.CreatedAt = DateTime.UtcNow;
            _db.HeroImages.Add(heroImage);
            await _db.SaveChangesAsync();

            return CreatedAtAction(nameof(GetImageById), new { id = heroImage.Id }, heroImage);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateHeroImage(int id, [FromBody] HeroImage heroImage)
        {
            if (id != heroImage.Id) return BadRequest();

            var existingImage = await _db.HeroImages.FindAsync(id);
            if (existingImage == null) return NotFound();

            existingImage.ImageUrl = heroImage.ImageUrl;
            existingImage.Title = heroImage.Title;
            existingImage.Description = heroImage.Description;
            existingImage.CreatedAt = heroImage.CreatedAt;

            await _db.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteHeroImage(int id)
        {
            var image = await _db.HeroImages.FindAsync(id);
            if (image == null) return NotFound();

            _db.HeroImages.Remove(image);
            await _db.SaveChangesAsync();

            return NoContent();
        }

        [HttpPost("upload")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadImage([FromForm] UploadImageRequest request)
        {
            if (request.Image == null || request.Image.Length == 0)
                return BadRequest("Resim yüklenmedi.");

            var uploadsFolder = Path.Combine(_env.ContentRootPath, "wwwroot", "uploads");
            if (!Directory.Exists(uploadsFolder))
                Directory.CreateDirectory(uploadsFolder);

            var fileName = Guid.NewGuid() + Path.GetExtension(request.Image.FileName);
            var filePath = Path.Combine(uploadsFolder, fileName);

            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await request.Image.CopyToAsync(stream);
            }

            var heroImage = new HeroImage
            {

                ImageUrl = $"/uploads/{fileName}",
                Title = request.Title ?? "",
                Description = request.Description ?? "",
                CreatedAt = DateTime.UtcNow
            };

            _db.HeroImages.Add(heroImage);
            await _db.SaveChangesAsync();

            return Ok(new { fileName = fileName, url = $"/uploads/{fileName}" });
        }

        [HttpGet("latest")]
        public IActionResult GetLatestImage()
        {
            var latest = _db.HeroImages.OrderByDescending(h => h.CreatedAt).FirstOrDefault();
            if (latest == null) return NotFound();
            return Ok(latest);
        }
    }
}
