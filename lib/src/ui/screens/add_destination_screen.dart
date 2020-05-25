import 'dart:async';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_template/global_template.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../providers/maps_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/absen_provider.dart';

class AddDestinationScreen extends StatefulWidget {
  static const routeNamed = "/add-destination-screen";
  @override
  _AddDestinationScreenState createState() => _AddDestinationScreenState();
}

class _AddDestinationScreenState extends State<AddDestinationScreen> {
  Completer<GoogleMapController> _controller = Completer();

  TextEditingController _searchAddressController = TextEditingController();
  TextEditingController _nameDestinationController = TextEditingController();

  double iconSize = 40;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  void dispose() {
    _searchAddressController.dispose();
    _nameDestinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Destinasi'),
        actions: [
          InkWell(
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (_) => AddDestinationForm(
                nameDestinationController: _nameDestinationController,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                FontAwesomeIcons.check,
                size: 18.0,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Selector<MapsProvider, Position>(
            selector: (_, provider) => provider.currentPosition,
            builder: (_, position, __) => GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 20,
              ),
              onMapCreated: (controller) async {
                _controller.complete(controller);
                await _gotToCenterUser();
              },
              onCameraMove: (position) => context.read<MapsProvider>().setCameraPosition(position),
              onCameraIdle: () => print("Stop Camera"),
            ),
          ),
          Positioned(
            child: Icon(
              FontAwesomeIcons.mapMarkerAlt,
              color: colorPallete.primaryColor,
              size: iconSize,
            ),
            top: (sizes.height(context) - iconSize - kToolbarHeight) / 2.25,
            right: (sizes.width(context) - iconSize) / 2,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: kToolbarHeight, right: 40, left: 40),
              child: TextFormFieldCustom(
                controller: _searchAddressController,
                onSaved: (value) => print(value),
                onFieldSubmitted: (value) => _moveCameraByAddress(value),
                prefixIcon: Icon(
                  FontAwesomeIcons.searchLocation,
                  size: 18,
                ),
                suffixIcon: IconButton(
                  icon: Icon(FontAwesomeIcons.times),
                  onPressed: () => _searchAddressController.clear(),
                  iconSize: 18,
                ),
                textInputAction: TextInputAction.search,
                hintText: "Ayo Cari Destinasimu...",
                disableOutlineBorder: false,
                hintStyle: appTheme.caption(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _gotToCenterUser() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            context.read<MapsProvider>().currentPosition.latitude,
            context.read<MapsProvider>().currentPosition.longitude,
          ),
          zoom: 20,
        ),
      ),
    );
  }

  void _moveCameraByAddress(String address) async {
    try {
      List<Placemark> placemark = await Geolocator().placemarkFromAddress(address.toLowerCase());
      if (placemark != null) {
        final GoogleMapController controller = await _controller.future;
        Position position = placemark[0].position;
        controller
            .animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
        print(placemark[0].toJson());
      } else {
        throw "Destinasi Tidak Ditemukan";
      }
    } on PlatformException catch (err) {
      if (err.code == "ERROR_GEOCODNG_ADDRESSNOTFOUND") {
        globalF.showToast(
            message: "Destinasi Tidak Ditemukan", isError: true, isLongDuration: true);
      } else {
        globalF.showToast(message: err.code, isError: true, isLongDuration: true);
      }
      print(err);
    } catch (e) {
      globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
    }
  }
}

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
                builder: (_, isLoading, __) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: isLoading
                      ? LoadingFutureBuilder(isLinearProgressIndicator: false)
                      : FlatButton(
                          onPressed: () => _destinationRegister(context),
                          child: Text('Simpan'),
                          color: colorPallete.primaryColor,
                          textTheme: ButtonTextTheme.primary,
                        ),
                ),
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
