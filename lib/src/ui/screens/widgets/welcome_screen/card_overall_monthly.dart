import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import './content_performance.dart';

class CardOverallMonthly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizes.height(context) / 3,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: sizes.height(context) / 30,
          bottom: sizes.height(context) / 30,
          left: sizes.width(context) / 20,
          right: sizes.width(context) / 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: colorPallete.primaryColor,
          boxShadow: [
            BoxShadow(
              color: colorPallete.black.withOpacity(.5),
              offset: const Offset(1.5, 3),
              blurRadius: 2,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 8.0, left: 12.0),
          child: Column(
            children: const <Widget>[
              TitlePerformance(),
              ContentPerformance(),
            ],
          ),
        ),
      ),
    );
  }
}

class TitlePerformance extends StatelessWidget {
  const TitlePerformance({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: SizedBox(
        width: sizes.width(context) / 1.9,
        child: FittedBox(
          child: Text(
            'Performance Bulanan',
            style: appTheme.headline6(context).copyWith(
                  color: colorPallete.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
