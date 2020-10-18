import 'package:flutter/material.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:s_timesheet_mobile/utils/widget/semi_round_border_widget.dart';

class TabbarWithBorderStatistic extends StatelessWidget {
  final bool haveBorderInQR;
  final String contentQR;
  final String contentLocation;
  final VoidCallback voidCallbackQR;
  final VoidCallback voidCallbackLocation;
  final Color colorQR;
  final Color colorLocation;

  TabbarWithBorderStatistic({this.haveBorderInQR, this.contentQR, this.contentLocation,
      this.voidCallbackQR, this.voidCallbackLocation, this.colorQR,
      this.colorLocation});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 74.h,
          width: 80.w,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                    color: Color(0xff005a88),
                    width: 2.w,
                  ))),
        ),
        InkWell(
            onTap: () {
              voidCallbackQR();
            },
            child: haveBorderInQR
                ? Container(
              height: 80.h,
              width: 456.w,
              child: SemiRoundedBorderButton(
                  borderSide:
                  BorderSide(color: Color(0xff005a88), width: 2.0.w),
                  radius: const Radius.circular(10.0),
                  background: Colors.white,
                  child: Center(
                    child: Text(
                      contentQR,
                      style: TextStyle(
                        fontFamily: 'Roboto-Bold',
                        fontSize: 42.sp,
                        color: colorQR,
                      ),
                    ),
                  )),
            )
                : Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color(0xff005a88), width: 2.0.w))),
                height: 74.h,
                width: 456.w,
                child: Center(
                  child: Text(
                    contentQR,
                    style: TextStyle(
                      fontFamily: 'Roboto-Bold',
                      fontSize: 42.sp,
                      color: colorQR,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ))),
        InkWell(
            onTap: () {
              voidCallbackLocation();
            },
            child: !haveBorderInQR
                ? Container(
              height: 80.h,
              width: 456.w,
              child: SemiRoundedBorderButton(
                  borderSide:
                  BorderSide(color: Color(0xff005a88), width: 2.0.w),
                  radius: const Radius.circular(10.0),
                  background: Colors.white,
                  child: new Center(
                    child: Text(
                      contentLocation,
                      style: TextStyle(
                        fontFamily: 'Roboto-Bold',
                        fontSize: 42.sp,
                        color: colorLocation,
                      ),
                    ),
                  )),
            )
                : Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color(0xff005a88), width: 2.0.w))),
                height: 74.h,
                width: 456.w,
                child: Center(
                  child: Text(
                    contentLocation,
                    style: TextStyle(
                      fontFamily: 'Roboto-Bold',
                      fontSize: 42.sp,
                      color: colorLocation,
                    ),
                  ),
                ))),
        Container(
          height:  74.h,
          width: 80.w,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                    color: Color(0xff005a88),
                    width: 2.w,
                  ))),
        ),
      ],
    );
  }
}
