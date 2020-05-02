import 'dart:ui';

import 'package:flutter/material.dart';

class ColorPallete {
  Brightness getAppTheme(BuildContext context) => Theme.of(context).brightness;
  Color white = Color(0xFFFFFFFF);
  Color black = Color(0xFF000000);
  Color transparent = Color(0x00000000);

  /// Grey
  Color grey = Color(0xFFeaeaea);
  Color greyTransparent = Color(0xFFBDBDBD);

  ///Primary Color
  Color primaryColor = Color(0xffe23e57);
  Color primaryColor2 = Color(0xfff8b195);

  ///Accent Color
  Color accentColor = Color(0xff88304e);
  Color accentColor2 = Color(0xfff67280);

  /// Scaffold Color
  Color scaffoldColor = Color(0xFFf9f9f9);

  /// Scaffold Dark Color
  Color scaffoldDarkColor = Color(0xFF003545);

  // Color darkModeColor = Color(0xff121212);
  Color accentDarkModeColor = Color(0xFFf638dc);
}

final colorPallete = ColorPallete();
