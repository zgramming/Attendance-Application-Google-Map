import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_template/global_template.dart';

class AppBarAnimatedColor extends StatefulWidget {
  final Widget title;
  final AnimationController controller;
  AppBarAnimatedColor({@required this.controller, this.title});
  @override
  _AppBarAnimatedColorState createState() => _AppBarAnimatedColorState();
}

class _AppBarAnimatedColorState extends State<AppBarAnimatedColor> {
  Animation<Color> appBarColor, iconColor;

  @override
  void initState() {
    appBarColor = ColorTween(begin: Colors.transparent, end: colorPallete.primaryColor)
        .animate(CurvedAnimation(parent: widget.controller, curve: Curves.decelerate));
    iconColor = ColorTween(begin: colorPallete.accentColor, end: colorPallete.white)
        .animate(CurvedAnimation(parent: widget.controller, curve: Curves.decelerate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuild AppBarAnimatedColor ");
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_, __) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlutterLogo(),
          ),
          elevation: 0,
          title: widget.title ??
              Text(
                '',
                style: appTheme.subtitle1(context).copyWith(color: iconColor.value),
              ),
          backgroundColor: appBarColor.value,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () => '',
                child: Icon(
                  FontAwesomeIcons.bars,
                  color: iconColor.value,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
