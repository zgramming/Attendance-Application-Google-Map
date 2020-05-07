import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:global_template/global_template.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../function/common_function.dart';
import '../../providers/zabsen_provider.dart';

import './widgets/live_clock.dart';

class MapScreen extends StatefulWidget {
  static const routeNamed = "/map-screen";
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  double tujuanLatitude = -6.1767733;
  double tujuanLongitude = 106.9955114;
  double radiusCircle = 3.5;
  void getLocation(ZAbsenProvider provider) async {
    Location location = Location();
    location.changeSettings(interval: 1000);
    location.onLocationChanged.listen((currentLocation) {
      if (currentLocation == null) {
        return null;
      }
      provider.setTrackingLocation(currentLocation);
    });
  }

  Future<void> _gotToCenterUser(ZAbsenProvider provider) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
              provider.currentPosition.latitude ?? 3, provider.currentPosition.longitude ?? 3),
          zoom: 20.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: ConstrainedBox(
          constraints: BoxConstraints(minHeight: sizes.height(context)),
          child: Stack(
            children: [
              Consumer<ZAbsenProvider>(
                builder: (_, absenProvider, __) {
                  final distanceTwoLocation = commonF.getDistanceLocation(
                    absenProvider.currentPosition.latitude,
                    absenProvider.currentPosition.longitude,
                    tujuanLatitude,
                    tujuanLongitude,
                  );
                  print(
                      "Jarak $distanceTwoLocation || Lokasi Saya ${absenProvider.currentPosition}");
                  return GoogleMap(
                    circles: Set.of({
                      Circle(
                        circleId: CircleId('1'),
                        strokeColor: Colors.transparent,
                        fillColor: commonF
                            .changeColorRadius(distanceTwoLocation, radiusCircle)
                            .withOpacity(.8),
                        center: LatLng(tujuanLatitude, tujuanLongitude),
                        radius: radiusCircle,
                      ),
                    }),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(absenProvider.currentPosition.latitude,
                          absenProvider.currentPosition.longitude),
                      zoom: 14.4746,
                    ),
                    onMapCreated: (controller) {
                      getLocation(absenProvider);
                      _gotToCenterUser(absenProvider);
                      _controller.complete(controller);
                    },
                    myLocationEnabled: true,
                    // myLocationButtonEnabled: true,
                  );
                },
              ),
              Positioned(
                child: Card(
                  // color: Colors.transparent,
                  elevation: 0,
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text("Absen Datang"),
                          Text('Absen Pulang'),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      ),
                      SizedBox(height: 5),
                      Consumer<ZAbsenProvider>(
                        builder: (_, absenProvider, __) {
                          final distanceTwoLocation = commonF.getDistanceLocation(
                            absenProvider.currentPosition.latitude,
                            absenProvider.currentPosition.longitude,
                            tujuanLatitude,
                            tujuanLongitude,
                          );
                          return Row(
                            children: [
                              Flexible(
                                child: ButtonCustom(
                                  onPressed: distanceTwoLocation < radiusCircle ? () => '' : null,
                                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                                  child: LiveClock(),
                                ),
                              ),
                              Flexible(
                                child: ButtonCustom(
                                  padding: EdgeInsets.symmetric(horizontal: 6.0),
                                  child: LiveClock(),
                                  onPressed: distanceTwoLocation < radiusCircle ? () => '' : null,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
                bottom: 30,
                left: 10,
                right: 50,
              ),
              Positioned(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    // realTimePosition.cancel();
                  },
                  child: CircleAvatar(
                    backgroundColor: colorPallete.white,
                    child: Icon(FontAwesomeIcons.times),
                  ),
                ),
                top: 50,
                left: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
