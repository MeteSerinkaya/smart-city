using ErzurumAkilliSehirAPI.Data;
using ErzurumAkilliSehirAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ErzurumAkilliSehirAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EventsController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly ILogger<EventsController> _logger;

        public EventsController(AppDbContext context, ILogger<EventsController> logger)
        {
            _context = context;
            _logger = logger;
        }

        // GET: api/events
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Event>>> GetEvents()
        {
            return await _context.Events
                .OrderByDescending(e => e.Date)
                .ToListAsync();
        }

        // GET: api/events/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Event>> GetEvent(int id)
        {
            var evt = await _context.Events.FindAsync(id);

            if (evt == null)
            {
                return NotFound();
            }

            return evt;
        }

        // POST: api/events
        [HttpPost]
        public async Task<ActionResult<Event>> CreateEvent(CreateEvent dto)
        {
            var evt = new Event
            {
                Title = dto.Title,
                Description = dto.Description,
                Date = dto.Date.ToUniversalTime(),
                Location = dto.Location,
                ImageUrl = dto.ImageUrl
            };

            _context.Events.Add(evt);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetEvent), new { id = evt.Id }, evt);
        }

        // PUT: api/events/5
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateEvent(int id, UpdateEvent dto)
        {
            if (id != dto.Id)
            {
                return BadRequest("ID uyuşmazlığı.");
            }

            var existing = await _context.Events.FindAsync(id);
            if (existing == null)
            {
                return NotFound();
            }

            existing.Title = dto.Title;
            existing.Description = dto.Description;
            existing.Date = dto.Date;
            existing.Location = dto.Location;
            existing.ImageUrl = dto.ImageUrl;

            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/events/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEvent(int id)
        {
            var evt = await _context.Events.FindAsync(id);
            if (evt == null)
            {
                return NotFound();
            }

            _context.Events.Remove(evt);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
