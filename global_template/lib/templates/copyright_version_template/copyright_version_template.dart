import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:global_template/global_template.dart';

class CopyRightVersion extends StatelessWidget {
  const CopyRightVersion({
    this.copyRight = 'Copyright \u00a9 Zeffry Reynando',
    this.colorText = Colors.white,
    this.backgroundColor,
    this.showOnlyVersion = false,
  });
  final String copyRight;
  final Color colorText;
  final Color backgroundColor;
  final bool showOnlyVersion;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: colorText),
      child: Container(
        // color: backgroundColor == null ? Colors.transparent : backgroundColor,
        color: backgroundColor ?? Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<GlobalProvider>(
              builder: (_, globalProvider, __) => Text(
                showOnlyVersion
                    ? 'VERSION ${globalProvider.versionPackageInfo}'
                    : '${globalProvider.appNamePackageInfo} | Version ${globalProvider.versionPackageInfo}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              showOnlyVersion ? '' : copyRight,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
