import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

class ButtonAttendance extends StatelessWidget {
  ButtonAttendance({
    @required this.hideFabAnimation,
    @required this.onTapAttendence,
    @required this.onTapGoHome,
  });

  final AnimationController hideFabAnimation;
  final Function onTapAttendence;
  final Function onTapGoHome;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 10,
      right: 10,
      child: ScaleTransition(
        scale: hideFabAnimation,
        child: Card(
          // color: Colors.transparent,
          elevation: 0,
          child: Column(
            children: [
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Absen Masuk'),
                  Text('Absen Pulang'),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Flexible(
                    child: ButtonCustom(
                      onPressed: onTapAttendence,
                      padding: EdgeInsets.symmetric(horizontal: 6.0),
                      buttonTitle: globalF.formatHoursMinutesSeconds(DateTime.now()),
                    ),
                  ),
                  Flexible(
                    child: ButtonCustom(
                      padding: EdgeInsets.symmetric(horizontal: 6.0),
                      buttonTitle: globalF.formatHoursMinutesSeconds(DateTime.now()),
                      onPressed: onTapGoHome,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
