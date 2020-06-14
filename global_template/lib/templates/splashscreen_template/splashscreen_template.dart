import 'dart:async';
import 'package:flutter/material.dart';

import '../copyright_version_template/copyright_version_template.dart';

class SplashScreenTemplate extends StatefulWidget {
  const SplashScreenTemplate({
    this.duration = 4,
    this.backgroundColor,
    @required this.image,
    @required this.navigateAfterSplashScreen,
  });

  final int duration;
  final Widget image;
  final Widget navigateAfterSplashScreen;
  final Color backgroundColor;

  @override
  _SplashScreenTemplateState createState() => _SplashScreenTemplateState();
}

class _SplashScreenTemplateState extends State<SplashScreenTemplate> {
  void startTime() {
    final Duration durations = Duration(seconds: widget.duration);
    Timer(durations, navigationPage);
  }

  dynamic navigationPage() {
    Future<dynamic>.delayed(
        const Duration(milliseconds: 500),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => widget.navigateAfterSplashScreen)));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor ?? Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 10,
            child: widget.image,
          ),
          const Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.center,
              child: CopyRightVersion(
                showOnlyVersion: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
