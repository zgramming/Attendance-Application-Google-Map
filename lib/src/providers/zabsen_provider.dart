import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_template/global_template.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:network/network.dart';

class ZAbsenProvider extends ChangeNotifier {
  Future<List<AbsensiModel>> fetchAbsenMonthly(String idUser, DateTime dateTime) async {
    final result = await absensiAPI.getAbsenMonthly(idUser: idUser, dateTime: dateTime);
    final resultList = setTableAttendance(result, dateTime);
    return resultList;
  }

  List<AbsensiModel> setTableAttendance(List<AbsensiModel> value, DateTime dateTime) {
    int totalDay = globalF.totalDaysOfMonth(dateTime.year, dateTime.month);

    List<AbsensiModel> tempList = [];
    for (int i = 1; i <= totalDay; i++) {
      final result = value.firstWhere((element) => element.tanggalAbsen.day == i,
          orElse: () => AbsensiModel(jamAbsenMasuk: "-", jamAbsenPulang: "-"));
      tempList.add(result);
    }
    return tempList;
  }

  DestinasiModel _destinasiModel = DestinasiModel();
  DestinasiModel get destinasiModel => _destinasiModel;
  Future<void> saveDestinasiUser(String idUser) async {
    try {
      await reusableRequestServer.requestServer(() async {
        await destinasiAPI.getDestinationById(idUser: idUser).then((value) => value.forEach(
              (element) => _destinasiModel = element,
            ));
      });
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Position _currentPosition;
  Position get currentPosition => _currentPosition;

  Future<void> getCurrentPosition() async {
    // Location location = Location();
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    try {
      await reusableRequestServer.requestServer(
          //! Pertama Dapatkan Lokasi Terakhir User, Kalau Lokasi Terakhir == null maka dapatkan lokasi user sekarang.
          () async => await geolocator.getLastKnownPosition().then((lastPosition) async {
                if (lastPosition != null) {
                  _currentPosition = lastPosition;
                  print("Mendapatkan Lokasi Terakhir User $lastPosition");
                } else {
                  await geolocator.getCurrentPosition().then((currentPosition) {
                    if (currentPosition != null) {
                      _currentPosition = currentPosition;
                      print("Mendapatkan Lokasi Terbaru User $lastPosition");
                    } else {
                      throw "Tidak Dapat Menemukan Lokasi Kamu";
                    }
                  });
                }
              }));
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
