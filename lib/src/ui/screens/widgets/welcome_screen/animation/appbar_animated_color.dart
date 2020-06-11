import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarAnimatedColor extends StatefulWidget {
  const AppBarAnimatedColor({@required this.controller, this.leading});
  final Widget leading;
  final AnimationController controller;
  @override
  _AppBarAnimatedColorState createState() => _AppBarAnimatedColorState();
}

class _AppBarAnimatedColorState extends State<AppBarAnimatedColor> {
  Animation<Color> appBarColor, iconColor, logoColor;

  @override
  void initState() {
    appBarColor = ColorTween(begin: Colors.transparent, end: colorPallete.primaryColor)
        .animate(CurvedAnimation(parent: widget.controller, curve: Curves.decelerate));

    iconColor = ColorTween(begin: colorPallete.accentColor, end: colorPallete.white)
        .animate(CurvedAnimation(parent: widget.controller, curve: Curves.decelerate));

    logoColor = ColorTween(begin: colorPallete.transparent, end: colorPallete.white)
        .animate(CurvedAnimation(parent: widget.controller, curve: Curves.decelerate));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_, __) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: widget.leading,
          ),
          elevation: 0,
          backgroundColor: appBarColor.value,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () => Scaffold.of(context).openDrawer(),
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
