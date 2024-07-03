const dbName = "semsar.db";

const userTable = "users";

const chatRoomsTable = "chatRooms";

const messagesTable = "messages";

const createUsersTable = '''
CREATE TABLE IF NOT EXISTS users (
    userId TEXT PRIMARY KEY,
    email TEXT NOT NULL,
    username TEXT NOT NULL,
    phone_number TEXT NOT NULL
);
''';
const createChatRoomsTable = '''
CREATE TABLE IF NOT EXISTS chatRooms (
    chatRoomId TEXT PRIMARY KEY,
    userId TEXT NOT NULL,
    receiverId TEXT NOT NULL,
    receiverName TEXT NOT NULL,
    FOREIGN KEY (userId) REFERENCES users (userId)
);
''';
const createMessagesTable = '''
CREATE TABLE IF NOT EXISTS messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    senderId TEXT NOT NULL,
    receiverId TEXT NOT NULL,
    chatRoomId TEXT NOT NULL,
    message TEXT NOT NULL,
    sentTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chatRoomId) REFERENCES chatRooms (chatRoomId)
);
''';
