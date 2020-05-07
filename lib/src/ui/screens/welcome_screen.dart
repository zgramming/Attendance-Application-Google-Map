import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  AnimationController _hideFloatingButton;
  @override
  void initState() {
    commonF.initPermission(context);
    WidgetsBinding.instance.addObserver(this);
    _hideFloatingButton = AnimationController(vsync: this, duration: kThemeAnimationDuration);
    super.initState();
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
      onNotification: (notification) => commonF.handleScrollNotification(
        notification,
        controllerButton: _hideFloatingButton,
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CardOverallMonthly(),
                  Consumer2<ZAbsenProvider, GlobalProvider>(
                    builder: (_, value, value2, __) {
                      print(value2.isChangeMode);
                      return AnimatedCrossFade(
                        firstChild: CalendarHorizontal(
                          networkDateTime: value.networkDateTime ?? DateTime.now(),
                        ),
                        secondChild: TableAttendance(),
                        duration: Duration(seconds: 1),
                        crossFadeState: value2.isChangeMode
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstCurve: Curves.fastLinearToSlowEaseIn,
                        secondCurve: Curves.linearToEaseOut,
                      );
                    },
                  ),
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
                        (_) => Navigator.of(context).pushNamed(MapScreen.routeNamed),
                      );
                },
                onTapGoHome: () => print('go home'),
              ),
            ),
          ],
        ),
        floatingActionButton: Consumer<GlobalProvider>(
          builder: (_, value, __) => FloatingActionButton(
            onPressed: () {
              value.setChangeMode(value.isChangeMode);
              print(value.isChangeMode);
            },
            mini: true,
            child: Icon(
                value.isChangeMode ? FontAwesomeIcons.calendarTimes : FontAwesomeIcons.tabletAlt),
          ),
        ),
      ),
    );
  }
}
