import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

class DoubleTapToExit {
  DateTime _currentBackPressTime;
  Future<bool> doubleTapToExit({
    @required GlobalKey<ScaffoldState> scaffoldKey,
  }) async {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime) > Duration(seconds: 2)) {
      _currentBackPressTime = now;
      globalF.showToast(message: 'Tekan Sekali Lagi Untuk Keluar Aplikasi');
      print("Press Again To Close Application");
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}

final doubleTapToExit = DoubleTapToExit();
