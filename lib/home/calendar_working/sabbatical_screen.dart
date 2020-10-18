import 'package:core_asgl/core_asgl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/core/bloc_provider.dart';
import 'package:s_timesheet_mobile/core/style.dart' as prefix0;
import 'package:flutter_screenutil/size_extension.dart';
import 'package:s_timesheet_mobile/home/calendar_working/calendar_work_bloc.dart';
import 'package:s_timesheet_mobile/model/calendar_model.dart';
import 'package:s_timesheet_mobile/utils/animation/animation_open_calendar_detail.dart';
import 'package:s_timesheet_mobile/utils/widget/loadding_widget.dart';

class SabbaticalLeaveScreen extends StatefulWidget {
  final int idShift;
  final DateTime Datetime;

  const SabbaticalLeaveScreen({Key key, this.idShift, this.Datetime})
      : super(key: key);

  @override
  _SabbaticalLeaveScreenState createState() => _SabbaticalLeaveScreenState();
}

class _SabbaticalLeaveScreenState extends State<SabbaticalLeaveScreen> {
  TextEditingController _controller = TextEditingController();
  FocusNode _focus = new FocusNode();
  bool isCheck = false;
  AppBloc appbloc;

//  AnimationController controller;
  DateTime dDate;
  final TextStyle contentTextStyle = TextStyle(
      color: prefix0.blackColor333,
      fontFamily: 'Roboto-Regular',
      fontSize: 48.sp);
  final TextStyle RickTextBlack = TextStyle(
      fontSize: ScreenUtil().setSp(52.0),
      fontFamily: "Roboto-Regular",
      color: Color(0xff333333),
      fontWeight: FontWeight.normal);
  final TextStyle contentTextStyleUforcus = TextStyle(
      color: prefix0.greyColore8e8e8,
      fontFamily: 'Roboto-Regular',
      fontSize: 48.sp);
  final OutlineInputBorder inputContentBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0.w),
    borderSide: BorderSide(color: prefix0.color959ca7, width: 0.5),
  );

  final TextStyle buttonColor1 = TextStyle(
      color: prefix0.accentColor,
      fontFamily: 'Roboto-Medium',
      fontWeight: FontWeight.w500,
      fontSize: 52.sp);
  final TextStyle buttonColor2 = TextStyle(
      color: prefix0.accentColor.withOpacity(0.5),
      fontFamily: 'Roboto-Regular',
      fontWeight: FontWeight.w500,
      fontSize: 52.sp);

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      appbloc.authBloc.loadingStream.notify(true);
      appbloc.calendarWorkBloc
          .getSabaticalDetail(id: widget.idShift, appBloc: appbloc);
    });
    super.initState();
    BackStateBloc backStateBloc = BackStateBloc.getInstance();
    backStateBloc.setStateToOther(state: isFocusWidget.REQUEST_OFF_SHIFT);
  }

  @override
  Widget build(BuildContext context) {
    appbloc = BlocProvider.of(context);

    return StreamBuilder<Object>(
        initialData: null,
        stream: appbloc.calendarWorkBloc.sabbaticalStream.stream,
        builder: (context, snapshot) {
          return Stack(
            children: <Widget>[
              InkWell(
                onTap: () {
                  appbloc.homeBloc.disableWithAnimation(() => appbloc
                      .calendarWorkBloc.shiftStateStream
                      .notify(ShiftStateModel(state: ShiftState.NONE)));
//                  appbloc.homeBloc.disableWithAnimationOpenQRLocation(
//                      () => appbloc.calendarWorkBloc.shiftStateStream
//                          .notify(ShiftStateModel(state: ShiftState.NONE)),
//                      controller);
                },
                child: Container(
                  color: Color(0xffa4aab3).withOpacity(0.7),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Positioned(
                top: 478.h,
                bottom: 0,
                child: OpenCalendarAnimation(
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.w),
                          topRight: Radius.circular(30.w),
                        )),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              height: 149.h,
                              padding: EdgeInsets.only(top: 55.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "asset/images/ic_calendar_leave.png",
                                    width: 60.w,
                                    height: 60.h,
                                    color: Color(0xffe18c12),
                                  ),
                                  SizedBox(width: 25.w),
                                  Text(
                                    "Xin nghỉ",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(60.0),
                                        fontFamily: "Roboto-Regular",
                                        color: Color(0xffe18c12),
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 2.h,
                              width: MediaQuery.of(context).size.width,
                              color: Color(0xffe18c12),
                            ),
                            buildListBigItemChonCa()
                          ],
                        ),
                        Positioned(
                          top: 0.h,
                          right: 0,
                          child: InkWell(
                              onTap: () {
                                appbloc.homeBloc.disableWithAnimation(() =>
                                    appbloc.calendarWorkBloc.shiftStateStream
                                        .notify(ShiftStateModel(
                                            state: ShiftState.NONE)));

//                                controller.reverse();
//                                Future.delayed(Duration(milliseconds: 500), () {
//                                  appbloc.calendarWorkBloc.shiftStateStream
//                                      .notify(ShiftStateModel(
//                                          state: ShiftState.NONE));
//                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  right: 0.0.w,
                                  top: 50.0.h,
                                  bottom: 59.h,
                                ),
                                height: 149.h,
                                width: 108.h,
                                child: Image.asset(
                                  "asset/images/ic_cancel.png",
                                  width: 40.w,
                                  height: 40.w,
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                  voidCallback: (c) {
                    appbloc.homeBloc.animationController = c;
                  },
                ),
              ),
            ],
          );
        });
  }

  buildListBigItemChonCa() {
    return Expanded(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 28.0.h,
                  ),
                  StreamBuilder<ChangeColorbuttonModel>(
                      initialData:
                          ChangeColorbuttonModel(state: ChangeColorbutton.NO),
                      stream: appbloc
                          .calendarWorkBloc.ChangeColorbuttonStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.data.state == ChangeColorbutton.NO) {
                          return _BuildbuttonNodata();
                        } else {
                          return _Buildbutton();
                        }
                      }),
                  SizedBox(
                    height: 53.0.h,
                  ),
                  _BuildContentText(),
                  SizedBox(
                    height: 25.0.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(34.0),
                      right: ScreenUtil().setWidth(34.0),
                    ),
                    height: ScreenUtil().setHeight(2.0),
                    width: ScreenUtil().setWidth(1000.0),
                    color: Color(0xff959ca7),
                  ),
                  SizedBox(
                    height: 35.0.h,
                  ),
                  Container(
                    child: Text(
                      'Vui lòng nhập lý do',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(52.0),
                          fontFamily: "Roboto-Regular",
                          color: Color(0xff333333),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 27.0.h,
                  ),
                  _buildComponentContent(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _BuildContentText() {
    return StreamBuilder<CalendarModel>(
        initialData: null,
        stream: appbloc.calendarWorkBloc.workScheduleDetailStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 30.h,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 55.h),
                    width: MediaQuery.of(context).size.width,
                    height: 200.h,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  prefix0.accentColor)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          DateTime dateTime = DateTime.parse(snapshot.data.date);
          dateTime = dateTime;
          String Calv = snapshot.data.shift?.name;
          String day = DateFormat('dd/MM/yyyy').format(dateTime).toString();
          String startAt = snapshot.data.shift?.workTimes[0]?.startAt;
          String StartWork = "";
          String EndWork = "";
          if (startAt != null) {
            StartWork = startAt.substring(0, startAt.length - 3);
            startAt = startAt.substring(0, startAt.length - 3) + " $day";
          } else {
            StartWork = 'Chưa xác định';
            startAt = 'Chưa xác định';
          }
          String finishAt = snapshot.data.shift?.workTimes[0]?.finishAt;
          if (finishAt != null) {
            EndWork = finishAt.substring(0, finishAt.length - 3);
            finishAt = finishAt.substring(0, finishAt.length - 3) + " $day";
          } else
            EndWork = 'Chưa xác định';
          finishAt = 'Chưa xác định';
          return Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 49.0.w, right: 49.0.w),
                width: 982.0.w,
                child: RichText(
                  text: TextSpan(
                    text: 'Bạn muốn ',
                    style: RickTextBlack,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'xin nghỉ',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(52.0),
                            fontFamily: "Roboto-Regular",
                            color: Color(0xffe10606),
                            fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text:
                            ' $Calv bắt đầu lúc $StartWork và kết thúc lúc $EndWork  ngày $day.',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(52.0),
                            fontFamily: "Roboto-Regular",
                            color: Color(0xff333333),
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            ' Yêu cầu của bạn sẽ được gửi tới quản lý trực tiếp và bạn sẽ nhận được phản hồi sớm !',
                        style: RickTextBlack,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        });
  }

  _buildComponentContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: 962.w,
              height: 557.0.h,
              margin: EdgeInsets.only(left: 59.0.w, right: 59.0.w),
              child: StreamBuilder<Object>(
                  stream: null,
                  builder: (context, snapshot) {
                    return StreamBuilder<ChangeColorbuttonModel>(
                        initialData:
                            ChangeColorbuttonModel(state: ChangeColorbutton.NO),
                        stream: appbloc
                            .calendarWorkBloc.ChangeColorbuttonStream.stream,
                        builder: (context, snapshot) {
                          if (snapshot.data.state == ChangeColorbutton.NO) {
                            return TextFormField(
                              onChanged: (data) {
                                if (data != null &&
                                    data.length > 0 &&
                                    data.length < 2) {
                                  appbloc
                                      .calendarWorkBloc.ChangeColorbuttonStream
                                      .notify(ChangeColorbuttonModel(
                                          state: ChangeColorbutton.YES));
                                }
                              },
                              controller: _controller,
                              focusNode: _focus,
                              minLines: 10,
                              maxLines: null,
                              textAlign: TextAlign.start,
                              style: contentTextStyle,
                              cursorColor: prefix0.blackColor333,
                              decoration: InputDecoration(
                                hintText: "Lý do xin nghỉ",
                                hintStyle: contentTextStyleUforcus,
                                contentPadding:
                                    EdgeInsets.only(top: 21.0.h, left: 20.0.w),
                                isDense: true,
                                border: inputContentBorder,
                                disabledBorder: inputContentBorder,
                                focusedBorder: inputContentBorder,
                                errorBorder: inputContentBorder,
                                enabledBorder: inputContentBorder,
                              ),
                            );
                          } else {
                            return TextFormField(
                              onChanged: (data) {
                                if (data != null &&
                                    data.length > 0 &&
                                    data.length < 2) {
                                  appbloc
                                      .calendarWorkBloc.ChangeColorbuttonStream
                                      .notify(ChangeColorbuttonModel(
                                          state: ChangeColorbutton.YES));
                                }
                              },
                              controller: _controller,
                              focusNode: _focus,
                              minLines: 10,
                              maxLines: null,
                              textAlign: TextAlign.start,
                              style: contentTextStyle,
                              cursorColor: prefix0.blackColor333,
                              decoration: InputDecoration(
                                hintText: "Xin nghỉ vì lý do cá nhân",
                                hintStyle: contentTextStyle,
                                contentPadding:
                                    EdgeInsets.only(top: 21.0.h, left: 20.0.w),
                                isDense: true,
                                border: inputContentBorder,
                                disabledBorder: inputContentBorder,
                                focusedBorder: inputContentBorder,
                                errorBorder: inputContentBorder,
                                enabledBorder: inputContentBorder,
                              ),
                            );
                          }
                        });
                  }),
            ),
          ],
        )
      ],
    );
  }

  _Buildbutton() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(739.0),
              ),
              child: InkWell(
                onTap: () {
                  if (_controller.text.length > 0 &&
                      _controller.text.length <= 6) {
//                  DialogUtil.showDialogLogin(
//                      context, false, "Thông báo",   "Lý do xin nghỉ quả ngắn, xin nhập lại!");
                    Toast.showShort(
                        "Lý do xin nghỉ quả ngắn, xin nhập lại!");
                  } else if (_controller.text.length == 0) {
                    Toast.showShort(
                        "Bạn chưa nhập lý do xin nghỉ, xin nhập lại!");
                  } else {
                    appbloc.authBloc.loadingStream.notify(true);
                    appbloc.calendarWorkBloc.SendSabatical(context,
                        id: widget.idShift,
                        lydoxinnghi: _controller.text,
                        DT: widget.Datetime,
                        appBloc: appbloc);
                  }
                },
                child: Text(
                  'GỬI YÊU CẦU',
                  style: buttonColor1,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
        StreamBuilder(
          initialData: false,
          stream: appbloc.authBloc.loadingStream.stream,
          builder: (loadingContext, AsyncSnapshot<bool> loadingSnap) {
            if (loadingSnap.data) {
              return Center(
                child: Container(
//                  padding: EdgeInsets.only(top: 55.h),
                  width: MediaQuery.of(context).size.width,
                  height: 200.h,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                prefix0.accentColor)),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }

  _BuildbuttonNodata() {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(739.0),
          ),
          child: Text(
            'GỬI YÊU CẦU',
            style: buttonColor2,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
