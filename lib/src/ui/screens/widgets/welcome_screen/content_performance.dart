import 'package:network/network.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import 'package:percent_indicator/percent_indicator.dart';

import './subtitle_performance.dart';

import '../../../../providers/user_provider.dart';

class ContentPerformance extends StatefulWidget {
  const ContentPerformance({
    Key key,
  }) : super(key: key);

  @override
  _ContentPerformanceState createState() => _ContentPerformanceState();
}

class _ContentPerformanceState extends State<ContentPerformance> {
  Future<List<PerformanceModel>> performanceMonthly;
  @override
  void initState() {
    performanceMonthly = getPerformanceMonthly();
    super.initState();
  }

  Future<List<PerformanceModel>> getPerformanceMonthly() async {
    final now = DateTime.now();
    final result = absensiAPI.getPerformanceBulanan(
      idUser: context.read<UserProvider>().user.idUser,
      dateTime: DateTime.now(),
      totalDayOfMonth: globalF.totalDaysOfMonth(now.year, now.month),
      totalWeekDayOfMonth: globalF.totalWeekDayOfMonth(now.year, now.month),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    print("Widget : WelcomeScreen/ContentPerformance.dart   | Rebuild !");

    return Flexible(
      flex: 2,
      child: FutureBuilder<List<PerformanceModel>>(
        future: performanceMonthly,
        builder: (BuildContext context, AsyncSnapshot<List<PerformanceModel>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return LoadingFutureBuilder(isLinearProgressIndicator: true);
          }
          if (snapshot.hasError) {
            return InkWell(
              onTap: _refrehsMenu,
              child: Text(
                "${snapshot.error.toString()} , Tap Untuk Refresh Data",
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
                      "${snapshot.data[0].percentace}%",
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
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'VarelaRound',
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SubtitlePerformance(),
                        Flexible(
                          flex: 2,
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '${globalF.totalWeekDayOfMonth(DateTime.now().year, DateTime.now().month)}',
                                  textAlign: TextAlign.center,
                                  style: appTheme.headline3(context).copyWith(
                                        color: colorPallete.white,
                                        fontWeight: FontWeight.bold,
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
          return Text('No Data');
        },
      ),
    );
  }

  void _refrehsMenu() {
    performanceMonthly = getPerformanceMonthly();
    setState(() {});
  }
}
