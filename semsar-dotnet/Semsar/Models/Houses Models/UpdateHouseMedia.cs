using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace Semsar.Models
{
    public class UpdateHouseMedia
    {
        public int HouseId { get; set; }

        public required List<byte[]> Media { get; set; }
    }
}
