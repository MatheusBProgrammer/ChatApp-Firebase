import 'dart:io';

import 'package:chat/core/models/app_user.dart';
import 'package:chat/core/services/auth/auth_mock_service.dart';

import 'auth_firebase_service.dart';

abstract class AuthService {
  AppUser? get currentUser;

  Stream<AppUser?> get userChanges;

  Future<void> signup(
      String email, String password, String username, File? image);

  Future<void> login(String email, String password);

  Future<void> logout();

  factory AuthService() {
    //return AuthMockService();
    //future implementation below
    return AuthFirebaseService();
  }
}
