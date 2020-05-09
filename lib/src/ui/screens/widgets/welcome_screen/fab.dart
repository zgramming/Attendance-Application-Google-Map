import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FabChangeMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
      builder: (_, value, __) => FloatingActionButton(
        onPressed: () {
          value.setChangeMode(value.isChangeMode);
        },
        mini: true,
        child:
            Icon(value.isChangeMode ? FontAwesomeIcons.calendarTimes : FontAwesomeIcons.tabletAlt),
      ),
    );
  }
}
