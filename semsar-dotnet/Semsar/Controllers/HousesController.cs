using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Semsar.Models;
using Semsar.Models.Errors;
using Semsar.Models.Houses_Models;
using Semsar.Models.Services;

namespace Semsar.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class HousesController : ControllerBase
    {
        private readonly HousesServices _services;

        public HousesController(HousesServices servcies)
        {
            _services = servcies;
        }

        //Get requests
        [HttpGet]
        public ActionResult<List<GetHouse>>GetAllHouses([FromQuery] string category, [FromQuery] int? stars , [FromQuery] double? min, [FromQuery] double? max, [FromQuery] string userId, [FromQuery]  string? city)
        {
            SearchFilter filter = new SearchFilter {category =category,stars = stars,min = min ,max = max};


            if (filter.category == "All")
            {
                filter.category = null;
            }
            return _services.GetAllHouses(userId, city,filter);
        }

        [HttpGet("{id}")]
        public ActionResult<HouseDetails> GetHouseDetails(int id)
        {
            var house = _services.GetSpecificHouse(id);

            if (house == null)
            {
                return NotFound("House Not Founded");
            }

            return Ok(house);
        }

        [HttpGet]
        [Route("GetSavedHouses")]
        public ActionResult<List<GetHouse>> GetSavedHouses(string userId)
        {
            return Ok(_services.GetSavedHouses(userId));
        }
        [HttpGet]
        [Route("GetMyPosts")]
        public ActionResult<List<GetHouse>> GetMyPosts(string userId)
        {
            return Ok(_services.GetMyPosts(userId));
        }

        [HttpGet]
        [Route("GetMedia")]
        public ActionResult<List<HouseMedia>> GetMedia(int HouseId, int excludedMediaId) 
        { 
            return Ok(_services.GetHouseMedia(HouseId, excludedMediaId));
        }
       
        //Post requests
        [HttpPost]
        [Route("AddHouse")]
        public ActionResult UploadHouse(UploadHouse uploadHouse)
        {
            HousesErrors isUploaded = _services.UploadNewHouse(uploadHouse);

            if (!isUploaded.Success)
            {
                return BadRequest(isUploaded.Error ??"Something went wrong");
            }

            return Ok("Successfully uploaded");
        }

        [HttpPost]
        [Route("AddHouseMedia")]
        public ActionResult AddHouseMedia(HouseMedia houseMedia)
        {
            HousesErrors isAdded = _services.AddHouseMedia(houseMedia);

            if (!isAdded.Success)
            {
                return BadRequest(isAdded.Error ?? "Something went wrong");
            }
            
            return Ok("Succesfully added");
        }

        [HttpPost]
        [Route("SaveHouse")]
        public ActionResult SaveHouse([FromBody] SavedHouses house)
        {
            HousesErrors isSaved = _services.SaveHouse(house);

            if (!isSaved.Success)
            {
                return BadRequest(isSaved.Error ?? "Something went wrong");
            }

            return Ok(isSaved.Error);
        }

        [HttpPost]
        [Route("CheckIfSaved")]
        public ActionResult CheckIfSaved([FromBody] SavedHouses house)
        {
            HousesErrors isSaved = _services.CheckIfSaved(house);

            if (!isSaved.Success)
            {
                return BadRequest(isSaved.Error ?? "Something went wrong");
            }

            return Ok();
        }

        //Delete requests
        [HttpDelete]
        public ActionResult DeleteHouse(int houseId)
        {
            HousesErrors isDelted = _services.DeleteHouse(houseId);

            if(!isDelted.Success)
            {
                return BadRequest(isDelted.Error ?? "Something went wrong");
            }
            
            return Ok("Succesfully deleted the house");
        }
        
        [HttpDelete]
        [Route("SpecificMedia")]
        public ActionResult DeleteSpecificHouseMedia(HouseMedia media)
        {
            HousesErrors isDelted = _services.DeleteSpecificHouseMedia(media);

            if(!isDelted.Success)
            {
                return BadRequest(isDelted.Error ?? "Something went wrong");
            }

            return Ok("Succesfully deleted");
        }

        [HttpDelete]
        [Route("DeleteSavedHouse")]
        public ActionResult DeleteSavedHouse(string userId, int houseId)
        {
            HousesErrors isDelted = _services.DeleteSavedHouse(userId, houseId);

            if(!isDelted.Success)
            {
                return BadRequest(isDelted.Error ?? "Something went wrong");
            }
            return Ok("Successfully deleted saved house");
        }

        ////Put requests
        [HttpPut]
        public ActionResult UpdateHouseDetails(UpdateDetails houseDetails)
        {
           HousesErrors isUpdated = _services.UpdateHouseDetails(houseDetails);

            if (!isUpdated.Success)
            {
                return BadRequest(isUpdated.Error ?? "Something went wrong");
            }
            return Ok("Successfully updated");
        }

    }
}
