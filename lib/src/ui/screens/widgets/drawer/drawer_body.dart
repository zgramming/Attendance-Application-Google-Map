import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './drawer_body_menu.dart';
import './drawer_body_title.dart';
import './drawer_body_menu_absen.dart';

import '../../login_screen.dart';
import '../../user_profil_screen.dart';
import '../../add_destination_screen.dart';

import '../../../../providers/zabsen_provider.dart';
import '../../../../providers/user_provider.dart';

class DrawerBody extends StatelessWidget {
  const DrawerBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        DrawerBodyTitle(title: "Absen"),
        DrawerBodyMenuAbsen(),
        DrawerBodyTitle(title: "Destinasi"),
        Selector<GlobalProvider, bool>(
          selector: (_, provider) => provider.isLoading,
          builder: (_, isLoading, __) => DrawerBodyMenu(
            icon: FontAwesomeIcons.fortAwesome,
            subtitle: isLoading ? "Loading..." : "Tambah Destinasi",
            onTap: isLoading ? null : () => goToAddDestination(context),
          ),
        ),
        DrawerBodyMenu(
          icon: FontAwesomeIcons.mapMarkerAlt,
          subtitle: "Pilih Destinasi ",
          onTap: () => Navigator.of(context).pushNamed(AddDestinationScreen.routeNamed),
        ),
        DrawerBodyTitle(title: "Akun"),
        DrawerBodyMenu(
          icon: FontAwesomeIcons.user,
          subtitle: "Profil",
          onTap: () => Navigator.of(context).pushNamed(UserProfilScreen.routeNamed),
        ),
        DrawerBodyMenu(
          icon: FontAwesomeIcons.userTimes,
          subtitle: "Hapus Akun",
          onTap: () async {
            print("Proses Delete User");
            await context
                .read<UserProvider>()
                .userDelete(idUser: context.read<UserProvider>().user.idUser);
            print("Proses Hapus Session User");
            await context.read<UserProvider>().removeSessionUser();
            print("Proses Pindah Halaman");
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeNamed);
          },
        ),
        DrawerBodyMenu(
          icon: FontAwesomeIcons.signOutAlt,
          subtitle: "Keluar",
          onTap: () async {
            print("Proses Perpindahan Hlaman");
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeNamed);
          },
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }

  void goToAddDestination(BuildContext context) async {
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
          .then((_) => Navigator.of(context).pushNamed(AddDestinationScreen.routeNamed));
    } catch (e) {
      globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
      context.read<GlobalProvider>().setLoading(false);
    }
  }
}
