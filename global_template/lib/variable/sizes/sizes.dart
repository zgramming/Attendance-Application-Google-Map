import 'package:flutter/material.dart';

class SizesDevice {
  MediaQueryData mediaQuery(BuildContext context) => MediaQuery.of(context);

  double width(BuildContext context) => MediaQuery.of(context).size.width;
  double height(BuildContext context) => MediaQuery.of(context).size.height;

  double statusBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  double screenHeightMinusAppBar(BuildContext context) =>
      sizes.height(context) - kToolbarHeight;

  double screenHeightMinusStatusBar(BuildContext context) =>
      sizes.height(context) - statusBarHeight(context);

  double screenHeightMinusAppBarMinusStatusBar(BuildContext context) =>
      sizes.height(context) - kToolbarHeight - statusBarHeight(context);

  double keyboardHeight(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom;

  double dp4(BuildContext context) => MediaQuery.of(context).size.width / 100;
  double dp6(BuildContext context) => MediaQuery.of(context).size.width / 70;
  double dp8(BuildContext context) => MediaQuery.of(context).size.width / 54;
  double dp10(BuildContext context) => MediaQuery.of(context).size.width / 41;
  double dp12(BuildContext context) => MediaQuery.of(context).size.width / 34;
  double dp14(BuildContext context) => MediaQuery.of(context).size.width / 29;
  double dp16(BuildContext context) => MediaQuery.of(context).size.width / 26;
  double dp18(BuildContext context) => MediaQuery.of(context).size.width / 23;
  double dp20(BuildContext context) => MediaQuery.of(context).size.width / 20;
  double dp22(BuildContext context) => MediaQuery.of(context).size.width / 17;
  double dp24(BuildContext context) => MediaQuery.of(context).size.width / 16;
  double dp25(BuildContext context) => MediaQuery.of(context).size.width / 15;
}

final sizes = SizesDevice();
