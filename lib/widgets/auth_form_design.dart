import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
      this.submitFn,
      this.isLoading,
      );

  final bool isLoading;
  void Function(
      String email,
      String password,
      String userName,
      File image,
      bool isLogin,
      BuildContext ctx,
      ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _userImage;

  void _pickedImage(File image){
    _userImage = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(_userImage== null && _isLogin)
      {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: const Text('Please Select an Image'),
              backgroundColor: Theme.of(context).errorColor,
            ),
        );
        return;
      }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _userImage! ,_isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: const ValueKey('username'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  const SizedBox(height: 12),
                  if(widget.isLoading) const CircularProgressIndicator(),
                  if(!widget.isLoading)
                    ElevatedButton(
                       onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup',
                         style: const TextStyle(fontSize: 20),),
                        ),
                  if(!widget.isLoading)
                    TextButton(
                      child: Text(_isLogin
                        ? 'SignUp'
                        : 'Already have an account',
                       style: const TextStyle(fontSize: 20),),
                       onPressed: () {
                         setState(() {
                          _isLogin = !_isLogin;
                         });
                       },
                    )
                   ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
