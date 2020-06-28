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
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String encodeSession = jsonEncode(list.map((UserModel e) => e.toJson()).toList());
    await pref.setString(userKey, encodeSession);
    await _getSessionUser();
    notifyListeners();
  }

  Future<void> _getSessionUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String getEncodeSession = pref.getString(userKey);
    if (getEncodeSession == null) {
      return;
    } else {
      final List decodeSession = json.decode(getEncodeSession) as List;
      final List<UserModel> user = decodeSession.map((e) => UserModel.fromJson(e)).toList();
      for (final item in user) {
        _user = item;
      }
    }
    notifyListeners();
  }

  Future<void> removeSessionUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(userKey);
    await _getSessionUser();
    notifyListeners();
  }

  Future<List<UserModel>> userUpdateImage(String idUser, File image) async {
    try {
      final List<UserModel> result =
          await userAPI.userUpdateImage(idUser: idUser, imageFile: image);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> userUpdateFullName(String idUser, String fullName) async {
    try {
      final result = await userAPI.userUpdateFullName(idUser: idUser, fullName: fullName);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> userDelete({@required String idUser}) async {
    try {
      final result = await userAPI.userDelete(idUser: idUser);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
