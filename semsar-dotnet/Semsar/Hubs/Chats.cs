using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Semsar.Models;
using System.Security.Claims;

namespace Semsar.Hubs
{
    public class Chats : Hub
    {
        public async Task sendMessage(string userId, string message)
        {
            await Clients.User(userId).SendAsync("ReceiveMessage", message);
        }
    }
}
