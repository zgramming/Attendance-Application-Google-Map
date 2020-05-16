import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';

import './table_attendance.dart';
import './calendar_horizontal.dart';

class AnimatedCalendarAndTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Rebuild AnimatedCalendarAndTable");
    return Selector<GlobalProvider, bool>(
      selector: (_, provider) => provider.isChangeMode,
      builder: (_, value, __) => AnimatedCrossFade(
        firstChild: TableAttendance(),
        secondChild: Container(
          child: CalendarHorizontal(),
        ),
        duration: Duration(seconds: 1),
        crossFadeState: value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstCurve: Curves.decelerate,
        secondCurve: Curves.fastOutSlowIn,
      ),
    );
  }
}
