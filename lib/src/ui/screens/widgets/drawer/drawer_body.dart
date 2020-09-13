import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_template/global_template.dart';
import 'package:provider/provider.dart';

import '../../../../providers/maps_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../add_destination_screen.dart';
import '../../login_screen.dart';
import '../../pick_destination_screen.dart';
import '../../user_profil_screen.dart';
import './drawer_body_menu.dart';
import './drawer_body_menu_absen.dart';
import './drawer_body_title.dart';

class DrawerBody extends StatelessWidget {
  const DrawerBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        const DrawerBodyTitle(title: 'Absen'),
        const DrawerBodyMenuAbsen(),
        const DrawerBodyTitle(title: 'Destinasi'),
        Selector<GlobalProvider, bool>(
          selector: (_, provider) => provider.isLoading,
          builder: (_, isLoading, __) {
            return Visibility(
              child: DrawerBodyMenu(
                icon: Icons.add_location,
                subtitle: isLoading ? 'Loading...' : 'Tambah Lokasi Absen',
                onTap: isLoading ? null : () => goToAddDestination(context),
              ),
            );
          },
        ),
        DrawerBodyMenu(
          icon: FontAwesomeIcons.searchLocation,
          subtitle: 'Pilih Lokasi Absen ',
          onTap: () => Navigator.of(context).pushNamed(PickDestinationScreen.routeNamed),
        ),
        const DrawerBodyTitle(title: 'Akun'),
        Visibility(
          visible: false,
          child: DrawerBodyMenu(
            icon: FontAwesomeIcons.user,
            subtitle: 'Profil',
            onTap: () => Navigator.of(context).pushNamed(UserProfilScreen.routeNamed),
          ),
        ),
        DrawerBodyMenu(
          icon: FontAwesomeIcons.userTimes,
          subtitle: 'Hapus Akun',
          onTap: () => _userDelete(context),
        ),
        DrawerBodyMenu(
          icon: FontAwesomeIcons.signOutAlt,
          subtitle: 'Keluar',
          onTap: () => _userLogout(context),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }

  Future<void> _userLogout(BuildContext context) async {
    await context.read<UserProvider>().removeSessionUser();
    await Navigator.of(context).pushReplacementNamed(LoginScreen.routeNamed);
  }

  Future<void> _userDelete(BuildContext context) async {
    await context.read<UserProvider>().userDelete(idUser: context.read<UserProvider>().user.idUser);
    await context.read<UserProvider>().removeSessionUser();
    await Navigator.of(context).pushReplacementNamed(LoginScreen.routeNamed);
  }

  Future<void> goToAddDestination(BuildContext context) async {
    context.read<GlobalProvider>().setLoading(true);
    try {
      await context.read<MapsProvider>().getCurrentPosition();
      context.read<GlobalProvider>().setLoading(false);
      await Navigator.of(context).pushNamed(AddDestinationScreen.routeNamed);
    } catch (e) {
      await globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
      context.read<GlobalProvider>().setLoading(false);
    }
  }
}
