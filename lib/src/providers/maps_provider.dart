import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsProvider extends ChangeNotifier {
  Position _currentPosition;
  Position get currentPosition => _currentPosition;

  Future<void> getCurrentPosition() async {
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    try {
      final lastPosition = await geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        print("Berhasil Mendapatkan Last Position Kamu...");
        _currentPosition = lastPosition;
      } else {
        final currentPosition = await geolocator.getCurrentPosition();
        if (currentPosition != null) {
          print("Berhasil Mendapatkan Current Position Kamu");
          _currentPosition = currentPosition;
        } else {
          throw "Tidak Dapat Menemukan Lokasi Kamu";
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
