import 'dart:io';

import 'package:core_asgl/dialog/dialog.dart';
import 'package:core_asgl/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:s_timesheet_mobile/auth/forgot_password/confirm_forgot_pass.dart';
import 'package:s_timesheet_mobile/auth/forgot_password/forgot_pass_screen.dart';
import 'package:s_timesheet_mobile/auth/login_screen.dart';
import 'package:s_timesheet_mobile/auth/profile/my_profile_screen.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/core/bloc_provider.dart';
import 'package:s_timesheet_mobile/home/home_screen.dart';
import 'package:s_timesheet_mobile/model/auth_model.dart';
import 'package:s_timesheet_mobile/core/style.dart' as prefix0;
import 'package:s_timesheet_mobile/utils/model/dialog_model.dart';
import 'package:s_timesheet_mobile/utils/widget/dialog_util.dart';
//import 'package:s_timesheet_mobile/splash/splash_screen.dart';

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> with WidgetsBindingObserver {
  AppBloc appBloc;
  final MethodChannel methodChannel =
      MethodChannel("com.asgl.s_timesheet_mobile");

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (appBloc.authBloc.newJwt != "" && state == AppLifecycleState.resumed) {
      resetApplicationWithNewJWT(appBloc);
    }
    if(state == AppLifecycleState.resumed){
      FocusScope.of(context).requestFocus(new FocusNode());
    }
  }

  //Reset application
  void resetApplicationWithNewJWT(AppBloc appBloc) async {
    if (Platform.isIOS) {
      appBloc.authBloc.newJwt = "";
      appBloc.authBloc.newPassword = "";
      appBloc.authBloc.newUserName = "";
      appBloc.authBloc.logOutAndReLogin(appBloc);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    methodChannel.setMethodCallHandler((call) async {
      try {
        if (call != null &&
            call.method == "com.asgl.s_timesheet_mobile.new_intent_jwt") {
          if (call.arguments != null && call.arguments.toString() != "") {
            appBloc.authBloc.setData(call.arguments);
          }
        } else if (call != null &&
            call.method == "com.asgl.s_timesheet_mobile.new_url_data") {
          appBloc.authBloc.setData(call.arguments);
        }
      } catch (ex) {
        print(ex.toString());
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 1080, height: 1980, allowFontScaling: false);
    appBloc = BlocProvider.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (appBloc.backStateBloc.focusWidgetModel.state ==
            isFocusWidget.FORGOT_PASSWORD) {
          appBloc.authBloc.changeStateBackToLogin();
          appBloc.backStateBloc.setStateToOther(state: isFocusWidget.LOGIN);
          //return false;
        } else if (appBloc.backStateBloc.focusWidgetModel.state ==
            isFocusWidget.LOGIN) {
          //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          appBloc.authBloc.requestExitApplicationNotLogout(context);
        } else {
          //cho phép chạy vào check các will pop bên trong homescreen
          return true;
        }
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              StreamBuilder(
                initialData: AuthenticationModel(AuthState.SPLASH, false, null),
                stream: appBloc.authBloc.authStream.stream,
                builder: (buildContext,
                    AsyncSnapshot<AuthenticationModel> snapshotData) {
                  switch (snapshotData.data.state) {
                    case AuthState.LOGIN_FAILED:
                      return LoginScreen();
                      break;
                    case AuthState.LOGIN_SUCCESS:
                      return HomeScreen();
                      break;
                    case AuthState.REQUEST_LOGIN:
                      return LoginScreen();
                      break;
                    case AuthState.FORGOTPASS:
                      return ForgotPassScreen();
                      break;
                    case AuthState.CONFIRMFORGOTPASS:
                      return ConfirmForgotPass(
                          messageString: snapshotData.data.data);
                      break;
                    default:
                      return _buildSplash();
                      break;
                  }
                },
              ),
              StreamBuilder(
                  initialData: false,
                  stream: appBloc.showMyProfileStream.stream,
                  builder: (buildContext, AsyncSnapshot<bool> myProfileSnap) {
                    if (myProfileSnap.data) {
                      return MyProfileLayout();
                    } else {
                      return Container();
                    }
                  })
            ],
          )),
    );

  }

  Widget _buildSplash() {
    return SplashScreen(
      onInitCallback: () {
        Future.delayed(Duration(seconds: 2), () {
          appBloc.authBloc.checkAuthentication(context);
        });
      },
      splashModel: SplashModel(
          animateBackgroundColor: prefix0.accentColor,
          curvesAnimated: Curves.fastOutSlowIn,
          blendModeColor: prefix0.accentColor.withOpacity(0.9),
          logoResource: "asset/images/img_bg_splash_full.png",
          logoSize: MediaQuery.of(context).size.height,
          splashComponent: <SplashComponent>[
            Distance(
              distance: 371.0.h,
            ),
            ImageSplash("asset/images/img_logo.png",
                imgSizeWidth: ScreenUtil().setWidth(596.5)),
            Distance(
              distance: 74.4.h,
            ),
            ImageSplash("asset/images/ic_splash.png",
                imgSizeWidth: ScreenUtil().setWidth(397.9)),
            Distance(
              distance: 10.0.h,
            ),
            ImageSplash("asset/images/ic_splash_text.png",
                imgSizeWidth: ScreenUtil().setWidth(430.0)),
          ]),
    );
  }
}
