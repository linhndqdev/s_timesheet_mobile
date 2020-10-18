import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:s_timesheet_mobile/core/core.dart';
import 'package:s_timesheet_mobile/core/style.dart' as prefix0;
import 'package:flutter_screenutil/size_extension.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  AppBloc appBloc;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    super.initState();

  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2),(){
      appBloc.authBloc.checkAuthentication(context);
    });
    appBloc = BlocProvider.of(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 1000),
      color: prefix0.accentColor,
      curve: Curves.fastOutSlowIn,
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "asset/images/img_bg_splash_full.png",
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
//              width: MediaQuery.of(context).size.width,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            color: prefix0.accentColor.withOpacity(0.9),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 371.0.h,
                    ),
                    Image.asset(
                      "asset/images/img_logo.png",
                      width: ScreenUtil().setWidth(596.5),
                    ),
                    SizedBox(
                      height: 74.4.h,
                    ),
                    Image.asset(
                      "asset/images/ic_splash.png",
                      width: ScreenUtil().setWidth(397.9),
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Image.asset(
                      "asset/images/ic_splash_text.png",
                      width: ScreenUtil().setWidth(430.0),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
