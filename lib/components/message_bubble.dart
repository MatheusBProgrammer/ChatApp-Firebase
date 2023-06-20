import 'dart:io';

import 'package:chat/core/models/app_user.dart';
import 'package:chat/core/models/chat_message.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  static const _defaultImage = 'assets/images/avatar.png';
  final ChatMessage message;
  final bool isMe;

  const MessageBubble({
    required this.message,
    required this.isMe,
    super.key,
  });

  Widget _showUserImage(String imageUrl) {
    ImageProvider? provider;
    final uri = Uri.parse(imageUrl);

    //if the image is the default image, we use the AssetImage
    if (uri.path.contains(_defaultImage)) {
      provider = const AssetImage(_defaultImage);
      //if the image is from the network, we use the NetworkImage
    } else if (uri.scheme.contains('http')) {
      provider = NetworkImage(uri.toString());
      //if the image is from the device, we use the FileImage
    } else {
      provider = FileImage(File(uri.toString()));
    }

    return CircleAvatar(
      backgroundImage: provider,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: !isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isMe
                      ? Colors.grey.shade300
                      : Colors.orange,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: !isMe
                        ? const Radius.circular(12)
                        : const Radius.circular(0),
                    bottomRight: !isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(12),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.50,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                child: Column(
                  crossAxisAlignment: !isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisAlignment: !isMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Text(
                      message.userName,
                      style: TextStyle(
                        color: !isMe ? Colors.deepPurpleAccent : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      message.text,
                      style: TextStyle(
                        color: !isMe ? Colors.black : Colors.black87,
                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
        Positioned(
          top: 0,
          left: !isMe ? null : MediaQuery.of(context).size.width * 0.45,
          right: !isMe ? MediaQuery.of(context).size.width * 0.45 : null,
          child: _showUserImage(message.userImageURL),
        ),
      ],
    );
  }
}
