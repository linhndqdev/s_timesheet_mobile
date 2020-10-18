import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/core/style.dart' as prefix0;

import 'package:s_timesheet_mobile/home/statistic/statistic_bloc.dart';
import 'package:s_timesheet_mobile/utils/animation/animation_open_qr_location.dart';

class ChooseMonth extends StatefulWidget {
  final AppBloc appBloc;
  final StatisticState state;
  final int month;
  final int year;
  final VoidCallback onResetData;

  const ChooseMonth(
      {Key key,
      this.onResetData,
      this.state,
      this.month,
      this.year,
      this.appBloc})
      : super(key: key);

  @override
  _ChooseMonthState createState() => _ChooseMonthState();
}

class _ChooseMonthState extends State<ChooseMonth> {
  @override
  void initState() {
    super.initState();
    genDateTime();
  }

  int selectedYear;

  int selectedMonth;
  List<int> listYears = new List<int>();
  List<int> listMonth = new List<int>();

  genDateTime() {
    selectedYear = widget.year == null
        ? DateTime.now().year
        : widget.year; // widget.month;
    selectedMonth = widget.month == null
        ? DateTime.now().month
        : widget.month; //widget.year;
    for (int i = DateTime.now().year; i < DateTime.now().year + 10; i++) {
      listYears.add(i);
    }
    for (int i = 1; i < 13; i++) {
      listMonth.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.appBloc.backStateBloc
        .setStateToOther(state: isFocusWidget.CHOOSE_MONTH);
    return //buildNewDatePicker();
        WillPopScope(
      onWillPop: () async {
        if (widget.appBloc.backStateBloc.focusWidgetModel.state ==
            isFocusWidget.CHOOSE_MONTH) {
          widget.appBloc.homeBloc.disableWithAnimation(() =>
              widget.appBloc.statisticBloc.showMonthSelectStream.notify(
                  ShowChooseMonthModel(state: widget.state, isShow: false)));
          widget.appBloc.backStateBloc.setStateToHome();
        } else {
          return true;
        }
        return false;
      },
      child: Stack(
        children: <Widget>[
          InkWell(
            onTap: () {
              widget.appBloc.homeBloc.disableWithAnimation(() => widget
                  .appBloc.statisticBloc.showMonthSelectStream
                  .notify(ShowChooseMonthModel(
                      state: widget.state, isShow: false)));
            },
            child: Container(
              color: Color(0xff959ca7).withOpacity(0.7),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Positioned(
            bottom: 0,
            child: OpenAnimationQRandLocation(
                Container(
                  height: 831.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0))),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(height: 55.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                  "asset/images/ic_calendar_statistic.png",
                                  width: 60.w,
                                  height: 60.h),
                              SizedBox(width: 25.w),
                              Text("Chọn tháng",
                                  style: TextStyle(
                                      color: Color(0xffe18c12),
                                      fontSize: 60.sp,
                                      fontFamily: "Roboto-Bold"))
                            ],
                          ),
                          //tiêu đề chọn ca
                          SizedBox(height: 15.h),
                          Container(
                            height: 2.h,
                            width: MediaQuery.of(context).size.width,
                            color: Color(0xffe18c12),
                          ),
                          SizedBox(height: 14.h),
                          buildBtnFinish(),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                SizedBox(width: 161.w),
                                buildYearWidget(selectedYear),
                                Expanded(child: Container()),
                                buildMonthWidget(selectedMonth),
                                SizedBox(width: 161.w),
                              ],
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        top: 0, //34.h,
                        right: 0, //34.w,
                        child: InkWell(
                            onTap: () {
                              widget.appBloc.homeBloc.disableWithAnimation(() =>
                                  widget.appBloc.statisticBloc
                                      .showMonthSelectStream
                                      .notify(ShowChooseMonthModel(
                                          state: widget.state, isShow: false)));
                            },
                            child: Container(
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.only(
                                  top: 34.h,
                                  right: 34.w,
                                  left: 50.w,
                                  bottom: 50.h),
                              child: Image.asset(
                                "asset/images/ic_cancel.png",
                                width: 40.w,
                                height: 40.h,
                              ),
                            )),
                      )
                    ],
                  ),
                ), voidCallback: (c) {
              widget.appBloc.homeBloc.animationController = c;
            }),
          )
        ],
      ),
    );
  }

  buildMonthWidget(int initMonth) {
    return StreamBuilder<int>(
        initialData: initMonth,
        stream: widget.appBloc.statisticBloc.monthSelectedStream.stream,
        builder: (context, snapshot) {
          int indexScrool = 0;
          for (int i = 0; i < listMonth.length; i++) {
            if (listMonth[i] == snapshot.data) {
              indexScrool = i;
              break;
            }
          }
          return Container(
            width: 300.w,
            child: CupertinoPicker.builder(
                scrollController:
                    FixedExtentScrollController(initialItem: indexScrool),
                itemExtent: 163.h,
                onSelectedItemChanged: (int index) {
                  selectedMonth = listMonth[index];
                  widget.appBloc.statisticBloc.monthSelectedStream
                      .notify(selectedMonth);
                },
                backgroundColor: Colors.white,
                childCount: listMonth.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 163.h,
                    child: Center(
                      child: Text(
                        "Tháng " + listMonth[index].toString(),
                        style: snapshot.data == listMonth[index]
                            ? TextStyle(
                                color: Color(0xffee8800),
                                fontSize: 52.sp,
                                fontFamily: "Roboto-Medium",
                                height: 1.31,
                                fontWeight: FontWeight.w500)
                            : TextStyle(
                                color: Color(0xffb1afaf),
                                fontSize: 48.sp,
                                fontFamily: "Roboto-Regular",
                                height: 1.42,
                              ),
                      ),
                    ),
                  );
                }),
          );
        });
  }

  buildYearWidget(int initYear) {
    return StreamBuilder<int>(
        initialData: initYear,
        stream: widget.appBloc.statisticBloc.yearSelectedStream.stream,
        builder: (context, snapshot) {
          int indexScrool = 0;
          for (int i = 0; i < listYears.length; i++) {
            if (listYears[i] == snapshot.data) {
              indexScrool = i;
              break;
            }
          }

          print(indexScrool.toString());
          return Container(
            width: 300.w,
            child: CupertinoPicker.builder(
                scrollController:
                    FixedExtentScrollController(initialItem: indexScrool),
                itemExtent: 163.h,
                onSelectedItemChanged: (int index) {
                  selectedYear = listYears[index];
                  widget.appBloc.statisticBloc.yearSelectedStream
                      .notify(selectedYear);
                },
                backgroundColor: Colors.white,
                childCount: listYears.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 163.h,
                    child: Center(
                      child: Text(
                        listYears[index].toString(),
                        style: snapshot.data == listYears[index]
                            ? TextStyle(
                                color: Color(0xffee8800),
                                fontSize: 52.sp,
                                fontFamily: "Roboto-Medium",
                                height: 1.31,
                                fontWeight: FontWeight.w500)
                            : TextStyle(
                                color: Color(0xffb1afaf),
                                fontSize: 48.sp,
                                fontFamily: "Roboto-Regular",
                                height: 1.42,
                              ),
                      ),
                    ),
                  );
                }),
          );
        });
  }

  buildBtnFinish() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          onTap: () {
            widget.appBloc.homeBloc.disableWithAnimation(() =>
                widget.appBloc.statisticBloc.showMonthSelectStream.notify(
                    ShowChooseMonthModel(state: widget.state, isShow: false)));

            widget.appBloc.statisticBloc.selectedYear = selectedYear;
            widget.appBloc.statisticBloc.selectedMonth = selectedMonth;
            if (widget.state == StatisticState.THONG_KE) {
              widget.appBloc.statisticBloc.showMonthSelectThongKeStream?.notify(
                  ShowChooseMonthModel(
                      state: widget.state,
                      isShow: false,
                      data: MonthYearModel(
                          month: selectedMonth, year: selectedYear)));
            } else if (widget.state == StatisticState.NHAT_KY) {
              widget.appBloc.statisticBloc.showMonthSelectNhatKyStream?.notify(
                  ShowChooseMonthModel(
                      state: widget.state,
                      isShow: false,
                      data: MonthYearModel(
                          month: selectedMonth, year: selectedYear)));
              widget.onResetData();
            }
          },
          child: Text("XONG",
              style: TextStyle(
                color: Color(0xff005a88),
                fontSize: 52.sp,
                height: 1.15,
                fontFamily: "Roboto-Medium",
                fontWeight: FontWeight.w500,
              )),
        ),
        SizedBox(width: 34.w),
      ],
    );
  }
}
