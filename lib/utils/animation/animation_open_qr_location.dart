import 'package:flutter/material.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/bloc_provider.dart';

class OpenAnimationQRandLocation extends StatefulWidget {
  final Widget widgetAction;
  final Function(dynamic data) voidCallback;

  OpenAnimationQRandLocation(this.widgetAction,{this.voidCallback});

  @override
  _OpenAnimationQRandLocationState createState() => _OpenAnimationQRandLocationState();
}

class _OpenAnimationQRandLocationState extends State<OpenAnimationQRandLocation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animationScale;
  AppBloc appBloc;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
    _animationScale = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
       widget.voidCallback(_controller);
      }
    });
    _controller.forward();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appBloc=BlocProvider.of(context);
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return Transform.translate(
            offset: Offset(0,MediaQuery.of(context).size.height*_animationScale.value),
            child: widget.widgetAction,
          );
        });
  }
}
