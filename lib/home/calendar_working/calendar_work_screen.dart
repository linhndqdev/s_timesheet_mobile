import 'package:core_asgl/animation/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/core/core.dart';
import 'package:s_timesheet_mobile/home/calendar_working/calendar_plan_detail.dart';
import 'package:s_timesheet_mobile/home/calendar_working/calendar_work_bloc.dart';
import 'package:s_timesheet_mobile/home/calendar_working/information_shift_member_model.dart';
import 'package:s_timesheet_mobile/home/calendar_working/sabbatical_screen.dart';
import 'package:s_timesheet_mobile/model/calendar_model.dart';
import 'package:s_timesheet_mobile/utils/common/datetime_utils.dart';
import 'package:s_timesheet_mobile/utils/widget/calendar_widget.dart';
import 'package:s_timesheet_mobile/utils/widget/choose_shift_has_data_widget.dart';
import 'package:s_timesheet_mobile/utils/widget/custom_appbar.dart';
import 'package:s_timesheet_mobile/utils/widget/switch_shift_information_widget.dart';

class CalendarWorkingScreen extends StatefulWidget {
  final VoidCallback callBackOpenMenu;

  const CalendarWorkingScreen({Key key, this.callBackOpenMenu})
      : super(key: key);

  @override
  _CalendarWorkingScreenState createState() => _CalendarWorkingScreenState();
}

class _CalendarWorkingScreenState extends State<CalendarWorkingScreen> {
  AppBloc appbloc;
  final SlidableController _slidableController = SlidableController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Map<int, String> mapDate =
          DateTimeUtils.getFirstDateAndLastDate(DateTime.now());
//      String time = DateTimeUtils.convertDate(DateTime.now());
      appbloc.calendarWorkBloc.getWorkSchedulesMonth(
          startDate: mapDate[0], endDate: mapDate[1], isInit: true);
    });
    super.initState();
    BackStateBloc backStateBloc = BackStateBloc.getInstance();
    backStateBloc.setStateToHome();
  }

  @override
  Widget build(BuildContext context) {
    appbloc = BlocProvider.of(context);

    appbloc.calendarWorkBloc.shiftStateStream.notify(ShiftStateModel(
        state: ShiftState
            .NONE)); //chỗ này sẽ ẩn hết các màn con khi chưa được ẩn đi
//    Slidable.of(context)?.dispose();
    return WillPopScope(
      onWillPop: () async {
        if (appbloc.backStateBloc.focusWidgetModel.state ==
            isFocusWidget.REQUEST_OFF_SHIFT) {
          hideChildWidget();
        } else if (appbloc.backStateBloc.focusWidgetModel.state ==
            isFocusWidget.DETAIL_SHIFT) {
          hideChildWidget();
        } else if (appbloc.backStateBloc.focusWidgetModel.state ==
            isFocusWidget.SWITCH_SHIFT) {
          hideChildWidget();
        } else if (appbloc.backStateBloc.focusWidgetModel.state ==
            isFocusWidget.CHOOSE_SHIFT) {
          hideChildWidget();
        }else {
          return true;
        }
        return false;
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
              backgroundColor: Color(0xffffffff),
              appBar: PreferredSize(
                preferredSize: Size(
                    MediaQuery.of(context).size.width, 66.h + 47.1.h + 19.h),
                child: CustomAppBar(
                  callBackOpenMenu: () => widget.callBackOpenMenu(),
                  title: "Lịch làm việc",
                ),
              ),
              body: TranslateVertical(
                  startPosition: MediaQuery.of(context).size.height,
                  curveAnimated: Curves.easeInOutQuart,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 21.0.h),
                        CalendarWidget(appBloc: appbloc),
                        SizedBox(height: 45.0.h),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 59.0.w),
                            Image.asset("asset/images/ic_calendar_yellow.png",
                                width: 60.w, height: 60.h),
                            SizedBox(width: 25.0.w),
                            //DateFormat('yyyy-MM-dd').format(startTime),
                            StreamBuilder(
                                initialData:
                                    appbloc.calendarWorkBloc.selectedDay,
                                stream: appbloc
                                    .calendarWorkBloc.selectedDateStream.stream,
                                builder: (context,
                                    AsyncSnapshot<DateTime> snapshot) {
                                  String time = DateFormat('dd-MM-yyyy')
                                      .format(snapshot.data)
                                      .toString();
                                  return Text("Ngày " + time,
                                      style: TextStyle(
                                          color: Color(0xff333333),
                                          fontSize: 48.sp,
                                          height: 1.25,
                                          fontFamily: "Roboto-Medium"));
                                }),
                          ],
                        ),
                        SizedBox(height: 21.0.h),
                        buildContentWorkShif(),
                        SizedBox(height: 108.2.h)
                      ],
                    ),
                  ))), //khi giao diện lần đầu load lên
          StreamBuilder<ShiftStateModel>(
              initialData: ShiftStateModel(state: ShiftState.NONE),
              stream: appbloc.calendarWorkBloc.shiftStateStream.stream,
              builder: (context, snapshot) {
                switch (snapshot.data.state) {
                  case ShiftState.NONE:
                    return Container();
                    break;
                  case ShiftState.XIN_NGHI:
                    return SabbaticalLeaveScreen(
                        idShift: snapshot.data.data,
                        Datetime: snapshot.data.days);
                    break;
                  case ShiftState.CHI_TIET:
                    return PlanDetailScreen(
                        idShift: snapshot.data.data,
                        status: snapshot.data.status);
                    break;
                  case ShiftState.INFOMATIONSHIFT:
                    return SwitchShiftInformationWidget(
                      appBloc: appbloc,
                      data: snapshot.data.data,
                      Choseday: snapshot.data.days,
                    );
                    break;
                  case ShiftState.CHON_CA:
                    return ChooseShiftHasData(
                      appBloc: appbloc,
                      data: snapshot.data.data,
                      days: snapshot.data.days,
                    ); //buildChooseShiftHasData();
                    break;
                  default:
                    return Container();
                    break;
                }
              }), //khi bấm đổi ca show màn hình chọn ca
        ],
      ),
    );
  }

  hideChildWidget() {
    appbloc.homeBloc.disableWithAnimation(
        () => appbloc.calendarWorkBloc.shiftStateStream.notify(
              ShiftStateModel(state: ShiftState.NONE),
            ));
    appbloc.backStateBloc.setStateToHome();
  }

  buildContentWorkShif() {
    return StreamBuilder(
        initialData:
            CalendarDayStreamModel(CalendarDayStreamState.LOADING, null),
        stream: appbloc.calendarWorkBloc.workScheduleStream.stream,
        builder: (context, AsyncSnapshot<CalendarDayStreamModel> snapshot) {
          switch (snapshot.data.state) {
            case CalendarDayStreamState.LOADING:
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
              break;
            case CalendarDayStreamState.NO_DATA:
              return Text("Không có dữ liệu ca");
              break;
            case CalendarDayStreamState.SHOW:
              return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 34.w, right: 34.w),
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: Color(0xffe18c12),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (context, index) {
                      CalendarModel data = snapshot.data.data[index];
                      DateTime dateTime = DateTime.parse(data.date);
                      String startAt = data.shift?.workTimes[0]?.startAt;
                      startAt = startAt.substring(0, startAt.length - 3);
                      String finishAt = data.shift?.workTimes[0]?.finishAt;
                      finishAt = finishAt != null
                          ? finishAt.substring(0, finishAt.length - 3)
                          : "";
                      String location = data.location?.name;
                      String shift = data.shift?.name;
                      return buildItemCa(
                          idShift: data.id,
                          inTime: startAt,
                          outTime: finishAt,
                          location: location,
                          statusShiftOri: data.status,
                          shift: shift ?? "Ca Hành Chính",
                          lastItem:
                              index == snapshot.data.data.length ? true : false,
                          choseday: dateTime);
                    },
                  )
                ],
              );
              break;
            default:
              return Text("Không có dữ liệu ca");
              break;
          }
        });
  }

  buildItemCa(
      {int idShift,
      String inTime,
      String outTime,
      String shift,
      String location,
      String statusShiftOri,
      bool lastItem,
      DateTime choseday}) {
    String statusShift = "Chưa vào ca";
    switch (statusShiftOri) {
      case "incoming":
        statusShift = "Chưa vào ca";
        break;
      case "happening":
        statusShift = "Đang trong ca";
        break;
      case "ended":
        statusShift = "Đã hết ca";
        break;
    }
    return InkWell(
      onTap: () {
        _slidableController?.activeState = null;
        print(statusShift);
        appbloc.calendarWorkBloc.shiftStateStream.notify(ShiftStateModel(
            state: ShiftState.CHI_TIET, data: idShift, status: statusShiftOri));
      },
      child: statusShift == "Chưa vào ca"
          ? Slidable(
              actionPane: SlidableDrawerActionPane(),
              closeOnScroll: true,
              controller: _slidableController,
              actionExtentRatio: 0.20,
              child: buildContent(
                  inTime, outTime, shift, location, statusShift, lastItem),
              secondaryActions: <Widget>[
                  InkWell(
                    onTap: () {
                      _slidableController?.activeState = null; //ẩn slideable đi
                      appbloc.authBloc.loadingStream.notify(true);
                      appbloc.calendarWorkBloc.getDataToSwitchShift(
                          idShift: idShift, appBloc: appbloc);

                      appbloc.calendarWorkBloc.shiftStateStream.notify(
                        ShiftStateModel(
                            state: ShiftState.INFOMATIONSHIFT,
                            data: InformationShiftMemberModel
                                .createInformationShiftMemberModel(
                                    idShift: idShift,
                                    date: "",
                                    time: "",
                                    nameShift: "",
                                    idShiftChange: null,
                                    nameMember: "",
                                    idMember: null,
                                    asglID: "",
                                    isInit: true,
                                    choseDay: choseday),
                            days: choseday),
                      );
                    },
                    child: Container(
                      width: 207.w,
                      color: Color(0xff005a88).withOpacity(0.2),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 39.h),
                          Image.asset(
                              "asset/images/ic_calendar_changeShift.png",
                              width: 60.w,
                              height: 60.w,
                              color: Color(0xff005a88)),
                          SizedBox(height: 12.h),
                          Text(
                            "Đổi ca",
                            style: TextStyle(
                                color: Color(0xff005a88),
                                fontFamily: "Roboto-Regular",
                                fontSize: 43.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print("Xin nghỉ");
                      appbloc.calendarWorkBloc.shiftStateStream.notify(
                          ShiftStateModel(
                              state: ShiftState.XIN_NGHI,
                              data: idShift,
                              days: choseday));
                      _slidableController?.activeState = null;
                      //ẩn slideable đi, nếu ko dùng thì nó cứ hiện mãi
                    },
                    child: Container(
                      width: 207.w,
                      color: Color(0xffe18c12).withOpacity(0.2),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 39.h),
                          Image.asset(
                              "asset/images/ic_calendar_changeShift.png",
                              width: 60.w,
                              height: 60.w,
                              color: Color(0xffe10606)),
                          SizedBox(height: 12.h),
                          Text(
                            "Xin nghỉ",
                            style: TextStyle(
                                color: Color(0xffe10606),
                                fontFamily: "Roboto-Regular",
                                fontSize: 43.sp),
                          )
                        ],
                      ),
                    ),
                  )
                ])
          : buildContent(
              inTime, outTime, shift, location, statusShift, lastItem),
    );
  }

  buildContent(String inTime, String outTime, String shift, String location,
      String statusShift, bool lastItem) {
    Color colorStatus = Color(0xff959ca7);
    if (statusShift.toLowerCase() == "chưa vào ca")
      colorStatus = Color(0xff959ca7);
    else if (statusShift.toLowerCase() == "đang trong ca")
      colorStatus = Color(0xff00ea12);
    else if (statusShift.toLowerCase() == "đã hết ca")
      colorStatus = Color(0xffe10606);
    return Stack(
      children: <Widget>[
        Container(
          height: 207.h,
          child: Column(
            children: <Widget>[
              SizedBox(height: 21.h),
              Row(
                children: <Widget>[
                  SizedBox(width: 59.0.w),
                  Container(
                    height: 123.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
//                    SizedBox(height:6.h),
                        Container(
                          height: (123 / 2).h,
                          child: Text(inTime,
                              style: TextStyle(
                                  color: Color(0xff005a88),
                                  fontSize: 48.sp,
//                              height: 1.25,
                                  fontFamily: "Roboto-Medium")),
                        ),
                        Container(
                          height: (123 / 2).h,
                          child: Text(outTime,
                              style: TextStyle(
                                  color: Color(0xffe8e8e8),
                                  fontSize: 48.sp,
//                              height: 1.25,
                                  fontFamily: "Roboto-Medium")),
                        ),
//                      SizedBox(height:6.h),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.0.w),
                  Container(
                    height: (123 + 12).h,
                    padding: EdgeInsets.only(left: 16.w),
                    decoration: BoxDecoration(
                      border: Border(
                          left:
                              BorderSide(width: 3.w, color: Color(0xff005a88))),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 74.h,
                          child: Text(
                            shift,
                            style: TextStyle(
                                color: Color(0xff005a88),
                                fontSize: 56.sp,
//                            height: 1.07,
                                fontFamily: "Roboto-Bold"),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          height: 55.h,
                          child: Text(location,
                              style: TextStyle(
                                  color: Color(0xff959ca7),
                                  fontSize: 42.sp,
//                              height: 1.43,
                                  fontFamily: "Roboto-Regular")),
                        )
                      ],
                    ),
                  ),
                  //  SizedBox(width: 16.0.w),

                  Expanded(
                    child: Container(),
                  ),
                  SizedBox(width: 59.w)
                ],
              ),
              // SizedBox(height: 12.h),
              SizedBox(height: 48.h),
              !lastItem
                  ? Container(
                      margin: EdgeInsets.only(left: 34.w, right: 34.w),
                      height: 1.h,
                      decoration: BoxDecoration(
                        color: Color(0xff959ca7),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        Positioned(
          right: 59.w,
          bottom: 19.h,
          child: Text(statusShift,
              style: TextStyle(
                  color: colorStatus,
                  fontSize: 40.sp,
                  height: 1.5,
                  fontFamily: "Roboto-Italic")),
        )
      ],
    );
  }
}
