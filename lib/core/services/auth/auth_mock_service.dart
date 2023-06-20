import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:chat/core/models/app_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';

class AuthMockService implements AuthService {
  //this is the default user
  static const _defaultUser = AppUser(
    id: '456',
    name: 'Matheus',
    email: 'matheus@',
    imageURL: 'assets/images/avatar.png',
  );

  //this is the list of users
  static final Map<String, AppUser> _users = {
    _defaultUser.email: _defaultUser,
  };

  //this is the current user
  static AppUser? _currentUser;

  //this is the controller of the stream
  static MultiStreamController<AppUser?>? _controller;

  //this is the stream of the user
  static final _userStream = Stream<AppUser?>.multi((controller) {
    //define the controller
    _controller = controller;
    //this line will send the data to the Stream when the first listener is added
    _updateUser(_defaultUser);
  });

  @override
  AppUser? get currentUser {
    return _currentUser;
  }

  //this is the getter of the stream, used to listen to the stream in the StreamBuilder
  @override
  Stream<AppUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final newUser = AppUser(
      id: Random().nextDouble().toString(),
      name: name,
      email: email,
      imageURL: image?.path ?? 'assets/images/avatar.png',
    );

    //putIfAbsent will add the user only if the email is not in the map
    _users.putIfAbsent(email, () => newUser);
    //send the data to the stream and update the current user
    _updateUser(newUser);
  }

  @override
  Future<void> login(String email, String password) async {
    //send the data to the stream and update the current user
    _updateUser(_users[email]);
  }

  @override
  Future<void> logout() async {
    //send the data to the stream and update the current user
    //when null is sent to the stream, the StreamBuilder will show the login screen, because the hasData will be false
    _updateUser(null);
  }

  //this method will send the data to the stream and update the current user
  static void _updateUser(AppUser? user) {
    //update the current user
    _currentUser = user;
    //add the user to the stream, and notify the listeners
    _controller?.add(_currentUser);
  }
}
