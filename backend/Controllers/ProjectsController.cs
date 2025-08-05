using ErzurumAkilliSehirAPI.Data;
using ErzurumAkilliSehirAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;

namespace ErzurumAkilliSehirAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProjectsController : ControllerBase
    {
        private readonly AppDbContext _appDbContext;
        private readonly ILogger<ProjectsController> _logger;

        public ProjectsController(AppDbContext appDbContext, ILogger<ProjectsController> logger)
        {
            _appDbContext = appDbContext;
            _logger = logger;
        }

        // GET: api/projects
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Project>>> GetProjects(
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 10)
        {
            try
            {
                _logger.LogInformation("Getting projects - Page {Page} with size {PageSize}", page, pageSize);

                var projects = await _appDbContext.Projects
                    .OrderBy(p => p.Id)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .Select(p => new Project
                    {
                        Id = p.Id,
                        Title = p.Title,
                        Description = p.Description,
                        ImageUrl = p.ImageUrl
                    })
                    .ToListAsync();

                return Ok(projects);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting projects");
                return StatusCode(500, "An error occurred while processing your request");
            }
        }

        // GET: api/projects/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Project>> GetProject(int id)
        {
            try
            {
                var project = await _appDbContext.Projects.FindAsync(id);

                if (project == null)
                {
                    _logger.LogWarning("Project with ID {Id} not found", id);
                    return NotFound();
                }

                return Ok(new Project
                {
                    Id = project.Id,
                    Title = project.Title,
                    Description = project.Description,
                    ImageUrl = project.ImageUrl
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting project with ID {Id}", id);
                return StatusCode(500, "An error occurred while processing your request");
            }
        }

        // PUT: api/projects/5
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateProject(int id, UpdateProject updateProjectDto)
        {
            try
            {
                if (id != updateProjectDto.Id)
                {
                    _logger.LogWarning("ID mismatch in update request. Path ID: {PathId}, DTO ID: {DtoId}", id, updateProjectDto.Id);
                    return BadRequest("ID mismatch");
                }

                var existingProject = await _appDbContext.Projects.FindAsync(id);
                if (existingProject == null)
                {
                    _logger.LogWarning("Project with ID {Id} not found for update", id);
                    return NotFound();
                }

                existingProject.Title = updateProjectDto.Title;
                existingProject.Description = updateProjectDto.Description;
                existingProject.ImageUrl = updateProjectDto.ImageUrl;

                await _appDbContext.SaveChangesAsync();

                _logger.LogInformation("Project with ID {Id} updated successfully", id);
                return NoContent();
            }
            catch (DbUpdateConcurrencyException ex)
            {
                if (!_appDbContext.Projects.Any(p => p.Id == id))
                {
                    _logger.LogWarning("Project with ID {Id} not found during concurrency check", id);
                    return NotFound();
                }
                _logger.LogError(ex, "Concurrency error updating project with ID {Id}", id);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating project with ID {Id}", id);
                return StatusCode(500, "An error occurred while processing your request");
            }
        }

        // DELETE: api/projects/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProject(int id)
        {
            try
            {
                var project = await _appDbContext.Projects.FindAsync(id);
                if (project == null)
                {
                    _logger.LogWarning("Project with ID {Id} not found for deletion", id);
                    return NotFound();
                }

                _appDbContext.Projects.Remove(project);
                await _appDbContext.SaveChangesAsync();

                _logger.LogInformation("Project with ID {Id} deleted successfully", id);
                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting project with ID {Id}", id);
                return StatusCode(500, "An error occurred while processing your request");
            }
        }

        // POST: api/projects
        [HttpPost]
        public async Task<ActionResult<Project>> CreateProject(CreateProject createProjectDto)
        {
            try
            {
                _logger.LogInformation("Creating new project with title: {Title}", createProjectDto.Title);

                var project = new Project
                {
                    Title = createProjectDto.Title,
                    Description = createProjectDto.Description,
                    ImageUrl = createProjectDto.ImageUrl
                };

                _appDbContext.Projects.Add(project);
                await _appDbContext.SaveChangesAsync();

                var projectDto = new Project
                {
                    Id = project.Id,
                    Title = project.Title,
                    Description = project.Description,
                    ImageUrl = project.ImageUrl
                };

                _logger.LogInformation("Project created successfully with ID {Id}", project.Id);
                return CreatedAtAction(nameof(GetProject), new { id = project.Id }, projectDto);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating new project");
                return StatusCode(500, "An error occurred while processing your request");
            }
        }
    }
}