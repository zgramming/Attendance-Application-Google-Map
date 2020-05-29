import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:provider/provider.dart';

import './welcome_screen.dart';
import './login_screen.dart';

import '../../providers/user_provider.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SplashScreenTemplate(
        image: GRotateAnimation(
          child: FlutterLogo(
            size: sizes.height(context) / 4,
          ),
        ),
        navigateAfterSplashScreen:
            userProvider.user.idUser == null ? LoginScreen() : WelcomeScreen(),
      ),
    );
  }
}
