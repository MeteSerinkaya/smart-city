    using System.ComponentModel.DataAnnotations;

namespace ErzurumAkilliSehirAPI.Models.Api
{
    public class UploadImageRequest
    {
        [Required]
        public IFormFile Image { get; set; }
        public string Title { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;
    }
}