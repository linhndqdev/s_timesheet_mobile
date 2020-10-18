import 'package:dio/dio.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:flutter/material.dart';
class BtnMenuWidget extends StatelessWidget {
  final VoidCallback onClick;

  BtnMenuWidget({this.onClick});
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {
        onClick();
      },
      child: Row(
        children: <Widget>[
          SizedBox(width: 34.5.w),
          Image.asset(
            'asset/images/ic_menu.png',
            width: 49.9.w,
          ),
          SizedBox(width: 40.5.w)
        ],
      ),
    );;
  }
}
