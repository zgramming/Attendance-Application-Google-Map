import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_template/global_template.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/maps_provider.dart';

import './widgets/pick_destination_screen/add_destination_form.dart';
import './widgets/pick_destination_screen/input_text_search_address.dart';

class AddDestinationScreen extends StatefulWidget {
  static const String routeNamed = '/add-destination-screen';
  @override
  _AddDestinationScreenState createState() => _AddDestinationScreenState();
}

class _AddDestinationScreenState extends State<AddDestinationScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchLocationController = TextEditingController();
  final TextEditingController _nameDestinationController = TextEditingController();

  static const double markerSize = 40;
  static const double iconTimesSize = 18;
  static const double iconActionAppbarSize = 18.0;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void dispose() {
    _searchLocationController.dispose();
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
            onTap: () => showModalBottomSheet<dynamic>(
              context: context,
              builder: (_) => AddDestinationForm(
                nameDestinationController: _nameDestinationController,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                FontAwesomeIcons.check,
                size: iconActionAppbarSize,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Selector<MapsProvider, Position>(
            selector: (_, provider) => provider.currentPosition,
            builder: (_, position, __) {
              return GoogleMap(
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
                onCameraIdle: () => print('Stop Camera'),
              );
            },
          ),
          Positioned(
            child: Icon(
              FontAwesomeIcons.mapMarkerAlt,
              color: colorPallete.primaryColor,
              size: markerSize,
            ),
            top: (sizes.height(context) - markerSize - kToolbarHeight) / 2.25,
            right: (sizes.width(context) - markerSize) / 2,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: InputTextSearchAddress(
              searchLocationController: _searchLocationController,
              iconTimesSize: iconTimesSize,
              completer: _controller,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _gotToCenterUser() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
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
}
