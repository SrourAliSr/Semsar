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
        public User? GetUser(string email)
        {
            return (from user in _context.Users  
                    where user.Email == email 
                    select new User 
                    { 
                        UserId = user.Id,
                        Email = email , 
                        UserName = user.UserName ?? "",
                        PhoneNumber = user.PhoneNumber ?? "",
                    }).FirstOrDefault();
        }
       
        public bool CreateUsernameAndPhoneNumber(string email, string username, string phoneNumber)
        {
            string? userId = GetUser(email)?.UserId;
            
            if (userId == null)
            {
                return false;
            }
            var user = _context.Users.FirstOrDefault(user => user.Id == userId);

            if (user == null)
            {
                return false;   
            }

            user.UserName = username;

            user.PhoneNumber = phoneNumber;

            _context.SaveChanges();

            return true;
        }
    }
}
