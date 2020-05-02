import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import './login_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenTemplate(
        duration: 5,
        image: GRotateAnimation(
          duration: Duration(seconds: 2),
          widget: FlutterLogo(
            size: sizes.height(context) / 4,
          ),
        ),
        navigateAfterSplashScreen: LoginScreen(),
      ),
    );
  }
}
