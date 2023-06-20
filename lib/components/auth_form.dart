import 'dart:io';

import 'package:chat/components/user_image_picker.dart';
import 'package:flutter/material.dart';

import '../core/models/auth_form_data.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;

  const AuthForm({super.key, required this.onSubmit});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _authFormData = AuthFormData();
  final _formKey = GlobalKey<FormState>();

  void _handleImagePick(File image) {
    //the image is the image picked from the device
    //the parameter is send from the UserImagePicker widge
    //the _authFormData is going to be modified by the execution of the function in the UserImagePicker widget
    _authFormData.image = image;
  }

  void _showErrorMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _submit() {
    //validate the form
    //the false means that if the form is not valid, it will not show the error messages
    final isValid = _formKey.currentState?.validate() ?? false;
    //close the keyboard
    if (!isValid) {
      return;
    }

    /*if (_authFormData.image == null && _authFormData.isSignup) {
      _showErrorMsg('Please pick an image');
    }*/
    print('_submit, in the AuthForm');
    //save the form and send the data to the parent widget, which is the AuthPage
    //in there, the data will be sent to the firebase
    widget.onSubmit(_authFormData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(18),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_authFormData.isSignup)
                UserImagePicker(onImagePick: _handleImagePick),
              if (_authFormData.isSignup)
                TextFormField(
                    onChanged: (name) => _authFormData.name = name,
                    initialValue: _authFormData.name,
                    key: ValueKey('username'),
                    validator: (_value) {
                      //value is the value of the TextFormField
                      final value = _value ?? '';
                      //if the validator returns a string/message, it means there is an error
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length < 3) {
                        return 'Please enter a valid name(min. 3 characters)';
                      }
                      //return null means no error
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Username')),
              TextFormField(
                onChanged: (email) => _authFormData.email = email,
                key: ValueKey('email'),
                decoration: InputDecoration(labelText: 'E-mail'),
                validator: (_value) {
                  //value is the value of the TextFormField
                  final value = _value ?? '';
                  if (!value.contains('@')) {
                    return "Please enter a valid E-mail";
                  }
                  ;
                },
              ),
              TextFormField(
                obscureText: true,
                onChanged: (password) => _authFormData.password = password,
                key: ValueKey('password'),
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                validator: (_value) {
                  //value is the value of the TextFormField
                  final value = _value ?? '';

                  //if the validator returns a string/message, it means there is an error
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length < 4) {
                    return 'Please enter a valid password(min. 4 characters)';
                  }
                  //return null means no error
                  return null;
                },
              ),
              SizedBox(height: 12),
              ElevatedButton(
                  onPressed: _submit,
                  child: Text(_authFormData.isLogin ? 'Login' : 'Signup')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _authFormData.toggleMode();
                    });
                  },
                  child: Text(_authFormData.isLogin
                      ? 'Create new Account'
                      : 'Alredy have an Account'))
            ],
          ),
        ),
      ),
    );
  }
}
