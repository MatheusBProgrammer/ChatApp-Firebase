import 'package:chat/core/services/auth/auth_mock_service.dart';
import 'package:flutter/material.dart';
import '../components/auth_form.dart';
import '../core/models/auth_form_data.dart';
import '../core/services/auth/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoading = false;

  Future<void> _handleSubmit(AuthFormData formData) async {
    try {
      if(!mounted) return;
      setState(() {
        isLoading = true;
      });
      if (formData.isLogin) {
        //login
        await AuthService().login(formData.email, formData.password);
      } else {
        //signup
        print('signup');
        await AuthService().signup(
          formData.name,
          formData.email,
          formData.password,
          formData.image,
        );
        print('Auth page recebeu os parametros do form, que vieram do model auth_form_data.dart, e foram usados para converter'
            'os dados em um objeto do tipo AppUser, que foi enviado para o AuthService/AuthMockService');
      }
    } catch (error) {
      //this line will be executed if the setState fails
    }
    //this line will be executed if the setState fails, independently of the error
    finally {
      if(!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: SingleChildScrollView(
              child: AuthForm(
                onSubmit: _handleSubmit,
              ),
            ),
          ),
          // if (isLoading)
          //   Container(
          //     height: double.infinity,
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //         color: Colors.black54,
          //         borderRadius: BorderRadius.circular(10)),
          //     child: Center(
          //       child: CircularProgressIndicator(),
          //     ),
          //   )
        ],
      ),
    );
  }
}
