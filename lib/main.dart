import 'package:chat/pages/auth_or_app_page.dart';
import 'package:chat/pages/notification_page.dart';
import 'package:chat/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/notification/chat_notification_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatNotificationService(),
        )
      ],
      child: MaterialApp(
        title: 'ChatApp',
        theme: ThemeData(
            primaryColor: Color(0xFF0F0F1B),
            textTheme:
                const TextTheme(bodyLarge: TextStyle(color: Colors.white))),
        home: AuthOrAppPage(),
        routes: {
          AppRoutes.NOTIFICATIONS: (_) => NotificationPage(),
        },
      ),
    );
  }
}
