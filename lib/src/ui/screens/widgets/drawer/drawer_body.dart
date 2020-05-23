import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './drawer_body_menu.dart';
import './drawer_body_title.dart';
import './drawer_body_menu_absen.dart';

import '../../login_screen.dart';
import '../../user_profil_screen.dart';

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
        DrawerBodyMenu(
          icon: FontAwesomeIcons.fortAwesome,
          subtitle: "Tambah Destinasi",
        ),
        DrawerBodyMenu(
          icon: FontAwesomeIcons.mapMarkerAlt,
          subtitle: "Pilih Destinasi",
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
}
