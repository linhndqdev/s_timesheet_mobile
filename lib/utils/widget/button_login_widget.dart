import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/style.dart' as prefix0;
import 'package:s_timesheet_mobile/utils/animation/button_animation.dart';
import 'package:s_timesheet_mobile/utils/cache/share_prefer_utils.dart';
import 'package:s_timesheet_mobile/utils/widget/dialog_util.dart';
import 'package:s_timesheet_mobile/utils/widget/fingerprint_button_login.dart';

class ButtonLoginWidget extends StatefulWidget {
  final AppBloc appBloc;
  final TextEditingController inputUserController;
  final TextEditingController inputPassController;

  ButtonLoginWidget(
      this.appBloc, this.inputUserController, this.inputPassController);

  @override
  _ButtonLoginWidgetState createState() => _ButtonLoginWidgetState();
}

class _ButtonLoginWidgetState extends State<ButtonLoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          width: 658.w,
          height: 129.h,
          decoration: BoxDecoration(
            border: Border(
                right: BorderSide(
                  color: Color(0xffffffff),
                )),
          ),
          child: ButtonAnimation(
            width: 658.w,
            height: 129.h,
            color: 0xff005a88,
            child: ButtonTheme(
                child: Container(
                    decoration: BoxDecoration(
                      color: prefix0.accentColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.w),
                          topLeft: Radius.circular(20.w)),
                    ),
                    height: ScreenUtil().setHeight(129),
                    width: ScreenUtil().setWidth(658),
                    child: Center(
                      child: Text('Đăng nhập'.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Roboto-Medium',
                            fontSize: ScreenUtil().setSp(48.0),
                            color: prefix0.whiteColor,
                          )),
                    )
                )),
            isControlEvent: false,
            onClicked: (controller) {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.appBloc.authBloc.loginWith(
                  context,
                  widget.inputUserController.text,
                  widget.inputPassController.text,
                  animationControllerButtonLogin: controller
              );
            },
            appBloc: widget.appBloc,
          ),
        ),
        StreamBuilder(
            initialData: true,
            stream: widget.appBloc.authBloc.enableAndDisableButton.stream,
            builder: (buildContext, snapshotFingerButton) {
              if (snapshotFingerButton.data) {
                return FingerPrintButton(() async {
                  if (Platform.isAndroid) {
                    bool statusFingerPrintKey =
                        await SharePreferUtils.getStatusFingerPrint();
                    DialogUtil.showDialogAuthenticateFingerprint(
                        context, widget.appBloc, statusFingerPrintKey);
                  } else if (Platform.isIOS) {
                    widget.appBloc.authBloc.authenticateFingerPrintIOS(context);
                  }
                }, true);
              } else {
                return FingerPrintButton(() async {
                  DialogUtil.showDialogAuthenticateFinger(context,
                      title: "Thất bại",
                      message:
                          "Bạn xác thực vân tay không thành công. Vui lòng đăng nhập bằng tài khoản và mật khẩu.",
                      styleTitle: TextStyle(
                        color: Color(0xffee8800),
                        fontFamily: 'Roboto-Bold',
                        fontSize: 50.sp,
                      ),
                      haveButton: false,
                      fingerPrintDisable: false);
                }, false);
              }
            })
      ],
    );
  }
}
