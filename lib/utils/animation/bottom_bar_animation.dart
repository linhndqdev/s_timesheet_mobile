import 'dart:math';

import 'package:flutter/material.dart';

class BottomBarAnimation extends StatefulWidget {
  final Widget WIDGETACTION;

  BottomBarAnimation(this.WIDGETACTION);

  @override
  _BottomBarAnimationState createState() => _BottomBarAnimationState();
}

class _BottomBarAnimationState extends State<BottomBarAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animation = Tween<double>(
      begin: 1.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceOut,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return Transform.scale(
              alignment: FractionalOffset.center,
              scale: _animation.value,
              child: widget.WIDGETACTION);
        });
  }
}
