import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsProvider extends ChangeNotifier {
  Position _currentPosition;
  Position get currentPosition => _currentPosition;

  Future<void> getCurrentPosition() async {
    try {
      Position lastPosition = await Geolocator().getLastKnownPosition();
      if (lastPosition != null) {
        print("Success Get Last Position...");
        _currentPosition = lastPosition;
      } else {
        final currentPosition = await Geolocator().getCurrentPosition();
        if (currentPosition != null) {
          print("Success Get Your Current Position...");
          _currentPosition = currentPosition;
        } else {
          throw "Can't Get Your Position";
        }
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  void setTrackingLocation(Position position) {
    _currentPosition = position;
    notifyListeners();
  }

  CameraPosition _cameraPosition;
  CameraPosition get cameraPosition => _cameraPosition;

  void setCameraPosition(CameraPosition value) {
    _cameraPosition = value;
    print("${_cameraPosition.target.latitude} || ${_cameraPosition.target.longitude}");
    notifyListeners();
  }
}
