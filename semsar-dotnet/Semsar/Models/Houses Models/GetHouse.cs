using System.ComponentModel.DataAnnotations;

namespace Semsar.Models
{
    public class GetHouse
    {
        public required HouseDetails HouseDetails { get; set; }
        
        public required HouseMedia HouseMedia { get; set; }  
    }
}
