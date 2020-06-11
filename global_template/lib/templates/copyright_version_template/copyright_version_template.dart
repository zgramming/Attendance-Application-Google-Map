import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:global_template/global_template.dart';

class CopyRightVersion extends StatelessWidget {
  final String copyRight;
  final Color colorText;
  final Color backgroundColor;
  final bool showOnlyVersion;
  CopyRightVersion({
    this.copyRight = "Copyright \u00a9 Zeffry Reynando",
    this.colorText = Colors.white,
    this.backgroundColor,
    this.showOnlyVersion = false,
  });
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: colorText),
      child: Container(
        color: backgroundColor == null ? Colors.transparent : backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<GlobalProvider>(
              builder: (_, globalProvider, __) => Text(
                showOnlyVersion
                    ? "VERSION ${globalProvider.versionPackageInfo}"
                    : "${globalProvider.appNamePackageInfo} | Version ${globalProvider.versionPackageInfo}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),






            
            SizedBox(height: 5),
            Text(
              showOnlyVersion ? '' : copyRight,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
