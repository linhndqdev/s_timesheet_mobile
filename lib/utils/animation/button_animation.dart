import 'package:flutter/material.dart';
import 'package:flutter_screenutil/size_extension.dart';
import '../../core/bloc_provider.dart';
import '../../core/app_bloc.dart';

class ButtonAnimation extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final int color;
  final Function(AnimationController data) onClicked;
  final isControlEvent;
  final AppBloc appBloc;

  ButtonAnimation(
      {this.child,
      this.width,
      this.height,
      this.color,
      this.onClicked,
      this.isControlEvent = false,
      this.appBloc});

  @override
  _ButtonAnimationState createState() => _ButtonAnimationState();
}

class _ButtonAnimationState extends State<ButtonAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween<double>(
      begin: widget.width,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
    _controller?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onClicked(_controller);
      }
    });
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
          return Container(
            child: _animation.value < widget.height
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(widget.color),
                    ),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    width: _animation.value,
                    height: widget.height,
                    child: InkWell(
                      onTap: () async {
                        if (!widget.isControlEvent) {
                          _controller.reset();
                          _controller.forward();
                        } else {
                          widget.onClicked(_controller);
                        }
                      },
                      child: widget.child,
                    ),
                  ),
          );
        });
  }
}
