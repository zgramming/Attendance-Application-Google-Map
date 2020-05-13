import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:global_template/global_template.dart';
import 'package:network/network.dart';

class ZAbsenProvider extends ChangeNotifier {
  DestinasiModel _destinasiModel = DestinasiModel();
  DestinasiModel get destinasiModel => _destinasiModel;

  Future<void> saveDestinasiUser(String idUser) async {
    try {
      final List<DestinasiModel> result = await reusableRequestServer.requestServer(() async {
        await destinasiAPI.getDestinationById(idUser: idUser);
      });
      result.forEach((element) => _destinasiModel = element);
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  LocationData _currentPosition;
  LocationData get currentPosition => _currentPosition;

  Future<void> getCurrentPosition() async {
    Location location = Location();
    final LocationData result =
        await reusableRequestServer.requestServer(() async => await location.getLocation());
    if (result != null) {
      _currentPosition = result;
    }

    print("Hello From Current Position $_currentPosition");
    notifyListeners();
  }

  void setTrackingLocation(LocationData result) {
    _currentPosition = result;
    notifyListeners();
  }

  DateTime _trueTime;
  DateTime get trueTime => _trueTime;

  void setTrueTime(DateTime value) {
    _trueTime = value;
    notifyListeners();
  }
}
