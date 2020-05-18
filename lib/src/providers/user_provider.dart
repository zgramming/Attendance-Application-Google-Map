import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:network/network.dart';

class UserProvider extends ChangeNotifier {
  UserProvider() {
    _getSessionUser();
  }
  final String userKey = 'userKey';
  UserModel _user = UserModel();

  UserModel get user => _user;

  Future<void> saveSessionUser({
    @required List<UserModel> list,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final encodeSession = jsonEncode(list.map((e) => e.toJson()).toList());
    final result = await pref.setString(userKey, encodeSession);
    print('Encode Session : $encodeSession');
    print('Result Encode $result');
    _getSessionUser();
    notifyListeners();
  }

  Future<void> _getSessionUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String getEncodeSession = pref.getString(userKey);
    if (getEncodeSession == null) {
      return null;
    } else {
      final List decodeSession = json.decode(getEncodeSession);
      final List<UserModel> user = decodeSession.map((e) => UserModel.fromJson(e)).toList();
      user.forEach((element) => _user = element);
      notifyListeners();
    }
  }

  Future<void> removeSessionUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final result = await pref.remove(userKey);
    await _getSessionUser();
    notifyListeners();
    return result;
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

  Future<List<UserModel>> userUpdateImage(String idUser, File image) async {
    try {
      final result = await userAPI.userUpdateImage(idUser: idUser, imageFile: image);
      return result;
    } catch (e) {
      throw e;
    }
  }
}
