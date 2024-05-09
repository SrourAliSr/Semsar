using System.ComponentModel.DataAnnotations.Schema;

namespace Semsar.Models
{
    public class SavedHouses
    {
        public int Id { get; set; }

        [ForeignKey("ApplicationUser")]
        public required string UserId { get; set; }

        public required int HouseId { get; set; }
    }
}
