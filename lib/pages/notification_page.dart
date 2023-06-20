import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/notification/chat_notification_service.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ChatNotificationService>(context);
    final items = service.items;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: const Text('Notification\'s'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: ListView.builder(
            itemCount: service.itemsCount,
            itemBuilder: (_, i) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.message_outlined, color: Colors.white),
                ),
                title: Text(
                  items[i].title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  items[i].body,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    service.remove(i);
                  },
                ),
                onTap: () => service.remove(i),
              );
            }));
  }
}
