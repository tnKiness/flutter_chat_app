import 'package:chat_app/data_layered/chat/chat_service.dart'; // THÊM DÒNG NÀY
import 'package:chat_app/presentation_layered/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(child: Text('No messages found.'));
        }

        if (chatSnapshots.hasError) {
          return const Center(child: Text('Something went wrong...'));
        }

        final chatDocs = chatSnapshots.data!.docs;
        final messages =
            chatDocs.map((doc) => ChatMessage.fromDocument(doc)).toList();

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = messages[index];
            final nextChatMessage =
                index + 1 < messages.length ? messages[index + 1] : null;

            final nextUserIsSame =
                nextChatMessage?.userId == chatMessage.userId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage.text,
                isMe: authenticatedUser.uid == chatMessage.userId,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage.userImage,
                username: chatMessage.username,
                message: chatMessage.text,
                isMe: authenticatedUser.uid == chatMessage.userId,
              );
            }
          },
        );
      },
    );
  }
}
