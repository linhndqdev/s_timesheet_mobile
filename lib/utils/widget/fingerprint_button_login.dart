import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:s_timesheet_mobile/core/style.dart' as prefix0;
import 'package:s_timesheet_mobile/utils/animation/button_animation.dart';

class FingerPrintButton extends StatefulWidget {
  final VoidCallback onTapButton;
  final bool isEnableButton;

  FingerPrintButton(this.onTapButton, this.isEnableButton);

  @override
  _FingerPrintButtonState createState() => _FingerPrintButtonState();
}

class _FingerPrintButtonState extends State<FingerPrintButton> {
  @override
  Widget build(BuildContext context) {
    return
      InkWell(
      onTap: () {
        widget.onTapButton();
      },
      child: Container(
        height: 129.0.h,
        width: 163.0.w,
        padding: EdgeInsets.only(
            left: 25.9.w, right: 26.8.w, top: 14.7.h, bottom: 15.h),
        decoration: BoxDecoration(
          color:prefix0.accentColor,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20.w),
              topRight: Radius.circular(20.w)),
        ),
        child: Center(
          child: Image.asset(
            "asset/images/ic_login_fingerprint.png",
            width: 110.3.w,
            height: 110.3.h,
          ),
        ),
      ),
    );
  }
}
