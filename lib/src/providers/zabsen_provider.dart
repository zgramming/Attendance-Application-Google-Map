import 'package:flutter/foundation.dart';
import 'package:ntp/ntp.dart';
import 'package:location/location.dart';
import 'package:global_template/global_template.dart';

class ZAbsenProvider extends ChangeNotifier {
  ZAbsenProvider() {
    _getNetworkDateTime();
  }

  LocationData _currentPosition;
  LocationData get currentPosition => _currentPosition;

  Future<void> getCurrentPosition() async {
    Location location = Location();
    try {
      LocationData result;

      result = await reusableRequestServer.requestServer(() async => await location.getLocation());
      _currentPosition = result;
    } catch (e) {
      throw e.toString();
    }
    print("Hello From Current Position $_currentPosition");
    notifyListeners();
  }

  void setTrackingLocation(LocationData result) {
    _currentPosition = result;
    print("Ini dari provider position $_currentPosition");
    notifyListeners();
  }

  DateTime _networkDateTime = DateTime.now();
  DateTime get networkDateTime => _networkDateTime;

  Future<void> _getNetworkDateTime() async {
    DateTime result;
    try {
      result = await reusableRequestServer.requestServer(() async => await NTP.now());
    } catch (e) {
      result = null;
      // throw e.toString();
    }
    _networkDateTime = result;
    notifyListeners();
    return result;
  }
}
