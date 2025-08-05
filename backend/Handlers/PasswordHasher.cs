using System;
using System.Security.Cryptography;
using System.Text;

public class PasswordHasher
{
    // Hash ve salt uzunlukları
    private const int SaltSize = 16; // 128 bit
    private const int KeySize = 32;  // 256 bit
    private const int Iterations = 10000; // Önerilen tekrar sayısı

    // Şifreyi hash'le ve sonucu Base64 formatında dön
    public static string HashPassword(string password)
    {
        using var rng = RandomNumberGenerator.Create();
        byte[] salt = new byte[SaltSize];
        rng.GetBytes(salt);

        using var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations, HashAlgorithmName.SHA256);
        byte[] key = pbkdf2.GetBytes(KeySize);

        // salt ve key'i tek string olarak birleştir (salt:key)
        var hashParts = new
        {
            Iterations,
            Salt = Convert.ToBase64String(salt),
            Key = Convert.ToBase64String(key)
        };

        // Örneğin: iterations.salt.key formatı ile sakla
        return $"{hashParts.Iterations}.{hashParts.Salt}.{hashParts.Key}";
    }

    // Şifreyi doğrula
    public static bool VerifyPassword(string password, string hashedPassword)
    {
        var parts = hashedPassword.Split('.', 3);
        if (parts.Length != 3)
            return false;

        int iterations = int.Parse(parts[0]);
        byte[] salt = Convert.FromBase64String(parts[1]);
        byte[] key = Convert.FromBase64String(parts[2]);

        using var pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations, HashAlgorithmName.SHA256);
        byte[] keyToCheck = pbkdf2.GetBytes(KeySize);

        // Sabit zamanlı karşılaştırma (timing attack'a karşı)
        return CryptographicOperations.FixedTimeEquals(key, keyToCheck);
    }
}


