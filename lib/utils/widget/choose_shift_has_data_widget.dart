import 'package:flutter/material.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/core/core.dart';
import 'package:s_timesheet_mobile/home/calendar_working/calendar_work_bloc.dart';
import 'package:s_timesheet_mobile/home/calendar_working/information_shift_member_model.dart';
import 'package:s_timesheet_mobile/home/event/event_screen.dart';
import 'package:s_timesheet_mobile/model/choose_shift_model.dart';
import 'package:s_timesheet_mobile/utils/animation/animation_switch_shift.dart';
import 'package:s_timesheet_mobile/utils/animation/button_animation.dart';
import 'package:s_timesheet_mobile/utils/common/datetime_utils.dart';
import 'package:s_timesheet_mobile/utils/model/chooseShift_sample_model.dart';
import 'package:s_timesheet_mobile/core/style.dart' as prefix0;

class ChooseShiftHasData extends StatefulWidget {
  final AppBloc appBloc;
  final InformationShiftMemberModel data;
  final DateTime days;

  ChooseShiftHasData({this.appBloc, this.data, this.days});

  @override
  _ChooseShiftHasDataState createState() => _ChooseShiftHasDataState();
}

class _ChooseShiftHasDataState extends State<ChooseShiftHasData> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackStateBloc backStateBloc = BackStateBloc.getInstance();
    backStateBloc.setStateToOther(state: isFocusWidget.CHOOSE_SHIFT);
    Future.delayed(Duration.zero, () {
      widget.appBloc.calendarWorkBloc.getShiftCanChange(
          idShift: widget.data.idShift,
          idUserWillChange: widget.data.idMember,
          appBloc: widget.appBloc,
          oldData: widget.data);
      widget.appBloc.calendarWorkBloc.choosedShift = null;
      // widget.appBloc.calendarWorkBloc.createSampleChooseShiftData();
    });
  }

//  AnimationController controller;

  @override
  Widget build(BuildContext context) {


    return Container(
        color: Color(0xff959ca7).withOpacity(0.85),
        width: MediaQuery.of(context).size.width,
//        height: MediaQuery.of(context).size.height,
        child: AnimationSwitchShift(
          voidCallback: (c) {
            widget.appBloc.homeBloc.animationController = c;
          },
          widgetAction: StreamBuilder<DataChooseShiftModel>(
              initialData:
                  DataChooseShiftModel(state: DataChooseShiftState.LOAD_DING),
              stream: widget.appBloc.calendarWorkBloc.dataStatusStream.stream,
              builder: (context, snapshot) {
                double opacitiHeight = 270.h;

                if (snapshot.data.state != DataChooseShiftState.NO_DATA) {
                  opacitiHeight = 270.h;
                } else {
                  opacitiHeight = 669.h;
                }
                return Column(
                  children: <Widget>[
                    SizedBox(height: opacitiHeight),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0))),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 55.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                        "asset/images/ic_calendar_choseShift.png",
                                        width: 60.w,
                                        height: 60.h),
                                    SizedBox(width: 25.w),
                                    Text("Chọn ca",
                                        style: TextStyle(
                                            color: Color(0xffe18c12),
                                            fontSize: 60.sp,
                                            fontFamily: "Roboto-Bold"))
                                  ],
                                ), //tiêu đề chọn ca
                                SizedBox(height: 24.h),
                                Container(
                                  height: 2.h,
                                  width: MediaQuery.of(context).size.width,
                                  color: snapshot.data.state ==
                                          DataChooseShiftState.HAS_DATA
                                      ? Color(0xff005a88)
                                      : Color(0xffe18c12),
                                ), //dòng kẻ xanh
                                _buildContent(snapshot.data.state)
//              }
//                              snapshot.data.state ==
//                                      DataChooseShiftState.HAS_DATA
//                                  ? buildWidgetHasData(widget.appBloc)
//                                  : buildWidgetNoData(widget.appBloc)
                              ],
                            ),
                          ),
                          Positioned(
                              top: 0, //34.h,
                              right: 0, //34.w,
                              child: InkWell(
                                onTap: () {
                                  widget.appBloc.homeBloc
                                      .disableWithAnimation(() {
                                    widget.appBloc.calendarWorkBloc
                                        .shiftStateStream
                                        ?.notify(ShiftStateModel(
                                            state: ShiftState.INFOMATIONSHIFT,
                                            data: widget.data,
                                            days: widget.days));
                                  });
//                                  controller?.reverse();
//                                  Future.delayed(Duration(milliseconds: 400),
//                                      () {
//                                    widget.appBloc.calendarWorkBloc
//                                        .shiftStateStream
//                                        ?.notify(ShiftStateModel(
//                                            state: ShiftState.INFOMATIONSHIFT,
//                                            data: widget.data,
//                                            days: widget.days));
////                                    widget.appBloc.calendarWorkBloc
////                                        .shiftStateStream
////                                        .notify(ShiftStateModel(
////                                            state: ShiftState.NONE));
//                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: 34.w,
                                      top: 34.h,
                                      left: 34.w,
                                      bottom: 34.h),
                                  child: Image.asset(
                                      "asset/images/ic_cancel.png",
                                      width: 40.w,
                                      height: 40.w),
                                ),
                              )),
                        ],
                      ),
                    )
                  ],
                );
              }),
        ));
  }

  _buildContent(DataChooseShiftState state) {
    switch (state) {
      case DataChooseShiftState.HAS_DATA:
        return buildWidgetHasData(widget.appBloc);
        break;
      case DataChooseShiftState.NO_DATA:
        return buildWidgetNoData(widget.appBloc);
        break;
      case DataChooseShiftState.LOAD_DING:
        return buildLoaddingWidget();
        break;
    }
  }

  buildLoaddingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
//        Container(
//          padding: EdgeInsets.only(top: 55.h),
//          child: Text(
//            'Không có dữ liệu',
//            style: TextStyle(
//                fontSize: 52.sp,
//                fontFamily: "Roboto-Medium",
//                color: Color(0xff333333),
//                fontWeight: FontWeight.w500),
//          ),
//        ),
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
                          AlwaysStoppedAnimation<Color>(prefix0.accentColor)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildWidgetNoData(AppBloc appBloc) {
    return Column(
      children: <Widget>[
        SizedBox(height: 23.h),
        Row(
          children: <Widget>[
            SizedBox(width: 24.w),
            InkWell(
              onTap: () {
                widget.appBloc.calendarWorkBloc.shiftStateStream?.notify(
                    ShiftStateModel(
                        state: ShiftState.INFOMATIONSHIFT,
                        data: widget.data,
                        days: widget.days));
              },
              child: Text("QUAY LẠI",
                  style: TextStyle(
                      color: Color(0xff959ca7),
                      fontSize: 52.sp,
                      height: 1.15,
                      fontFamily: "Roboto-Medium")),
            ),
          ],
        ), //dòng kẻ xanh,
        SizedBox(height: 101.h),
        Image.asset("asset/images/ic_noDataShift.png",
            width: 690.5.w, height: 600.h),
        SizedBox(height: 15.h),
        Text("Hiện chưa có lịch làm việc",
            style: TextStyle(
                color: Color(0xff959ca7),
                fontSize: 48.sp,
                height: 1.42,
                letterSpacing: 0.94.sp,
                fontFamily: "Roboto-Regular"))
      ],
    );
  }

  buildWidgetHasData(AppBloc appBloc) {
    return Expanded(
      child: Column(
        children: <Widget>[
          SizedBox(height: 23.h),
          Row(
            children: <Widget>[
              SizedBox(width: 24.w),
              InkWell(
                onTap: () {
                  widget.appBloc.calendarWorkBloc.shiftStateStream?.notify(
                      ShiftStateModel(
                          state: ShiftState.INFOMATIONSHIFT,
                          data: widget.data,
                          days: widget.days));
                },
                child: Text("QUAY LẠI",
                    style: TextStyle(
                        color: Color(0xff959ca7),
                        fontSize: 52.sp,
                        height: 1.15,
                        fontFamily: "Roboto-Medium")),
              ),
              Expanded(
                child: Container(),
              ),
              InkWell(
                onTap: () {
                  if (widget.appBloc.calendarWorkBloc.choosedShift != null) {
                    widget.appBloc.calendarWorkBloc.shiftStateStream?.notify(
                        ShiftStateModel(
                            state: ShiftState.INFOMATIONSHIFT,
                            data: widget.appBloc.calendarWorkBloc.choosedShift,
                            days: widget.days));
                  } else
                    widget.appBloc.calendarWorkBloc.shiftStateStream?.notify(
                        ShiftStateModel(
                            state: ShiftState.INFOMATIONSHIFT,
                            data: widget.data,
                            days: widget.days));
                },
                child: Text("XONG",
                    style: TextStyle(
                        color: Color(0xff005a88),
                        //Color(0xff959ca7),
                        fontSize: 52.sp,
                        height: 1.15,
                        fontFamily: "Roboto-Medium")),
              ),
              SizedBox(width: 33.w)
            ],
          ), //quay lại - xong,,
          SizedBox(height: 38.h),
          buildListBigItemChonCa()
        ],
      ),
    );
  }

  buildListBigItemChonCa() {
    // dataStatusStream.notify(DataChooseShiftModel(state:  DataChooseShiftState.NO_DATA));
    return Expanded(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: widget.appBloc.calendarWorkBloc.listShiftDates.length,
          itemBuilder: (context, index) {
            var data = widget.appBloc.calendarWorkBloc.listShiftDates[index];
            return buildBigItemChonCa(chooseShiftModel: data);
          },
        ),
      ),
    );
  }

  buildBigItemChonCa({ChooseShiftModel chooseShiftModel}) {
    return Column(
      children: <Widget>[
        SizedBox(height: 35.h),
        Row(
          children: <Widget>[
            SizedBox(width: 59.w),
            Image.asset("asset/images/ic_calendar_date.png",
                color: Color(0xff333333), width: 60.w, height: 60.h),
            SizedBox(width: 25.w),
            Text(chooseShiftModel.date,
                style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 52.sp,
                    fontFamily: "Roboto-Medium"))
          ],
        ), //icon và ngày
        SizedBox(height: 20.h),
        ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: chooseShiftModel.listEventDataModel.length,
          itemBuilder: (context, index) {
            var data = chooseShiftModel.listEventDataModel[index];

            return buildItemShift(
                id: data.index,
                location: data.location,
                chosenStatus: data.isSelected,
                firstItem: index == 0 ? true : false,
                inTime: data.timeIn,
                outTime: data.timeOut,
                shift: data.shift,
                onClick: () {
                  widget.appBloc.calendarWorkBloc.mapShiftData.keys
                      .forEach((key) {
                    if (key == data.index) {
                      widget.appBloc.calendarWorkBloc.mapShiftData[key] =
                          !widget.appBloc.calendarWorkBloc.mapShiftData[key];
                    } else
                      widget.appBloc.calendarWorkBloc.mapShiftData[key] = false;
                  });
                  bool isCheck =
                      widget.appBloc.calendarWorkBloc.mapShiftData[data.index];
                  widget.appBloc.calendarWorkBloc.choseItemShiftStream.notify(
                      ChooseShiftDataModel(id: data.index, state: isCheck));
                  if (isCheck) {
                    var choosed = widget.appBloc.calendarWorkBloc
                        .listShiftCanChange[data.index];
                    widget.appBloc.calendarWorkBloc.choosedShift =
                        InformationShiftMemberModel
                            .createInformationShiftMemberModel(
                                idMember: widget.data.idMember,
                                nameMember: widget.data.nameMember,
                                idShift: widget.data.idShift,
                                idShiftChange: choosed.id,
                                asglID: widget.data.asglID,
                                date: DateTimeUtils.convertDate3(choosed.date),
                                nameShift: choosed.shift.name,
                                time: data.timeIn +
                                    (data.timeOut != ""
                                        ? " - " + data.timeOut
                                        : ""),
                                choseDay: widget.days,
                                isInit: true);
                  } else {
                    widget.appBloc.calendarWorkBloc.choosedShift =
                        InformationShiftMemberModel
                            .createInformationShiftMemberModel(
                                idMember: widget.data.idMember,
                                nameMember: widget.data.nameMember,
                                idShift: widget.data.idShift,
                                idShiftChange: null,
                                asglID: widget.data.asglID,
                                date: "",
                                nameShift: "",
                                time: "",
                                choseDay: widget.days,
                                isInit: true);
                    //widget.appBloc.calendarWorkBloc.choosedShift = null;
                  }
                });
          },
        ),
      ],
    );
  }

  buildItemShift(
      {int id,
      String inTime,
      String outTime,
      String shift,
      String location,
      bool firstItem,
      bool chosenStatus,
      VoidCallback onClick}) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 34.w),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xff005a88).withOpacity(0.15),
        ),
//      height: 222.h,
        child: Column(
          children: <Widget>[
//          SizedBox(height: 50.h),
            Container(
              height: 2.h,
              decoration: BoxDecoration(
                color: firstItem
                    ? Color(0xff005a88).withOpacity(0.3)
                    : Color(0xff959ca7).withOpacity(0.8),
              ),
            ),
            //: Container(),
            Row(
              children: <Widget>[
                SizedBox(width: 25.0.w),
                Column(
                  children: <Widget>[
                    Text(inTime,
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 42.sp,
                            height: 1.43,
                            fontFamily: "Roboto-Medium")),
                    Text(outTime,
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 42.sp,
                            height: 1.43,
                            fontFamily: "Roboto-Medium"))
                  ],
                ), //2 khung giờ,
                SizedBox(width: 20.0.w),
                Container(
                  height: 135.h,
                  width: 3.w,
                  color: Color(0xff005a88),
                ), //đường kẻ đứng
                SizedBox(width: 21.0.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(shift,
                        style: TextStyle(
                            color: Color(0xff005a88),
                            fontSize: 52.sp,
                            height: 1.15,
                            fontFamily: "Roboto-Bold")),
                    Container(
                      child: Text(location,
                          style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 42.sp,
                              height: 1.43,
                              fontFamily: "Roboto-Regular")),
                    )
                  ],
                ), //ca và vị trí
                Expanded(
                  child: Container(),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: 81.h),
                    StreamBuilder<ChooseShiftDataModel>(
                        initialData: null,
                        stream: widget.appBloc.calendarWorkBloc
                            .choseItemShiftStream.stream,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return !chosenStatus
                                ? Container(
                                    height: 60.w,
                                    width: 60.w,
                                    decoration: BoxDecoration(
                                      color: Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(5.w),
                                    ),
                                  )
                                : Image.asset("asset/images/ic_chosen.png",
                                    width: 60.w, height: 60.w);
                          } else {
                            if (id == snapshot.data.id && snapshot.data.state) {
                              return Image.asset("asset/images/ic_chosen.png",
                                  width: 60.w, height: 60.w);
                            } else
                              return Container(
                                height: 60.w,
                                width: 60.w,
                                decoration: BoxDecoration(
                                  color: Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(5.w),
                                ),
                              );
                          }
                        }),
//                    !chosenStatus
//                        ? Container(
//                            height: 60.h,
//                            width: 60.w,
//                            decoration: BoxDecoration(
//                              color: Color(0xffffffff),
//                              borderRadius: BorderRadius.circular(5.w),
//                            ),
//                          )
//                        : Image.asset("asset/images/ic_chosen.png",
//                            width: 60.w, height: 60.h),
                    SizedBox(height: 81.h),
                  ],
                ),
                SizedBox(width: 43.w)
              ],
            ),
//          SizedBox(height: 36.h),
//          !lastItem
//              ? Container(
//            margin: EdgeInsets.only(left: 34.w, right: 34.w),
//            height: 1.h,
//            decoration: BoxDecoration(
//              color: Color(0xff959ca7),
//            ),
//          )
//              : Container(),
          ],
        ),
      ),
    );
  }
}
