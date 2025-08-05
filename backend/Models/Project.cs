using System.ComponentModel.DataAnnotations;

namespace ErzurumAkilliSehirAPI.Models
{
    public class Project
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string ImageUrl { get; set; } = string.Empty;
    }

    public class CreateProject
    {
        [Required]
        [StringLength(100, MinimumLength = 3)]
        public string Title { get; set; } = string.Empty;

        [Required]
        [StringLength(500)]
        public string Description { get; set; } = string.Empty;

        [Url]
        [StringLength(255)]
        public string ImageUrl { get; set; } = string.Empty;
    }

    public class UpdateProject
    {
        public int Id { get; set; }

        [Required]
        [StringLength(100, MinimumLength = 3)]
        public string Title { get; set; } = string.Empty;

        [Required]
        [StringLength(500)]
        public string Description { get; set; } = string.Empty;

        [Url]
        [StringLength(255)]
        public string ImageUrl { get; set; } = string.Empty;
    }
}

