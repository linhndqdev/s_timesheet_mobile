import 'dart:math';

import 'package:flutter/material.dart';

class CloseCalendarAnimation extends StatefulWidget {
  final Widget WIDGETACTION;

  CloseCalendarAnimation(this.WIDGETACTION);

  @override
  _CloseCalendarDetailAnimationState createState() => _CloseCalendarDetailAnimationState();
}

class _CloseCalendarDetailAnimationState extends State<CloseCalendarAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animationScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 800));
    _animationScale = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
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
          return Transform.translate(
            offset: Offset(0,MediaQuery.of(context).size.height*_animationScale.value),
            child: widget.WIDGETACTION,
          );
        });
  }
}