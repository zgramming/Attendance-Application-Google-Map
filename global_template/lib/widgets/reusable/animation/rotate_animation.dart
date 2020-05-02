import 'package:flutter/material.dart';
import 'dart:math';

class GRotateAnimation extends StatefulWidget {
  final Widget widget;
  final Duration duration;
  final Curve curve;
  GRotateAnimation({
    @required this.widget,
    this.duration = const Duration(milliseconds: 700),
    this.curve = Curves.elasticIn,
  });
  @override
  _GRotateAnimationState createState() => _GRotateAnimationState();
}

class _GRotateAnimationState extends State<GRotateAnimation> with TickerProviderStateMixin {
  Animation<double> _bounce;
  AnimationController _bounceController;
  Animation<double> _rotate;
  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(vsync: this, duration: widget.duration);
    _bounceController.repeat(reverse: true);
    _bounce = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _bounceController, curve: widget.curve),
    );
    _rotate = Tween<double>(begin: 0.0, end: 2 * pi)
        .animate(CurvedAnimation(curve: Interval(0.0, .5), parent: _bounceController));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceController,
      child: widget.widget,
      builder: (ctx, child) => Transform.translate(
        offset: Offset(0.0, _bounce.value),
        child: Transform.rotate(
          angle: _rotate.value,
          child: child,
        ),
      ),
    );
  }
}
