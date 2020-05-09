import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:global_template/global_template.dart';

class ZAbsenProvider extends ChangeNotifier {
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
    // print("Ini dari provider position $_currentPosition");
    notifyListeners();
  }

  DateTime _trueTime;
  DateTime get trueTime => _trueTime;

  void setTrueTime(DateTime value) {
    _trueTime = value;
    notifyListeners();
  }
}
