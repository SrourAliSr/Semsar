using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
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
        public ActionResult<string> GetUserIdByEmail(string email)
        {
            string? userId =  _services.GetCurrentUserByEmail(email);

            if (userId == null)
            {
                return NotFound("User not founded");
            }

            return Ok(userId);
        }
    }
}
