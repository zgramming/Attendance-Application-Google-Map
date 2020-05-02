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

  // StreamSubscription<Position> trackingPosition(Geolocator geolocator) {
  //   final result = geolocator
  //       .getPositionStream(LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 2000))
  //       .listen((position) {
  //     _currentPosition = position;
  //     notifyListeners();

  //     print(
  //         "Lokasi RealTime UserLocation $_currentPosition \n Accurary ${position.accuracy} \n Mocked ${position.mocked} \n");
  //   });
  //   return result;
  // }

  DateTime _networkDateTime = DateTime.now();
  DateTime get networkDateTime => _networkDateTime;

  Future<void> _getNetworkDateTime() async {
    final result = await NTP.now();
    _networkDateTime = result;
    notifyListeners();
  }
}
