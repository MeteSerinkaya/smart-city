using System.ComponentModel.DataAnnotations;

namespace ErzurumAkilliSehirAPI.Models.DTOs
{
    public class UpdateNews
    {
        [Required]
        public int Id { get; set; }

        [Required]
        [MaxLength(200)]
        public string Title { get; set; } = string.Empty;

        [Required]
        public string Content { get; set; } = string.Empty;

        public string? ImageUrl { get; set; }

        public DateTime? PublishedAt { get; set; }
    }
}
