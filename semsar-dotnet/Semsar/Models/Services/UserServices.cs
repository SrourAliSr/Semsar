using Semsar.Data;

namespace Semsar.Models.Services
{
    public class UserServices
    {
        private readonly DataContext _context;

        public UserServices(DataContext context) 
        { 
            _context = context;
        }

        public string? GetCurrentUserByEmail(string email)
        {
            return (from user in _context.Users
                    where user.Email == email
                    select user.Id).FirstOrDefault();
        }
    }
}
