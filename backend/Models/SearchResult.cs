using System.ComponentModel.DataAnnotations;

namespace ErzurumAkilliSehirAPI.Models
{
    public class SearchResult
    {
        public int Id { get; set; }
        
        [Required]
        public string Title { get; set; }
        
        public string? Content { get; set; }
        
        public string? Description { get; set; }
        
        public string? ImageUrl { get; set; }
        
        public string? IconUrl { get; set; }
        
        [Required]
        public string Type { get; set; } // "news", "announcement", "project", "city_service"
        
        public DateTime? PublishedAt { get; set; }
        
        public DateTime? Date { get; set; }
        
        public double? RelevanceScore { get; set; }
    }

    public class SearchRequest
    {
        [Required]
        public string Query { get; set; }
        
        public string? Type { get; set; } // Filter by specific type
        
        public int? Limit { get; set; } // Limit number of results
        
        public int? Offset { get; set; } // For pagination
        
        public bool IncludeNews { get; set; } = true;
        
        public bool IncludeAnnouncements { get; set; } = true;
        
        public bool IncludeProjects { get; set; } = true;
        
        public bool IncludeCityServices { get; set; } = true;
    }

    public class SearchResponse
    {
        public List<SearchResult> Results { get; set; } = new List<SearchResult>();
        
        public int TotalCount { get; set; }
        
        public int NewsCount { get; set; }
        
        public int AnnouncementCount { get; set; }
        
        public int ProjectCount { get; set; }
        
        public int CityServiceCount { get; set; }
        
        public string Query { get; set; }
        
        public DateTime SearchTime { get; set; } = DateTime.UtcNow;
    }
} 