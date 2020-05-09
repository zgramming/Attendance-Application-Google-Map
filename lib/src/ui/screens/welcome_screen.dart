import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:global_template/global_template.dart';

import '../screens/maps_screen.dart';

import '../../providers/zabsen_provider.dart';
import '../../function/zabsen_function.dart';

import './widgets/welcome_screen/fab.dart';
import './widgets/welcome_screen/user_profile.dart';
import './widgets/welcome_screen/table_attendance.dart';
import './widgets/welcome_screen/button_attendance.dart';
import './widgets/welcome_screen/calendar_horizontal.dart';
import './widgets/welcome_screen/card_overall_monthly.dart';
import './widgets/welcome_screen/animation/appbar_animated_color.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeNamed = "/welcome-screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController _hideFloatingButton;
  AnimationController _appbarController;
  @override
  void initState() {
    commonF.initPermission(context);
    _hideFloatingButton = AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _appbarController = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    WidgetsBinding.instance.addObserver(this);
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      UserProfile(),
                      CardOverallMonthly(),
                      Consumer<GlobalProvider>(
                        builder: (_, value2, __) {
                          return AnimatedCrossFade(
                            firstChild: TableAttendance(),
                            secondChild: Container(
                              child: CalendarHorizontal(),
                            ),
                            duration: Duration(seconds: 1),
                            crossFadeState: value2.isChangeMode
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstCurve: Curves.decelerate,
                            secondCurve: Curves.fastOutSlowIn,
                          );
                        },
                      ),
                      SizedBox(height: 1000),
                    ],
                  ),
                ),
                Consumer<ZAbsenProvider>(
                  builder: (_, absenProvider, __) => ButtonAttendance(
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
                Positioned(
                  child: AppBarAnimatedColor(controller: _appbarController),
                  top: 0,
                  left: 0,
                  right: 0,
                ),
              ],
            ),
            floatingActionButton: FabChangeMode(),
          ),
        ),
      ),
    );
  }
}
