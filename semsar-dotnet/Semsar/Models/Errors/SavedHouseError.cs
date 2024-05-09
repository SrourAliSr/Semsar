namespace Semsar.Models.Errors
{
    public class SavedHouseError
    {
        public List<GetHouse> SavedHouses { get; set; } = [];

        public required bool Success { get; set; }

        public string? Error { get; set; }
    }
}
