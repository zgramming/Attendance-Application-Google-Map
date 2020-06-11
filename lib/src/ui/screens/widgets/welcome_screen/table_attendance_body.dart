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
                fittedText: true,
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
    EdgeInsetsGeometry padding,
    double fontSize = 11,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    final text = Text(
      result ?? '-',
      style: appTheme.caption(context).copyWith(fontWeight: fontWeight, fontSize: fontSize),
      textAlign: textAlign,
    );
    return Flexible(
      flex: flex,
      child: fittedText
          ? Padding(
              padding: padding ?? const EdgeInsets.all(0),
              child: FittedBox(child: text),
            )
          : Padding(
              padding: padding ?? const EdgeInsets.all(0),
              child: text,
            ),
      fit: FlexFit.tight,
    );
  }
}
