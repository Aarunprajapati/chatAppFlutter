class ChatModel {
  final String chatId;
  final String lastMessage;
  final DateTime lastMessageTime;
  final List<String> participants;

  ChatModel({
    required this.chatId,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.participants,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
      'participants': participants,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: DateTime.fromMillisecondsSinceEpoch(
        map['lastMessageTime'],
      ),
      participants: List<String>.from(map['participants'] ?? []),
    );
  }
}
