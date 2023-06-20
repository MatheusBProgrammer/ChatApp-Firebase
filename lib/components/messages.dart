import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../core/services/chat/chat_service.dart';
import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;
    return StreamBuilder(
      stream: ChatService().messagesStream(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData ||
            (snapshot.data as List<ChatMessage>).isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  Icons.sentiment_neutral_outlined,
                  size: 80,
                  color: Colors.orange,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Você tem um total de 0 mensagens',
                  style: TextStyle(fontSize: 22,color: Colors.orange),
                ),
              ],
            ),
          );
        } else {
          final messages = snapshot.data as List<ChatMessage>;
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (_, index) {
                  return MessageBubble(
                    isMe:
                        messages[index].userId == currentUser?.id.toString(),
                    message: messages[index],
                  );
                }),
          );
        }
      },
    );
  }
}
