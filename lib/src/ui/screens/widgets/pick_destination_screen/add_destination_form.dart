import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../providers/user_provider.dart';
import '../../../../providers/maps_provider.dart';
import '../../../../providers/absen_provider.dart';

class AddDestinationForm extends StatelessWidget {
  const AddDestinationForm({
    Key key,
    @required TextEditingController nameDestinationController,
  })  : _nameDestinationController = nameDestinationController,
        super(key: key);

  final TextEditingController _nameDestinationController;

  @override
  Widget build(BuildContext context) {
    print("Widget : PickDestinationScreen/AddDestinationForm.dart  | Rebuild !");

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormFieldCustom(
            controller: _nameDestinationController,
            onSaved: (value) => '',
            prefixIcon: Icon(FontAwesomeIcons.fortAwesome),
            hintText: "Nama Destinasi",
            autoFocus: true,
          ),
          Row(
            children: [
              Spacer(),
              FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text('Batal')),
              Selector<GlobalProvider, bool>(
                selector: (_, provider) => provider.isLoading,
                builder: (_, isLoading, __) {
                  print(
                      "Widget : PickDestinationScreen/AddDestinationForm.dart |Selector  | Rebuild !");

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: isLoading
                        ? LoadingFutureBuilder(isLinearProgressIndicator: false)
                        : FlatButton(
                            onPressed: () => _destinationRegister(context),
                            child: Text('Simpan'),
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

  void _destinationRegister(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    final mapsProvider = context.read<MapsProvider>();
    final absenProvider = context.read<AbsenProvider>();
    final globalProvider = context.read<GlobalProvider>();
    if (mapsProvider.cameraPosition == null) {
      globalF.showToast(message: "Belum Memilih Destinasi", isError: true, isLongDuration: true);
    } else if (_nameDestinationController.text.isEmpty) {
      globalF.showToast(message: "Nama Destinasi Belum Diisi", isError: true, isLongDuration: true);
    } else {
      try {
        globalProvider.setLoading(true);
        print("Proses Add Destination");
        final result = await absenProvider.destinationRegister(
          idUser: userProvider.user.idUser,
          nameDestination: _nameDestinationController.text,
          latitude: mapsProvider.cameraPosition.target.latitude,
          longitude: mapsProvider.cameraPosition.target.longitude,
        );
        print("Selesai Add Destination");
        globalF.showToast(message: result, isSuccess: true, isLongDuration: true);
        _nameDestinationController.clear();
        globalProvider.setLoading(false);

        Navigator.of(context).pop();
      } catch (e) {
        globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
        globalProvider.setLoading(false);
      }
    }
  }
}
