import 'package:flutter/material.dart';
import 'package:network/network.dart';
import 'package:global_template/global_template.dart';

import '../../../../function/common_function.dart';

class CardCalendar extends StatelessWidget {
  const CardCalendar({
    Key key,
    @required this.now,
    @required this.index,
    @required this.list,
  }) : super(key: key);

  final DateTime now;
  final int index;
  final List<AbsensiStatusModel> list;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sizes.width(context) / 5.5,
      child: Stack(
        children: [
          Card(
            color: commonF.isWeekend(now, index),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: DateTime.now().day == index + 1
                  ? BorderSide(color: colorPallete.accentColor, width: 3)
                  : const BorderSide(color: Colors.transparent),
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
                        '${index + 1}',
                        style: appTheme.headline5(context).copyWith(
                              fontWeight: FontWeight.bold,
                              color: commonF.isWeekend(
                                now,
                                index,
                                colorWeekend: colorPallete.white,
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
                        type: 1,
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
          Positioned(child: commonF.setStatusAbsenIcon(list, index), top: 0, right: 0),
        ],
      ),
    );
  }
}
