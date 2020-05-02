import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import '../live_clock.dart';

class ButtonAttendance extends StatelessWidget {
  ButtonAttendance({
    @required this.hideFabAnimation,
    @required this.onTapAttendence,
    @required this.onTapGoHome,
    this.bottom = 10,
    this.left = 10,
    this.right = 10,
  });

  final AnimationController hideFabAnimation;
  final Function onTapAttendence;
  final Function onTapGoHome;
  final double bottom;
  final double left;
  final double right;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      left: left,
      right: right,
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
                      child: LiveClock(),
                    ),
                  ),
                  Flexible(
                    child: ButtonCustom(
                      padding: EdgeInsets.symmetric(horizontal: 6.0),
                      child: LiveClock(),
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
