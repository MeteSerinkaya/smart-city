using System.ComponentModel.DataAnnotations;

namespace ErzurumAkilliSehirAPI.Models
{
    public class UpdateEvent
    {
        [Required]
        public int Id { get; set; }

        [Required]
        [MaxLength(100)]
        public string Title { get; set; } = string.Empty;

        [Required]
        [MaxLength(500)]
        public string Description { get; set; } = string.Empty;

        [Required]
        public DateTime Date { get; set; }

        public string? Location { get; set; }

        public string? ImageUrl { get; set; }
    }
}
