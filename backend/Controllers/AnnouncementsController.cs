using ErzurumAkilliSehirAPI.Data;
using ErzurumAkilliSehirAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ErzurumAkilliSehirAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AnnouncementsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AnnouncementsController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var announcements = await _context.Announcements.OrderByDescending(a => a.Date).ToListAsync();
            return Ok(announcements);
        }

        [HttpPost]
        public async Task<IActionResult> Create(Announcement announcement)
        {
            announcement.Date = DateTime.UtcNow;
            _context.Announcements.Add(announcement);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetAll), new { id = announcement.Id }, announcement);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, Announcement updated)
        {
            if (id != updated.Id)
                return BadRequest("ID uyuşmazlığı.");

            var existing = await _context.Announcements.FindAsync(id);
            if (existing == null) return NotFound();

            existing.Title = updated.Title;
            existing.Content = updated.Content;
            existing.Date = DateTime.UtcNow;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var announcement = await _context.Announcements.FindAsync(id);
            if (announcement == null) return NotFound();

            _context.Announcements.Remove(announcement);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
    