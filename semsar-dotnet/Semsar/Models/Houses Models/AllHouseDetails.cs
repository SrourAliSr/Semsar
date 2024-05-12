namespace Semsar.Models.Houses_Models
{
    public class AllHouseDetails
    {
        public required HouseDetails HouseDetails { get; set; }

        public required List<byte[]> HouseMedia { get; set; }
    }
}
