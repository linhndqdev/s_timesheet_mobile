import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:s_timesheet_mobile/auth/auth_bloc.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/core/core.dart';
import 'package:s_timesheet_mobile/core/style.dart' as prefix0;
import 'package:s_timesheet_mobile/utils/animation/ZoomInAnimation.dart';
import 'package:s_timesheet_mobile/utils/animation/button_animation.dart';
import 'package:s_timesheet_mobile/utils/widget/button_login_widget.dart';
import 'package:s_timesheet_mobile/utils/widget/loadding_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AppBloc appBloc;
  TextEditingController _inputPassController = TextEditingController();
  TextEditingController _inputUserController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BackStateBloc backStateBloc = BackStateBloc.getInstance();
    backStateBloc.setStateToOther(state: isFocusWidget.LOGIN);
    Future.delayed(Duration.zero, () async {
      appBloc?.authBloc?.checkUserNamePassWord();
    });
  }

  @override
  Widget build(BuildContext context) {
    appBloc = BlocProvider.of(context);

    return ZoomInAnimation(Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Container(
              width: MediaQuery.of(context).size.width,
//              color: prefix0.whiteColor,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(255)),
              margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(128.9),
                right: ScreenUtil().setWidth(127.9),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    "asset/images/logo.png",
                    width: ScreenUtil().setWidth(515),
                    height: ScreenUtil().setHeight(266.3),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(152.3),
                  ),
                  _buildTextFieldUser(),
                  StreamBuilder(
                      initialData: RegisterOldValidateState.NONE,
                      stream: appBloc.authBloc.validateUserStream.stream,
                      builder: (iconContext,
                          AsyncSnapshot<RegisterOldValidateState>
                              validateNameSnap) {
                        switch (validateNameSnap.data) {
                          case RegisterOldValidateState.NONE:
                            return Container(
                                height: ScreenUtil().setHeight(40.0));
                            break;
                          case RegisterOldValidateState.ERROR:
                            return Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(10),
                                  bottom: ScreenUtil().setHeight(7.8)),
                              child: Text(
                                "Vui lòng nhập mã nhân viên đúng định dạng",
                                style: TextStyle(
                                    color: prefix0.redColor,
                                    fontSize: ScreenUtil().setSp(34)),
                              ),
                            );
                            break;
                          case RegisterOldValidateState.MATCHED:
                            return Container(
                                height: ScreenUtil().setHeight(51.8));
                            break;
                          default:
                            return Container(
                                height: ScreenUtil().setHeight(51.8));
                            break;
                        }
                      }),
                  _buildTextFieldPass(),
                  StreamBuilder(
                      initialData: RegisterOldValidateState.NONE,
                      stream: appBloc.authBloc.validatePassStream.stream,
                      builder: (iconContext,
                          AsyncSnapshot<RegisterOldValidateState>
                              validateNameSnap) {
                        switch (validateNameSnap.data) {
                          case RegisterOldValidateState.NONE:
                            return Container();
                            break;
                          case RegisterOldValidateState.ERROR:
                            return Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(10),
                                  bottom: ScreenUtil().setHeight(12)),
                              child: Text(
                                "Vui lòng nhập đúng định dạng mật khẩu .",
                                style: TextStyle(
                                    color: prefix0.redColor,
                                    fontSize: ScreenUtil().setSp(34)),
                              ),
                            );
                            break;
                          case RegisterOldValidateState.MATCHED:
                            return Container();
                            break;
                          default:
                            return Container();
                            break;
                        }
                      }),
                  Container(
                    width: ScreenUtil().setWidth(823),
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(64.3)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(child: _buildRememberPass()),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(63.0),
                  ),
                  StreamBuilder(
                      initialData: false,
                      stream:
                          appBloc.authBloc.haveUserNamePasswordStream.stream,
                      builder:
                          (buildContext, AsyncSnapshot<bool> snapshotData) {
                        if (snapshotData.data) {
                          return ButtonLoginWidget(appBloc,
                              _inputUserController, _inputPassController);
                        } else {
                          return ButtonAnimation(
                            width: 823.w,
                            height: 129.h,
                            color: 0xff005a88,
                            child: ButtonTheme(
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: prefix0.accentColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.w)),
                                    ),
                                    width: 823.w,
                                    height: 129.h,
                                    child: Center(
                                      child: Text('Đăng nhập'.toUpperCase(),
                                          style: TextStyle(
                                            fontFamily: 'Roboto-Medium',
                                            fontSize: ScreenUtil().setSp(48.0),
                                            color: prefix0.whiteColor,
                                          )),
                                    ))),
                            isControlEvent: false,
                            onClicked: (controller) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              appBloc.authBloc.loginWith(
                                  context,
                                  _inputUserController.text,
                                  _inputPassController.text,
                                  animationControllerButtonLogin: controller
                              );
                            },
                          );
                        }
                      }),
                  SizedBox(
                    height: ScreenUtil().setHeight(46.0),
                  ),
                  InkWell(
                    onTap: () {
                      appBloc.authBloc.moveToForgotPassScreen();
                    },
                    child: Text("Quên mật khẩu?",
                        style: TextStyle(
                            color: Color(0xffe18c12),
                            fontSize: ScreenUtil().setSp(50.0),
                            fontFamily: 'Roboto-Regular')),
                  ),
                ],
              ),
            ),
          ),
        ),
        StreamBuilder(
          initialData: false,
          stream: appBloc.authBloc.loadingStream.stream,
          builder: (loadingContext, AsyncSnapshot<bool> loadingSnap) {
            if (loadingSnap.data) {
              return Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              );
            } else {
              return Container();
            }
          },
        )
      ],
    ));
  }

  _buildTextFieldUser() {
    _inputUserController.text = appBloc.authBloc?.email ?? "";
    return Stack(
      children: <Widget>[
        TextField(
          keyboardType: TextInputType.emailAddress,
          cursorColor: prefix0.accentColor,
          textInputAction: TextInputAction.done,
          textAlign: TextAlign.start,
          controller: _inputUserController,
          maxLines: 1,
          obscureText: false,
          enabled: true,
          onChanged: (value) {
            appBloc.authBloc.updateUser(value);
          },
          style: TextStyle(
              fontFamily: "Roboto-Regular",
              fontSize: ScreenUtil().setSp(44.0),
              color: prefix0.greyColor,
              fontWeight: FontWeight.normal),
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: prefix0.color959ca7,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0.w))),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: prefix0.color959ca7,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0.w))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: prefix0.color959ca7,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0.w))),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: prefix0.color959ca7,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0.w))),
            hintText: "Mã nhân viên",
            hintStyle: TextStyle(
                fontSize: ScreenUtil().setSp(50.0),
                fontFamily: "Roboto-Regular",
                color: prefix0.greyColor),
            contentPadding: EdgeInsets.only(
              bottom: ScreenUtil().setHeight(57),
              top: ScreenUtil().setHeight(57),
              left: ScreenUtil().setWidth(157),
              right: ScreenUtil().setWidth(63),
            ),
          ),
        ),
        Positioned(
          bottom: ScreenUtil().setHeight(58.0),
          left: ScreenUtil().setWidth(58.1),
//          top: ScreenUtil().setHeight(48.0),
          child: Image.asset(
            "asset/images/userIcon.png",
            width: ScreenUtil().setWidth(56.0),
          ),
        ),
      ],
    );
  }

  _buildTextFieldPass() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        StreamBuilder(
            initialData: false,
            stream: appBloc.authBloc.showPassStream.stream,
            builder: (buildContext, AsyncSnapshot<bool> showPassSnap) {
              return InkWell(
                onTap: () {
                  appBloc.authBloc.updateStateShowPass();
                },
                child: showPassSnap.data
                    ? TextField(
                        cursorColor: prefix0.accentColor,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.start,
                        obscureText: false,
                        controller: _inputPassController,
                        maxLines: 1,
                        enabled: true,
                        style: TextStyle(
                            fontFamily: "Roboto-Regular",
                            fontSize: ScreenUtil().setSp(44.0),
                            color: prefix0.greyColor,
                            fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffb1afaf),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0.w))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffb1afaf),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0.w))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffb1afaf),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0.w))),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffb1afaf),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0.w))),
                          hintText: "Mật Khẩu",
                          hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(50.0),
                              fontFamily: "Roboto-Regular",
                              color: prefix0.greyColor),
                          contentPadding: EdgeInsets.only(
                            bottom: ScreenUtil().setHeight(57),
                            top: ScreenUtil().setHeight(57),
                            left: ScreenUtil().setWidth(157),
                            right: ScreenUtil().setWidth(63),
                          ),
                        ),
                      )
                    : TextField(
                        cursorColor: prefix0.accentColor,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.start,
                        obscureText: true,
                        controller: _inputPassController,
                        maxLines: 1,
                        enabled: true,
                        style: TextStyle(
                            fontFamily: "Roboto-Regular",
                            fontSize: ScreenUtil().setSp(44.0),
                            color: prefix0.greyColor,
                            fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffb1afaf),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0.w))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffb1afaf),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0.w))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffb1afaf),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0.w))),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffb1afaf),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0.w))),
                          hintText: "Mật Khẩu",
                          hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(50.0),
                              fontFamily: "Roboto-Regular",
                              color: prefix0.greyColor),
                          contentPadding: EdgeInsets.only(
                            bottom: ScreenUtil().setHeight(57),
                            top: ScreenUtil().setHeight(57),
                            left: ScreenUtil().setWidth(157),
                            right: ScreenUtil().setWidth(63),
                          ),
                        ),
                      ),
              );
            }),
        Positioned(
          bottom: ScreenUtil().setHeight(58.0),
          left: ScreenUtil().setWidth(58.1),
          child: Image.asset(
            "asset/images/ic_lock.png",
            width: ScreenUtil().setWidth(56.0),
          ),
        ),
        Positioned(
            bottom: ScreenUtil().setHeight(58.0),
            right: ScreenUtil().setWidth(31.8),
            child: StreamBuilder(
                initialData: false,
                stream: appBloc.authBloc.showPassStream.stream,
                builder: (buildContext, AsyncSnapshot<bool> showPassSnap) {
                  return InkWell(
                    onTap: () {
                      appBloc.authBloc.updateStateShowPass();
                    },
                    child: showPassSnap.data
                        ? Icon(
                            Icons.remove_red_eye,
                            color: prefix0.accentColor,
                            size: ScreenUtil().setWidth(62.0),
                          )
                        : Image.asset(
                            "asset/images/ic_login_showpass.png",
                            width: ScreenUtil().setWidth(62.0),
                          ),
                  );
                })),
      ],
    );
  }

  _buildRememberPass() {
    return StreamBuilder(
        initialData: false,
        stream: appBloc.authBloc.rememberPassStream.stream,
        builder: (buildContext, AsyncSnapshot<bool> rememberPassSnap) {
          return InkWell(
            onTap: () {
              appBloc.authBloc.updateStateRememberPass();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                rememberPassSnap.data
                    ? Image.asset(
                        "asset/images/ic_login_checkbox.png",
                        width: ScreenUtil().setWidth(58.0),
                      )
                    : Image.asset(
                        "asset/images/ic_remember_outline-no_check_box.png",
                        width: ScreenUtil().setWidth(58.0),
                      ),
                SizedBox(
                  width: ScreenUtil().setWidth(29.0),
                ),
                Text("Nhớ mật khẩu",
                    style: TextStyle(
                        color: prefix0.blackColor,
                        fontSize: ScreenUtil().setSp(50.0),
                        fontFamily: 'Roboto-Regular'))
              ],
            ),
          );
        });
  }
}
