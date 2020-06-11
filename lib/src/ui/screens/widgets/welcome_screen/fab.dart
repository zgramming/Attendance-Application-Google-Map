import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FabChangeMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () =>
          context.read<GlobalProvider>().setChangeMode(context.read<GlobalProvider>().isChangeMode),
      mini: true,
      child: Selector<GlobalProvider, bool>(
        selector: (_, provider) => provider.isChangeMode,
        builder: (_, value, __) {
          return AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            switchInCurve: Curves.decelerate,
            switchOutCurve: Curves.decelerate,
            child: Icon(
              value ? FontAwesomeIcons.calendarDay : FontAwesomeIcons.table,
              key: UniqueKey(),
              color: colorPallete.white,
            ),
          );
        },
      ),
    );
  }
}
