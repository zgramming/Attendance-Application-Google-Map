import 'package:flutter/material.dart';

enum AnimateFrom { FromLeft, FromRight, FromTop, FromBottom }

class GSlideTransition extends StatefulWidget {
  const GSlideTransition({
    @required this.child,
    this.curve = Curves.fastOutSlowIn,
    this.duration = const Duration(seconds: 2),
    this.position = AnimateFrom.FromRight,
  });
  final Duration duration;
  final Widget child;
  final Curve curve;
  final AnimateFrom position;
  @override
  GSlideTransitionState createState() => GSlideTransitionState();
}

class GSlideTransitionState extends State<GSlideTransition> with TickerProviderStateMixin {
  Animation<Offset> slide;
  AnimationController slideController;
  @override
  void initState() {
    Offset offset;
    if (widget.position == AnimateFrom.FromBottom) {
      offset = const Offset(0.0, -100);
    } else if (widget.position == AnimateFrom.FromTop) {
      offset = const Offset(0.0, 100);
    } else if (widget.position == AnimateFrom.FromLeft) {
      offset = const Offset(100.0, 0.0);
    } else if (widget.position == AnimateFrom.FromRight) {
      offset = const Offset(-100, 0.0);
    } else {
      offset = const Offset(0.0, -100);
    }
    print(offset);
    slideController = AnimationController(vsync: this, duration: widget.duration);
    slide = Tween<Offset>(begin: offset, end: Offset.zero)
        .animate(CurvedAnimation(parent: slideController, curve: widget.curve));
    slideController.forward();
    super.initState();
  }

  @override
  void dispose() {
    slideController.dispose();
    super.dispose();
  }

  Widget buildAnimation() {
    return AnimatedBuilder(
      animation: slideController,
      child: widget.child,
      builder: (context, child) => Transform.translate(
        offset: slide.value,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.position);
    return buildAnimation();
  }
}
