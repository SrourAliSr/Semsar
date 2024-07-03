using Azure.Core;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Semsar.Models.chat;
using System;
using System.Collections.Concurrent;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;


namespace Semsar.Hubs
{
    [Authorize]
    public class Chats(SharedDb sharedDb) : Hub
    {
        public readonly SharedDb _sharedDb = sharedDb;

        private static List<Message> tempMessage = [];

        public override async Task OnConnectedAsync()
        {
  
            var userId = Context.UserIdentifier;
          
            var results = _sharedDb.Connections!.Where(i => i.Value.UserId == userId).FirstOrDefault();

            if (results.Key == null)
            {
                _sharedDb.Connections[Context.ConnectionId] = new ChatConnections{ UserId = userId!, UserChatRooms= []};

                return;
            }
            var oldConnectionId = results.Key;

            for (var i = 0; i< results.Value.UserChatRooms.Count; i++)
            {
                await Groups.RemoveFromGroupAsync(oldConnectionId, results.Value.UserChatRooms[i]);
            }

            for (var i = 0; i < results.Value.UserChatRooms.Count; i++)
            {
                await Groups.AddToGroupAsync(Context.ConnectionId, results.Value.UserChatRooms[i]);
            }

            _sharedDb.Connections.Remove(oldConnectionId);

            _sharedDb.Connections.Add(Context.ConnectionId, results.Value);

           
            await base.OnConnectedAsync();


        }

        public Task CreateNewChat()
        {

            return Task.CompletedTask; 
        }

        public override Task OnDisconnectedAsync(Exception? exception)
        {
            return base.OnDisconnectedAsync(exception);
        }

        public async Task AddGroup(ChatGroupElements chat)
        {
            try
            {
                var results = _sharedDb.Connections.Where(i => i.Value.UserId == Context.UserIdentifier && i.Value.UserChatRooms.Contains(chat.ChatRoom)).FirstOrDefault();

                if(results.Key == null)
                {
                    await Groups.AddToGroupAsync(Context.ConnectionId, chat.ChatRoom);

                    _sharedDb.Connections[Context.ConnectionId].UserChatRooms.Add(chat.ChatRoom);

                    await Clients.Group(chat.ChatRoom).SendAsync("ReceiveMessage",chat.ChatRoom ,$"{chat.Username} joined the chat");
                }
                return;

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }

        }

        public async Task SendMessage(Message message)
        {
            tempMessage.Add(message);    

            await Clients.Group(message.ChatRoom).SendAsync("ReceiveMessage", message);
        }

        public List<Message> GetTempMessages(string userId)
        {
            List<Message> messages = tempMessage.Where(i => i.ReciverId == userId).ToList();

            tempMessage = tempMessage.Except(messages).ToList();

            return messages;
        }
        
       
    }
     
}
