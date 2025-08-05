using Microsoft.AspNetCore.Mvc;
using ErzurumAkilliSehirAPI.Data;
using ErzurumAkilliSehirAPI.Models;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using Microsoft.Extensions.Logging;

namespace ErzurumAkilliSehirAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SearchController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly ILogger<SearchController> _logger;

        public SearchController(AppDbContext context, ILogger<SearchController> logger)
        {
            _context = context;
            _logger = logger;
        }

        [HttpGet]
        public async Task<IActionResult> Search([FromQuery] string query)
        {
            if (string.IsNullOrWhiteSpace(query))
            {
                return BadRequest("Search query is required");
            }

            var searchQuery = query.ToLower();

            try
            {
                // Search in News
                var newsResults = await _context.News
                    .Where(n => n.title.ToLower().Contains(searchQuery) || 
                               n.content.ToLower().Contains(searchQuery))
                    .Select(n => new
                    {
                        id = n.id,
                        title = n.title,
                        content = n.content,
                        imageUrl = n.imageUrl,
                        type = "news",
                        publishedAt = n.PublishedAt
                    })
                    .ToListAsync();

                // Search in Announcements
                var announcementResults = await _context.Announcements
                    .Where(a => a.Title.ToLower().Contains(searchQuery) || 
                               a.Content.ToLower().Contains(searchQuery))
                    .Select(a => new
                    {
                        id = a.Id,
                        title = a.Title,
                        content = a.Content,
                        type = "announcement",
                        date = a.Date
                    })
                    .ToListAsync();

                // Search in Projects
                var projectResults = await _context.Projects
                    .Where(p => p.Title.ToLower().Contains(searchQuery) || 
                               p.Description.ToLower().Contains(searchQuery))
                    .Select(p => new
                    {
                        id = p.Id,
                        title = p.Title,
                        description = p.Description,
                        imageUrl = p.ImageUrl,
                        type = "project"
                    })
                    .ToListAsync();

                // Search in City Services
                var cityServiceResults = await _context.CityServices
                    .Where(cs => cs.Title.ToLower().Contains(searchQuery) || 
                                cs.Description.ToLower().Contains(searchQuery))
                    .Select(cs => new
                    {
                        id = cs.Id,
                        title = cs.Title,
                        description = cs.Description,
                        iconUrl = cs.IconUrl,
                        type = "city_service"
                    })
                    .ToListAsync();

                // Search in Events
                var eventResults = await _context.Events
                    .Where(e => e.Title.ToLower().Contains(searchQuery) || 
                               e.Description.ToLower().Contains(searchQuery))
                    .Select(e => new
                    {
                        id = e.Id,
                        title = e.Title,
                        description = e.Description,
                        imageUrl = e.ImageUrl,
                        type = "event",
                        date = e.Date
                    })
                    .ToListAsync();

                // Combine all results
                var allResults = new
                {
                    news = newsResults,
                    announcements = announcementResults,
                    projects = projectResults,
                    cityServices = cityServiceResults,
                    events = eventResults,
                    totalCount = newsResults.Count + announcementResults.Count + 
                                projectResults.Count + cityServiceResults.Count + eventResults.Count
                };

                return Ok(allResults);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Search failed for query: {Query}", query);
                return StatusCode(500, new { error = "Search failed", message = ex.Message });
            }
        }

        [HttpGet("news")]
        public async Task<IActionResult> SearchNews([FromQuery] string query)
        {
            if (string.IsNullOrWhiteSpace(query))
            {
                return BadRequest("Search query is required");
            }

            var searchQuery = query.ToLower();

            try
            {
                var results = await _context.News
                    .Where(n => n.title.ToLower().Contains(searchQuery) || 
                               n.content.ToLower().Contains(searchQuery))
                    .ToListAsync();

                return Ok(results);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "News search failed for query: {Query}", query);
                return StatusCode(500, new { error = "News search failed", message = ex.Message });
            }
        }

        [HttpGet("announcements")]
        public async Task<IActionResult> SearchAnnouncements([FromQuery] string query)
        {
            if (string.IsNullOrWhiteSpace(query))
            {
                return BadRequest("Search query is required");
            }

            var searchQuery = query.ToLower();

            try
            {
                var results = await _context.Announcements
                    .Where(a => a.Title.ToLower().Contains(searchQuery) || 
                               a.Content.ToLower().Contains(searchQuery))
                    .ToListAsync();

                return Ok(results);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Announcement search failed for query: {Query}", query);
                return StatusCode(500, new { error = "Announcement search failed", message = ex.Message });
            }
        }

        [HttpGet("projects")]
        public async Task<IActionResult> SearchProjects([FromQuery] string query)
        {
            if (string.IsNullOrWhiteSpace(query))
            {
                return BadRequest("Search query is required");
            }

            var searchQuery = query.ToLower();

            try
            {
                var results = await _context.Projects
                    .Where(p => p.Title.ToLower().Contains(searchQuery) || 
                               p.Description.ToLower().Contains(searchQuery))
                    .ToListAsync();

                return Ok(results);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Project search failed for query: {Query}", query);
                return StatusCode(500, new { error = "Project search failed", message = ex.Message });
            }
        }

        [HttpGet("city-services")]
        public async Task<IActionResult> SearchCityServices([FromQuery] string query)
        {
            if (string.IsNullOrWhiteSpace(query))
            {
                return BadRequest("Search query is required");
            }

            var searchQuery = query.ToLower();

            try
            {
                var results = await _context.CityServices
                    .Where(cs => cs.Title.ToLower().Contains(searchQuery) || 
                                cs.Description.ToLower().Contains(searchQuery))
                    .ToListAsync();

                return Ok(results);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "City service search failed for query: {Query}", query);
                return StatusCode(500, new { error = "City service search failed", message = ex.Message });
            }
        }

        [HttpGet("events")]
        public async Task<IActionResult> SearchEvents([FromQuery] string query)
        {
            if (string.IsNullOrWhiteSpace(query))
            {
                return BadRequest("Search query is required");
            }

            var searchQuery = query.ToLower();

            try
            {
                var results = await _context.Events
                    .Where(e => e.Title.ToLower().Contains(searchQuery) || 
                               e.Description.ToLower().Contains(searchQuery))
                    .ToListAsync();

                return Ok(results);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Event search failed for query: {Query}", query);
                return StatusCode(500, new { error = "Event search failed", message = ex.Message });
            }
        }
    }
} 