import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';

import './widgets/welcome_screen/fab.dart';
import './widgets/drawer/drawer_custom.dart';
import './widgets/welcome_screen/user_profile.dart';
import './widgets/welcome_screen/button_attendance.dart';
import './widgets/welcome_screen/card_overall_monthly.dart';
import './widgets/welcome_screen/animated_table_calendar.dart';
import './widgets/welcome_screen/animation/appbar_animated_color.dart';

import '../../function/common_function.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeNamed = "/welcome-screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController _buttonAbsentController;
  AnimationController _appbarController;
  @override
  void initState() {
    super.initState();
    commonF.initPermission(context);
    _buttonAbsentController = AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _appbarController = AnimationController(vsync: this, duration: kThemeChangeDuration);
    _buttonAbsentController.forward();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final geolocationStatus = await commonF.getGeolocationPermission();
    final gpsStatus = await commonF.getGPSService();
    if (state == AppLifecycleState.paused) {
      print("Paused Depedencies");

      if (geolocationStatus != GeolocationStatus.granted) {
        Navigator.of(context).pop();
      } else if (!gpsStatus) {
        Navigator.of(context).pop();
      }
    } else if (state == AppLifecycleState.resumed) {
      print("Resumed Depedencies");

      if (geolocationStatus != GeolocationStatus.granted) {
        commonF.showPermissionLocation(context);
      } else if (!gpsStatus) {
        commonF.showPermissionGPS(context);
      }
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _buttonAbsentController.dispose();
    _appbarController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) => commonF.handleScrollNotification(
        notification,
        controllerButton: _buttonAbsentController,
        appBarController: _appbarController,
      ),
      child: Scaffold(
        drawer: DrawerCustom(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: kToolbarHeight * 1.5),
                  UserProfile(),
                  CardOverallMonthly(),
                  AnimatedCalendarAndTable(),
                  const SizedBox(height: kToolbarHeight * 2),
                ],
              ),
            ),
            Positioned(
              left: 10,
              right: 60,
              bottom: 10,
              child: ScaleTransition(
                scale: _buttonAbsentController,
                child: ButtonAttendance(),
              ),
            ),
            AppBarAnimatedColor(
              controller: _appbarController,
              leading: FlutterLogo(
                size: kToolbarHeight / 1.5,
              ),
            ),
          ],
        ),
        floatingActionButton: FabChangeMode(),
      ),
    );
  }
}
