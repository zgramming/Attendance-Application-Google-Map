import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import '../screens/maps_screen.dart';

import '../../providers/zabsen_provider.dart';
import '../../function/common_function.dart';

import './widgets/welcome_screen/button_attendance.dart';
import './widgets/welcome_screen/calendar_horizontal.dart';
import './widgets/welcome_screen/table_attendance.dart';
import './widgets/welcome_screen/card_overall_monthly.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeNamed = "/welcome-screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool changeMode;
  AnimationController _hideFloatingButton;
  @override
  void initState() {
    super.initState();
    commonF.initPermission(context);
    changeMode = false;
    WidgetsBinding.instance.addObserver(this);
    _hideFloatingButton = AnimationController(vsync: this, duration: kThemeAnimationDuration);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      if (!await commonF.serviceEnabled()) {
        Navigator.of(context).pop();
      } else if (await commonF.checkLocationPermission() != PermissionStatus.granted) {
        Navigator.of(context).pop();
      }
      print("Trigger Paused");
    }
    if (state == AppLifecycleState.resumed) {
      // commonF.initPermission(context);
      if (!await commonF.serviceEnabled()) {
        commonF.initPermission(context);
      } else if (await commonF.checkLocationPermission() != PermissionStatus.granted) {
        commonF.initPermission(context);
      }
      print("Trigger Resumed");
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _hideFloatingButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) =>
          commonF.handleScrollNotification(notification, controller: _hideFloatingButton),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CardOverallMonthly(),
                  AnimatedCrossFade(
                      firstChild: CalendarHorizontal(),
                      secondChild: TableAttendance(),
                      duration: Duration(seconds: 1),
                      crossFadeState:
                          changeMode ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      firstCurve: Curves.fastLinearToSlowEaseIn,
                      secondCurve: Curves.linearToEaseOut),
                  SizedBox(height: 1000),
                ],
              ),
            ),
            Consumer<ZAbsenProvider>(
              builder: (_, absenProvider, __) => ButtonAttendance(
                // left: 20,
                right: 60,
                hideFabAnimation: _hideFloatingButton,
                onTapAttendence: () {
                  absenProvider.getCurrentPosition().then(
                        (_) => Future.delayed(
                          Duration(milliseconds: 300),
                          () => Navigator.of(context).pushNamed(MapScreen.routeNamed),
                        ),
                      );
                },
                onTapGoHome: () => print('go home'),
              ),
            ),
          ],
        ),
        floatingActionButton: Semantics(
          container: true,
          child: FloatingActionButton(
            onPressed: () {
              setState(() => changeMode = !changeMode);
            },
            mini: true,
            child: Icon(changeMode ? FontAwesomeIcons.calendarTimes : FontAwesomeIcons.tabletAlt),
          ),
        ),
      ),
    );
  }
}
