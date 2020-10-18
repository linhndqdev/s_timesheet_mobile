import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/style.dart' as prefix0;
import 'package:s_timesheet_mobile/utils/animation/ZoomInAnimation.dart';
import 'package:s_timesheet_mobile/utils/model/dialog_model.dart';
import 'package:s_timesheet_mobile/utils/widget/component_dialog_auth.dart';
import 'package:s_timesheet_mobile/utils/widget/component_dialog_inapp.dart';
import 'package:s_timesheet_mobile/utils/widget/fingerprint_widget.dart';

class DialogUtil {
  // Lưu ý : Dialog này được sử dụng cho toàn bộ các dialog trong ứng dụng
  static void showDialogProject(BuildContext context,
      {@required DialogModel dialogModel,bool barrierDismissible=false}) {
      assert(dialogModel!=null,"Dialog Model can't be null");
      showDialog(
          context: context,
          builder: (buildContext) {
            switch(dialogModel.state){
            //Bộ dialog dành cho phần Auth
              case DialogType.AUTH:
                return ZoomInAnimation(ComponentDialogAuth(dialogModel));
                break;
            //Bộ dialog dành cho toàn bộ các thành phần trong app
              case DialogType.INAPP:
                return ZoomInAnimation(ComponentDialogInApp(dialogModel));
                break;
              default:
                return Container();
                break;
            }
          },
          barrierDismissible: barrierDismissible);


  }

  //Dialog can lam lai

  static void showDialogAuthenticateFingerprint(
      BuildContext context, AppBloc appBloc, bool statusFingerPrintKey) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (buildContext) {
          return Dialog(
            insetAnimationCurve: Curves.bounceIn,
            backgroundColor: prefix0.white,
            child: FingerprintWidget(appBloc, context, statusFingerPrintKey),
          );
        });
  }


  static void showDialogAuthenticateFinger(
      BuildContext context, {
        String title,
        String message,
        bool haveButton,
        TextStyle styleTitle,
        bool fingerPrintDisable,
      }) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return ZoomInAnimation(
          Dialog(
            child: Container(
              margin: EdgeInsets.only(left: 27.w, right: 27.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(
                    10.w)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil().setHeight(36.8),
                  ),
                  Image.asset(
                    fingerPrintDisable
                        ? "asset/images/ic_finger_disable.png"
                        : "asset/images/ic_finger_enable.png",
                    width: 171.2.w,
                    height: 171.2.h,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(4.0),
                  ),
                  Text(
                    title,
                    style: styleTitle,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(18.0),
                  ),
                  Container(
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Roboto-Regular',
                          color: prefix0.blackColor333,
                          fontSize: ScreenUtil().setSp(40.0),
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(54.6),
                  ),
                  haveButton
                      ? Container(
                    height: ScreenUtil().setHeight(1.0),
                    width: ScreenUtil().setWidth(889.0),
                    color: Color(0xff0959ca7),
                  )
                      : Container(),
                  haveButton
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          child: Container(
                            height: 187.5.h,
                            child: Center(
                              child: Text(
                                "Hủy",
                                style: TextStyle(
                                    fontFamily: 'Roboto-Regular',
                                    color: Color(0xff959ca7),
                                    fontSize: ScreenUtil().setSp(50.0),
                                    fontWeight: FontWeight.normal),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  )
                      : Container(
                    height: 90.h,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showDialogAuthenticateFingerFirst(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            margin: EdgeInsets.only(left: 27.w, right: 27.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.w)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: ScreenUtil().setHeight(51.1),
                ),
                Image.asset(
                  "asset/images/ic_finger_disable.png",
                  width: 171.2.w,
                  height: 171.2.h,
                  color: Color(0xffeaeaea),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(23.0),
                ),
                Text(
                  "Vui lòng đăng nhập lần đầu tiên trước khi sử dụng vân tay",
                  style: TextStyle(
                    color: prefix0.accentColor,
                    fontFamily: 'Roboto-Bold',
                    fontSize: 40.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(106),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showDialogForgotSuccess(
    BuildContext context,
    bool isSucess,
    String title,
    String description,
    String email,
    bool haveEmail,
  ) {
    String convertString;
    if (haveEmail && email.length >= 8) {
      convertString = email.replaceRange(2, email.length - 8, "******");
    } else {
      convertString = email;
    }
    showDialog(
        context: context,
        builder: (buildContext) {
          return ZoomInAnimation(
            Dialog(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 103.0.h,
                        ),
                        Flexible(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                text: title,
                                style: TextStyle(
                                    color: prefix0.blackColor,
                                    fontSize: 60.0.sp,
                                    fontFamily: "Roboto-Bold",
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                          ),
                        ),
                        SizedBox(
                          height: 21.0.h,
                        ),
                        haveEmail
                            ? Container(
                                padding: EdgeInsets.only(
                                  left: 53.0.w,
                                  right: 53.0.w,
                                ),
                                child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: prefix0.blackColor,
                                            fontSize: 50.0.sp,
                                            fontFamily: 'Roboto-Regular'),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                "Đường dẫn thay đổi mật khẩu đã gửi tới ",
                                            style: TextStyle(
                                                color: prefix0.blackColor,
                                                fontSize: 50.0.sp,
                                                fontFamily: 'Roboto-Regular'),
                                          ),
                                          TextSpan(
                                            text: convertString,
                                            style: TextStyle(
                                                color: prefix0.accentColor,
                                                fontSize: 50.0.sp,
                                                fontFamily: 'Roboto-Bold'),
                                          ),
                                          TextSpan(
                                            text:
                                                " .Nếu bạn không sử dụng e-mail này, vui lòng liên hệ trực tiếp với bộ phận hỗ trợ! ",
                                            style: TextStyle(
                                                color: prefix0.blackColor,
                                                fontSize: 50.0.sp,
                                                fontFamily: 'Roboto-Regular'),
                                          ),
                                        ])),
                              )
                            : Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 53.0.w,
                                    right: 53.0.w,
                                  ),
                                  child: Text(
                                    description,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: prefix0.blackColor,
                                        fontSize: 50.0.sp,
                                        fontFamily: 'Roboto-Regular'),
                                  ),
                                ),
                              ),
                        SizedBox(height: 39.0.h),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Color(0xffdde0e6), width: 1.0))),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(444.5),
                                height: ScreenUtil().setHeight(188.5),
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            color: Color(0xffdde0e6),
                                            width: 1.0))),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: ButtonTheme(
                                  child: Container(
                                    width: ScreenUtil().setWidth(400.5),
                                    height: ScreenUtil().setHeight(188.5),
                                    child: Center(
                                      child: Text(
                                        "Quay lại",
                                        style: TextStyle(
                                            color: prefix0.accentColor,
                                            fontFamily: "Roboto-Bold",
                                            fontSize: ScreenUtil().setSp(50)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        barrierDismissible: false);
  }

  static void showDialogLogin(
    BuildContext context,
    bool isSucess,
    String title,
    String description,
  ) {
    showDialog(
        context: context,
        builder: (buildContext) {
          return ZoomInAnimation(
            Dialog(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: ScreenUtil().setHeight(36.0),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(9.7),
                        ),
                        Flexible(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                text: title,
                                style: TextStyle(
                                    color: prefix0.blackColor,
                                    fontSize: 60.0.sp,
                                    fontFamily: "Roboto-Bold",
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(23)),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(159.0),
                              right: ScreenUtil().setWidth(159.0),
                            ),
                            child: Text(
                              description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: prefix0.blackColor,
                                  fontSize: ScreenUtil().setSp(50)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(39.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(67.0),
                            right: ScreenUtil().setWidth(67.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: ButtonTheme(
                              child: Container(
                                height: ScreenUtil().setHeight(107.5),
                                color: prefix0.accentColor,
                                child: Center(
                                  child: Text(
                                    "Đóng".toUpperCase(),
                                    style: TextStyle(
                                        color: prefix0.white,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: "Roboto-Regular",
                                        fontSize: ScreenUtil().setSp(44)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(72.8),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: ScreenUtil().setHeight(16.7),
                    right: ScreenUtil().setWidth(23.7),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        barrierDismissible: false);
  }
}
