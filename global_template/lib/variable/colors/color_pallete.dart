import 'dart:ui';

import 'package:flutter/material.dart';

class ColorPallete {
  Brightness getAppTheme(BuildContext context) => Theme.of(context).brightness;
  Color white = const Color(0xFFFFFFFF);
  Color black = const Color(0xFF222831);
  Color transparent = const Color(0x00000000);

  /// Grey
  Color grey = const Color(0xFFeaeaea);
  Color greyTransparent = const Color(0xFFBDBDBD);

  ///Primary Color
  Color primaryColor = const Color(0xff7c73e6);
  Color primaryColor2 = const Color(0xfff8b195);

  ///Accent Color
  Color accentColor = const Color(0xffE67C73);
  Color accentColor2 = const Color(0xfff67280);

  /// Scaffold Color
  Color scaffoldColor = const Color(0xFFf9f9f9);

  /// Scaffold Dark Color
  Color scaffoldDarkColor = const Color(0xFF003545);

  // Color darkModeColor = const Color(0xff121212);
  Color accentDarkModeColor = const Color(0xFFf638dc);
}

final colorPallete = ColorPallete();
