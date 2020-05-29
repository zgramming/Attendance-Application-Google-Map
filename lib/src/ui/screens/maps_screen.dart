import 'dart:async';

import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'package:network/network.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_template/global_template.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './widgets/welcome_screen/button_attendance.dart';

import '../screens/welcome_screen.dart';

import '../../function/common_function.dart';
import '../../providers/absen_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/maps_provider.dart';

class MapScreen extends StatefulWidget {
  static const routeNamed = "/map-screen";
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  StreamSubscription<Position> _positionStream;

  double radiusCircle = 10;

  @override
  void initState() {
    trackingLocation();
    super.initState();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    print("Dispose Stream Listen");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuild Maps Screen");
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: ConstrainedBox(
          constraints: BoxConstraints(minHeight: sizes.height(context)),
          child: Stack(
            children: [
              Selector2<MapsProvider, AbsenProvider, Tuple2<Position, DestinasiModel>>(
                selector: (_, provider1, provider2) =>
                    Tuple2(provider1.currentPosition, provider2.destinasiModel),
                builder: (_, value, __) {
                  return GoogleMap(
                    // mapType: MapType.hybrid,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(value.item1.latitude, value.item1.longitude),
                      zoom: 14.4746,
                    ),
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                      _goToCenterUser();
                    },
                    circles: buildCircles(value),
                  );
                },
              ),
              Positioned(
                bottom: 30,
                left: 10,
                right: 50,
                child: Selector2<MapsProvider, AbsenProvider, Tuple2<Position, DestinasiModel>>(
                  selector: (_, provider1, provider2) =>
                      Tuple2(provider1.currentPosition, provider2.destinasiModel),
                  builder: (_, value, __) => ButtonAttendance(
                    onTapAbsen: () => _validateAbsen(
                      distanceTwoLocation: commonF.getDistanceLocation(
                        value.item1,
                        value.item2,
                      ),
                      radius: radiusCircle,
                      isAbsentIn: true,
                    ),
                    backgroundColor: Colors.transparent,
                    onTapPulang: () => _validateAbsen(
                      distanceTwoLocation: commonF.getDistanceLocation(
                        value.item1,
                        value.item2,
                      ),
                      radius: radiusCircle,
                      isAbsentIn: false,
                    ),
                  ),
                ),
              ),
              Positioned(
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: CircleAvatar(
                    backgroundColor: colorPallete.white,
                    child: Icon(FontAwesomeIcons.times),
                  ),
                ),
                top: sizes.statusBarHeight(context) + 10,
                left: 10,
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(top: sizes.statusBarHeight(context) * 4 + 10),
          child: InkWell(
            onTap: _goToCenterUser,
            child: CircleAvatar(
              backgroundColor: colorPallete.white,
              child: Icon(Icons.my_location),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      ),
    );
  }

  Set<Circle> buildCircles(Tuple2<Position, DestinasiModel> value) {
    return Set.of(
      {
        Circle(
          circleId: CircleId('1'),
          strokeColor: Colors.transparent,
          fillColor: commonF
              .changeColorRadius(
                commonF.getDistanceLocation(value.item1, value.item2),
                radiusCircle,
              )
              .withOpacity(.6),
          center: LatLng(
            value.item2.latitude,
            value.item2.longitude,
          ),
          radius: radiusCircle,
        ),
      },
    );
  }

  trackingLocation() {
    var locationOptions = LocationOptions();
    Stream<Position> positionStream = Geolocator().getPositionStream(locationOptions);
    _positionStream = positionStream.listen((Position position) {
      context.read<MapsProvider>().setTrackingLocation(position);
      print(
          "Berhasil Tracking Dengan Hasil Lat=${position.latitude} Long=${position.longitude} Accuracy=${position.accuracy} Speed=${position.speed} Mocked=${position.mocked}");
    }, onError: (error) => print("Error Handling Listen Stream ${error.toString()}"));
  }

  Future<void> _goToCenterUser() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            context.read<MapsProvider>().currentPosition.latitude,
            context.read<MapsProvider>().currentPosition.longitude,
          ),
          zoom: 20.5,
        ),
      ),
    );
  }

  void _validateAbsen({
    @required double distanceTwoLocation,
    @required double radius,
    @required bool isAbsentIn,
  }) async {
    final userProvider = context.read<UserProvider>();
    final absenProvider = context.read<AbsenProvider>();
    final globalProvider = context.read<GlobalProvider>();
    final mapsProvider = context.read<MapsProvider>();
    final isInsideRadius = commonF.isInsideRadiusCircle(distanceTwoLocation, radius);

    if (!mapsProvider.currentPosition.mocked) {
      if (isInsideRadius) {
        try {
          globalProvider.setLoading(true);
          final trueTime = await commonF.getTrueTime();
          final timeFormat = DateFormat("HH:mm:ss").format(trueTime);
          String result;
          if (isAbsentIn) {
            result = await absenProvider.absensiMasuk(
              idUser: userProvider.user.idUser,
              tanggalAbsen: trueTime,
              tanggalAbsenMasuk: trueTime,
              jamAbsenMasuk: timeFormat,
              createdDate: trueTime,
            );
          } else {
            result = await absenProvider.absensiPulang(
              idUser: userProvider.user.idUser,
              tanggalAbsenPulang: trueTime,
              jamAbsenPulang: timeFormat,
              updateDate: trueTime,
            );
          }
          globalF.showToast(message: result, isSuccess: true, isLongDuration: true);
          globalProvider.setLoading(false);
          Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeNamed);
        } catch (e) {
          globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
          globalProvider.setLoading(false);
        }
      } else {
        globalF.showToast(message: "Anda Diluar Jangkauan Absensi", isError: true);
      }
    } else {
      globalF.showToast(
        message: "Anda Terdeteksi Menggunakan Mock Location",
        isError: true,
        isLongDuration: true,
      );
    }
  }
}
//! Menampilkan Jarak Antara 2 Lokasi
// Selector2<MapsProvider, AbsenProvider, Tuple2<Position, DestinasiModel>>(
//   selector: (_, provider1, provider2) =>
//       Tuple2(provider1.currentPosition, provider2.destinasiModel),
//   builder: (_, value, __) => Align(
//     alignment: Alignment.topCenter,
//     child: Container(
//       padding: const EdgeInsets.all(14.0),
//       color: commonF.changeColorRadius(
//           commonF.getDistanceLocation(value.item1, value.item2), radiusCircle),
//       child: Text(
//         "${value.item1.latitude} || ${value.item1.longitude} \n Jarak Ke Destinasi : ${commonF.getDistanceLocation(value.item1, value.item2).toStringAsFixed(1)} Meter",
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: colorPallete.white,
//         ),
//       ),
//     ),
//   ),
// )
