using ErzurumAkilliSehirAPI.Entity;
using ErzurumAkilliSehirAPI.Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;

namespace ErzurumAkilliSehirAPI.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Project> Projects => Set<Project>();
        public DbSet<News> News {  get; set; }
        public DbSet<Event> Events { get; set; }
        public DbSet<Announcement> Announcements { get; set; }
        public DbSet<CityService> CityServices { get; set; }
        public DbSet<UserAccount> UserAccounts { get; set; }

        public DbSet<HeroImage> HeroImages { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<UserAccount>(entity =>
            {
                entity.ToTable("useraccounts"); // tablo adı küçük harf

                // Property ile sütun ismi eşleştirmesi:
                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.UserName).HasColumnName("username");
                entity.Property(e => e.Password).HasColumnName("password");
                entity.Property(e => e.Role).HasColumnName("role");
                // diğer property'ler için de aynı şekilde...
            });

            base.OnModelCreating(modelBuilder);
        }




    }
}
