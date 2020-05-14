import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:network/network.dart';

class TableAttendanceBody extends StatelessWidget {
  const TableAttendanceBody({
    Key key,
    @required this.now,
    @required this.index,
    @required this.result,
  }) : super(key: key);

  final int index;
  final DateTime now;
  final AbsensiModel result;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 4.0),
      child: DefaultTextStyle(
        style: appTheme.caption(context).copyWith(fontWeight: FontWeight.bold),
        child: Row(
          children: [
            Flexible(
                child: Text(
                  globalF.formatYearMonthDaySpecific(
                    DateTime(
                      now.year,
                      now.month,
                      index + 1,
                    ),
                  ),
                  style: appTheme.caption(context),
                ),
                fit: FlexFit.tight,
                flex: 2),
            Flexible(child: Text(result.jamAbsenMasuk), fit: FlexFit.tight),
            Flexible(child: Text(result.jamAbsenPulang), fit: FlexFit.tight),
            Flexible(
                child:
                    Text(globalF.formatTimeTo(result.durasiAbsen, timeFormat: TimeFormat.JamMenit)),
                fit: FlexFit.tight),
          ],
        ),
      ),
    );
  }
}
