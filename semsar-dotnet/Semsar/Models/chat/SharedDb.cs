namespace Semsar.Models.chat
{
    public class SharedDb
    {
        private readonly Dictionary<string, ChatConnections> _connections = new Dictionary<string, ChatConnections>();

        public Dictionary<string, ChatConnections> Connections => _connections;

    }
}
