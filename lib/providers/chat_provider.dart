import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/chat_model.dart';

class ChatProvider with ChangeNotifier {
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
    try {
      final chatRef = _firestore.collection('chats').doc(chatId);
      final messagesRef = chatRef.collection('messages');

      // Update chat document
      await chatRef.set({
        'chatId': chatId,
        'lastMessage': message,
        'lastMessageTime': DateTime.now(),
        'participants': [senderId, receiverId],
      }, SetOptions(merge: true));

      // Add new message
      await messagesRef.add({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'timestamp': DateTime.now(),
      });

      notifyListeners(); // Notify listeners after sending message
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Additional method to create or get existing chat
  Future<String> getOrCreateChatId({
    required String currentUserId,
    required String otherUserId,
  }) async {
    // Sort user IDs to ensure consistent chatId
    final participants = [currentUserId, otherUserId]..sort();
    final chatId = participants.join('_');

    // Check if chat already exists
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    if (!chatDoc.exists) {
      await _firestore.collection('chats').doc(chatId).set({
        'chatId': chatId,
        'participants': participants,
        'createdAt': DateTime.now(),
        'lastMessage': '',
        'lastMessageTime': DateTime.now(),
      });
    }

    return chatId;
  }
}
