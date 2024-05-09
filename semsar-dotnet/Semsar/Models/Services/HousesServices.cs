using Semsar.Data;
using Semsar.Models.Errors;
using Semsar.Models.Houses_Models;
using System.Linq;

namespace Semsar.Models.Services
{
    public class HousesServices
    {
        private readonly DataContext _context;
       
        public HousesServices(DataContext context)
        {
            _context = context;
        }
        
        //get request logic
        public List<GetHouse> GetAllHouses(string userId,string? city,SearchFilter filter)
        {

            IQueryable<GetHouse?> JoinedTable = from d in _context.HouseDetails
                          join m in _context.HouseMedia
                          on d.HousesId equals m.HouseId into mediaGroup
                          from media in mediaGroup.Take(1).DefaultIfEmpty()
                          where userId != d.UserId && 
                          (city == null || d.City.Contains(city)) 
                          && (filter.category == null || filter.category == d.Category) 
                          && (filter.stars == null || filter.stars == d.Rating)
                          && (filter.min == null || filter.min < d.Price)
                          && (filter.max == null || filter.max > d.Price)
                          select new GetHouse
                          {
                              HouseDetails = d,
                              HouseMedia = media
                          };


            List<GetHouse> allHouses = [.. JoinedTable];

            return allHouses;
            
        }
        
        public GetHouse? GetSpecificHouse(int id)
        {
            var JoinedTable = from d in _context.HouseDetails
                              join m in _context.HouseMedia
                              on d.HousesId equals m.HouseId into mediaGroup
                              from media in mediaGroup.Take(1).DefaultIfEmpty()
                              where d.HousesId == id
                              select new GetHouse
                              {
                                  HouseDetails = d,
                                  HouseMedia = media
                              };
            return JoinedTable.ToList()[0];
        }

        public List<HouseMedia> GetHouseMedia(int houseId,int excludedImageId)
        {
            return [.. from m in _context.HouseMedia
                                          where m.HouseId == houseId && m.Id != excludedImageId
                                          select new HouseMedia
                                          {
                                              Id = m.Id,
                                              HouseId = m.HouseId,
                                              Media = m.Media,
                                          }];

        }

        public List<GetHouse> GetSavedHouses(string userId)
        {
            var joinedTable = from d in _context.HouseDetails
                              join m in _context.HouseMedia
                              on d.HousesId equals m.HouseId
                              into mediaGroup
                              from media in mediaGroup.Take(1).DefaultIfEmpty()
                              join s in _context.SavedHouses
                              on d.HousesId equals s.HouseId
                              where s.UserId == userId
                              select new GetHouse { HouseDetails = d, HouseMedia = media };

            return [..joinedTable];
                            
        }

        //post request logic
        public HousesErrors UploadNewHouse(UploadHouse uploadHouse)
        {
            HousesErrors errors = new() { Success = false, Error = null };

            try
            {
               var user = _context.Users.FirstOrDefault(i => i.Email == uploadHouse.email);
                
                if(user != null) 
                {

                    HouseDetails newHouse = new HouseDetails { 
                        UserId = user.Id,
                        Username = user.UserName!,
                        Price= uploadHouse.price, 
                        Detials = uploadHouse.details ?? "" , 
                        PhoneNumber = uploadHouse.phoneNumber,
                        HousesName = uploadHouse.houseName ?? "",
                        City = uploadHouse.City,
                        Category = uploadHouse.Category
                    };

                    _context.HouseDetails.Add(newHouse);

                    _context.SaveChanges();


                    for (int i = 0; i < uploadHouse.Media.Count; i++)
                    {

                        HouseMedia newMedia = new() { HouseId = newHouse.HousesId, Media = uploadHouse.Media[i] };
                        
                        _context.HouseMedia.Add(newMedia);
                    }

                    _context.SaveChanges();

                    errors.Success = true;

                    errors.Error = null;

                    return errors;
                }

                errors.Success = false;
                    
                errors.Error = "User is null";
                    
                return errors;

            }catch (Exception ex)
            {
                errors.Success = false;

                errors.Error= ex.Message;

                return errors;
            }
        }

        public HousesErrors AddHouseMedia(HouseMedia newMedia)
        {
            HousesErrors errors = new HousesErrors { Success = false, Error = null };

            try
            {
                _context.HouseMedia.Add(newMedia);

                _context.SaveChanges();

                errors.Success= true;

                errors.Error = null;

                return errors;
            }catch (Exception ex)
            {
                errors.Success = false;

                errors.Error= ex.Message;

                return errors;
            }
        }

        public HousesErrors SaveHouse(SavedHouses house)
        {
            HousesErrors errors = new HousesErrors { Success = false, Error = null };

            int houseId = house.HouseId;

            string userId = house.UserId;

            try
            {
                var checkIfHouseAvailable = GetSpecificHouse(houseId);

                if (checkIfHouseAvailable != null)
                {
                    var isHouseAlreadySaved = (from s in _context.SavedHouses
                        where s.HouseId == houseId && s.UserId == userId
                        select s).FirstOrDefault();
                    
                    if (isHouseAlreadySaved != null)
                    {
                       
                        
                        _context.SavedHouses.Remove(isHouseAlreadySaved);
                        
                        _context.SaveChanges();

                        errors.Success = true;

                        errors.Error = "Removed";

                        return errors;
                    }
                    else
                    {
                        SavedHouses savedHouses = new SavedHouses { UserId = userId, HouseId = houseId };

                        _context.SavedHouses.Add(savedHouses);

                        _context.SaveChanges();

                        errors.Success = true;

                        errors.Error = "Saved";

                        return errors;
                    }
                    

                }

                throw new Exception("House is no available");

            }catch(Exception ex)
            {
                errors.Success = false;
                
                errors.Error= ex.Message;
                
                return errors;
            }
        }
        
        public HousesErrors CheckIfSaved(SavedHouses house)
        {
            HousesErrors errors = new HousesErrors { Success = false, Error = null };
            
            int houseId = house.HouseId;
            
            string userId = house.UserId;

            try
            {
                var checkIfHouseAvailable = GetSpecificHouse(houseId);

                if (checkIfHouseAvailable != null)
                {
                    var isHouseAlreadySaved = from s in _context.SavedHouses
                                              where s.HouseId == houseId && s.UserId == userId
                                              select new SavedHouses
                                              {
                                                  HouseId = s.HouseId,
                                                  Id = s.Id,
                                                  UserId = s.UserId
                                              };
                    if (isHouseAlreadySaved.Any())
                    {

                        errors.Success = true;

                        errors.Error = null;

                        return errors;
                    }
                    else
                    {
                        
                        errors.Success = false;

                        errors.Error = "house Not Saved";

                        return errors;
                    }


                }

                throw new Exception("House is no available");

            }
            catch (Exception ex)
            {
                errors.Success = false;

                errors.Error = ex.Message;

                return errors;
            }
        }



        //Delete requests logic
        public HousesErrors DeleteHouse(int houseId)
        {
            HousesErrors errors = new() { Success = false, Error = null };
            try
            {

                var deletedHouseDetails = from h in _context.HouseDetails
                                          where h.HousesId == houseId
                                          select h;


                if (deletedHouseDetails.Any())
                {
                    _context.HouseDetails.Remove(deletedHouseDetails.ToList()[0]);
                }

                var deletedHouseMedia = from m in _context.HouseMedia
                                        where m.HouseId == houseId
                                        select m;

                if (deletedHouseMedia.Any())
                {
                    foreach (var media in deletedHouseMedia)
                    {
                        _context.HouseMedia.Remove(media);
                    }
                }

                _context.SaveChanges();

                errors.Success = true;

                errors.Error = null;

                return errors;

            }catch(Exception ex)
            {
                errors.Success = false;

                errors.Error = ex.Message;

                return errors;
            }
        }

        public HousesErrors DeleteSpecificHouseMedia(HouseMedia media)
        {
            HousesErrors errors = new HousesErrors { Success = false, Error = null};
            try
            {

                _context.HouseMedia.Remove(media);

                _context.SaveChanges();

                errors.Success = true;

                errors.Error = null;

                return errors;
            }catch (Exception ex)
            {
                errors.Success = false;

                errors.Error = ex.Message;

                return errors;
            }
        }

        public HousesErrors DeleteSavedHouse(string userId,int houseId)
        {
            HousesErrors errors = new HousesErrors { Success = false, Error = null };

            try
            {
                var checkIfHouseAvailable = GetSpecificHouse(houseId);

                if (checkIfHouseAvailable != null)
                {
                    var savedHouse = ( from s in _context.SavedHouses
                                       where s.HouseId == houseId
                                       select s).FirstOrDefault();
                    if (savedHouse != null)
                    {

                        _context.SavedHouses.Remove(savedHouse);

                        _context.SaveChanges();

                        errors.Success = true;

                        errors.Error = null;

                        return errors;
                    }
                    throw new Exception("House is not saved");

                }

                throw new Exception("House is no available");

            }
            catch (Exception ex)
            {
                errors.Success = false;

                errors.Error = ex.Message;

                return errors;
            }
        }

        //put requests logic
        public HousesErrors UpdateHouseDetails(UpdateDetails houseDetails)
        {
            HousesErrors errors = new() { Success = false, Error = null };
            
            try
            {
                var user = _context.Users.Where(i => i.UserName == houseDetails.userEmail).FirstOrDefault();

                if (user != null)
                {
                    var isUserTheOwner = _context.HouseDetails.Where(i => i.UserId == user.Id).FirstOrDefault();

                    if (isUserTheOwner != null)
                    {
                        HouseDetails? oldDetails =  _context.HouseDetails.FirstOrDefault(i => i.HousesId == houseDetails.houseId);

                        if (oldDetails != null)
                        {
                            oldDetails.PhoneNumber = houseDetails.PhoneNumber;

                            oldDetails.HousesName = houseDetails.HousesName;

                            oldDetails.Detials = houseDetails.Detials;

                            oldDetails.Price = houseDetails.Price;

                            _context.SaveChanges();

                            errors.Success = true;

                            errors.Error = null;

                            return errors;
                        }
                        errors.Success = false;

                        errors.Error = "There are no Details To be Edited";
                        
                        return errors;
                    }
                    errors.Success = false;

                    errors.Error = "You dont own this house";

                    return errors;
                }
                errors.Success = false;

                errors.Error = "The user is null";

                return errors;
            }catch(Exception ex)
            {
                errors.Success = false;

                errors.Error = ex.Message;

                return errors;
            }
        }

       
        
    }
}
