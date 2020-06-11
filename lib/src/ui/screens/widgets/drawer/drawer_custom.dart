import 'package:flutter/material.dart';

import './drawer_body.dart';
import './drawer_header.dart';

class DrawerCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            DrawerHeaderCustom(),
            DrawerBody(),
          ],
        ),
      ),
    );
  }
}
