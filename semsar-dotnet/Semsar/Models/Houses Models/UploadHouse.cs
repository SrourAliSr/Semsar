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
        
        public required string houseName { get; set; }

        public required string Category { get; set; } = "Casual";

        public required string City { get; set; }

        public required bool IsForSale { get; set; }

        public required bool IsForRent { get; set; }

        public double Rent { get; set; }

        public required int Rooms { get; set; }

        public required int Lavatory { get; set; }

        public required int Area { get; set; }

        public required int DiningRooms { get; set; }

        public required int SleepingRooms { get; set; }

        public List<byte[]> Media { get; set; } = [];
    }
}
