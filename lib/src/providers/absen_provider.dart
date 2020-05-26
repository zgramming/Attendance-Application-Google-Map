import 'package:flutter/foundation.dart';
import 'package:network/network.dart';
import 'package:global_template/global_template.dart';

class AbsenProvider extends ChangeNotifier {
  DestinasiModel _destinasiModel = DestinasiModel();
  DestinasiModel get destinasiModel => _destinasiModel;

  List<DestinasiModel> _listDestinasi = [];
  List<DestinasiModel> get listDestinasi => [..._listDestinasi];

  List<DestinasiModel> _filteredListDestinasi = [];
  List<DestinasiModel> get filteredListDestinasi => [..._filteredListDestinasi];

  Future<List<AbsensiModel>> fetchAbsenMonthly(String idUser, DateTime dateTime) async {
    try {
      final result = await absensiAPI.getAbsenMonthly(idUser: idUser, dateTime: dateTime);
      final resultList = setTableAttendance(result, dateTime);
      return resultList;
    } catch (e) {
      throw e;
    }
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

  Future<String> absensiMasuk({
    @required String idUser,
    @required DateTime tanggalAbsen,
    @required DateTime tanggalAbsenMasuk,
    @required String jamAbsenMasuk,
    @required DateTime createdDate,
  }) async {
    try {
      final result = await absensiAPI.absensiMasuk(
        idUser: idUser,
        tanggalAbsen: tanggalAbsen,
        tanggalAbsenMasuk: tanggalAbsenMasuk,
        jamAbsenMasuk: jamAbsenMasuk,
        createdDate: createdDate,
      );
      return result;
    } catch (e) {
      throw e;
    }
  }

  Future<String> absensiPulang({
    @required String idUser,
    @required DateTime tanggalAbsenPulang,
    @required String jamAbsenPulang,
    @required DateTime updateDate,
  }) async {
    try {
      final result = await absensiAPI.absensiPulang(
        idUser: idUser,
        tanggalAbsenPulang: tanggalAbsenPulang,
        jamAbsenPulang: jamAbsenPulang,
        updateDate: updateDate,
      );
      return result;
    } catch (e) {
      throw e;
    }
  }

  Future<String> destinationRegister({
    @required String idUser,
    @required String nameDestination,
    @required double latitude,
    @required double longitude,
  }) async {
    try {
      final result = await destinasiAPI.destinationRegister(
        idUser: idUser,
        nameDestination: nameDestination,
        latitude: latitude,
        longitude: longitude,
      );
      return result;
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchDestinationUser(String idUser, {String isSelected}) async {
    try {
      final result = await destinasiAPI.getDestinationById(idUser: idUser, isSelected: isSelected);
      final List<DestinasiModel> tempList = [...?result];
      _listDestinasi = tempList;

      print("List Destinasi Length ${_listDestinasi.length} ");
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<String> destinationUpdateStatus(String idDestinasi) async {
    try {
      final result = await destinasiAPI.destinationUpdateStatus(idDestinasi);
      setSelectedDestination(idDestinasi);
      return result;
    } catch (e) {
      throw e;
    }
  }

  Future<String> destinationDelete(String idDestinasi) async {
    try {
      final result = await destinasiAPI.destinationDelete(idDestinasi);
      deleteDestination(idDestinasi);
      return result;
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveSelectedDestinationUser(String idUser, {String isSelected}) async {
    try {
      final result = await destinasiAPI.getDestinationById(idUser: idUser, isSelected: isSelected);
      if (result.isNotEmpty || result != null) {
        print("Berhasil Mendapatkan Destinasi Kamu ... , Menyimpan Sementara Destinasi Kamu...");
        result.forEach((element) => _destinasiModel = element);
      } else {
        throw "Tidak Dapat Menemukan Lokasi User";
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  void filterListDestination(String query) {
    List<DestinasiModel> tempList = [];
    List<DestinasiModel> notSelectedDestination =
        _listDestinasi.where((element) => element.status != "t").toList();
    if (query.isEmpty) {
      tempList = [];
    } else {
      notSelectedDestination.forEach((element) {
        if (element.namaDestinasi.toLowerCase().contains(query.toLowerCase())) {
          tempList.add(element);
        }
      });
    }
    _filteredListDestinasi = tempList;

    notifyListeners();
  }

  void resetFilterListDestination() {
    List<DestinasiModel> tempList = [];
    _filteredListDestinasi = tempList;
    notifyListeners();
  }

  void setSelectedDestination(String idDestinasi) {
    List<DestinasiModel> tempList = [];
    for (var item in _listDestinasi) {
      if (item.status == "t") {
        item.status = null;
      }
      if (item.idDestinasi == idDestinasi) {
        item.status = "t";
      }

      tempList.add(item);
    }

    _listDestinasi = tempList;
    notifyListeners();
  }

  void deleteDestination(String idDestinasi) {
    _listDestinasi.removeWhere((element) => element.idDestinasi == idDestinasi);
    notifyListeners();
  }
}
