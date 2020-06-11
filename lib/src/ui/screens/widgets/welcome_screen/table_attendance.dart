import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_template/global_template.dart';
import 'package:network/network.dart';
import 'package:provider/provider.dart';

import '../../../../providers/absen_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../shimmer/shimmer_table_attendance.dart';
import './table_attendance_body.dart';

class TableAttendance extends StatefulWidget {
  @override
  _TableAttendanceState createState() => _TableAttendanceState();
}

class _TableAttendanceState extends State<TableAttendance> {
  Future<List<AbsensiModel>> getAbsenMonthly(DateTime now) async {
    final globalProvider = context.read<UserProvider>();
    final result = context.read<AbsenProvider>().fetchAbsenMonthly(globalProvider.user.idUser, now);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.angleLeft),
                onPressed: () => context.read<GlobalProvider>().substractMonthCalendar(),
              ),
              Selector<GlobalProvider, DateTime>(
                selector: (_, provider) => provider.dateAddSubstract,
                builder: (_, dateTime, __) {
                  return Text(
                    globalF.formatYearMonth(dateTime, type: 3),
                    style: appTheme.subtitle1(context),
                  );
                },
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.angleRight),
                onPressed: () => context.read<GlobalProvider>().addMonthCalendar(),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
        const SizedBox(height: 20),
        Card(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                color: colorPallete.accentColor,
                padding: const EdgeInsets.all(8.0),
                child: DefaultTextStyle(
                  style: appTheme.button(context),
                  child: Row(
                    children: [
                      rowHeader(context, 'Tanggal', flex: 2),
                      rowHeader(context, 'Datang'),
                      rowHeader(context, 'Pulang'),
                      rowHeader(context, 'Durasi'),
                    ],
                  ),
                ),
              ),
              Selector<GlobalProvider, DateTime>(
                selector: (_, provider) => provider.dateAddSubstract,
                builder: (_, dateTime, __) {
                  return FutureBuilder(
                    future: getAbsenMonthly(dateTime),
                    builder: (BuildContext context, AsyncSnapshot<List<AbsensiModel>> snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return ShimmerTableAttendance();
                      }
                      if (snapshot.hasError) {
                        return InkWell(
                          onTap: _refreshMenu,
                          child: Text(
                            '${snapshot.error.toString()} , Tap Untuk Refresh Data',
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (BuildContext context, int index) {
                            final result = snapshot.data[index];
                            return TableAttendanceBody(
                              index: index,
                              now: dateTime,
                              result: result,
                            );
                          },
                        );
                      }
                      return const Text('no data');
                    },
                  );
                },
              ),
            ],
          ),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }

  Flexible rowHeader(
    BuildContext context,
    String result, {
    int flex = 1,
    TextAlign textAlign = TextAlign.center,
  }) {
    final text = Text(
      result,
      textAlign: textAlign,
      style: TextStyle(color: colorPallete.white, fontWeight: FontWeight.bold),
    );
    return Flexible(child: text, fit: FlexFit.tight, flex: flex);
  }

  void _refreshMenu() {
    setState(() {});
  }
}
