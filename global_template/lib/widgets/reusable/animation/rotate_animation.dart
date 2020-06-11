import 'dart:math';
import 'package:flutter/material.dart';

class GRotateAnimation extends StatefulWidget {
  const GRotateAnimation({
    @required this.child,
    this.duration = const Duration(milliseconds: 2000),
  });
  final Widget child;
  final Duration duration;
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

    _bounce = Tween<double>(begin: 60.0, end: -60.0)
        .animate(CurvedAnimation(parent: _bounceController, curve: const Interval(.75, 1)));
    _rotate = Tween<double>(begin: 0.0, end: 2 * pi)
        .animate(CurvedAnimation(curve: const Interval(0.0, .5), parent: _bounceController));
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
      child: widget.child,
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
