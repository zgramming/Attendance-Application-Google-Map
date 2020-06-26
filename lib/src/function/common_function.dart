import 'package:ntp/ntp.dart';
import 'package:network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent/android_intent.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:great_circle_distance2/great_circle_distance2.dart';
import 'package:location_permissions/location_permissions.dart';

class CommonFunction {
  Future<void> initPermission(BuildContext ctx) async {
    final GeolocationStatus geolocationStatus = await getGeolocationPermission();
    final bool gpsStatus = await getGPSService();
    if (geolocationStatus != GeolocationStatus.granted) {
      await showDialog(context: ctx, builder: (ctxDialog) => showPermissionLocation());
    } else if (!gpsStatus) {
      await showDialog(context: ctx, builder: (ctxDialog) => showPermissionGPS());
    }
  }

  Future<void> initClosePermission(BuildContext context) async {
    final GeolocationStatus geolocationStatus = await getGeolocationPermission();
    final bool gpsStatus = await getGPSService();
    if (geolocationStatus != GeolocationStatus.granted) {
      Navigator.of(context).pop();
      print('Tutup Popup Lokasi');
    } else if (!gpsStatus) {
      Navigator.of(context).pop();
      print('Tutup Popup GPS');
    }
  }

  Widget showPermissionGPS() {
    return PopupPermission(
      typePermission: 'GPS',
      iconPermission: FontAwesomeIcons.mapMarkedAlt,
      showCloseButton: false,
      onAccept: () async {
        const AndroidIntent intent = AndroidIntent(action: 'action_location_source_settings');
        await intent.launch();
      },
    );
  }

  Widget showPermissionLocation() {
    return PopupPermission(
      typePermission: 'Lokasi',
      iconPermission: FontAwesomeIcons.locationArrow,
      showCloseButton: false,
      onAccept: () async => await LocationPermissions().openAppSettings(),
    );
  }

  //! Geolocator Permission
  Future<GeolocationStatus> getGeolocationPermission() async {
    GeolocationStatus result;
    try {
      result = await reusableRequestServer.requestServer(() async => await Geolocator()
          .checkGeolocationPermissionStatus(
              locationPermission: GeolocationPermission.locationAlways)) as GeolocationStatus;
    } catch (e) {
      rethrow;
    }
    return result;
  }

  Future<bool> getGPSService() async {
    bool result;
    try {
      result = await reusableRequestServer
          .requestServer(() async => await Geolocator().isLocationServiceEnabled()) as bool;
    } catch (e) {
      rethrow;
    }
    return result;
  }

  //! Batas Geolocator Permission
  //* Rumus Untuk Mendapatkan Jarak Antara Dua Lokasi
  //* Rumus ini yang akan digunakan untuk memperkirakan user sudah didalam radius absen / belum

  double getDistanceLocation(
    Position position,
    DestinasiModel destinasiModel, {
    int typeCalculate = 1,
    bool isKm = false,
  }) {
    final GreatCircleDistance calculate = GreatCircleDistance.fromDegrees(
      latitude1: position.latitude,
      longitude1: position.longitude,
      latitude2: destinasiModel.latitude,
      longitude2: destinasiModel.longitude,
    );

    double result;
    if (typeCalculate == 1) {
      result = calculate.haversineDistance();
    } else if (typeCalculate == 2) {
      result = calculate.sphericalLawOfCosinesDistance();
    } else if (typeCalculate == 3) {
      result = calculate.vincentyDistance();
    } else {
      result = calculate.haversineDistance();
    }
    return isKm ? result / 1000 : result;
  }

  //* Fungsi Untuk Mengubah Warna Radius
  //* Saat Didalam Radius Default = Hijau , Diluar = Ungu
  Color changeColorRadius(
    double distanceTwoLocation,
    double radius, {
    Color outsideRadius = Colors.purple,
    Color insideRadius = Colors.green,
  }) {
    if (distanceTwoLocation < radius) {
      return insideRadius;
    } else {
      return outsideRadius;
    }
  }

  //* Pengecekan Jika Kita Saat Absen Didalam Radius Absensi
  bool isInsideRadiusCircle(double distanceTwoLocation, double radius) {
    if (distanceTwoLocation < radius) {
      return true;
    } else {
      return false;
    }
  }

  //! Fungsi Selain Maps

  //* Fungsi Mendapatkan Waktu dari Internet.
  //* Berguna Untuk Mendapatkan tingkat akurasi yang tinggi saat absensi
  //* Mencegah user memanipulasi tanggal/jam di device mereka , dan membuat waktu absen tidak akurat.
  Future<DateTime> getTrueTime() async {
    try {
      final DateTime result =
          await reusableRequestServer.requestServer(() async => await NTP.now()) as DateTime;
      return result;
    } catch (e) {
      rethrow;
    }
  }

  bool handleScrollNotification(
    ScrollNotification notification, {
    @required AnimationController controllerButton,
    @required AnimationController appBarController,
  }) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent) {
              Future<void>.delayed(const Duration(seconds: 0), () => controllerButton.forward());
            }

            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent) {
              Future<void>.delayed(const Duration(seconds: 0), () => controllerButton.reverse());
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
      if (notification.metrics.pixels <= 0) {
        if (appBarController.status == AnimationStatus.completed) {
          Future<void>.delayed(const Duration(seconds: 0), () => appBarController.reverse());
        }
      } else {
        if (appBarController.status != AnimationStatus.completed) {
          Future<void>.delayed(const Duration(seconds: 0), () => appBarController.forward());
        }
      }
    }

    return false;
  }

  //* Fungsi Untuk Membuat Icon Berdasarkan Status Absensi User
  Widget setStatusAbsenIcon(List<AbsensiStatusModel> data, int day) {
    final AbsensiStatusModel result = data.firstWhere(
      (AbsensiStatusModel element) => element.tanggalAbsen.day == day + 1,
      orElse: () => AbsensiStatusModel(
        tanggalAbsen: DateTime(DateTime.now().year, DateTime.now().month, day + 1),
      ),
    );
    Widget icon;
    if (result.status != null) {
      //* Jika Status Absen Tepat Waktu
      if (result.status.toLowerCase() == 'o') {
        icon = const CircleAvatar(
          child: Icon(FontAwesomeIcons.calendarCheck, size: 8),
          radius: 8,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        );
        //* Jika Status Absen Telat
      } else if (result.status.toLowerCase() == 't') {
        icon = const CircleAvatar(
          child: Icon(FontAwesomeIcons.calendarMinus, size: 8),
          radius: 8,
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        );

        //* Jika Status Absen Alpha
      } else {
        icon = const CircleAvatar(
          child: Icon(FontAwesomeIcons.calendarTimes, size: 8),
          radius: 8,
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        );
      }
    } else {
      icon = const SizedBox();
    }
    return icon;
  }

  String getDayName(DateTime dateTime, int indexDay) {
    final String result = globalF.formatDay(DateTime(dateTime.year, dateTime.month, indexDay + 1));
    return result;
  }

  Color isWeekend(DateTime dateTime, int indexDay, {Color colorWeekend, Color colorWeekDay}) {
    final String daysName = getDayName(dateTime, indexDay);
    if (daysName.toLowerCase() == 'sabtu' ||
        daysName.toLowerCase() == 'minggu' ||
        daysName.toLowerCase() == 'sab' ||
        daysName.toLowerCase() == 'min') {
      return colorWeekend ?? colorPallete.weekEnd;
    } else {
      return colorWeekDay;
    }
  }

  Future<void> openGoogleMap(double latitude, double longitude) async {
    final String googleMapUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    try {
      if (await canLaunch(googleMapUrl)) {
        await launch(googleMapUrl);
      } else {
        throw 'Could not open the map.';
      }
    } catch (e) {
      rethrow;
    }
  }
}

final CommonFunction commonF = CommonFunction();
