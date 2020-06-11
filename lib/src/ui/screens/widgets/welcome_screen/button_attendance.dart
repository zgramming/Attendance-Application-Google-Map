import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:network/network.dart';
import 'package:provider/provider.dart';

import '../../../../providers/absen_provider.dart';
import '../../../../providers/maps_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../maps_screen.dart';
import '../../shimmer/shimmer_button_absent.dart';
import '../live_clock.dart';

class ButtonAttendance extends StatefulWidget {
  const ButtonAttendance({
    this.onTapAbsen,
    this.onTapPulang,
    this.backgroundColor = Colors.white,
  });
  final Function onTapAbsen;
  final Function onTapPulang;
  final Color backgroundColor;
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
    alreadyAbsen = checkAlreadyAbsent();
  }

  Future<int> checkAlreadyAbsent() async {
    final result = absensiAPI.checkAbsenMasukDanPulang(
      idUser: context.read<UserProvider>().user.idUser,
      tanggalAbsenMasuk: DateTime(now.year, now.month, now.day),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: alreadyAbsen,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return ShimmerButtonAttendance();
        }
        if (snapshot.hasError) {
          return InkWell(
            onTap: () {
              alreadyAbsen = checkAlreadyAbsent();
              setState(() {});
            },
            child: Text(
              '${snapshot.error.toString()} , Tap Untuk Refresh Data',
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
                  children: const <Widget>[
                    Text(
                      'Absen Masuk',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
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
                        builder: (_, isLoading, __) {
                          return ButtonCustom(
                            onPressed: isLoading
                                ? null
                                : (snapshot.data == 2)
                                    ? null
                                    : (snapshot.data == 1) ? null : widget.onTapAbsen ?? goToMaps,
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: isLoading ? const Text('Loading...') : LiveClock(),
                          );
                        },
                      ),
                    ),
                    Flexible(
                      child: Selector<GlobalProvider, bool>(
                        selector: (_, provider) => provider.isLoading,
                        builder: (_, isLoading, __) {
                          return ButtonCustom(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: isLoading ? const Text('Loading...') : LiveClock(),
                            onPressed: isLoading
                                ? null
                                : (snapshot.data == 2)
                                    ? null
                                    : (snapshot.data != 1) ? null : widget.onTapPulang ?? goToMaps,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const Text('No Data');
      },
    );
  }

  Future<void> goToMaps() async {
    final globalProvider = context.read<GlobalProvider>();
    final absenProvider = context.read<AbsenProvider>();
    final userProvider = context.read<UserProvider>();
    final mapsProvider = context.read<MapsProvider>();
    try {
      globalProvider.setLoading(true);
      await mapsProvider.getCurrentPosition();
      await absenProvider.saveSelectedDestinationUser(userProvider.user.idUser, isSelected: 't');
      globalProvider.setLoading(false);
      await Navigator.of(context).pushNamed(MapScreen.routeNamed);
    } catch (e) {
      await globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
      globalProvider.setLoading(false);
    }
  }
}
