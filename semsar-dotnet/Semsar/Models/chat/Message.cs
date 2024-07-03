namespace Semsar.Models.chat
{
    public class Message
    {
        public required string ChatRoom { get; set; }

        public required string SenderId { get; set; }

        public required string SenderName { get; set; }

        public required string SentMessage { get; set; }

        public required string ReciverId { get; set; }

        public required DateTime SentTime { get; set; }

    }
}
