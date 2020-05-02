import 'package:flutter/material.dart';

import '../screens/welcome_screen.dart';

import 'package:global_template/global_template.dart';

class LoginScreen extends StatelessWidget {
  static const routeNamed = "/login-screen";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginScreenTemplate(
        formKey: _formKey,
        imageBuilder: FlutterLogo(
          size: sizes.height(context) / 5,
        ),
        formLogin: [
          TextFormFieldCustom(
            onSaved: (value) => '',
            hintText: '',
            radius: 50,
          ),
          SizedBox(height: 20),
          TextFormFieldCustom(
            onSaved: (value) => '',
            isPassword: true,
            labelText: 'Password',
            hintText: '',
            radius: 50,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 20),
          ButtonCustom(
            onPressed: () => Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeNamed),
          ),
        ],
        background: Container(color: colorPallete.primaryColor),
      ),
    );
  }
}
