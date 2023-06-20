import 'dart:io';

enum AuthMode { Login, Signup }

class AuthFormData {
  String name = '';
  String email = '';
  String password = '';
  File? image;

  AuthMode _mode = AuthMode.Login;

  bool get isLogin {
    return _mode == AuthMode.Login;
  }

  bool get isSignup {
    return _mode == AuthMode.Signup;
  }

  void toggleMode() {
    _mode = isLogin ? AuthMode.Signup : AuthMode.Login;
  }
}
