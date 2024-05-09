
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Semsar.Models
{
    public class HouseDetails{
        
        [Key]
        public int HousesId { get; set; }

        [ForeignKey("ApplicationUser")]
        public required string UserId { get; set; }

        [ForeignKey("ApplicationUser")]
        public required string Username { get; set; }
       
        public string HousesName { get; set; } = "House";

        public required string Category { get; set; } = "Casual";

        public required string City { get; set; }
        
        public double Rating { get; set; } = 0;

        [Phone]
        public int? PhoneNumber { get; set; }
       
        public required double Price { get; set; }

        public string Detials { get; set; } = string.Empty;
        
    }
}
