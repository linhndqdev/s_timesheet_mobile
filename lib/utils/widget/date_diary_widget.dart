import 'package:flutter/material.dart';
import 'package:flutter_screenutil/size_extension.dart';

class DateDiaryWidget extends StatefulWidget {
  final String date;
  final VoidCallback voidCallback;

  DateDiaryWidget({this.date, this.voidCallback});

  @override
  _DateDiaryWidgetState createState() => _DateDiaryWidgetState();
}

class _DateDiaryWidgetState extends State<DateDiaryWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.voidCallback();
      },
      child:Container(
        margin: EdgeInsets.only(
          right: 34.w,
          left: 34.w
        ),
        width: MediaQuery.of(context).size.width,
        height: 138.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 25.0.w),
              child: Image.asset(
                'asset/images/ic_calendar_statistic.png',
                width: 60.0.w,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 25.0.w),
              child: Text(
                widget.date,
                style: TextStyle(
                  fontFamily: 'Roboto-Bold',
                  fontSize: 52.sp,
                  color: Color(0xffe18c12),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(),
              child: Image.asset(
                'asset/images/ic_dropdown.png',
                width: 35.0.w,
              ),
            )
          ],
        ),
      )
    );
  }
}
