using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Semsar.Models;
using Semsar.Models.Services;

namespace Semsar.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly UserServices _services;

        public UserController(UserServices services)
        {
            _services = services;
        }
        [HttpGet]
        public ActionResult<User> GetUser(string email)
        {
            var user = _services.GetUser(email);

            if (user == null)
            {
                return NotFound("User is not available");
            }
            return Ok(user);
        }

        [HttpPost]
        public ActionResult CreateUsernameAndPhoneNumber(string email, string phoneNumber, string username) 
        { 
            var success = _services.CreateUsernameAndPhoneNumber(email,  username, phoneNumber);

            if(!success)
            {
                return BadRequest("Somethin went wrong");
            }
            else
            {
                return Ok(success);
            }
        }
    }
}
