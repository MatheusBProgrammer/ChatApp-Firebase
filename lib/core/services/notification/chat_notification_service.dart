import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../models/chat_notification.dart';

class ChatNotificationService with ChangeNotifier {
  List<ChatNotification> _items = [];

  List<ChatNotification> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  void add(ChatNotification item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(int i) {
    _items.removeAt(i);
    notifyListeners();
  }

  //Push Notification
  Future<void> init() async {
    //the order of the methods is important because the app will be in foreground most of the time
    await _configureTerminated();
    await _configureForeground();
    await _configureBackGroud();
  }

  //request permission to send notifications on the device
  Future<bool> requestPermission() async {
    //starts a instance of firebase messaging
    final messaging = FirebaseMessaging.instance;
    //request permission to send notifications on the device
    final settings = await messaging.requestPermission();
    //check if the user granted permission and return true or false
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        //check if the user granted provisional permission and return true or false (iOS 12+ only)
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  //configure the notification when the app is in foreground
  Future<void> _configureForeground() async {
    if (await requestPermission()) {
      FirebaseMessaging.onMessage.listen(_messageHandle);
    }
  }

//configure the notification when the app is in background
  Future<void> _configureBackGroud() async {
    if (await requestPermission()) {
      //when the app is in background or closed and the user clicks on the notification
      FirebaseMessaging.onMessageOpenedApp.listen(_messageHandle);
    }
  }

//configure the notification when the app is terminated
  Future<void> _configureTerminated() async {
    if (await requestPermission()) {
      //when the app is closed and the user clicks on the notification
      RemoteMessage? msg = await FirebaseMessaging.instance.getInitialMessage();
      if (msg != null) {
        _messageHandle(msg);
      } else {
        return;
      }
    }
  }

  void _messageHandle(RemoteMessage msg) {
    //check if the message is null or if the notification is null
    if (msg == null || msg.notification == null) return;
    add(ChatNotification(
        title: msg.notification?.title ?? 'Não informado',
        body: msg.notification?.body ?? 'Não informado'));
  }
}
