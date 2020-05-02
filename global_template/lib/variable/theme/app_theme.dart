import 'package:flutter/material.dart';

class AppTheme {
  ThemeData theme(BuildContext context) => Theme.of(context);
  TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;

  ///Used for emphasizing text that would otherwise be [bodyText2].
  TextStyle bodyText1(BuildContext context) => textTheme(context).bodyText1;

  ///The default text style for [Material].
  TextStyle bodyText2(BuildContext context) => textTheme(context).bodyText2;

  ///Used for text on [RaisedButton] and [FlatButton].
  TextStyle button(BuildContext context) => textTheme(context).button;

  ///Used for auxiliary text associated with images.
  TextStyle caption(BuildContext context) => textTheme(context).caption;

  ///Extremely large text.
  TextStyle headline1(BuildContext context) => textTheme(context).headline1;

  ///Used for the date in the dialog shown by [showDatePicker].
  TextStyle headline2(BuildContext context) => textTheme(context).headline2;

  ///Very large text.
  TextStyle headline3(BuildContext context) => textTheme(context).headline3;

  ///Large text.
  TextStyle headline4(BuildContext context) => textTheme(context).headline4;

  ///Used for large text in dialogs (e.g., the month and year in the dialog shown by [showDatePicker]).
  TextStyle headline5(BuildContext context) => textTheme(context).headline5;

  ///Used for the primary text in app bars and dialogs (e.g., [AppBar.title] and [AlertDialog.title]).
  TextStyle headline6(BuildContext context) => textTheme(context).headline6;

  ///The smallest style.
  ///Typically used for captions or to introduce a (larger) headline.
  TextStyle overline(BuildContext context) => textTheme(context).overline;

  ///Used for the primary text in lists (e.g., [ListTile.title]).
  TextStyle subtitle1(BuildContext context) => textTheme(context).subtitle1;

  ///For medium emphasis text that's a little smaller than [subtitle1].
  TextStyle subtitle2(BuildContext context) => textTheme(context).subtitle2;
}

final appTheme = AppTheme();
