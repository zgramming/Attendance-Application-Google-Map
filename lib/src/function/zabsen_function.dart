import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:location/location.dart';
import 'package:android_intent/android_intent.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:great_circle_distance2/great_circle_distance2.dart';
import 'package:location_permissions/location_permissions.dart' as lc;
import 'package:network/network.dart';
import 'package:ntp/ntp.dart';

class CommonFunction {
  Location location = Location();

  void initPermission(BuildContext context) async {
    final permissionStatus = await checkLocationPermission();
    final serviceEnable = await serviceEnabled();
    // final requestPermisionStatus = await _requestPermissionStatus();
    // final requestService = await _requestService();
    //* Jika Lokasi Permission Tidak Didapatkan
    if (permissionStatus != PermissionStatus.granted) {
      showDialog(
        context: context,
        builder: (ctx) => PopupPermission(
          typePermission: 'Lokasi',
          iconPermission: FontAwesomeIcons.locationArrow,
          showCloseButton: false,
          onAccept: () async {
            final bool result = await lc.LocationPermissions().openAppSettings();
            print("result open appseting $result");
          },
        ),
      );
      //* Jika GPS Permission Tidak Didapatkan
    } else if (!serviceEnable) {
      showDialog(
        context: context,
        builder: (ctx) => PopupPermission(
          typePermission: 'GPS',
          iconPermission: FontAwesomeIcons.mapMarkedAlt,
          showCloseButton: false,
          onAccept: () {
            final AndroidIntent intent =
                const AndroidIntent(action: 'action_location_source_settings');
            intent.launch();
          },
        ),
      );
    }
  }

  Future<PermissionStatus> checkLocationPermission() async {
    final result = await location.hasPermission();
    return result;
  }

  Future<bool> serviceEnabled() async {
    final result = await location.serviceEnabled();
    return result;
  }
  // Future<PermissionStatus> _requestPermissionStatus() async {
  //   final result = await location.requestPermission();
  //   return result;
  // }

  // Future<bool> _requestService() async {
  //   final result = await location.requestService();
  //   return result;
  // }
  //* Rumus Untuk Mendapatkan Jarak Antara Dua Lokasi
  //* Rumus ini yang akan digunakan untuk memperkirakan user sudah didalam radius absen / belum

  double getDistanceLocation(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2, {
    int typeCalculate = 1,
    bool isKm = false,
  }) {
    var calculate = GreatCircleDistance.fromDegrees(
      latitude1: latitude1,
      longitude1: longitude1,
      latitude2: latitude2,
      longitude2: longitude2,
    );

    var result;
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
          child: Icon(FontAwesomeIcons.check, size: 8),
          radius: 8,
          backgroundColor: Colors.green,
        );
        //* Jika Status Absen Telat
      } else if (result.status.toLowerCase() == "t") {
        icon = CircleAvatar(
          child: Icon(FontAwesomeIcons.minusSquare, size: 8),
          radius: 8,
          backgroundColor: Colors.orange,
        );

        //* Jika Status Absen Alpha
      } else {
        icon = CircleAvatar(
          child: Icon(FontAwesomeIcons.times, size: 8),
          radius: 8,
          backgroundColor: Colors.red,
        );
      }
    } else {
      //* Jika Tanggal Absen Lebih Dari Hari Ini
      if (result.tanggalAbsen.day >= DateTime.now().day) {
        icon = SizedBox();
      } else {
        icon = CircleAvatar(child: Icon(FontAwesomeIcons.question, size: 8), radius: 8);
      }
    }
    return icon;
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
      result = null;
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
      return colorWeekDay ?? null;
    }
  }
}

final commonF = CommonFunction();
