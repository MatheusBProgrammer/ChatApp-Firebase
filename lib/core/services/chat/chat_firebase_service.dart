import 'dart:async';
import 'package:chat/core/models/app_user.dart';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> _msgStream() {
    final store = FirebaseFirestore.instance;
    final snapshots = store
        .collection('chat')
        //orderBy will order the data by the field createdAt
        //descending: true will order the data in descending order
        .orderBy('createdAt', descending: true)
        //
        .withConverter(fromFirestore: _fromFireStore, toFirestore: _toFireStore)
        //snapshots will return a Stream<QuerySnapshot<Map<String, dynamic>>>
        //QuerySnapshot is a list of documents
        .snapshots();

    //IMPLICIT CONVERSION
    //the StreamBuilder will receive a Stream<List<ChatMessage>> as a result of this method
    return snapshots.map((snapshot) {
      //snapshot.docs is a List<QueryDocumentSnapshot<Map<String, dynamic>>>
      //the map will convert each QueryDocumentSnapshot to a ChatMessage and put into a List, to become a List<ChatMessage>
      //doc.data() is the return of the fromFirestore method and a ChatMessage
      return snapshot.docs.map((doc) => doc.data()).toList();
    });

    //EXPLICIT CONVERSION
/*    return Stream<List<ChatMessage>>.multi((controller) {
      snapshots.listen((snapshot) {
        List<ChatMessage> list = snapshot.docs.map((doc) => doc.data()).toList();
        controller.add(list);
      });
    });*/
  }

  @override
  Stream<List<ChatMessage>> messagesStream() {
    //This getter will be used to listen to the stream in the StreamBuilder
    return _msgStream();
  }

  @override
  Future<ChatMessage?>? saveMessage(String message, AppUser user) async {
    final fireBaseStore = FirebaseFirestore.instance;

    //the message is converted to a ChatMessage
    //the AppUser data is used to fill the ChatMessage fields
    final msg = ChatMessage(
      id: '',
      text: message,
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageURL,
      createdAt: DateTime.now(),
    );

    final docRef = await fireBaseStore
        //the collection is called 'chat'
        //collection is a table in SQL
        //in firebase, the collection is a Map<String, dynamic>
        .collection('chat')
        //the Converter will convert the ChatMessage to a Map<String, dynamic>
        //with the propouse of saving it on FirebaseStore
        //and will return directly a ChatMessage
        .withConverter(
          //fromFirestore will convert the Map<String, dynamic> to a ChatMessage
          fromFirestore: _fromFireStore,
          //toFirestore will convert the ChatMessage to a Map<String, dynamic>
          toFirestore: _toFireStore,
        )
        //add will add the ChatMessage to the collection
        //the content in .add will be used in _toFireStore to convert the ChatMessage to a Map<String, dynamic>
        .add(msg);

    //the id is the document id
    final doc = await docRef.get();
    //previously, data() was a Map<String, dynamic>, but now it is a ChatMessage, because of the converter
    final data = doc.data();

    //the return value is converted to a ChatMessage
    return data;
  }

  ChatMessage _fromFireStore(
    //doc is a Map<String, dynamic>
    //this parameter is the data that comes from FirebaseStore
    DocumentSnapshot<Map<String, dynamic>> doc,
    //options is a SetOptions?
    //is used to set the options of the converter, that could be things like merge, mergeFields, etc
    SnapshotOptions? options,
  ) {
    return ChatMessage(
      //id is the document id, or the key of the map on FirebaseStore
      id: doc.id,
      text: doc.data()?['text'],
      createdAt: DateTime.parse(doc.data()?['createdAt']),
      userId: doc.data()?['userId'],
      userName: doc.data()?['userName'],
      userImageURL: doc.data()?['userImageURL'],
    );
  }

  Map<String, dynamic> _toFireStore(
      ChatMessage chatMessage, SetOptions? options) {
    return {
      'text': chatMessage.text,
      'userId': chatMessage.userId,
      'userName': chatMessage.userName,
      'userImageURL': chatMessage.userImageURL,
      'createdAt': chatMessage.createdAt.toIso8601String(),
    };
  }
}
