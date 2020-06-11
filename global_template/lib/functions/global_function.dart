import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:global_template/global_template.dart';

enum TimeFormat { Jam, JamMenit, JamMenitDetik, Menit, MenitDetik, Detik }

class GlobalFunction {
  /// Format Hari
  String formatDay(DateTime date, {int type = 2}) {
    if (type == 1) {
      return DateFormat.E(appConfig.indonesiaLocale).format(date);
    } else {
      return DateFormat.EEEE(appConfig.indonesiaLocale).format(date);
    }
  }

  /// Format : Jam
  String formatHours(DateTime date) {
    return DateFormat.H(appConfig.indonesiaLocale).format(date);
  }

  /// Format : Jam:Menit
  String formatHoursMinutes(DateTime date) {
    return DateFormat.Hm(appConfig.indonesiaLocale).format(date);
  }

  /// Format : Jam:Menit:Detik
  String formatHoursMinutesSeconds(DateTime date) {
    final result = DateFormat.Hms(appConfig.indonesiaLocale).format(date);
    return result.replaceAll('.', ':');
  }

  /// Format : Tahun
  String formatYear(DateTime date) {
    return DateFormat.y(appConfig.indonesiaLocale).format(date);
  }

  /// Format : Tahun:Bulan[type=?]
  String formatYearMonth(DateTime date, {int type = 3}) {
    if (type == 1) {
      return DateFormat.yM(appConfig.indonesiaLocale).format(date);
    } else if (type == 2) {
      return DateFormat.yMMM(appConfig.indonesiaLocale).format(date);
    } else if (type == 3) {
      return DateFormat.yMMMM(appConfig.indonesiaLocale).format(date);
    } else {
      return DateFormat.yMMMM(appConfig.indonesiaLocale).format(date);
    }
  }

  /// Format : Tahun:Bulan:Hari[type=?]
  String formatYearMonthDay(DateTime date, {int type = 1}) {
    if (type == 1) {
      return DateFormat.yMd(appConfig.indonesiaLocale).format(date);
    } else if (type == 2) {
      return DateFormat.yMMMd(appConfig.indonesiaLocale).format(date);
    } else if (type == 3) {
      return DateFormat.yMMMMd(appConfig.indonesiaLocale).format(date);
    } else {
      return DateFormat.yMMMMd(appConfig.indonesiaLocale).format(date);
    }
  }

  /// Format : Tahun:Bulan:Hari[type=?] , Specific disini maksudnya Hari = Senin,Selasa,Rabu,Kamis,Jumat,Sabtu,Minggu
  String formatYearMonthDaySpecific(DateTime date, {int type = 3}) {
    if (type == 1) {
      return DateFormat.yMEd(appConfig.indonesiaLocale).format(date);
    } else if (type == 2) {
      return DateFormat.yMMMEd(appConfig.indonesiaLocale).format(date);
    } else if (type == 3) {
      return DateFormat.yMMMMEEEEd(appConfig.indonesiaLocale).format(date);
    } else {
      return DateFormat.yMMMMEEEEd(appConfig.indonesiaLocale).format(date);
    }
  }

  /// Format : Time => Jam Menit
  String formatTimeTo(
    String time, {
    TimeFormat timeFormat,
  }) {
    if (time == null) {
      return '-';
    } else {
      final String hour = time.replaceAll(':', '').substring(0, 2);
      final String minute = time.replaceAll(':', '').substring(2, 4);
      final String second = time.replaceAll(':', '').substring(4, 6);
      String resultHour, resultMinute, resultSecond;
      if (hour.startsWith('0')) {
        resultHour = hour.substring(1);
      } else {
        resultHour = hour;
      }
      if (minute.startsWith('0')) {
        resultMinute = minute.substring(1);
      } else {
        resultMinute = minute;
      }
      if (second.startsWith('0')) {
        resultSecond = second.substring(1);
      } else {
        resultSecond = second;
      }

      switch (timeFormat) {
        case TimeFormat.Jam:
          return '$resultHour Jam ';
          break;
        case TimeFormat.JamMenit:
          return '$resultHour Jam $resultMinute Menit';
          break;
        case TimeFormat.JamMenitDetik:
          return '$resultHour Jam $resultMinute Menit $resultSecond Detik';
          break;
        case TimeFormat.Menit:
          return '$resultMinute Menit';
          break;
        case TimeFormat.MenitDetik:
          return '$resultMinute Menit $resultSecond Detik';
          break;
        case TimeFormat.Detik:
          return '$resultSecond Detik';
          break;
        default:
          return '$resultHour Jam $resultMinute Menit $resultSecond Detik';
      }
    }
  }

  ///! Mendapatkan Total Hari Pada bulan X
  int totalDaysOfMonth(int year, int month) {
    final result = (month < 12) ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);
    return result.day;
  }

  ///! Mendapatkan Total Jumlah Kerja yang sudah dikurangi weekend (Sabtu,Minggu).
  int totalWeekDayOfMonth(int year, int month, {int day = 1}) {
    final int totalDayOfMonth = totalDaysOfMonth(year, month);
    int result = 0;
    DateTime tempDateTime = DateTime(year, month, day);
    for (int i = day; i <= totalDayOfMonth; i++) {
      tempDateTime = DateTime(tempDateTime.year, tempDateTime.month, i);
      if (tempDateTime.weekday == DateTime.saturday || tempDateTime.weekday == DateTime.sunday) {
        // print('is weekend');
      } else {
        result++;
      }
    }
    return result;
  }

  ///! Memunculkan Toast
  Future<void> showToast({
    @required String message,
    bool isError = false,
    bool isSuccess = false,
    bool isLongDuration = false,
    Color backgroungColor,
    Color textColor,
    double fontSize = 16.0,
  }) async {
    await Fluttertoast.showToast(
      msg: message.toString(),
      backgroundColor: isError ? Colors.red : isSuccess ? Colors.green : backgroungColor,
      textColor: (isError || isSuccess) ? Colors.white : textColor,
      fontSize: fontSize,
      toastLength: isLongDuration ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    );
  }

  ///! Ketuk 2 Kali Untuk Keluar
  Future<bool> doubleTapToExit({
    @required GlobalKey<ScaffoldState> scaffoldKey,
  }) async {
    DateTime _currentBackPressTime;
    final DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime) > const Duration(seconds: 2)) {
      _currentBackPressTime = now;
      await globalF.showToast(message: 'Tekan Sekali Lagi Untuk Keluar Aplikasi');
      // print('Press Again To Close Application');
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}

final globalF = GlobalFunction();
