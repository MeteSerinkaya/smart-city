using ErzurumAkilliSehirAPI.Data;
using ErzurumAkilliSehirAPI.Models;
using ErzurumAkilliSehirAPI.Models.DTOs;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ErzurumAkilliSehirAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class NewsController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly ILogger<NewsController> _logger;

        public NewsController(AppDbContext context, ILogger<NewsController> logger)
        {
            _context = context;
            _logger = logger;
        }

        // GET: api/news
        [HttpGet]
        public async Task<ActionResult<IEnumerable<News>>> GetNews(
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 10)
        {
            var newsList = await _context.News
                .OrderByDescending(n => n.PublishedAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return Ok(newsList);
        }

        // GET: api/news/5
        [HttpGet("{id}")]
        public async Task<ActionResult<News>> GetNewsItem(int id)
        {
            var news = await _context.News.FindAsync(id);

            if (news == null)
            {
                return NotFound();
            }

            return Ok(news);
        }

        // POST: api/news
        [HttpPost]
        public async Task<ActionResult<News>> CreateNews(CreateNews dto)
        {
            var news = new News
            {
                title = dto.Title,
                content = dto.Content,
                imageUrl = dto.ImageUrl,
                PublishedAt = dto.PublishedAt ?? DateTime.UtcNow
            };

            _context.News.Add(news);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetNewsItem), new { id = news.id }, news);
        }

        // PUT: api/news/5
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateNews(int id, UpdateNews dto)
        {
            if (id != dto.Id)
            {
                return BadRequest("ID uyuşmazlığı.");
            }

            var existingNews = await _context.News.FindAsync(id);
            if (existingNews == null)
            {
                return NotFound();
            }

            existingNews.title = dto.Title;
            existingNews.content = dto.Content;
            existingNews.imageUrl = dto.ImageUrl;
            existingNews.PublishedAt = dto.PublishedAt ?? existingNews.PublishedAt;

            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/news/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteNews(int id)
        {
            var news = await _context.News.FindAsync(id);
            if (news == null)
            {
                return NotFound();
            }

            _context.News.Remove(news);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
