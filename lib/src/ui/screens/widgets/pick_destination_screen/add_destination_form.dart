import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:provider/provider.dart';

import '../../../../providers/absen_provider.dart';
import '../../../../providers/maps_provider.dart';
import '../../../../providers/user_provider.dart';

class AddDestinationForm extends StatelessWidget {
  const AddDestinationForm({
    Key key,
    @required TextEditingController nameDestinationController,
  })  : _nameDestinationController = nameDestinationController,
        super(key: key);

  final TextEditingController _nameDestinationController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormFieldCustom(
            controller: _nameDestinationController,
            onSaved: (value) => '',
            prefixIcon: const Icon(Icons.add_location),
            hintText: 'Nama Lokasi Absen',
            autoFocus: true,
          ),
          Row(
            children: [
              const Spacer(),
              FlatButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
              Selector<GlobalProvider, bool>(
                selector: (_, provider) => provider.isLoading,
                builder: (_, isLoading, __) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: isLoading
                        ? const LoadingFutureBuilder(isLinearProgressIndicator: false)
                        : FlatButton(
                            onPressed: () => _destinationRegister(context),
                            child: const Text('Simpan'),
                            color: colorPallete.primaryColor,
                            textTheme: ButtonTextTheme.primary,
                          ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _destinationRegister(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    final mapsProvider = context.read<MapsProvider>();
    final absenProvider = context.read<AbsenProvider>();
    final globalProvider = context.read<GlobalProvider>();
    if (mapsProvider.cameraPosition == null) {
      await globalF.showToast(
          message: 'Belum Memilih Destinasi', isError: true, isLongDuration: true);
    } else if (_nameDestinationController.text.isEmpty) {
      await globalF.showToast(
          message: 'Nama Destinasi Belum Diisi', isError: true, isLongDuration: true);
    } else {
      try {
        globalProvider.setLoading(true);
        final result = await absenProvider.destinationRegister(
          idUser: userProvider.user.idUser,
          nameDestination: _nameDestinationController.text,
          latitude: mapsProvider.cameraPosition.target.latitude,
          longitude: mapsProvider.cameraPosition.target.longitude,
        );
        await globalF.showToast(message: result, isSuccess: true, isLongDuration: true);
        _nameDestinationController.clear();
        globalProvider.setLoading(false);

        Navigator.of(context).pop();
      } catch (e) {
        await globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
        globalProvider.setLoading(false);
      }
    }
  }
}
