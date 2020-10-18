import 'package:core_asgl/animation/animation.dart';
import 'package:flutter/material.dart';
import 'package:s_timesheet_mobile/utils/widget/btn_menu_widget.dart';
import 'package:flutter_screenutil/size_extension.dart';

class CustomAppBar extends StatelessWidget {
  final VoidCallback callBackOpenMenu;
  final String title;

  const CustomAppBar({Key key, this.callBackOpenMenu, this.title = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TranslateHorizontal(
      startPosition: MediaQuery.of(context).size.width,
      child: AppBar(
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
        title: Column(
          children: <Widget>[
            SizedBox(height: 47.1.h),
            Row(
              children: <Widget>[
                BtnMenuWidget(onClick: callBackOpenMenu),
                if (title != null && title.trim() != "") ...{
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 50.sp,
                        color: Color(0xff005a88),
                        fontFamily: "Roboto-Bold"),
                  )
                }
                // Your widgets here
              ],
            ),
            SizedBox(height: 19.h),
          ],
        ),
        elevation: 0,
        backgroundColor: Color(0xffffffff),
      ),
    );
  }
}
