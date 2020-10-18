import 'package:flutter/material.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/core.dart';
import 'package:s_timesheet_mobile/home/identification/identification_bloc.dart';
import 'package:s_timesheet_mobile/utils/widget/semi_round_border_widget.dart';

class TabbarWithBorder extends StatelessWidget {
final QrAndLocationState state;
TabbarWithBorder(this.state);

@override
  Widget build(BuildContext context) {
   AppBloc appBloc=BlocProvider.of(context);

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
              appBloc.identificationBloc.qrAndLocationStream
                  .notify(
                QrAndLocationModel(
                    QrAndLocationState.QR),
              );
              appBloc.identificationBloc.stateQrAndLocation =
                  IdentificationState.QR;
            },
            child: state==QrAndLocationState.QR
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
                      "Mã QR",
                      style: TextStyle(
                        fontFamily: 'Roboto-Bold',
                        fontSize: 48.sp,
                        color: Color(0xff005a88),
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
                      "Mã QR",
                    style: TextStyle(
                      fontFamily: 'Roboto-Bold',
                      fontSize: 48.sp,
                      color: Color(0xff959ca7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ))),
        InkWell(
            onTap: () {
//              voidCallbackLocation();
              appBloc.identificationBloc.qrAndLocationStream
                  .notify(QrAndLocationModel(
                  QrAndLocationState.LOCATION));
              appBloc.identificationBloc.stateQrAndLocation =
                  IdentificationState.LOCATION;
            },
            child: state==QrAndLocationState.LOCATION
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
                      "Vị Trí",
                      style: TextStyle(
                        fontFamily: 'Roboto-Bold',
                        fontSize: 48.sp,
                        color: Color(0xff005a88),
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
                    "Vị trí",
                    style: TextStyle(
                      fontFamily: 'Roboto-Bold',
                      fontSize: 48.sp,
                      color: Color(0xff959ca7),
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
