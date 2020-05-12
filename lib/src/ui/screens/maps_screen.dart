import 'dart:async';

import 'package:intl/intl.dart';
import 'package:network/network.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './widgets/welcome_screen/button_attendance.dart';

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

  double radiusCircle = 800;

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
                  Consumer<ZAbsenProvider>(
                    builder: (_, absenProvider, __) {
                      final distanceTwoLocation = commonF.getDistanceLocation(
                        absenProvider.currentPosition.latitude,
                        absenProvider.currentPosition.longitude,
                        absenProvider.destinasiModel.latitude,
                        absenProvider.destinasiModel.longitude,
                      );
                      // print(
                      //     "Jarak $distanceTwoLocation || Lokasi Saya ${absenProvider.currentPosition}");
                      return GoogleMap(
                        circles: Set.of(
                          {
                            Circle(
                              circleId: CircleId('1'),
                              strokeColor: Colors.transparent,
                              fillColor: commonF
                                  .changeColorRadius(distanceTwoLocation, radiusCircle)
                                  .withOpacity(.6),
                              center: LatLng(
                                absenProvider.destinasiModel.latitude,
                                absenProvider.destinasiModel.longitude,
                              ),
                              radius: radiusCircle,
                            ),
                          },
                        ),
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
                      );
                    },
                  ),
                  Positioned(
                    bottom: 30,
                    left: 10,
                    right: 50,
                    child: ButtonAttendance(
                      onTapAbsen: () => _validateAbsenMasuk(radiusCircle),
                      backgroundColor: Colors.transparent,
                      onTapPulang: () => _validateAbsenPulang(radiusCircle),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getLocation(ZAbsenProvider provider) async {
    Location location = Location();
    location.changeSettings(interval: 2500);
    location.onLocationChanged.listen((currentLocation) {
      if (currentLocation == null) {
        return null;
      } else {
        provider.setTrackingLocation(currentLocation);
      }
    });
  }

  Future<void> _gotToCenterUser(ZAbsenProvider provider) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            provider.currentPosition.latitude ?? 1,
            provider.currentPosition.longitude ?? 1,
          ),
          zoom: 20.5,
        ),
      ),
    );
  }

  void _validateAbsenMasuk(double radius) async {
    final absenProvider = context.read<ZAbsenProvider>();
    final userProvider = context.read<UserProvider>();
    final trueTime = await commonF.getTrueTime();
    final timeFormat = DateFormat("HH:mm:ss").format(trueTime);
    final distanceTwoLocation = commonF.getDistanceLocation(
      absenProvider.currentPosition.latitude,
      absenProvider.currentPosition.longitude,
      absenProvider.destinasiModel.latitude,
      absenProvider.destinasiModel.longitude,
    );
    final isUserInsideRadius = commonF.isInsideRadiusCircle(distanceTwoLocation, radius);
    if (isUserInsideRadius) {
      try {
        final result = await absensiAPI.absensiMasuk(
          idUser: userProvider.user.idUser,
          tanggalAbsen: trueTime,
          tanggalAbsenMasuk: trueTime,
          jamAbsenMasuk: timeFormat,
          createdDate: trueTime,
        );

        globalF.showToast(message: result, isSuccess: true, isLongDuration: true);
        Navigator.of(context).pop();
      } catch (e) {
        globalF.showToast(message: e, isError: true);
      }
    } else {
      globalF.showToast(message: "Anda Diluar Jangkauan Absensi", isError: true);
    }
  }

  void _validateAbsenPulang(double radius) async {
    final absenProvider = context.read<ZAbsenProvider>();
    final userProvider = context.read<UserProvider>();
    final trueTime = await commonF.getTrueTime();
    final timeFormat = DateFormat("HH:mm:ss").format(trueTime);
    final distanceTwoLocation = commonF.getDistanceLocation(
      absenProvider.currentPosition.latitude,
      absenProvider.currentPosition.longitude,
      absenProvider.destinasiModel.latitude,
      absenProvider.destinasiModel.longitude,
    );

    final isUserInsideRadius = commonF.isInsideRadiusCircle(distanceTwoLocation, radius);
    if (isUserInsideRadius) {
      final result = await absensiAPI.absensiPulang(
        idUser: userProvider.user.idUser,
        tanggalAbsenPulang: trueTime,
        jamAbsenPulang: timeFormat,
        updateDate: trueTime,
      );
      globalF.showToast(message: result, isSuccess: true, isLongDuration: true);
      Navigator.of(context).pop();
    } else {
      globalF.showToast(message: "Anda Diluar Jangkauan Absensi", isError: true);
    }
  }
}
