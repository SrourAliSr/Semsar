using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Semsar.Models;

namespace Semsar.Data
{
    public class DataContext : IdentityDbContext
    {
        public DataContext(DbContextOptions<DataContext> options) : base(options)
        {
            
        } 

        public DbSet<HouseDetails> HouseDetails { get; set; }

        public DbSet<HouseMedia> HouseMedia { get; set; }

        public DbSet<SavedHouses> SavedHouses{ get; set; }
    }
    
}

