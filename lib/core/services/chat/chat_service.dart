import 'package:chat/core/models/chat_message.dart';

import '../../models/app_user.dart';
import 'chat_firebase_service.dart';
import 'chat_mock_service.dart';

//abstract class to be used as a base for the implementation of the ChatService
//the reason to use an abstract class is to allow us to change the implementation of the ChatService without change the code that uses it
abstract class ChatService {
  //the use of a Stream allow us to listen to the changes in the data, by the method listen() or by the StreamBuilder
  Stream<List<ChatMessage>> messagesStream();

  //this method will be used to send the message to the stream
  Future<ChatMessage?>? saveMessage(String message, AppUser user);

  //the factory constructor will be used to create the instance of the class
  factory ChatService() {
    //return ChatMockService();
    //future implementation below
    return ChatFirebaseService();
  }
}
