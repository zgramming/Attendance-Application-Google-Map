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
import 'package:location_permissions/location_permissions.dart' as lc;

class CommonFunction {
  void initPermission(BuildContext context) async {
    final geolocationStatus = await getGeolocationPermission();
    final gpsStatus = await getGPSService();
    // print("Init Permission GeolocationStatus $geolocationStatus");
    // print("Init Permission GeolocationGPS $gpsStatus");
    if (geolocationStatus != GeolocationStatus.granted) {
      showDialog(
        context: context,
        child: PopupPermission(
          typePermission: "Lokasi",
          iconPermission: FontAwesomeIcons.locationArrow,
          showCloseButton: false,
          onAccept: () async => await lc.LocationPermissions().openAppSettings(),
        ),
      );
    } else if (!gpsStatus) {
      showDialog(
        context: context,
        child: PopupPermission(
          typePermission: "GPS",
          iconPermission: FontAwesomeIcons.mapMarkedAlt,
          showCloseButton: false,
          onAccept: () async {
            final AndroidIntent intent =
                const AndroidIntent(action: 'action_location_source_settings');
            intent.launch();
          },
        ),
      );
    }
  }

  //! Geolocator Permission
  Future<GeolocationStatus> getGeolocationPermission() async {
    GeolocationStatus result;
    try {
      result = await reusableRequestServer
          .requestServer(() async => await Geolocator().checkGeolocationPermissionStatus());
    } catch (e) {
      throw e;
    }
    return result;
  }

  Future<bool> getGPSService() async {
    bool result;
    try {
      result = await reusableRequestServer
          .requestServer(() async => await Geolocator().isLocationServiceEnabled());
    } catch (e) {
      throw e;
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
    var calculate = GreatCircleDistance.fromDegrees(
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
    var result;
    try {
      result = await reusableRequestServer.requestServer(() async => await NTP.now());
    } catch (e) {
      throw e;
    }
    return result;
  }

  bool handleScrollNotification(
    ScrollNotification notification, {
    @required AnimationController controllerButton,
    @required AnimationController appBarController,
  }) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        if (userScroll.metrics.pixels == userScroll.metrics.minScrollExtent) {
          if (appBarController.status == AnimationStatus.completed) {
            Future.delayed(Duration(seconds: 0), () => appBarController.reverse());
          }
        } else {
          if (appBarController.status != AnimationStatus.completed) {
            Future.delayed(Duration(seconds: 0), () => appBarController.forward());
          }
        }
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent) {
              Future.delayed(Duration(seconds: 0), () => controllerButton.forward());
            }

            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent) {
              Future.delayed(Duration(seconds: 0), () => controllerButton.reverse());
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  //* Fungsi Untuk Membuat Icon Berdasarkan Status Absensi User
  Widget setStatusAbsenIcon(List<AbsensiStatusModel> data, int day) {
    final result = data.firstWhere(
      (element) => element.tanggalAbsen.day == day + 1,
      orElse: () => AbsensiStatusModel(
        tanggalAbsen: DateTime(DateTime.now().year, DateTime.now().month, day + 1),
      ),
    );
    Widget icon;
    if (result.status != null) {
      //* Jika Status Absen Tepat Waktu
      if (result.status.toLowerCase() == "o") {
        icon = CircleAvatar(
          child: Icon(FontAwesomeIcons.calendarCheck, size: 8),
          radius: 8,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        );
        //* Jika Status Absen Telat
      } else if (result.status.toLowerCase() == "t") {
        icon = CircleAvatar(
          child: Icon(FontAwesomeIcons.calendarMinus, size: 8),
          radius: 8,
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        );

        //* Jika Status Absen Alpha
      } else {
        icon = CircleAvatar(
          child: Icon(FontAwesomeIcons.calendarTimes, size: 8),
          radius: 8,
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        );
      }
    } else {
      //* Jika Tanggal Absen Lebih Dari Hari Ini , Tidak Memunculkan Circle dan Iconnya
      // if (result.tanggalAbsen.day >= DateTime.now().day) {
      //   icon = SizedBox();
      // } else {
      //   icon = CircleAvatar(
      //     child: Icon(FontAwesomeIcons.question, size: 8),
      //     radius: 8,
      //     foregroundColor: Colors.white,
      //   );
      // }
      icon = SizedBox();
    }
    return icon;
  }

  String getDayName(DateTime dateTime, int indexDay) {
    final result = globalF.formatDay(DateTime(dateTime.year, dateTime.month, indexDay + 1));
    return result;
  }

  Color isWeekend(DateTime dateTime, int indexDay, {Color colorWeekend, Color colorWeekDay}) {
    final daysName = getDayName(dateTime, indexDay);
    if (daysName.toLowerCase() == "sabtu" ||
        daysName.toLowerCase() == "minggu" ||
        daysName.toLowerCase() == "sab" ||
        daysName.toLowerCase() == "min") {
      return colorWeekend ?? colorPallete.weekEnd;
    } else {
      return colorWeekDay;
    }
  }

  Future<void> openGoogleMap(double latitude, double longitude) async {
    final String googleMapUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    try {
      if (await canLaunch(googleMapUrl)) {
        await launch(googleMapUrl);
      } else {
        throw 'Could not open the map.';
      }
    } catch (e) {
      throw e;
    }
  }
}

final commonF = CommonFunction();
