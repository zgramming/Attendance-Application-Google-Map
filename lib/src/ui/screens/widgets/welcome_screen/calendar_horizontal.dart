import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CalendarHorizontal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 2,
                child: Text(
                  globalF.formatYearMonth(DateTime.now(), type: 3),
                  style: appTheme.headline6(context),
                  textAlign: TextAlign.right,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: GestureDetector(
                  onTap: () => print('ss'),
                  child: Tooltip(
                    message: 'List Mode',
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(FontAwesomeIcons.list, size: 12)),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: sizes.height(context) / 8,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          // color: Colors.green,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemExtent: 90,
            itemCount: globalF.totalDaysOfMonth(DateTime.now().month, DateTime.now().year),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: DateTime.now().day == index + 1
                      ? BorderSide(color: Colors.green, width: 2)
                      : BorderSide(color: Colors.transparent),
                ),
                child: InkWell(
                  onTap: () => '',
                  borderRadius: BorderRadius.circular(15),
                  child: Column(
                    children: [
                      Flexible(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${index + 1}",
                            style: appTheme.headline4(context).copyWith(
                                fontWeight: FontWeight.bold, color: colorPallete.accentColor),
                          ),
                        ),
                        fit: FlexFit.tight,
                        flex: 3,
                      ),
                      Flexible(
                        child: Text(
                          globalF.formatDay(
                              DateTime(DateTime.now().year, DateTime.now().month, index + 1)),
                          textAlign: TextAlign.center,
                          style: appTheme.caption(context),
                        ),
                        fit: FlexFit.tight,
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  ),
                ),
              );
            },
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }
}
