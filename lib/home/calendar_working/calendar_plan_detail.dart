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
import 'package:s_timesheet_mobile/home/calendar_working/information_shift_member_model.dart';
import 'package:s_timesheet_mobile/model/calendar_model.dart';
import 'package:s_timesheet_mobile/utils/animation/animation_open_calendar_detail.dart';

class PlanDetailScreen extends StatefulWidget {
  final int idShift;
  final String status;

  const PlanDetailScreen({Key key, this.idShift, this.status})
      : super(key: key);

  @override
  _PlanDetailScreenScreenState createState() => _PlanDetailScreenScreenState();
}

class _PlanDetailScreenScreenState extends State<PlanDetailScreen> {
  bool isCheck = false;
  AppBloc appbloc;

//  AnimationController controller;

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
      fontFamily: 'Roboto-Regular',
      fontSize: 52.sp);
  final TextStyle buttonColor2 = TextStyle(
      color: prefix0.accentColor.withOpacity(0.85),
      fontFamily: 'Roboto-Regular',
      fontSize: 52.sp);

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
//      appbloc.authBloc.loadingStream.notify(true);
      appbloc.calendarWorkBloc
          .getWorkSchedulesDetail(id: widget.idShift, appBloc: appbloc);
    });
    super.initState();
    BackStateBloc backStateBloc = BackStateBloc.getInstance();
    backStateBloc.setStateToOther(state: isFocusWidget.DETAIL_SHIFT);
  }

  @override
  Widget build(BuildContext context) {
    appbloc = BlocProvider.of(context);


    DateTime dDate;
    return Stack(
      children: <Widget>[
        InkWell(
            onTap: () {
              appbloc.homeBloc.disableWithAnimation(
                  () => appbloc.calendarWorkBloc.shiftStateStream.notify(
                        ShiftStateModel(state: ShiftState.NONE),
                      ));
            },
            child: Container(
              color: Color(0xffa4aab3).withOpacity(0.7),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            )),
        Positioned(
          top: 231.h,
          bottom: 0,
          child: OpenCalendarAnimation(
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.w),
                    topRight: Radius.circular(30.w),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Color(0xfff3d09e), width: 2.w))),
                        width: MediaQuery.of(context).size.width,
                        height: 149.h,
                        padding: EdgeInsets.only(top: 55.h, bottom: 15.h),
                        child: StreamBuilder<CalendarModel>(
                            initialData: null,
                            stream: appbloc.calendarWorkBloc
                                .workScheduleDetailStream.stream,
                            builder: (context, snapshot) {
                              if (snapshot.data == null)
                                return Container(
                                  child: Text(''),
                                );
                              dDate = DateTime.parse(snapshot.data.date);
                              DateTime dateTime =
                                  DateTime.parse(snapshot.data.date);
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 55.h),
                                  _buildTitle(DateFormat('dd-MM-yyyy')
                                      .format(dateTime)
                                      .toString()),
                                ],
                              );
                            }),
                      ),
                      Positioned(
                        bottom: 0.h,
                        right: 0,
                        child: InkWell(
                            onTap: () {
                              appbloc.homeBloc
                                  .disableWithAnimation(() => appbloc
                                          .calendarWorkBloc.shiftStateStream
                                          .notify(
                                        ShiftStateModel(state: ShiftState.NONE),
                                      ));
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 33.0.h,
                  ),
                  Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: StreamBuilder<CalendarModel>(
                          initialData: null,
                          stream: appbloc
                              .calendarWorkBloc.workScheduleDetailStream.stream,
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(top: 55.h),
                                    child: Text(
                                      'Không có dữ liệu',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(52.0),
                                          fontFamily: "Roboto-Medium",
                                          color: Color(0xff333333),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
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
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        prefix0.accentColor)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              String startAt =
                                  snapshot.data.shift?.workTimes[0]?.startAt;
                              String startWork = "";
                              String endWork = "";
                              if (startAt != null) {
                                startWork =
                                    startAt.substring(0, startAt.length - 3);
                              } else {
                                startWork = '--:--';
                              }
                              String finishAt =
                                  snapshot.data.shift?.workTimes[0]?.finishAt;
                              if (finishAt != null) {
                                endWork = finishAt.substring(
                                        0, finishAt.length - 3) ??
                                    "Chưa xác định";
                              } else {
                                endWork = 'Chưa xác định';
                              }
                              return Column(
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 715.0.w,
                                            ),
                                            Container(
                                              child: InkWell(
                                                onTap: () {
                                                  if (widget.status
                                                      .contains("incoming")) {
                                                    appbloc
                                                        .authBloc.loadingStream
                                                        .notify(true);
                                                    appbloc.calendarWorkBloc
                                                        .getDataToSwitchShift(
                                                            idShift:
                                                                widget.idShift,
                                                            appBloc: appbloc);
                                                    appbloc.calendarWorkBloc
                                                        .shiftStateStream
                                                        .notify(ShiftStateModel(
                                                            state: ShiftState
                                                                .INFOMATIONSHIFT,
                                                            data: InformationShiftMemberModel.createInformationShiftMemberModel(
                                                                idShift: widget
                                                                    .idShift,
                                                                date: "",
                                                                time: "",
                                                                nameShift: "",
                                                                idShiftChange:
                                                                    null,
                                                                nameMember: "",
                                                                idMember: null,
                                                                asglID: "",
                                                                isInit: true),
                                                            days: dDate));
                                                  } else {
                                                    Toast.showShort(
                                                        "Xin lỗi, Bạn không thể đổi ca !");
                                                  }
                                                },
                                                child: Text(
                                                  'Đổi ca',
                                                  style: TextStyle(
                                                      color: prefix0.greyColor,
                                                      fontFamily:
                                                          'Roboto-Regular',
                                                      fontSize: 42.sp),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 19.0.w,
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                left:
                                                    ScreenUtil().setWidth(60.0),
                                                right:
                                                    ScreenUtil().setWidth(59.0),
                                              ),
                                              height:
                                                  ScreenUtil().setHeight(55.0),
                                              width: 2.0.w,
                                              color: prefix0.greyColor,
                                            ),
                                            SizedBox(
                                              width: 19.0.w,
                                            ),
                                            Container(
                                              child: InkWell(
                                                onTap: () {
                                                  if (widget.status
                                                      .contains("incoming")) {
                                                    appbloc.calendarWorkBloc
                                                        .shiftStateStream
                                                        .notify(ShiftStateModel(
                                                            state: ShiftState
                                                                .XIN_NGHI,
                                                            data:
                                                                widget.idShift,
                                                            days: dDate));
                                                  } else if (widget.status
                                                      .contains("ended")) {
                                                    Toast.showShort(
                                                        "Xin lỗi, Đã kết thúc ca làm việc không thể xin nghỉ !");
                                                  } else if (widget.status
                                                      .contains("happening")) {
                                                    Toast.showShort(
                                                        "Xin lỗi, Đang trong ca làm việc không thể xin nghỉ !");
                                                  }
                                                },
                                                child: Text(
                                                  'Xin nghỉ',
                                                  style: TextStyle(
                                                      color: prefix0.greyColor,
                                                      fontFamily:
                                                          'Roboto-Regular',
                                                      fontSize: 42.sp),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 42.h,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  EdgeInsets.only(left: 59.0.w),
                                              child: Text(
                                                snapshot.data?.shift?.name ??
                                                    "Chưa xác định",
                                                style: TextStyle(
                                                    color: prefix0.accentColor,
                                                    fontFamily: 'Roboto-Bold',
                                                    fontSize: 64.sp),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7.0.h,
                                        ),
                                        _buildContent(
                                            snapshot.data?.location?.name ??
                                                "Chưa xác định Chưa",
                                            "$startWork - $endWork",
                                            "Không có ghi chú"),
                                        SizedBox(
                                          height: 22.0.h,
                                        ),
                                        Container(
                                          height: 2.0.h,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Color(0xff959ca7)
                                              .withOpacity(0.5),
                                        ),
                                        SizedBox(
                                          height: 14.0.h,
                                        ),
                                        _buildTimekeepingDetail(
                                            snapshot.data.times),
                                        SizedBox(
                                          height: 22.0.h,
                                        ),
                                        Container(
                                          height: 2.0.h,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Color(0xff959ca7)
                                              .withOpacity(0.5),
                                        ),
                                        SizedBox(
                                          height: 14.0.h,
                                        ),
                                        _buildFinish(
                                            timeFinish: "", userConfirm: ""),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
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
//    );
  }

  _buildTitle(String dDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset("asset/images/ic_calendar_yellow.png",
            width: 60.w, height: 60.h),
        SizedBox(width: 25.w),
        Text(
          dDate,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(60.0),
              fontFamily: "Roboto-Regular",
              color: Color(0xffe18c12),
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  _buildFinish({String timeFinish, String userConfirm}) {
    if (userConfirm == "" && timeFinish == "") return _buildFinishNoData();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 59.0.w, bottom: 17.0.h),
          child: Text(
            'Chốt công',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(60.0),
                fontFamily: "Roboto-Medium",
                color: Color(0xffe18c12),
                fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 91.0.w),
              child: Text(
                'Thời gian được xác nhận',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(56.0),
                    fontFamily: "Roboto-Medium",
                    color: prefix0.blackColor333,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(left: 232.w),
          child: Text(
            timeFinish,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(52.0),
                fontFamily: "Roboto-Medium",
                color: prefix0.accentColor,
                fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 91.0.w),
              child: Text(
                'Người xác nhận',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(56.0),
                    fontFamily: "Roboto-Medium",
                    color: prefix0.blackColor333,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(left: 232.w, bottom: 34.5.h),
          child: Text(
            userConfirm,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(52.0),
                fontFamily: "Roboto-Medium",
                color: prefix0.accentColor,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  _buildFinishNoData() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 59.0.w, bottom: 17.0.h),
              child: Text(
                'Chốt công',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(60.0),
                    fontFamily: "Roboto-Medium",
                    color: Color(0xffe18c12),
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(left: 91.w),
          child: Text(
            'Thời gian được xác nhận',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(52.0),
                fontFamily: "Roboto-Medium",
                color: Color(0xff959ca7),
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 91.w, bottom: 34.5.h),
          child: Text(
            'Người xác nhận',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(52.0),
                fontFamily: "Roboto-Medium",
                color: Color(0xff959ca7),
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  _buildContent(String location, String time, String note) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 91.0.w, top: 7.0.h, bottom: 14.0.h),
              child: Text(
                'Địa điểm làm việc',
                style: TextStyle(
                    fontSize: 56.sp,
                    fontFamily: "Roboto-Medium",
                    color: Color(0xff333333),
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        Container(
          width: 800.w,
          margin: EdgeInsets.only(left: 121.0.w, right: 79.0.w),
          child: Text(
            location,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(52.0),
                fontFamily: "Roboto-Regular",
                color: prefix0.color6a6a6a,
                fontWeight: FontWeight.normal),
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 91.0.w, top: 7.0.h, bottom: 15.0.h),
              child: Text(
                'Thời gian làm việc dự kiến',
                style: TextStyle(
                    fontSize: 56.sp,
                    fontFamily: "Roboto-Medium",
                    color: Color(0xff333333),
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 119.0.w, right: 79.0.w),
          child: Text(
            time,
            style: TextStyle(
                fontSize: 52.0.sp,
                fontFamily: "Roboto-Regular",
                color: prefix0.color6a6a6a,
                fontWeight: FontWeight.normal),
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 91.0.w, top: 6.0.h, bottom: 9.0.h),
              child: Text(
                'Ghi chú',
                style: TextStyle(
                    fontSize: 56.sp,
                    fontFamily: "Roboto-Medium",
                    color: Color(0xff333333),
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 123.0.w),
          child: Text(
            note,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(52.0),
              fontFamily: "Roboto-Regular",
              color: prefix0.color3baae2,
            ),
          ),
        ),
      ],
    );
  }

  ///Chấm công
  _buildTimekeepingDetail(List<Time> times) {
    InOutEvent inEvent;
    InOutEvent outEvent;
    if (times != null && times.length > 0) {
      if (times[0].inEvent != null) {
        inEvent = times[0].inEvent;
      }
      if (times[0].outEvent != null) {
        outEvent = times[0].outEvent;
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
//      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 59.0.w, bottom: 13.0.h),
          child: Text(
            'Chấm công',
            style: TextStyle(
                fontSize: 60.0.sp,
                fontFamily: "Roboto-Medium",
                color: Color(0xffe18c12),
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.left,
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 91.0.w, bottom: 9.0.h),
              child: Text(
                'Vào',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(56.0),
                    fontFamily: "Roboto-Medium",
                    color: prefix0.blackColor333,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              width: 43.0.w,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 9.0.h),
              child: (inEvent != null &&
                      inEvent.location != null &&
                      inEvent.location.name != null)
                  ? Text(
                      inEvent.location.name,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(52.0),
                          fontFamily: "Roboto-Regular",
                          color: prefix0.color959ca7,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.left,
                    )
                  : Text(
                      "Không xác định",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(52.0),
                          fontFamily: "Roboto-Regular",
                          color: prefix0.color959ca7,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.left,
                    ),
            ),
          ],
        ),
        SizedBox(
          height: 14.0.h,
        ),
        Row(
          children: <Widget>[
            (inEvent != null &&
                    inEvent.check_at != null &&
                    inEvent.check_at.date != null)
                ? Container(
                    margin: EdgeInsets.only(left: 232.0.w),
                    child: Text(
                      _getTimeShow(inEvent.check_at.date),
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(48.0),
                          fontFamily: "Roboto-Regular",
                          color: prefix0.blackColor333,
                          fontWeight: FontWeight.normal),
                    ),
                  )
                : Container(),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 91.0.w, bottom: 9.0.h),
              child: Text(
                'Ra',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(56.0),
                    fontFamily: "Roboto-Medium",
                    color: prefix0.blackColor333,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              width: 76.0.w,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 9.0.h),
              child: (outEvent != null &&
                      outEvent.location != null &&
                      outEvent.location.name != null)
                  ? Text(
                      outEvent.location.name,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(52.0),
                          fontFamily: "Roboto-Regular",
                          color: prefix0.color959ca7,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.left,
                    )
                  : Text(
                      "Không xác định",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(52.0),
                          fontFamily: "Roboto-Regular",
                          color: prefix0.color959ca7,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.left,
                    ),
            ),
          ],
        ),
        SizedBox(
          height: 14.0.h,
        ),
        Row(
          children: <Widget>[
            (outEvent != null &&
                    outEvent.check_at != null &&
                    outEvent.check_at.date != null)
                ? Container(
                    margin: EdgeInsets.only(left: 232.0.w),
                    child: Text(
                      _getTimeShow(outEvent.check_at.date),
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(48.0),
                          fontFamily: "Roboto-Regular",
                          color: prefix0.blackColor333,
                          fontWeight: FontWeight.normal),
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }

  String _getTimeShow(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);
      DateFormat dateFormat = DateFormat("HH:mm dd/MM/yyyy");
      return dateFormat.format(dateTime);
    } catch (ex) {
      return "Không xác định";
    }
  }
}
