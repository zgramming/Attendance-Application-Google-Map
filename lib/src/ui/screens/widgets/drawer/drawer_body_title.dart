import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

class DrawerBodyTitle extends StatelessWidget {
  const DrawerBodyTitle({@required this.title});
  final String title;

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
