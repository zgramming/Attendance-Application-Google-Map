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
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
        height: sizes.height(context) / 20,
        child: DefaultTextStyle(
          style: appTheme.caption(context).copyWith(fontWeight: FontWeight.bold),
          child: Row(
            children: [
              rowContent(
                context,
                globalF.formatYearMonthDaySpecific(DateTime(now.year, now.month, index + 1)),
                flex: 2,
                textAlign: TextAlign.left,
              ),
              rowContent(context, result.jamAbsenMasuk),
              rowContent(context, result.jamAbsenPulang),
              rowContent(
                context,
                globalF.formatTimeTo(result.durasiAbsen, timeFormat: TimeFormat.JamMenit),
                fittedText: result.durasiAbsen == null ? false : true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Flexible rowContent(
    BuildContext context,
    String result, {
    int flex = 1,
    TextAlign textAlign = TextAlign.center,
    bool fittedText = false,
  }) {
    var text = Text(
      result,
      style: appTheme.caption(context).copyWith(fontWeight: FontWeight.w600, fontSize: 11),
      textAlign: textAlign,
    );
    return Flexible(
      flex: flex,
      child: fittedText ? FittedBox(child: text) : text,
      fit: FlexFit.tight,
    );
  }
}
