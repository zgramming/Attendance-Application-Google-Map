import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

class AppBarAnimatedColor extends StatefulWidget {
  final Widget title;
  final AnimationController controller;
  final List<Widget> action;
  AppBarAnimatedColor({@required this.controller, this.action, this.title});
  @override
  _AppBarAnimatedColorState createState() => _AppBarAnimatedColorState();
}

class _AppBarAnimatedColorState extends State<AppBarAnimatedColor> {
  Animation<Color> appBarColor, iconColor;

  @override
  void initState() {
    appBarColor = ColorTween(begin: Colors.transparent, end: colorPallete.primaryColor)
        .animate(widget.controller);
    iconColor = ColorTween(begin: colorPallete.primaryColor, end: colorPallete.white)
        .animate(widget.controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_, __) => AppBar(
          elevation: 0,
          title: widget.title ??
              Text(
                'AppBar',
                style: appTheme.subtitle1(context).copyWith(color: iconColor.value),
              ),
          backgroundColor: appBarColor.value,
          actions: widget.action),
    );
  }
}
