import 'package:flutter/material.dart';

import 'package:global_template/global_template.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    @required this.onPressed,
    this.alignment = Alignment.bottomRight,
    this.icon,
    this.child,
    this.disabledColor,
    this.disabledElevation,
    this.disabledTextColor,
    this.textStyle,
    this.shape,
    this.buttonColor,
    this.padding,
    this.buttonPlusIcon = false,
    this.buttonTitle = 'SUBMIT',
    this.buttonSize = 1,
    this.buttonHeight = 18,
    this.fontWeight = FontWeight.normal,
  });

  final double disabledElevation;
  final double buttonSize;
  final double buttonHeight;
  final Color buttonColor;
  final Color disabledColor;
  final Color disabledTextColor;
  final FontWeight fontWeight;
  final ShapeBorder shape;
  final TextStyle textStyle;
  final bool buttonPlusIcon;
  final Function onPressed;
  final String buttonTitle;
  final Widget icon;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final defaultButton = RaisedButton(
      onPressed: onPressed,
      disabledColor: disabledColor,
      disabledTextColor: disabledTextColor,
      disabledElevation: disabledElevation,
      shape: shape,
      textTheme: ButtonTextTheme.primary,
      // color: buttonColor == null ? colorPallete.primaryColor : buttonColor,
      color: buttonColor ?? colorPallete.primaryColor,
      child: child ??
          Text(
            buttonTitle,
            style: textStyle ??
                appTheme.subtitle1(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
          ),
    );
    final buttonIcon = RaisedButton.icon(
      onPressed: onPressed,
      disabledColor: disabledColor,
      disabledTextColor: disabledTextColor,
      disabledElevation: disabledElevation,
      shape: shape,
      textTheme: ButtonTextTheme.primary,
      color: buttonColor ?? Theme.of(context).primaryColor,
      icon: icon ?? const SizedBox(),
      label: child ??
          Text(
            buttonTitle,
            style: textStyle ??
                appTheme.subtitle1(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
          ),
    );
    return Container(
      padding: padding,
      width: sizes.width(context) / buttonSize,
      height: sizes.height(context) / buttonHeight,
      child: buttonPlusIcon ? buttonIcon : defaultButton,
    );
  }
}
