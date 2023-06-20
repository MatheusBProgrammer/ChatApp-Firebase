import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/pages/auth_page.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../core/models/app_user.dart';
import '../core/services/notification/chat_notification_service.dart';
import 'app_page.dart';
import 'package:provider/provider.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
    Provider.of<ChatNotificationService>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else {
          return StreamBuilder<AppUser?>(
            stream: AuthService().userChanges,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingPage();
              } else {
                return snapshot.hasData ? const AppPage() : const AuthPage();
              }
            },
          );
        }
      },
    );
  }
}
