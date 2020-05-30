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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController _buttonAbsentController;
  AnimationController _appbarController;
  @override
  void initState() {
    super.initState();
    initPermission(context);
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
      if (geolocationStatus != GeolocationStatus.granted) {
        Navigator.of(context).pop();
      } else if (!gpsStatus) {
        Navigator.of(context).pop();
      }
    } else if (state == AppLifecycleState.resumed) {
      initPermission(context);
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
        key: _scaffoldKey,
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

  void initPermission(BuildContext context) async {
    final geolocationStatus = await commonF.getGeolocationPermission();
    final gpsStatus = await commonF.getGPSService();
    if (geolocationStatus != GeolocationStatus.granted) {
      showDialog(
        context: context,
        builder: (ctx) {
          return commonF.showPermissionLocation(ctx);
        },
      );
    } else if (!gpsStatus) {
      showDialog(
        context: context,
        builder: (ctx) {
          return commonF.showPermissionGPS(ctx);
        },
      );
    }
  }
}
