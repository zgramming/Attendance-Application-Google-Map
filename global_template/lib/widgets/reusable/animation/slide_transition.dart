import 'package:flutter/material.dart';

enum AnimateFrom { FromLeft, FromRight, FromTop, FromBottom }

class GSlideTransition extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final Curve curve;
  final AnimateFrom position;
  GSlideTransition({
    @required this.child,
    this.curve = Curves.fastOutSlowIn,
    this.duration = const Duration(seconds: 2),
    this.position = AnimateFrom.FromRight,
  });
  @override
  GSlideTransitionState createState() => GSlideTransitionState();
}

class GSlideTransitionState extends State<GSlideTransition> with TickerProviderStateMixin {
  Animation<Offset> slide;
  AnimationController slideController;
  @override
  void initState() {
    super.initState();
    Offset offset;
    if (widget.position == AnimateFrom.FromBottom) {
      offset = Offset(0.0, -100);
    } else if (widget.position == AnimateFrom.FromTop) {
      offset = Offset(0.0, 100);
    } else if (widget.position == AnimateFrom.FromLeft) {
      offset = Offset(100.0, 0.0);
    } else if (widget.position == AnimateFrom.FromRight) {
      offset = Offset(-100, 0.0);
    } else {
      offset = Offset(0.0, -100);
    }
    print(offset);
    slideController = AnimationController(vsync: this, duration: widget.duration);
    slide = Tween<Offset>(begin: offset, end: Offset.zero)
        .animate(CurvedAnimation(parent: slideController, curve: widget.curve));
    slideController.forward();
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
