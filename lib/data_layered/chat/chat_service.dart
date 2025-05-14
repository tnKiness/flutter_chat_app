// lib/models/chat_message.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String text;
  final String userId;
  final String username;
  final String userImage;
  final Timestamp createdAt;

  ChatMessage({
    required this.id,
    required this.text,
    required this.userId,
    required this.username,
    required this.userImage,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'userId': userId,
      'username': username,
      'userImage': userImage,
      'createdAt': createdAt,
    };
  }

  factory ChatMessage.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChatMessage(
      id: doc.id,
      text: data['text'] ?? '',
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      userImage: data['userImage'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
