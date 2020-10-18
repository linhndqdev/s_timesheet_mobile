import 'package:flutter/material.dart';
import 'package:flutter_screenutil/size_extension.dart';

class EventScreenNoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
    children: <Widget>[
      SizedBox(height: (155+87 - 19).h),
      Image.asset("asset/images/ic_event_nodata.png",width: 690.w, height: 597.h),
      SizedBox(height: 60.h),
      Text("Hiện chưa có sự kiện nào",style: TextStyle(
        color: Color(0xff959ca7),fontSize: 48.sp, fontFamily: "Roboto-Regular",height: 1.42
      )),
      Expanded(child: Container())
    ],
    );
  }
}
