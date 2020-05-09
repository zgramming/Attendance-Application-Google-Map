import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import '../../../../function/zabsen_function.dart';

class CardCalendar extends StatelessWidget {
  const CardCalendar({
    Key key,
    @required this.now,
    @required this.index,
  }) : super(key: key);

  final DateTime now;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sizes.width(context) / 5.5,
      child: Card(
        color: commonF.isWeekend(now, index),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: now.day == index + 1
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
                    style: appTheme.headline5(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: commonF.isWeekend(
                            now,
                            index,
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
                fit: FlexFit.tight,
                child: Text(
                  globalF.formatDay(
                    DateTime(
                      now.year,
                      now.month,
                      index + 1,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: appTheme.caption(context).copyWith(
                        color: commonF.isWeekend(
                          now,
                          index,
                          colorWeekend: colorPallete.white,
                        ),
                      ),
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
        ),
      ),
    );
  }
}
