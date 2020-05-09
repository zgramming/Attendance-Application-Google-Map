import 'dart:async';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

class LiveClock extends StatefulWidget {
  @override
  _LiveClockState createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  String _timeClock;
  Timer _timerClock;

  @override
  void initState() {
    _timerClock = Timer.periodic(Duration(seconds: 1), (_) => _getTime());
    super.initState();
  }

  @override
  void dispose() {
    _timerClock.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeClock ?? '??:??:??',
      textAlign: TextAlign.center,
      style: appTheme.subtitle1(context).copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  void _getTime() async {
    final date = DateTime.now();
    final String formattedTime = (date == null) ? null : globalF.formatHoursMinutesSeconds(date);
    setState(() {
      _timeClock = formattedTime;
    });
  }
}
