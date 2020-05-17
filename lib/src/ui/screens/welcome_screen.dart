import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';

import './widgets/welcome_screen/fab.dart';
import './widgets/welcome_screen/user_profile.dart';
import './widgets/welcome_screen/button_attendance.dart';
import './widgets/welcome_screen/card_overall_monthly.dart';
import './widgets/welcome_screen/animated_table_calendar.dart';
import './widgets/welcome_screen/animation/appbar_animated_color.dart';

import '../../function/zabsen_function.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeNamed = "/welcome-screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController _hideFloatingButton;
  AnimationController _appbarController;
  bool isChange = false;
  @override
  void initState() {
    super.initState();
    commonF.initPermission(context);
    _hideFloatingButton = AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _appbarController = AnimationController(vsync: this, duration: kThemeChangeDuration);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      if (!await commonF.getGPSService()) {
        Navigator.of(context).pop();
      } else if (await commonF.getGeolocationPermission() != GeolocationStatus.granted) {
        Navigator.of(context).pop();
      }
      print("Trigger Paused");
    }
    if (state == AppLifecycleState.resumed) {
      // commonF.initPermission(context);
      if (!await commonF.getGPSService()) {
        commonF.initPermission(context);
      } else if (await commonF.getGeolocationPermission() != GeolocationStatus.granted) {
        commonF.initPermission(context);
      }
      print("Trigger Resumed");
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _hideFloatingButton.dispose();
    _appbarController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) => commonF.handleScrollNotification(
        notification,
        controllerButton: _hideFloatingButton,
        appBarController: _appbarController,
      ),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark),
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      UserProfile(),
                      CardOverallMonthly(),
                      AnimatedCalendarAndTable(),
                      const SizedBox(height: 1000),
                    ],
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 60,
                  bottom: 10,
                  child: ScaleTransition(
                    scale: _hideFloatingButton,
                    child: ButtonAttendance(),
                  ),
                ),
                AppBarAnimatedColor(controller: _appbarController),
              ],
            ),
            floatingActionButton: FabChangeMode(),
          ),
        ),
      ),
    );
  }
}
