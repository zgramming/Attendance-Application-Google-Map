import 'dart:async';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:ntp/ntp.dart';

class LiveClock extends StatefulWidget {
  @override
  _LiveClockState createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  // String _timeString;
  String _timeClock;
  Timer _timerClock;

  @override
  void initState() {
    // _timeString = globalF.formatYearMonthDaySpecific(DateTime.now(), type: 3);
    _timerClock = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
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
      _timeClock ?? '',
      textAlign: TextAlign.center,
      style: appTheme.subtitle1(context).copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  void _getTime() async {
    final DateTime timeNetwork = await NTP.now();
    // final String formattedDateTime = globalF.formatYearMonthDaySpecific(now, type: 3);
    final String formattedTime = globalF.formatHoursMinutesSeconds(timeNetwork);
    setState(() {
      // _timeString = formattedDateTime;
      _timeClock = formattedTime;
    });
  }
}
