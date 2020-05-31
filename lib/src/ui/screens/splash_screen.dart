import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import './welcome_screen.dart';
import './login_screen.dart';
import '../../providers/user_provider.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenTemplate(
        image: GRotateAnimation(
          child: FlutterLogo(
            size: sizes.height(context) / 4,
          ),
        ),
        navigateAfterSplashScreen:
            context.watch<UserProvider>().user.idUser == null ? LoginScreen() : WelcomeScreen(),
      ),
    );
  }
}
