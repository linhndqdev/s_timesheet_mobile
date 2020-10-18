import 'package:flutter/material.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/core/bloc_provider.dart';
import 'package:s_timesheet_mobile/core/style.dart' as prefix0;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:s_timesheet_mobile/utils/animation/ZoomInAnimation.dart';
import 'package:s_timesheet_mobile/utils/animation/button_animation.dart';
import 'package:s_timesheet_mobile/utils/widget/loading_widget.dart';
import '../auth_bloc.dart';

class ForgotPassScreen extends StatefulWidget {
  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  AppBloc appBloc;
  TextEditingController _textEditingController = TextEditingController();
  String validateErrorMail;
  String errorEmail;
  FocusNode _textFocus = FocusNode();

  @override
  @override
  Widget build(BuildContext context) {
    appBloc = BlocProvider.of(context);
    appBloc.backStateBloc.focusWidgetModel =
        FocusWidgetModel(state: isFocusWidget.FORGOT_PASSWORD);
    return ZoomInAnimation(
      Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              backgroundColor: prefix0.whiteColor,
              title: Container(
                width: MediaQuery.of(context).size.width,
                height: 178.5.h,
                child:Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      child: InkWell(
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 60.w, right: 59.w, bottom: 66.2.h, top: 60.h),
                          child: Image.asset(
                            "asset/images/ic_back.png",
                            color: prefix0.blackColor333,
                            width: ScreenUtil().setWidth(34.1),
                            height: 67.6.h,
                          ),
                        ),
                        onTap: () {
                          appBloc.authBloc.changeStateBackToLogin();
                        },
                      ),
                    ),
                    Center(
                      child: Text(
                        "Quên mật khẩu",
                        style: TextStyle(
                          color: prefix0.blackColor333,
                          fontSize: ScreenUtil().setSp(60),
                          fontFamily: 'Roboto-Bold',
                        ),
                      ),
                    )
                  ],
                ),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body:Container(
              color: prefix0.whiteColor,
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(128.9),
                right: ScreenUtil().setWidth(127.9),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil().setHeight(120.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(51),
                      right: ScreenUtil().setWidth(51),
                    ),
                    child: Text(
                      "Vui lòng cung cấp Mã nhân viên của bạn để thiết lập lại mật khẩu",
                      style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        color: prefix0.blackColor333,
                        fontSize: ScreenUtil().setSp(50.0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(125),
                  ),
                  _buildTextFieldUser(),
                  StreamBuilder(
                      initialData: RegisterOldValidateState.NONE,
                      stream: appBloc.authBloc.validateEmailForgotPass.stream,
                      builder: (iconContext,
                          AsyncSnapshot<RegisterOldValidateState>
                          validateNameSnap) {
                        switch (validateNameSnap.data) {
                          case RegisterOldValidateState.NONE:
                            return Container(height: ScreenUtil().setHeight(90.0));
                            break;
                          case RegisterOldValidateState.ERROR:
                            return Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(10),
                                  bottom: ScreenUtil().setHeight(47.1)),
                              child: Text(
                                "Vui lòng nhập lại Mã nhân viên đúng định dạng",
                                style: TextStyle(
                                    fontFamily: "Roboto-Regular",
                                    color: prefix0.redColor,
                                    fontSize: ScreenUtil().setSp(34)),
                              ),
                            );
                            break;
                          case RegisterOldValidateState.MATCHED:
                            return Container(height: ScreenUtil().setHeight(91.1));
                            break;
                          default:
                            return Container(height: ScreenUtil().setHeight(91.1));
                            break;
                        }
                      }),
                  ButtonAnimation(
                    child: Container(
                      alignment: Alignment.center,
                        width: ScreenUtil().setWidth(823),
                        height: ScreenUtil().setHeight(140),
                        decoration: BoxDecoration(
                          color: prefix0.accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(20.w)),
                        ),
                        child: Center(
                          child: Text(
                            "Gửi đi",
                            style: TextStyle(
                                color: prefix0.white,
                                fontSize: ScreenUtil().setSp(56),
                                fontFamily: 'Roboto-Bold'),
                          ),
                        )),
                    height: 140,
                    width: 823,
                    color: 0xff005a88,
                    onClicked: (c) {
                      _textFocus.unfocus();
                      appBloc.authBloc.loadingStream.notify(true);
                      appBloc.authBloc.forgotPassword(
                          context, _textEditingController.text,controller: c);
                    },
                    isControlEvent: true,
                    appBloc: appBloc,
                  )

                ],
              ),
            ),
          ),
          StreamBuilder(
            initialData: false,
            stream: appBloc.authBloc.loadingStream.stream,
            builder: (statusContext, statusSnapshot) {
              if (statusSnapshot.data) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.transparent,
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ));
  }

  _buildTextFieldUser() {
    _textEditingController.text = appBloc.authBloc?.email ?? "";
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        TextField(
          keyboardType: TextInputType.emailAddress,
          cursorColor: prefix0.accentColor,
          textInputAction: TextInputAction.done,
          textAlign: TextAlign.start,
          controller: _textEditingController,
          focusNode: _textFocus,
          maxLines: 1,
          enabled: true,
          onChanged: (value) {
            appBloc.authBloc.updateEmailForgotPass(value);
          },
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
                borderRadius: BorderRadius.all(Radius.circular(10.0.w))),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffb1afaf),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0.w))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffb1afaf),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0.w))),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffb1afaf),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0.w))),
            hintText: "Mã nhân viên",
            hintStyle: TextStyle(
                fontSize: ScreenUtil().setSp(50.0),
                fontFamily: "Roboto-Regular",
                color: prefix0.greyColor),
            contentPadding: EdgeInsets.only(
              bottom: ScreenUtil().setHeight(51.9),
              top: ScreenUtil().setHeight(50.1),
              left: ScreenUtil().setWidth(157),
              right: ScreenUtil().setWidth(63),
            ),
          ),
        ),
        Positioned(
          bottom: ScreenUtil().setHeight(57),
          right: ScreenUtil().setWidth(20),
          child: StreamBuilder(
              initialData: RegisterOldValidateState.NONE,
              stream: appBloc.authBloc.validateEmailForgotPass.stream,
              builder: (iconContext,
                  AsyncSnapshot<RegisterOldValidateState> validateEmailSnap) {
                switch (validateEmailSnap.data) {
                  case RegisterOldValidateState.NONE:
                    return Container();
                    break;
                  case RegisterOldValidateState.ERROR:
                    return Icon(
                      Icons.do_not_disturb_on,
                      color: Color(0xFFe50000),
                      size: ScreenUtil().setWidth(57.0),
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
        ),
        Positioned(
          bottom: ScreenUtil().setHeight(51.9),
          left: ScreenUtil().setWidth(60.0),
          child: Image.asset(
            "asset/images/userIcon.png",
            width: ScreenUtil().setWidth(56.0),
          ),
        ),
      ],
    );
  }
}
