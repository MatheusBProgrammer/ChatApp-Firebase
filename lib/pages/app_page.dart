import 'package:chat/core/models/chat_notification.dart';
import 'package:chat/core/services/auth/auth_mock_service.dart';
import 'package:chat/pages/notification_page.dart';
import 'package:flutter/material.dart';

import '../components/messages.dart';
import '../components/new_messages.dart';
import '../core/services/auth/auth_service.dart';
import '../core/services/notification/chat_notification_service.dart';
import 'package:provider/provider.dart';

import '../utils/routes.dart';

class AppPage extends StatelessWidget {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,

        //backgroundColor: Color(0xFF0F0F1B),
        appBar: AppBar(
          title: Text('Programmer\'s Chat'),
          centerTitle: true,
                  backgroundColor: Theme.of(context).primaryColor,

          actions: [
            DropdownButton(
              underline: Container(),
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              items: [
                DropdownMenuItem(
                  //the value connected to this item is identify in the onChanged
                  value: 'logout',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(
                        Icons.logout,
                      ),
                      Text(
                        'Sair',
                        style: TextStyle(),
                      ),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == 'logout') {
                  AuthService().logout();
                }
              },
            ),
            Stack(
              children: [
                IconButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(AppRoutes.NOTIFICATIONS),
                    //onPressed: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => NotificationPage(),),);
                    // }
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.orange,
                    )),
                Positioned(
                  top: 5,
                  right: 5,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red[900],
                    child: Text(
                      '+${Provider.of<ChatNotificationService>(context).itemsCount.toString()}',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  flex: 11,
                  child: Messages(),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: NewMessages(),
                ),
                /*FloatingActionButton(
                  onPressed: () {
                    Provider.of<ChatNotificationService>(
                      context,
                      listen: false,
                    ).add(ChatNotification(title: 'Titulo', body: 'body'));
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.orange,
                ),*/
              ],
            ),
          ),
        ));
  }
}
