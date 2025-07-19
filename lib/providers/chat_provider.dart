import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';

class ChatProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ChatModel>> getChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ChatModel.fromMap(doc.data()))
                  .toList(),
        );
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final chatRef = _firestore.collection('chats').doc(chatId);
    final messagesRef = chatRef.collection('messages');

    await chatRef.set({
      'chatId': chatId,
      'lastMessage': message,
      'lastMessageTime': DateTime.now(),
      'participants': [senderId, receiverId],
    }, SetOptions(merge: true));

    await messagesRef.add({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': DateTime.now(),
    });
  }

  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
