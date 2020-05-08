import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:global_template/global_template.dart';

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
    return result.replaceAll(".", ":");
  }

  /// Format : Tahun
  String formatYear(DateTime date) {
    return DateFormat.y(appConfig.indonesiaLocale).format(date);
  }

  /// Format : Tahun:Bulan[type=?]
  String formatYearMonth(DateTime date, {int type = 1}) {
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
  String formatYearMonthDaySpecific(DateTime date, {int type = 1}) {
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

  ///! Mendapatkan Total Hari Pada bulan X
  int totalDaysOfMonth(int year, int month) {
    final result = (month < 12) ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);
    return result.day;
  }

  ///! Mendapatkan Total Jumlah Kerja yang sudah dikurangi weekend (Sabtu,Minggu).
  int totalWeekDayOfMonth(int year, int month, {int day = 1}) {
    int totalDayOfMonth = totalDaysOfMonth(year, month);
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

  Color isWeekend(String getDaysName, {Color colorWeekend, Color colorWeekDay}) {
    if (getDaysName.toLowerCase() == "sabtu" ||
        getDaysName.toLowerCase() == "minggu" ||
        getDaysName.toLowerCase() == "sab" ||
        getDaysName.toLowerCase() == "min") {
      return colorWeekend ?? colorPallete.primaryColor;
    } else {
      return colorWeekDay ?? null;
    }
  }

  Future<void> showToast({
    @required String message,
    bool isError = false,
    bool isLongDuration = false,
    bool isSuccess = false,
    Color backgroungColor,
    Color textColor,
    double fontSize = 16.0,
  }) async {
    await Fluttertoast.showToast(
      msg: message.toString(),
      backgroundColor: (isError) ? Colors.red : (isSuccess) ? Colors.green : backgroungColor,
      textColor: (isError || isSuccess) ? Colors.white : textColor,
      fontSize: fontSize,
      toastLength: isLongDuration ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    );
  }
}

final globalF = GlobalFunction();
