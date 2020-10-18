import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:s_timesheet_mobile/core/style.dart' as prefix0;
import 'package:s_timesheet_mobile/utils/animation/bottom_bar_animation.dart';

typedef OnClickItem = Function();

class CustomNAVWidget extends StatelessWidget {
  final OnClickItem ONCLICKITEM;
  final bool ISSELECTED;
  final String ICONDATASELECTED;
  final String ICONDATANORMAL;

  const CustomNAVWidget(
      {Key key,
      @required this.ONCLICKITEM,
      this.ISSELECTED,
      this.ICONDATASELECTED,
      this.ICONDATANORMAL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ISSELECTED? BottomBarAnimation(_buildChild()):_buildChild();
  }

  _buildChild() {
    return Container(
      child: Center(
        child: InkWell(
            onTap: () {
              ONCLICKITEM();
            },
            child: Container(
              width: 200,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    ISSELECTED ? ICONDATASELECTED : ICONDATANORMAL,
                    fit: BoxFit.contain,
                    width: ScreenUtil().setWidth(70.0),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
