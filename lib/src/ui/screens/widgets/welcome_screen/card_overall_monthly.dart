import 'package:flutter/material.dart';

import 'package:global_template/global_template.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CardOverallMonthly extends StatelessWidget {
  const CardOverallMonthly({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizes.height(context) / 3,
      margin: EdgeInsets.only(top: sizes.height(context) / 12),
      // color: Colors.purple,
      child: Stack(
        children: [
          Container(
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
                  offset: Offset(1.5, 3),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 8.0, left: 12.0),
              child: Column(
                children: [
                  buildHeader(context),
                  buildBody(context),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 8.0,
            ),
            child: ShowImageNetwork(
              imageUrl: "https://homepages.cae.wisc.edu/~ece533/images/fruits.png",
              fit: BoxFit.cover,
              imageWidth: 5,
              imageHeight: 8.25,
            ),
          ),
        ],
      ),
    );
  }

  Flexible buildBody(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: CircularPercentIndicator(
              radius: sizes.width(context) / 4,
              circularStrokeCap: CircularStrokeCap.round,
              lineWidth: 8,
              center: Text(
                '50%',
                style: appTheme.headline5(context).copyWith(
                      color: colorPallete.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              progressColor: Colors.green,
              backgroundColor: colorPallete.greyTransparent,
              percent: .5,
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: DefaultTextStyle(
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'VarelaRound',
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Row(
                      children: [
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
                  ),
                  Flexible(
                    flex: 2,
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            '25',
                            textAlign: TextAlign.center,
                            style: appTheme.headline3(context).copyWith(
                                  color: colorPallete.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          fit: FlexFit.tight,
                        ),
                        Flexible(
                          child: Text(
                            '10',
                            textAlign: TextAlign.center,
                            style: appTheme.headline4(context).copyWith(
                                  color: colorPallete.white,
                                ),
                          ),
                          fit: FlexFit.tight,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Flexible buildHeader(BuildContext context) {
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
