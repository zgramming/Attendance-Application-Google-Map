import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';

import './calendar_horizontal.dart';
import './table_attendance.dart';

class AnimatedCalendarAndTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<GlobalProvider, bool>(
      selector: (_, provider) => provider.isChangeMode,
      builder: (_, value, __) {
        return AnimatedCrossFade(
          firstChild: TableAttendance(),
          secondChild: Container(
            child: CalendarHorizontal(),
          ),
          duration: const Duration(seconds: 1),
          crossFadeState: value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstCurve: Curves.decelerate,
          secondCurve: Curves.fastOutSlowIn,
        );
      },
    );
  }
}
