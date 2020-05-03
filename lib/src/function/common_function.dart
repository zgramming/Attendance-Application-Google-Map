import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_template/global_template.dart';
import 'package:location_permissions/location_permissions.dart' as lc;
import 'package:location/location.dart';
import 'package:great_circle_distance2/great_circle_distance2.dart';

class CommonFunction {
  Location location = new Location();
  void initPermission(BuildContext context) async {
    final permissionStatus = await checkLocationPermission();
    final serviceEnable = await serviceEnabled();
    // final requestPermisionStatus = await _requestPermissionStatus();
    // final requestService = await _requestService();

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
    print("ServiceEnable $serviceEnable || PermissionStatus $permissionStatus");
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

  bool handleScrollNotification(ScrollNotification notification, {AnimationController controller}) {
    // print(notification.runtimeType);
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent) {
              Future.delayed(Duration(milliseconds: 500), () => controller.forward());
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent) {
              Future.delayed(Duration(milliseconds: 500), () => controller.reverse());
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  double getDistanceLocation(
      double latitude1, double longitude1, double latitude2, double longitude2,
      {int typeCalculate = 0, GreatCircleDistance typeGCD}) {
    GreatCircleDistance calculate;

    if (calculate == null) {
      calculate = GreatCircleDistance.fromDegrees(
        latitude1: latitude1,
        longitude1: longitude1,
        latitude2: latitude2,
        longitude2: longitude2,
      );
    } else {
      if (calculate == GreatCircleDistance.fromDegrees()) {
        calculate = GreatCircleDistance.fromDegrees(
          latitude1: latitude1,
          longitude1: longitude1,
          latitude2: latitude2,
          longitude2: longitude2,
        );
      } else {
        calculate = GreatCircleDistance.fromRadians(
          latitude1: latitude1,
          longitude1: longitude1,
          latitude2: latitude2,
          longitude2: longitude2,
        );
      }
    }

    var result;
    if (typeCalculate == 0) {
      result = calculate.haversineDistance();
    } else if (typeCalculate == 1) {
      result = calculate.sphericalLawOfCosinesDistance();
    } else if (typeCalculate == 2) {
      result = calculate.vincentyDistance();
    } else {
      result = calculate.haversineDistance();
    }
    return result;
  }

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
}

final commonF = CommonFunction();
