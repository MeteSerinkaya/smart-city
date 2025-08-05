using System.ComponentModel.DataAnnotations;

namespace ErzurumAkilliSehirAPI.Models
{
    public class News
    {
        public int id {  get; set; }

        [Required]
        [MaxLength(255)]
        public string title { get; set; } = string.Empty;

        [Required]
        public string content { get; set; }= string.Empty;
        
        public string? imageUrl { get; set; }

        public DateTime PublishedAt { get; set; } = DateTime.UtcNow;

    }
}
