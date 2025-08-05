using System.ComponentModel.DataAnnotations;

namespace ErzurumAkilliSehirAPI.Models
{
    public class CityService
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string Title { get; set; } = string.Empty;

        public string? Description { get; set; }

        public string? IconUrl { get; set; }  // (isteğe bağlı) hizmeti temsil eden ikon linki
    }
}
