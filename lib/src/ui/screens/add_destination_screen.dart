import 'dart:async';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_template/global_template.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:z_absen/src/providers/user_provider.dart';

import '../../providers/zabsen_provider.dart';

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
            // onTap: _destinationRegister,
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (ctx) => Container(
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextFormFieldCustom(
                    controller: _nameDestinationController,
                    onSaved: (value) => '',
                    prefixIcon: Icon(FontAwesomeIcons.fortAwesome),
                    hintText: "Nama Destinasi",
                    autoFocus: true,
                    onFieldSubmitted: (value) => _destinationRegister(value),
                  ),
                ),
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
          Selector<ZAbsenProvider, Position>(
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
              onCameraMove: (position) =>
                  context.read<ZAbsenProvider>().setCameraPosition(position),
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
            context.read<ZAbsenProvider>().currentPosition.latitude,
            context.read<ZAbsenProvider>().currentPosition.longitude,
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

  void _destinationRegister(String nameDestination) async {
    final userProvider = context.read<UserProvider>();
    final absenProvider = context.read<ZAbsenProvider>();
    if (absenProvider.cameraPosition == null) {
      globalF.showToast(message: "Belum Memilih Destinasi", isError: true, isLongDuration: true);
    } else if (nameDestination.isEmpty) {
      globalF.showToast(message: "Nama Destinasi Belum Diisi", isError: true, isLongDuration: true);
    } else {
      try {
        print("Proses Add Destination");
        final result = await userProvider.destinationRegister(
          idUser: userProvider.user.idUser,
          nameDestination: nameDestination,
          latitude: absenProvider.cameraPosition.target.latitude,
          longitude: absenProvider.cameraPosition.target.longitude,
        );
        print("Selesai Add Destination");
        globalF.showToast(message: result, isSuccess: true, isLongDuration: true);
        _nameDestinationController.clear();
        Navigator.of(context).pop();
      } catch (e) {
        globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
      }
    }
  }
}
