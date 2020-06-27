import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_template/global_template.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsProvider extends ChangeNotifier {
  Position _currentPosition;
  Position get currentPosition => _currentPosition;

  List<Placemark> _autocompleteAddress = [];
  List<Placemark> get autocompleteAddress => _autocompleteAddress;

  Future<List<Placemark>> getAutocompleteAddress({@required String query}) async {
    try {
      final result = await Geolocator().placemarkFromAddress(
        query,
        localeIdentifier: '${AppConfig.languageID}_${AppConfig.countryCodeID}',
      );
      _autocompleteAddress = result;
      print(result.length);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getCurrentPosition() async {
    try {
      final Position lastPosition = await Geolocator().getLastKnownPosition();
      if (lastPosition != null) {
        print('Success Get Last Position...');
        _currentPosition = lastPosition;
      } else {
        final Position currentPosition = await Geolocator().getCurrentPosition();
        if (currentPosition != null) {
          print('Success Get Your Current Position...');
          _currentPosition = currentPosition;
        } else {
          throw "Can't Get Your Position";
        }
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  void setTrackingLocation(Position position) {
    _currentPosition = position;
    notifyListeners();
  }

  CameraPosition _cameraPosition;
  CameraPosition get cameraPosition => _cameraPosition;

  void setTrackingCameraPosition(CameraPosition value) {
    _cameraPosition = value;
    notifyListeners();
  }
}
