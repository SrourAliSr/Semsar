using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace Semsar.Models
{
    public class UpdateDetails
    {
        public required int houseId { get; set; }

        public required string userEmail { get; set; }

        public string HousesName { get; set; } = "House";

        public int? PhoneNumber { get; set; }

        public required double Price { get; set; }

        public string Detials { get; set; } = string.Empty;
    }
}
