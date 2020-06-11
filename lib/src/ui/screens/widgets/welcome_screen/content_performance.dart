import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:network/network.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../providers/user_provider.dart';
import '../../shimmer/shimmer_performance_monthly.dart';
import './subtitle_performance.dart';

class ContentPerformance extends StatefulWidget {
  const ContentPerformance({
    Key key,
  }) : super(key: key);

  @override
  _ContentPerformanceState createState() => _ContentPerformanceState();
}

class _ContentPerformanceState extends State<ContentPerformance> {
  Future<List<PerformanceModel>> getPerformanceMonthly(DateTime dateTime) async {
    final result = absensiAPI.getPerformanceBulanan(
      idUser: context.read<UserProvider>().user.idUser,
      dateTime: dateTime,
      totalDayOfMonth: globalF.totalDaysOfMonth(dateTime.year, dateTime.month),
      totalWeekDayOfMonth: globalF.totalWeekDayOfMonth(dateTime.year, dateTime.month),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Selector<GlobalProvider, DateTime>(
        selector: (_, provider) => provider.dateAddSubstract,
        builder: (_, dateTime, __) => FutureBuilder<List<PerformanceModel>>(
          future: getPerformanceMonthly(dateTime),
          builder: (BuildContext context, AsyncSnapshot<List<PerformanceModel>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return ShimmerPerformanceMonthly();
            }
            if (snapshot.hasError) {
              return InkWell(
                onTap: _refrehsMenu,
                child: Text(
                  '${snapshot.error.toString()} , Tap Untuk Refresh Data',
                  textAlign: TextAlign.center,
                ),
              );
            }
            if (snapshot.hasData) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: CircularPercentIndicator(
                      radius: sizes.width(context) / 4,
                      circularStrokeCap: CircularStrokeCap.round,
                      lineWidth: 8,
                      center: Text(
                        '${snapshot.data[0].percentace}%',
                        style: appTheme.headline5(context).copyWith(
                              color: colorPallete.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      progressColor: colorPallete.accentColor,
                      backgroundColor: colorPallete.white,
                      percent: snapshot.data[0].percentace / 100,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'VarelaRound',
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SubtitlePerformance(),
                          Flexible(
                            flex: 2,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Selector<GlobalProvider, DateTime>(
                                    selector: (_, provider) => provider.dateAddSubstract,
                                    builder: (_, dateTime, __) => Text(
                                      '${globalF.totalWeekDayOfMonth(dateTime.year, dateTime.month)}',
                                      textAlign: TextAlign.center,
                                      style: appTheme.headline3(context).copyWith(
                                            color: colorPallete.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  fit: FlexFit.tight,
                                ),
                                Flexible(
                                  child: Text(
                                    '${snapshot.data[0].ot}',
                                    textAlign: TextAlign.center,
                                    style: appTheme.headline4(context).copyWith(
                                          color: colorPallete.white,
                                        ),
                                  ),
                                  fit: FlexFit.tight,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Text('No Data');
          },
        ),
      ),
    );
  }

  void _refrehsMenu() {
    setState(() {});
  }
}
