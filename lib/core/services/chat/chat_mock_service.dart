import 'dart:async';
import 'dart:math';
import 'package:chat/core/models/app_user.dart';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/services/chat/chat_service.dart';

class ChatMockService implements ChatService {
  static MultiStreamController<List<ChatMessage>>? _msgStreamController;

  static final List<ChatMessage> _msg = [];

  static final Stream<List<ChatMessage>> _msgStream =
      Stream<List<ChatMessage>>.multi((controller) {
    _msgStreamController = controller;
    //this line will send the data to the Stream when the first listener is added
    _msgStreamController?.add(_msg.reversed.toList());
  });

  @override
  Stream<List<ChatMessage>> messagesStream() {
    //This getter will be used to listen to the stream in the StreamBuilder
    return _msgStream;
  }

  @override
  Future<ChatMessage> saveMessage(String message, AppUser user) {
    final newChatMessage = ChatMessage(
      id: Random().nextDouble().toString(),
      text: message,
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageURL,
      createdAt: DateTime.now(),
    );
    _msg.add(newChatMessage);
    //this line will send the data to the Stream when the first listener is added
    //and will update of the data when the Stream has listeners
    _msgStreamController?.add(_msg.reversed.toList());
    return Future.value(newChatMessage);
  }
}
