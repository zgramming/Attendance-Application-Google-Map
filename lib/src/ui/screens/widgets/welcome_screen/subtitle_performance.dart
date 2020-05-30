import 'package:flutter/material.dart';

class SubtitlePerformance extends StatelessWidget {
  const SubtitlePerformance({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Widget : WelcomeScreen/SubtitlePerformance.dart   | Rebuild !");

    return Flexible(
      fit: FlexFit.tight,
      child: Row(
        children: [
          const Flexible(
            child: Text(
              'Hari Kerja',
              textAlign: TextAlign.center,
            ),
            fit: FlexFit.tight,
          ),
          const Flexible(
            child: Text(
              'Tepat Waktu',
              textAlign: TextAlign.center,
            ),
            fit: FlexFit.tight,
          ),
        ],
      ),
    );
  }
}
