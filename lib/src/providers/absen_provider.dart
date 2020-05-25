import 'package:flutter/foundation.dart';
import 'package:global_template/global_template.dart';
import 'package:network/network.dart';

class AbsenProvider extends ChangeNotifier {
  DestinasiModel _destinasiModel = DestinasiModel();
  DestinasiModel get destinasiModel => _destinasiModel;

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

  Future<void> saveDestinasiUser(String idUser, {String isSelected}) async {
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
}
