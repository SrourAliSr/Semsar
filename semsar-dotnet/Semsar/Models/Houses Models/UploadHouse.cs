using System.ComponentModel.DataAnnotations;

namespace Semsar.Models
{
    public class UploadHouse
    {
        [EmailAddress]
        public required string email {  get; set; }

        [Required]
        public required double price { get; set; }
        
        public string? details { get; set; }
        
        public int? phoneNumber { get; set; }
        
        public string? houseName { get; set; }

        public required string Category { get; set; } = "Casual";

        public required string City { get; set; }

        public List<byte[]> Media { get; set; } = [];
    }
}
