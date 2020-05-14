import 'package:network/network.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:z_absen/src/providers/zabsen_provider.dart';

import '../../../../providers/user_provider.dart';
import './table_attendance_body.dart';

class TableAttendance extends StatefulWidget {
  @override
  _TableAttendanceState createState() => _TableAttendanceState();
}

class _TableAttendanceState extends State<TableAttendance> {
  Future<List<AbsensiModel>> absensiMonthly;
  DateTime now;
  @override
  void initState() {
    now = DateTime.now();
    absensiMonthly = getAbsenMonthly(context.read<UserProvider>().user.idUser, now);
    super.initState();
  }

  Future<List<AbsensiModel>> getAbsenMonthly(String idUser, DateTime now) async {
    final result = absensiAPI.getAbsenMonthly(idUser: idUser, dateTime: now);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuild Table Attendance");
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.angleLeft),
                onPressed: () {},
              ),
              Text(
                globalF.formatYearMonth(DateTime.now(), type: 3),
                style: appTheme.subtitle1(context),
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.angleRight),
                onPressed: () {},
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
                color: Colors.amber,
                padding: const EdgeInsets.all(8.0),
                child: DefaultTextStyle(
                  style: appTheme.button(context),
                  child: Row(
                    children: [
                      const Flexible(child: Text('Tanggal'), fit: FlexFit.tight, flex: 2),
                      const Flexible(child: Text('Datang'), fit: FlexFit.tight),
                      const Flexible(child: Text('Pulang'), fit: FlexFit.tight),
                      const Flexible(child: Text('Durasi'), fit: FlexFit.tight),
                    ],
                  ),
                ),
              ),
              Consumer<ZAbsenProvider>(
                builder: (_, provider, __) => FutureBuilder(
                  future: provider.fetchAbsenMonthly(context.read<UserProvider>().user.idUser, now),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    print("PANJANG TABLE ATTENDANCE ${provider.tableAttendance.length}");
                    if (snapshot.connectionState != ConnectionState.done)
                      return LoadingFutureBuilder(isLinearProgressIndicator: true);
                    if (snapshot.hasError)
                      return RaisedButton(
                        onPressed: () {
                          setState(() {
                            absensiMonthly =
                                getAbsenMonthly(context.read<UserProvider>().user.idUser, now);
                          });
                        },
                        child: Text(snapshot.error.toString()),
                      );
                    if (snapshot.hasData) {
                      return Container(
                        child: ListView.builder(
                          itemCount: provider.tableAttendance.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (BuildContext context, int index) {
                            final result = provider.tableAttendance[index];
                            return TableAttendanceBody(index: index, now: now, result: result);
                          },
                        ),
                      );
                    }
                    return Text('no data');
                  },
                ),
              ),
            ],
          ),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }
}
