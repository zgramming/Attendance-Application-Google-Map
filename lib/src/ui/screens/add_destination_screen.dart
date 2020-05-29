import 'dart:async';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_template/global_template.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './widgets/pick_destination_screen/add_destination_form.dart';

import '../../providers/maps_provider.dart';

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
        title: const Text('Tambah Lokasi'),
        actions: [
          InkWell(
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (_) => AddDestinationForm(
                nameDestinationController: _nameDestinationController,
              ),
            ),
            child: const Padding(
              padding: const EdgeInsets.only(right: 16.0),
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
              onCameraMove: (position) =>
                  context.read<MapsProvider>().setTrackingCameraPosition(position),
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
                onChanged: _onChangedSearcAddress,
                prefixIcon: Icon(
                  FontAwesomeIcons.searchLocation,
                  size: 18,
                ),
                suffixIcon: Selector<GlobalProvider, bool>(
                  selector: (_, provider) => provider.isShowClearTextField,
                  builder: (_, showClearTextField, __) => showClearTextField
                      ? IconButton(
                          icon: Icon(FontAwesomeIcons.times),
                          onPressed: _clearSearchAddress,
                          iconSize: 18,
                        )
                      : SizedBox(),
                ),
                textInputAction: TextInputAction.search,
                hintText: "Cari Lokasi Absen...",
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

  void _onChangedSearcAddress(String value) {
    final globalProvider = context.read<GlobalProvider>();
    if (value.isEmpty) {
      globalProvider.setShowClearTextField(false);
    } else {
      globalProvider.setShowClearTextField(true);
    }
  }

  void _clearSearchAddress() {
    _searchAddressController.clear();
    context.read<GlobalProvider>().setShowClearTextField(false);
  }
}
