using System.ComponentModel.DataAnnotations;

namespace ErzurumAkilliSehirAPI.Models
{
    public class Announcement
    {
        public int Id { get; set; }

        [Required]
        public string? Title { get; set; }

        public string? Content { get; set; } 

        public DateTime Date { get; set; }
    }
}
