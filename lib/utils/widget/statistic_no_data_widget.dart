import 'package:flutter/material.dart';
import 'package:flutter_screenutil/size_extension.dart';

class StatisticNoDataWidget extends StatelessWidget {
  final String content;

  StatisticNoDataWidget(this.content);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Color(0xfff0c88f),
                  width: 2.w
              )
          )
      ),
      margin: EdgeInsets.only(
        left: 34.w,
        right: 34.w,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 155.h),
            child: Image.asset(
              'asset/images/img_Statistic.png',
              width: 690.0.w,
              height: 431.6.h,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 87.4.h),
            child: Text(
              content,
              style: TextStyle(
                fontFamily: 'Roboto-Regular',
                fontSize: 48.sp,
                color: Color(0xff959ca7),
              ),
            ),
          )
        ],
      ),
    );
  }
}
