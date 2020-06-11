import 'package:flutter/material.dart';

class SubtitlePerformance extends StatelessWidget {
  const SubtitlePerformance({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: Row(
        children: const <Widget>[
          Flexible(
            child: Text(
              'Hari Kerja',
              textAlign: TextAlign.center,
            ),
            fit: FlexFit.tight,
          ),
          Flexible(
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
