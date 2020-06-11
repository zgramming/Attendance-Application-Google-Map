import 'package:network/network.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../providers/absen_provider.dart';
import '../../../../providers/user_provider.dart';

class ListDestination extends StatelessWidget {
  const ListDestination({
    Key key,
    @required this.result,
  }) : super(key: key);

  final DestinasiModel result;
  static const sizeIcon = 14.0;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: const ShowImageNetwork(
          imageUrl: AppConfig.defaultImageNetwork,
          fit: BoxFit.cover,
          isCircle: true,
          imageCircleRadius: 30,
        ),
        // leading: Text(result.image.length),
        title: Text(
          result.namaDestinasi,
          style: appTheme.subtitle2(context).copyWith(fontWeight: FontWeight.bold),
        ),
        trailing: Wrap(
          spacing: 5,
          children: [
            InkWell(
              onTap: () => _destinationUpdateStatus(context, result.idDestinasi),
              child: CircleAvatar(
                radius: sizeIcon,
                backgroundColor: colorPallete.green,
                foregroundColor: colorPallete.white,
                child: const Icon(FontAwesomeIcons.check, size: sizeIcon),
              ),
            ),
            InkWell(
              onTap: () => _destinationDelete(context, result.idDestinasi),
              child: CircleAvatar(
                radius: sizeIcon,
                foregroundColor: colorPallete.white,
                backgroundColor: colorPallete.red,
                child: const Icon(FontAwesomeIcons.trash, size: sizeIcon),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _destinationUpdateStatus(BuildContext context, String idDestinasi) async {
    final absenProvider = context.read<AbsenProvider>();
    final globalProvider = context.read<GlobalProvider>();
    final userProvider = context.read<UserProvider>();
    try {
      globalProvider.setLoading(true);
      final result = await absenProvider.destinationUpdateStatus(
        idDestinasi: idDestinasi,
        idUser: userProvider.user.idUser,
      );
      globalProvider.setLoading(false);
      await globalF.showToast(message: result, isSuccess: true);
    } catch (e) {
      await globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
      globalProvider.setLoading(false);
    }
  }

  Future<void> _destinationDelete(BuildContext context, String idDestinasi) async {
    final absenProvider = context.read<AbsenProvider>();
    final globalProvider = context.read<GlobalProvider>();
    try {
      globalProvider.setLoading(true);
      final result = await absenProvider.destinationDelete(idDestinasi);
      globalProvider.setLoading(false);
      await globalF.showToast(message: result, isSuccess: true);
    } catch (e) {
      await globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
    }
  }
}
