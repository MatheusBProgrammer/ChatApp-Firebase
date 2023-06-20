import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  String _message = '';
  TextEditingController _messageController = TextEditingController();

  Future<void> sendMessage() async {
    final user = AuthService().currentUser;
    final message = _messageController.text;
    if (user != null) {
      await ChatService().saveMessage(message, user);
      _messageController.clear();
      _message = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            onChanged: (value) {
              setState(() {
                _message = value;
              });
            },
            cursorColor: Colors.orange,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Enviar mensagem',
              labelStyle: TextStyle(color: Colors.orange),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
              //color of the writiing
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
            onSubmitted: (_) {
              if(_message.trim().isEmpty) return;
              setState(() {
                sendMessage();
              });
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: _message.trim().isEmpty ? (){} : () => setState(() {
            sendMessage();
          }),
          color: _message.trim().isEmpty ? Colors.white : Colors.orange,
        ),
      ],
    );
  }
}
