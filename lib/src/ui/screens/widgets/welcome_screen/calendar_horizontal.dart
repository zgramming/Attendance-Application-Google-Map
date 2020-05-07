import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

class CalendarHorizontal extends StatelessWidget {
  final DateTime networkDateTime;
  CalendarHorizontal({@required this.networkDateTime});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            globalF.formatYearMonth(networkDateTime, type: 3),
            style: appTheme.headline6(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Container(
            height: sizes.height(context) / 8,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            // color: Colors.green,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemExtent: 90,
              itemCount: globalF.totalDaysOfMonth(networkDateTime.month, networkDateTime.year),
              itemBuilder: (BuildContext context, int index) {
                String getDaysName = globalF
                    .formatDay(DateTime(networkDateTime.year, networkDateTime.month, index + 1));
                return Card(
                  color: isWeekend(getDaysName),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: networkDateTime.day == index + 1
                        ? BorderSide(color: Colors.green, width: 3)
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
                                    fontWeight: FontWeight.bold,
                                    color: isWeekend(
                                      getDaysName,
                                      colorWeekend: colorPallete.white,
                                      colorWeekDay: colorPallete.black.withOpacity(.7),
                                    ),
                                  ),
                            ),
                          ),
                          fit: FlexFit.tight,
                          flex: 3,
                        ),
                        Flexible(
                          child: Text(
                            globalF.formatDay(
                                DateTime(networkDateTime.year, networkDateTime.month, index + 1)),
                            textAlign: TextAlign.center,
                            style: appTheme.caption(context).copyWith(
                                color: isWeekend(getDaysName, colorWeekend: colorPallete.white)),
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
          SizedBox(height: 10),
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }

  Color isWeekend(String getDaysName, {Color colorWeekend, Color colorWeekDay}) {
    if (getDaysName.toLowerCase() == "sabtu" ||
        getDaysName.toLowerCase() == "minggu" ||
        getDaysName.toLowerCase() == "sab" ||
        getDaysName.toLowerCase() == "min") {
      return colorWeekend ?? colorPallete.primaryColor;
    } else {
      return colorWeekDay ?? null;
    }
  }
}
