import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:global_template/global_template.dart';
import 'package:network/network.dart';

class ZAbsenProvider extends ChangeNotifier {
  //! Untuk Table Attendance
  List<AbsensiModel> _tableAttendance = [];
  List<AbsensiModel> get tableAttendance => [..._tableAttendance];

  Future<List<AbsensiModel>> fetchAbsenMonthly(String idUser, DateTime dateTime) async {
    final result = await absensiAPI.getAbsenMonthly(idUser: idUser, dateTime: dateTime);
    setTableAttendance(result, dateTime);
    return result;
  }

  void setTableAttendance(List<AbsensiModel> value, DateTime dateTime) {
    int totalDay = globalF.totalDaysOfMonth(dateTime.year, dateTime.month);

    List<AbsensiModel> tempList = [];
    for (int i = 1; i <= totalDay; i++) {
      final result = value.firstWhere((element) => element.tanggalAbsen.day == i,
          orElse: () => AbsensiModel(jamAbsenMasuk: "-", jamAbsenPulang: "-"));
      tempList.add(result);
      _tableAttendance = tempList;
    }
  }

  DestinasiModel _destinasiModel = DestinasiModel();
  DestinasiModel get destinasiModel => _destinasiModel;
  Future<void> saveDestinasiUser(String idUser) async {
    try {
      await reusableRequestServer.requestServer(() async {
        await destinasiAPI
            .getDestinationById(idUser: idUser)
            .then((value) => value.forEach((element) {
                  _destinasiModel = element;
                }));
      });
      // if (result != null) {
      //   result.forEach((element) => _destinasiModel = element);
      // } else {
      //   throw "Tidak Dapat Menentukan Lokasi User";
      // }
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
