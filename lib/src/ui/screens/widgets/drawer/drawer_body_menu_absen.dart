import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:network/network.dart';
import 'package:provider/provider.dart';

import '../../../../providers/absen_provider.dart';
import '../../../../providers/maps_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../maps_screen.dart';
import './drawer_body_menu.dart';

class DrawerBodyMenuAbsen extends StatefulWidget {
  const DrawerBodyMenuAbsen({
    Key key,
  }) : super(key: key);

  @override
  _DrawerBodyMenuAbsenState createState() => _DrawerBodyMenuAbsenState();
}

class _DrawerBodyMenuAbsenState extends State<DrawerBodyMenuAbsen> {
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
      tanggalAbsenMasuk: DateTime(
        now.year,
        now.month,
        now.day,
      ),
    );
    return result;
  }

  //* Pengertian Dari Output Snapshot.data
  //* 1 == Anda Sudah Absen Hari Ini
  //* 2 == Anda Sudah Selesai Bekerja
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: alreadyAbsen,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LinearProgressIndicator();
        }
        if (snapshot.hasError) {
          return InkWell(
            onTap: _refreshMenuAbsen,
            child: Text(
              '${snapshot.error.toString()} , Tap Untuk Refresh Data',
              textAlign: TextAlign.center,
            ),
          );
        }
        if (snapshot.hasData) {
          return Column(
            children: [
              Selector<GlobalProvider, bool>(
                selector: (_, provider) => provider.isLoading,
                builder: (_, isLoading, __) {
                  return DrawerBodyMenu(
                    wordUppercase: 'M',
                    singleWordUppercase: true,
                    subtitle: isLoading ? 'Loading...' : 'Absen Masuk',
                    onTap: isLoading
                        ? null
                        : (snapshot.data == 2) ? null : (snapshot.data == 1) ? null : onTapAbsen,
                  );
                },
              ),
              Selector<GlobalProvider, bool>(
                selector: (_, provider) => provider.isLoading,
                builder: (_, isLoading, __) {
                  return DrawerBodyMenu(
                    wordUppercase: 'P',
                    singleWordUppercase: true,
                    subtitle: isLoading ? 'Loading...' : 'Absen Pulang',
                    onTap: isLoading
                        ? null
                        : (snapshot.data == 2) ? null : (snapshot.data != 1) ? null : onTapPulang,
                  );
                },
              ),
            ],
          );
        }
        return const Text('No Data');
      },
    );
  }

  Future<void> onTapAbsen() async {
    //! Membuat Button Menjadi Disable , Untuk Prevent Double Click
    context.read<GlobalProvider>().setLoading(true);
    try {
      await context.read<MapsProvider>().getCurrentPosition();
      await context
          .read<AbsenProvider>()
          .saveSelectedDestinationUser(context.read<UserProvider>().user.idUser)
          .then((_) => context.read<GlobalProvider>().setLoading(false))
          .then((_) => Navigator.of(context).pushNamed(MapScreen.routeNamed));
    } catch (e) {
      await globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
      context.read<GlobalProvider>().setLoading(false);
    }
  }

  Future<void> onTapPulang() async {
    context.read<GlobalProvider>().setLoading(true);
    try {
      await context.read<MapsProvider>().getCurrentPosition();
      await context
          .read<AbsenProvider>()
          .saveSelectedDestinationUser(context.read<UserProvider>().user.idUser)
          .then((_) => context.read<GlobalProvider>().setLoading(false))
          .then((_) => Navigator.of(context).pushNamed(MapScreen.routeNamed));
    } catch (e) {
      await globalF.showToast(message: e.toString(), isError: true);
      context.read<GlobalProvider>().setLoading(false);
    }
  }

  void _refreshMenuAbsen() {
    alreadyAbsen = checkAlreadyAbsent();
    setState(() {});
  }
}
