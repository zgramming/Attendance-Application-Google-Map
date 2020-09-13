import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_template/global_template.dart';
import 'package:location_permissions/location_permissions.dart';

import '../../function/common_function.dart';
import './widgets/drawer/drawer_custom.dart';
import './widgets/welcome_screen/animated_table_calendar.dart';
import './widgets/welcome_screen/animation/appbar_animated_color.dart';
import './widgets/welcome_screen/button_attendance.dart';
import './widgets/welcome_screen/card_overall_monthly.dart';
import './widgets/welcome_screen/fab.dart';
import './widgets/welcome_screen/user_profile.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeNamed = '/welcome-screen';

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
    SchedulerBinding.instance.addPostFrameCallback((_) {
      commonF.getGeolocationPermission().then((locationPermission) {
        if (locationPermission != GeolocationStatus.granted) {
          LocationPermissions().requestPermissions().then((value) {});
          // showDialog(context: context, child: commonF.showPermissionLocation());
        }
      });
      commonF.getGPSService().then((gpsPermission) {
        print('Welcome Permission gps $gpsPermission');
        if (!gpsPermission) {
          showDialog(context: context, child: commonF.showPermissionGPS());
        }
      });
    });
    _buttonAbsentController = AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _appbarController = AnimationController(vsync: this, duration: kThemeChangeDuration);
    _buttonAbsentController.forward();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      commonF.initClosePermission(context);
    } else if (state == AppLifecycleState.resumed) {
      commonF.initPermission(context);
    }
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
    print(appConfig.baseApiUrl);
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
                child: const ButtonAttendance(),
              ),
            ),
            AppBarAnimatedColor(
              controller: _appbarController,
              leading: const FlutterLogo(
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
