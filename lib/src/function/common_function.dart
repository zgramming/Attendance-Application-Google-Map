import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_template/global_template.dart';
import 'package:location_permissions/location_permissions.dart' as lc;
import 'package:location/location.dart';

class CommonFunction {
  Location location = new Location();
  void initPermission(BuildContext context) async {
    final permissionStatus = await _checkLocationPermission();
    // final requestPermisionStatus = await _requestPermissionStatus();
    final serviceEnable = await _serviceEnabled();
    // final requestService = await _requestService();

    if (permissionStatus != PermissionStatus.granted) {
      showDialog(
        context: context,
        builder: (ctx) => PopupPermission(
          typePermission: 'Lokasi',
          iconPermission: FontAwesomeIcons.locationArrow,
          showCloseButton: false,
          onAccept: () async {
            Navigator.of(ctx).pop();
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
            Navigator.of(ctx).pop();
            final AndroidIntent intent =
                const AndroidIntent(action: 'action_location_source_settings');
            intent.launch();
          },
        ),
      );
    }
  }

  Future<PermissionStatus> _checkLocationPermission() async {
    final result = await location.hasPermission();
    return result;
  }

  Future<bool> _serviceEnabled() async {
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

  Future<LocationData> _getCurrentLocation() async {
    try {
      var result;
      result = await reusableRequestServer.requestServer(() async {
        LocationData locationData = await location.getLocation();
        return locationData;
      });
      return result;
    } catch (e) {
      throw e.toString();
    }
  }

  // Future<bool> _checkGPSPermission() async {
  //   Geolocator geolocator = Geolocator();
  //   var result = await geolocator.isLocationServiceEnabled();
  //   print("Location Service Permission $result");
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

  // ///! Map Screen
  // Future<Position> getLocation(Geolocator geolocator) async {
  //   Position currentLocation;
  //   try {
  //     currentLocation = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  //   } catch (e) {
  //     currentLocation = null;
  //   }
  //   return currentLocation;
  // }
}

final commonF = CommonFunction();
