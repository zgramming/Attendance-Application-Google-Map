import 'package:flutter/material.dart';

class BounceAnimation extends StatefulWidget {
  final Widget widget;
  final Duration duration;
  BounceAnimation({@required this.widget, this.duration = const Duration(milliseconds: 700)});
  @override
  _BounceAnimationState createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation> with TickerProviderStateMixin {
  Animation<double> _bounce;
  AnimationController _bounceController;
  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(vsync: this, duration: widget.duration);
    _bounceController.repeat(reverse: true);
    _bounce = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.bounceIn),
    );
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
        child: child,
      ),
    );
  }
}
