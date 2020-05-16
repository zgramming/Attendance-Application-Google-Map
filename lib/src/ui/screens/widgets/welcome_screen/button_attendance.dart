import 'package:network/network.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';

import '../live_clock.dart';

import '../../maps_screen.dart';

import '../../../../providers/user_provider.dart';
import '../../../../providers/zabsen_provider.dart';

class ButtonAttendance extends StatefulWidget {
  final Function onTapAbsen;
  final Function onTapPulang;
  final Color backgroundColor;
  ButtonAttendance({
    this.onTapAbsen,
    this.onTapPulang,
    this.backgroundColor = Colors.white,
  });
  @override
  _ButtonAttendanceState createState() => _ButtonAttendanceState();
}

class _ButtonAttendanceState extends State<ButtonAttendance> {
  DateTime now;
  Future<int> alreadyAbsen;
  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    alreadyAbsen = checkAlreadyAbsent(context.read<UserProvider>().user.idUser);
    print("Button Attendance User ${context.read<UserProvider>().user.idUser}");
  }

  Future<int> checkAlreadyAbsent(String idUser) async {
    final result = absensiAPI.checkAbsenMasukDanPulang(
        idUser: idUser, tanggalAbsenMasuk: DateTime(now.year, now.month, now.day));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuild Button Attendance Screen");

    return FutureBuilder<int>(
      future: alreadyAbsen,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return LinearProgressIndicator();
        }
        if (snapshot.hasError) {
          return InkWell(
            onTap: () {
              alreadyAbsen = checkAlreadyAbsent(context.read<UserProvider>().user.idUser);
              setState(() {});
            },
            child: Text(
              "${snapshot.error.toString()} , Tap Untuk Refresh Data",
              textAlign: TextAlign.center,
            ),
          );
        }
        if (snapshot.hasData) {
          return Card(
            color: widget.backgroundColor,
            elevation: 0,
            child: Column(
              children: [
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text(
                      'Absen Masuk',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Absen Pulang',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Flexible(
                      child: Selector<GlobalProvider, bool>(
                        selector: (_, provider) => provider.isLoading,
                        builder: (_, isLoading, __) => ButtonCustom(
                          onPressed: isLoading
                              ? null
                              : (snapshot.data == 2)
                                  ? null
                                  : (snapshot.data == 1) ? null : widget.onTapAbsen ?? onTapAbsen,
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: LiveClock(),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Selector<GlobalProvider, bool>(
                        selector: (_, provider) => provider.isChangeMode,
                        builder: (context, isLoading, child) => ButtonCustom(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: LiveClock(),
                          onPressed: isLoading
                              ? null
                              : (snapshot.data == 2)
                                  ? null
                                  : (snapshot.data != 1) ? null : widget.onTapPulang ?? onTapPulang,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return Text('No Data');
      },
    );
  }

  void onTapAbsen() async {
    //! Membuat Button Menjadi Disable , Untuk Prevent Double Click
    context.read<GlobalProvider>().setLoading(true);
    // Future.delayed(Duration(seconds: 4), () => context.read<GlobalProvider>().setLoading(false));
    try {
      print('Proses Mendapatkan Initial Position');
      await context.read<ZAbsenProvider>().getCurrentPosition();
      print('Proses Menyimpan Destinasi User');
      await context
          .read<ZAbsenProvider>()
          .saveDestinasiUser(context.read<UserProvider>().user.idUser)
          .then((_) => context.read<GlobalProvider>().setLoading(false))
          .then((_) => Navigator.of(context).pushNamed(MapScreen.routeNamed));
      print("Proses Perpindahan Screen");
    } catch (e) {
      globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
      context.read<GlobalProvider>().setLoading(false);
    }
  }

  void onTapPulang() async {
    context.read<GlobalProvider>().setLoading(true);
    try {
      await context.read<ZAbsenProvider>().getCurrentPosition();
      await context
          .read<ZAbsenProvider>()
          .saveDestinasiUser(context.read<UserProvider>().user.idUser)
          .then((_) => context.read<GlobalProvider>().setLoading(false))
          .then((_) => Navigator.of(context).pushNamed(MapScreen.routeNamed));
    } catch (e) {
      globalF.showToast(message: e, isError: true);
      context.read<GlobalProvider>().setLoading(false);
    }
  }
}
