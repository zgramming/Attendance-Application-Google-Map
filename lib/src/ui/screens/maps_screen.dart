import 'dart:async';

import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'package:network/network.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './widgets/welcome_screen/button_attendance.dart';

import '../screens/welcome_screen.dart';

import '../../function/zabsen_function.dart';
import '../../providers/zabsen_provider.dart';
import '../../providers/user_provider.dart';

class MapScreen extends StatefulWidget {
  static const routeNamed = "/map-screen";
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  double radiusCircle = 10;

  @override
  void initState() {
    trackingLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuild Maps Screen");

    return WillPopScope(
      onWillPop: () async => false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: colorPallete.primaryColor),
        child: SafeArea(
          child: Scaffold(
            body: ConstrainedBox(
              constraints: BoxConstraints(minHeight: sizes.height(context)),
              child: Stack(
                children: [
                  Selector2<ZAbsenProvider, ZAbsenProvider, Tuple2<LocationData, DestinasiModel>>(
                    selector: (_, provider1, provider2) =>
                        Tuple2(provider1.currentPosition, provider2.destinasiModel),
                    builder: (context, value, child) {
                      final distanceTwoLocation =
                          commonF.getDistanceLocation(value.item1, value.item2);
                      print(
                          "Jarak $distanceTwoLocation || Lokasi Saya ${value.item1.latitude} ${value.item1.longitude}");
                      return GoogleMap(
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(value.item1.latitude, value.item1.longitude),
                          zoom: 14.4746,
                        ),
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                          // trackingLocation();
                          _gotToCenterUser();
                        },
                        circles: Set.of(
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
                              //! Ini LatLng untuk posisi Destinasi Yang Dituju (Lapangan Kampung Kepu)
                              center: LatLng(
                                value.item2.latitude,
                                value.item2.longitude,
                              ),
                              radius: radiusCircle,
                            ),
                          },
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 30,
                    left: 10,
                    right: 50,
                    child: Selector2<ZAbsenProvider, ZAbsenProvider,
                        Tuple2<LocationData, DestinasiModel>>(
                      selector: (_, provider1, provider2) =>
                          Tuple2(provider1.currentPosition, provider2.destinasiModel),
                      builder: (_, value, __) => ButtonAttendance(
                        onTapAbsen: () => _validateAbsenMasuk(
                          commonF.getDistanceLocation(
                            value.item1,
                            value.item2,
                          ),
                          radiusCircle,
                        ),
                        backgroundColor: Colors.transparent,
                        onTapPulang: () => _validateAbsenPulang(
                          commonF.getDistanceLocation(
                            value.item1,
                            value.item2,
                          ),
                          radiusCircle,
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
                    top: 10,
                    left: 10,
                  ),
                  Selector2<ZAbsenProvider, ZAbsenProvider, Tuple2<LocationData, DestinasiModel>>(
                    selector: (_, provider1, provider2) =>
                        Tuple2(provider1.currentPosition, provider2.destinasiModel),
                    builder: (_, value, __) => Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.all(14.0),
                        color: commonF.changeColorRadius(
                            commonF.getDistanceLocation(value.item1, value.item2), radiusCircle),
                        child: Text(
                          "${value.item1.latitude} || ${value.item1.longitude} \n Jarak Ke Destinasi : ${commonF.getDistanceLocation(value.item1, value.item2).toStringAsFixed(1)} Meter",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorPallete.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void trackingLocation() async {
    Location location = Location();
    //? Untuk Setting Interval Update Tracking Lokasi User
    location.changeSettings(interval: 2500);
    location.onLocationChanged.listen((currentLocation) {
      if (currentLocation == null) {
        print("CURRENT LOCATION RESULT NULL $currentLocation");
        return null;
      } else {
        context.read<ZAbsenProvider>().setTrackingLocation(currentLocation);
        print("RESULT FROM TRACKING LOCATION USER $currentLocation");
      }
    }, onError: (e) => print(e.toString()));
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
          zoom: 20.5,
        ),
      ),
    );
  }

  void _validateAbsenMasuk(double distanceTwoLocation, double radius) async {
    context.read<GlobalProvider>().setLoading(true);
    final userProvider = context.read<UserProvider>();
    final isInsideRadius = commonF.isInsideRadiusCircle(distanceTwoLocation, radius);
    if (isInsideRadius) {
      try {
        final trueTime = await commonF.getTrueTime();
        final timeFormat = DateFormat("HH:mm:ss").format(trueTime);
        print('PROSES INPUT ABSENSI MASUK');
        final result = await absensiAPI.absensiMasuk(
          idUser: userProvider.user.idUser,
          tanggalAbsen: trueTime,
          tanggalAbsenMasuk: trueTime,
          jamAbsenMasuk: timeFormat,
          createdDate: trueTime,
        );
        globalF.showToast(message: result, isSuccess: true, isLongDuration: true);
        context.read<GlobalProvider>().setLoading(false);
        print('SELESAI INPUT ABSENSI MASUK');

        Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeNamed);
      } catch (e) {
        globalF.showToast(message: e, isError: true);
        context.read<GlobalProvider>().setLoading(false);
      }
    } else {
      globalF.showToast(message: "Anda Diluar Jangkauan Absensi", isError: true);
      context.read<GlobalProvider>().setLoading(false);
    }
  }

  void _validateAbsenPulang(double distanceTwoLocation, double radius) async {
    context.read<GlobalProvider>().setLoading(true);
    final userProvider = context.read<UserProvider>();
    final isInsideRadius = commonF.isInsideRadiusCircle(distanceTwoLocation, radius);
    if (isInsideRadius) {
      final trueTime = await commonF.getTrueTime();
      final timeFormat = DateFormat("HH:mm:ss").format(trueTime);
      print('PROSES INPUT ABSENSI PULANG');
      final result = await absensiAPI.absensiPulang(
        idUser: userProvider.user.idUser,
        tanggalAbsenPulang: trueTime,
        jamAbsenPulang: timeFormat,
        updateDate: trueTime,
      );
      globalF.showToast(message: result, isSuccess: true, isLongDuration: true);
      context.read<GlobalProvider>().setLoading(false);
      print('SELESAI INPUT ABSENSI PULANG');

      Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeNamed);
    } else {
      globalF.showToast(message: "Anda Diluar Jangkauan Absensi", isError: true);
      context.read<GlobalProvider>().setLoading(false);
    }
  }
}
