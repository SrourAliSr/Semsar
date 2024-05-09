using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Semsar.Models
{
    public class HouseMedia
    {
        [Key]
        public int Id {  get; set; }

        [ForeignKey("HouseDetails")]
        public int HouseId { get; set; }

        [Required]
        public required byte[] Media { get; set; }
    }
}
