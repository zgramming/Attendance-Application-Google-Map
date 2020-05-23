import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

class DrawerBodyTitle extends StatelessWidget {
  final String title;

  DrawerBodyTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
      child: Text(
        title,
        style: appTheme.headline6(context),
      ),
    );
  }
}
