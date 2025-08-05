using System.ComponentModel.DataAnnotations.Schema;

namespace ErzurumAkilliSehirAPI.Entity
{
    [Table("useraccounts")]
    public class UserAccount
    {
        public int Id { get; set; }
        public string UserName { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;// Hashlenmiş şifre
        public string Role { get; set; } = "user";   // "admin", "user" gibi roller
    }

}
