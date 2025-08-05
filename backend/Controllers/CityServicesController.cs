using ErzurumAkilliSehirAPI.Data;
using ErzurumAkilliSehirAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ErzurumAkilliSehirAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CityServicesController : ControllerBase
    {
        private readonly AppDbContext _context;

        public CityServicesController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<CityService>>> GetCityServices()
        {
            return await _context.CityServices.ToListAsync();
        }

        [HttpPost]
        public async Task<ActionResult<CityService>> PostCityService(CityService cityService)
        {
            _context.CityServices.Add(cityService);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetCityServices), new { id = cityService.Id }, cityService);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutCityService(int id, CityService updated)
        {
            var existing = await _context.CityServices.FindAsync(id);
            if (existing == null) return NotFound();

            existing.Title = updated.Title;
            existing.Description = updated.Description;
            existing.IconUrl = updated.IconUrl;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCityService(int id)
        {
            var item = await _context.CityServices.FindAsync(id);
            if (item == null) return NotFound();

            _context.CityServices.Remove(item);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
