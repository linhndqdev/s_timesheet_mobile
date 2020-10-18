import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/core/core.dart';
import 'package:s_timesheet_mobile/utils/widget/circle_avatar.dart';

class DrawerScreen extends StatefulWidget {
  final AppBloc appBloc;
  final VoidCallback onExitApplication;

  DrawerScreen({Key key, this.appBloc, this.onExitApplication})
      : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.appBloc.backStateBloc.focusWidgetModel =
        FocusWidgetModel(state: isFocusWidget.DRAWER);
    return Container(
        width: 720.w,
        child: Drawer(
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 138.h),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: CustomCircleAvatar(
                              isClearCache: true,
                              userName:
                                  widget.appBloc.authBloc?.userNameDrawer ??
                                      "Không xác định",
                              size: 274.0,
                            ),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(height: 38.3.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 50.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      widget.appBloc.authBloc?.fullNameDrawer ??
                                          "Không xác định",
                                      style: TextStyle(
                                        color: Color(0xff263238),
                                        height: 1.28,
                                        fontFamily: 'Roboto-Bold',
                                        fontSize: 60.0.sp,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 66.h,
                            child: Text(
                              "ID: ${widget.appBloc.authBloc?.userNameDrawer?.toUpperCase()?.replaceAll('-', '') ?? ""}",
                              style: new TextStyle(
                                  fontFamily: 'Roboto-Regular',
                                  color: Color(0xff959ca7),
                                  fontSize: 50.0.sp),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          Container(
                            height: 1.h,
                            width: MediaQuery.of(context).size.width,
                            color: Color(0xffe18c12),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 42.0.h),
                      buildItemMenu(
                          title: "Tài khoản",
                          assetImg: "ic_setting.png",
                          onClickItem: () {
                            Navigator.of(context).pop();
                          }),
                      buildItemMenu(
                          title: "Tin nhắn",
                          assetImg: "ic_message_deactive.png",
                          onClickItem: () {
                            Navigator.of(context).pop();
                            widget.appBloc.homeBloc
                                .checkAndOpenAppWithPackageName(context,
                                    "com.asgl.s_timesheet_mobile", "sconnect");
                          }),
                      buildItemMenu(
                          title: "Sự kiện",
                          assetImg: "ic_star_deactive.png",
                          onClickItem: () {
                            Navigator.of(context).pop();
                            widget.appBloc.homeBloc.clickItemBottomBar(1);
                          }),
                      buildItemMenu(
                          title: "Lịch làm việc",
                          assetImg: "ic_calendar_deactive.png",
                          onClickItem: () {
                            Navigator.of(context).pop();
                            widget.appBloc.homeBloc.clickItemBottomBar(2);
                          }),
                      buildItemMenu(
                          title: "Chấm công",
                          assetImg: "ic_qr_deactive.png",
                          onClickItem: () {
                            Navigator.of(context).pop();
                            widget.appBloc.homeBloc.clickItemBottomBar(3);
                          }),
                      buildItemMenu(
                          title: "Thống kê",
                          assetImg: "ic_diagram_deactive.png",
                          onClickItem: () {
                            Navigator.of(context).pop();
                            widget.appBloc.homeBloc.clickItemBottomBar(4);
                          }),
                    ],
                  ),
                ),
              ),
              Container(
                height: 149.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Color(0xfff7f7f7), width: 1.0))),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onExitApplication();
                  },
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 31.h),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 61.w),
                          Image.asset("asset/images/ic_signout.png",
                              height: 68.6.h),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  buildItemMenu(
      {String title, String assetImg, @required VoidCallback onClickItem}) {
    return InkWell(
        onTap: () {
          onClickItem();
        },
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: 59.w),
                Image.asset("asset/images/" + assetImg,
                    width: 70.0.w, color: Color(0xff263238)),
                SizedBox(width: 46.7.w),
                Text(title,
                    style: new TextStyle(
                        fontFamily: 'Roboto-Regular',
                        color: Color(0xff263238),
                        fontSize: 50.0.sp,
                        height: 1.36))
              ],
            ),
            SizedBox(height: 56.0.h)
          ],
        ));
  }
}
