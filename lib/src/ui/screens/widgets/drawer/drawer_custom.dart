import 'package:flutter/material.dart';

import './drawer_header.dart';
import './drawer_body.dart';

class DrawerCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Widget : Drawer Custom.dart  | Rebuild !");

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            DrawerHeaderCustom(),
            DrawerBody(),
          ],
        ),
      ),
    );
  }
}
