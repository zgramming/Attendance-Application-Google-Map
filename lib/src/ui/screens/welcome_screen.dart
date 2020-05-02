import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../screens/maps_screen.dart';

import '../../providers/zabsen_provider.dart';
import '../../function/common_function.dart';

import './widgets/welcome_screen/button_attendance.dart';
import './widgets/welcome_screen/calendar_horizontal.dart';
import './widgets/welcome_screen/table_attendance.dart';
import './widgets/welcome_screen/card_overall_monthly.dart';
import 'package:global_template/global_template.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeNamed = "/welcome-screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _changeMode = false;
  AnimationController _hideFabAnimation;
  @override
  void initState() {
    super.initState();
    commonF.initPermission(context);
    WidgetsBinding.instance.addObserver(this);
    _hideFabAnimation = AnimationController(vsync: this, duration: kThemeAnimationDuration);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      commonF.initPermission(context);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _hideFabAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) =>
          commonF.handleScrollNotification(notification, controller: _hideFabAnimation),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CardOverallMonthly(),
                  if (!_changeMode) ...[
                    CalendarHorizontal(),
                  ] else ...[
                    TableAttendance(),
                  ],
                  SizedBox(height: 1000),
                ],
              ),
            ),
            Consumer<ZAbsenProvider>(
              builder: (_, absenProvider, __) => ButtonAttendance(
                hideFabAnimation: _hideFabAnimation,
                onTapAttendence: () {
                  absenProvider.getCurrentPosition().then((_) => Future.delayed(
                      Duration(milliseconds: 500),
                      () => Navigator.of(context).pushNamed(MapScreen.routeNamed)));
                },
                onTapGoHome: () => print('go home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
