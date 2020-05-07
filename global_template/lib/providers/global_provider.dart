import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/foundation.dart';

import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'package:intl/date_symbol_data_local.dart';

class GlobalProvider extends ChangeNotifier {
  GlobalProvider() {
    /// Untuk Setting Tanggal , Agar Bisa Memakai Format Tanggan (Senin 12 April 2020 16.50)
    initializeDateFormatting();
    _getDeviceId();
    _getPackageInfo();
  }
  //! For Get Device Id
  String _deviceId;
  String get deviceId => _deviceId;

  String _setDeviceId(String deviceId) {
    final result = deviceId;
    _deviceId = result;
    notifyListeners();
    return result;
  }

  Future<String> _getDeviceId() async {
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var buildAndroid = await deviceInfoPlugin.androidInfo;
        identifier = buildAndroid.androidId;
      } else if (Platform.isIOS) {
        var buildIos = await deviceInfoPlugin.iosInfo;
        identifier = buildIos.identifierForVendor;
      }
    } on PlatformException {
      print('Failed to get platform Version');
    }
    _setDeviceId(identifier);
    notifyListeners();
    return identifier;
  }

  //! Get Device Info Like AppName , Version etc.
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    buildNumber: 'Unknown',
    packageName: 'Unkwon',
    version: 'Unknown',
  );
  PackageInfo get packageInfo => _packageInfo;
  String get appNamePackageInfo => packageInfo.appName.toLowerCase();
  String get buildNumberPackageInfo => packageInfo.buildNumber;
  String get packageNamePackageInfo => packageInfo.packageName;
  String get versionPackageInfo => packageInfo.version;

  Future<PackageInfo> _getPackageInfo() async {
    final result = await PackageInfo.fromPlatform();
    _packageInfo = result;
    notifyListeners();
    return result;
  }

  bool _isChangeMode = false, _isLoading = false, _isRegister = false;

  bool get isChangeMode => _isChangeMode;
  void setChangeMode(bool value) {
    _isChangeMode = !value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isRegister => _isRegister;
  void setRegister(bool value) {
    _isRegister = value;
    notifyListeners();
  }

  bool _obsecurePassword = true;
  bool get obsecurePassword => _obsecurePassword;
  setObsecurePassword(bool value) {
    _obsecurePassword = !value;
    notifyListeners();
  }
}
