namespace Semsar.Models.chat
{
    public class ChatConnections
    {
        public required string UserId { get; set; }

        public List<string> UserChatRooms { get; set; } = [];

    }
}
