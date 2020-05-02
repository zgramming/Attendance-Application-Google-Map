import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:global_template/global_template.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../providers/zabsen_provider.dart';

class MapScreen extends StatefulWidget {
  static const routeNamed = "/map-screen";
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Geolocator geolocator;
  Completer<GoogleMapController> _controller = Completer();

  GoogleMapController mapController;
  // static Position currentPosition = Position(latitude: 0, longitude: 0);
  // StreamSubscription<Position> realTimePosition;
  // static double latitude_current = 31.9414246;
  // static double longitude_current = 35.8880857;
  @override
  void initState() {
    // geolocator = Geolocator();
    super.initState();
  }

  void getLocation(ZAbsenProvider provider) async {
    Location location = Location();
    location.changeSettings(accuracy: LocationAccuracy.high, interval: 1000, distanceFilter: 0);
    location.onLocationChanged.listen((currentLocation) {
      if (currentLocation == null) {
        return null;
      }
      provider.setTrackingLocation(currentLocation);
      print('Halooooooo $currentLocation');
    });
    // _gotToCenterUser(provider);
    // final locationOption = LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 500);
    // realTimePosition = geolocator.getPositionStream(locationOption).listen((position) {
    //   if (position == null) {
    //     currentPosition = Position(latitude: 0, longitude: 0);
    //   }
    // setState(() {
    //   currentPosition = position;
    //   print(currentPosition);
    //   _gotToCenterUser();
    // });
    // });
  }

  // static final CameraPosition _centerLocationUser = CameraPosition(
  //   target: LatLng(latitude_current, longitude_current),
  //   zoom: 17.5,
  // );

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
    print('goto Center');
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
                builder: (_, absenProvider, __) => GoogleMap(
                  circles: Set.of({
                    Circle(
                      circleId: CircleId('1'),
                      strokeColor: Colors.red,
                      fillColor: Colors.blue.withOpacity(.5),
                      center: LatLng(absenProvider.currentPosition.latitude,
                          absenProvider.currentPosition.longitude),
                      radius: 20,
                    ),
                    Circle(
                      circleId: CircleId('2'),
                      strokeColor: Colors.transparent,
                      fillColor: Colors.green.withOpacity(.5),
                      center: LatLng(-6.245117, 106.933738),
                      radius: 1000,
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
                ),
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
                      Row(
                        children: [
                          Flexible(
                            child: ButtonCustom(
                              onPressed: () => '',
                              // Navigator.of(context).pushNamed(MapScreen.routeNamed),
                              padding: EdgeInsets.symmetric(horizontal: 6.0),
                              buttonTitle: globalF.formatHoursMinutesSeconds(DateTime.now()),
                            ),
                          ),
                          Flexible(
                            child: ButtonCustom(
                              padding: EdgeInsets.symmetric(horizontal: 6.0),
                              buttonTitle: globalF.formatHoursMinutesSeconds(DateTime.now()),
                              onPressed: () => '',
                            ),
                          ),
                        ],
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
