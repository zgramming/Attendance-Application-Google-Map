import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import './widgets/login_screen/form.dart';

class LoginScreen extends StatefulWidget {
  static const routeNamed = '/login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginScreenTemplate(
        formKey: _formKey,
        imageBuilder: FlutterLogo(
          size: sizes.height(context) / 5,
        ),
        form: AnimatedSize(
          child: FormUser(formKey: _formKey),
          vsync: this,
          curve: Curves.linearToEaseOut,
          duration: const Duration(milliseconds: 1500),
        ),
        background: Container(color: colorPallete.primaryColor),
      ),
    );
  }
}
