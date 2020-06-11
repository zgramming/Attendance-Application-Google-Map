import 'dart:async';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

class LiveClock extends StatefulWidget {
  @override
  _LiveClockState createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  Stream<DateTime> liveClock;
  @override
  void initState() {
    liveClock = Stream<DateTime>.periodic(const Duration(seconds: 1), (_) {
      return DateTime.now();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: liveClock,
      initialData: DateTime.now(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Text(
            globalF.formatHoursMinutesSeconds(snapshot.data),
            style: appTheme.subtitle2(context).copyWith(
                  color: colorPallete.white,
                  fontWeight: FontWeight.bold,
                ),
          );
        }
        return Text(
            '${globalF.formatYearMonthDaySpecific(DateTime.now())} ${globalF.formatHoursMinutes(DateTime.now())}');
      },
    );
  }
}
