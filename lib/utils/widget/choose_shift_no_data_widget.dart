import 'package:flutter/material.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:s_timesheet_mobile/core/core.dart';
import 'package:s_timesheet_mobile/home/calendar_working/calendar_work_bloc.dart';
class ChooseShiftNoData extends StatelessWidget {
  final AppBloc appBloc;
  ChooseShiftNoData(this.appBloc);
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xff959ca7).withOpacity(0.85),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SizedBox(height: 669.h),
            Expanded(
              child: Container(
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
                            Image.asset("asset/images/ic_calendar_choseShift.png",
                                width: 60.w, height: 60.h),
                            SizedBox(width: 25.w),
                            Text("Chọn ca",
                                style: TextStyle(
                                    color: Color(0xffe18c12),
                                    fontSize: 60.sp,
                                    fontFamily: "Roboto-Bold"))
                          ],
                        ), //tiêu đề chọn ca
                        SizedBox(height: 15.h),
                        Container(
                          height: 2.h,
                          width: MediaQuery.of(context).size.width,
                          color: Color(0xffe18c12),
                        ),
                        SizedBox(height: 23.h),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 24.w),
                            InkWell(
                              onTap: () {
                                appBloc.calendarWorkBloc.shiftStateStream?.notify(
                                    ShiftStateModel(state: ShiftState.INFOMATIONSHIFT));
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
                    ),
                    Positioned(
                      top: 34.h,
                      right: 34.w,
                      child: InkWell(
                          onTap: () {
                            appBloc.calendarWorkBloc.shiftStateStream
                                .notify(ShiftStateModel(state: ShiftState.NONE));
                          },
                          child: Image.asset(
                            "asset/images/ic_cancel.png",
                            width: 40.w,
                            height: 40.h,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  }
}
