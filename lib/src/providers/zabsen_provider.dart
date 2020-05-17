import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_template/global_template.dart';
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
              (element) {
                _destinasiModel = element;
              },
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
    try {
      await reusableRequestServer.requestServer(
        () async => await Geolocator().getCurrentPosition().then((value) {
          if (value != null) {
            _currentPosition = value;
            print(
                "Mendapatkan Lokasi User Sekarang ${_currentPosition.latitude} || ${_currentPosition.longitude}");
          } else {
            throw "Tidak Dapat Menemukan Lokasi User";
          }
        }),
      );
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  void setTrackingLocation(Position position) {
    _currentPosition = position;
    notifyListeners();
  }

  DateTime _trueTime;
  DateTime get trueTime => _trueTime;

  void setTrueTime(DateTime value) {
    _trueTime = value;
    notifyListeners();
  }
}
