
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/core.dart';
import 'package:s_timesheet_mobile/utils/widget/custom_nav_widget.dart';

class BottomBarHome extends StatefulWidget {
  @override
  _BottomBarHomeState createState() => _BottomBarHomeState();
}

class _BottomBarHomeState extends State<BottomBarHome> {
  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = BlocProvider.of(context);
    return BottomAppBar(
        notchMargin: 18.0.w,
        elevation: 20.0,
//        color: prefix0.white,
        color: Color(0xfff7f7f7),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
            color: Color(0xff707070).withOpacity(0.2),
          ))),
          width: MediaQuery.of(context).size.width,
          height: 149.8.h,
          child: StreamBuilder(
              initialData: appBloc.homeBloc.bottomBarCurrentIndex,
              stream: appBloc.homeBloc.bottomBarStream.stream,
              builder: (buildContext, AsyncSnapshot<int> snapshotData) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: CustomNAVWidget(
                        ONCLICKITEM: () {
                          appBloc.homeBloc.checkAndOpenAppWithPackageName(
                              context,
                              "com.asgl.human_resource",
                              "sconnect");
                        },
                        ICONDATANORMAL: "asset/images/ic_message_deactive.png",
                        ICONDATASELECTED: "asset/images/ic_message_active.png",
                        ISSELECTED: snapshotData.data == 0,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: CustomNAVWidget(
                        ONCLICKITEM: () {
                          appBloc.homeBloc.clickItemBottomBar(1);
                        },
                        ICONDATANORMAL: "asset/images/ic_star_deactive.png",
                        ICONDATASELECTED: "asset/images/ic_star_active.png",
                        ISSELECTED: snapshotData.data == 1,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: CustomNAVWidget(
                        ONCLICKITEM: () {
                          appBloc.homeBloc.clickItemBottomBar(2);
                        },
                        ICONDATASELECTED: "asset/images/ic_calendar_active.png",
                        ICONDATANORMAL: "asset/images/ic_calendar_deactive.png",
                        ISSELECTED: snapshotData.data == 2,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: CustomNAVWidget(
                        ONCLICKITEM: () {
                          appBloc.homeBloc.clickItemBottomBar(3);
                        },
                        ICONDATASELECTED: "asset/images/ic_qr_active.png",
                        ICONDATANORMAL: "asset/images/ic_qr_deactive.png",
                        ISSELECTED: snapshotData.data == 3,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: CustomNAVWidget(
                        ONCLICKITEM: () {
                          appBloc.homeBloc.clickItemBottomBar(4);
                        },
                        ICONDATASELECTED: "asset/images/ic_diagram_active.png",
                        ICONDATANORMAL: "asset/images/ic_diagram_deactive.png",
                        ISSELECTED: snapshotData.data == 4,
                      ),
                    )
                  ],
                );
              }),
        ));
  }
}
