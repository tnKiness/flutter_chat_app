// lib/services/chat_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/data_layered/chat/chat_service.dart';

class ChatService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return;

    final user = _firebaseAuth.currentUser!;
    final userData = await _firestore.collection('users').doc(user.uid).get();

    final chatMessage = ChatMessage(
      id: '',
      text: messageText,
      userId: user.uid,
      username: userData['username'],
      userImage: userData['image_url'],
      createdAt: Timestamp.now(),
    );

    await _firestore.collection('chat').add(chatMessage.toMap());
  }
}
