import 'package:flutter/services.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/core/style.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:s_timesheet_mobile/auth/login_screen.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/bloc_provider.dart';
import 'package:s_timesheet_mobile/home/calendar_working/calendar_work_screen.dart';
import 'package:s_timesheet_mobile/home/event/event_screen.dart';
import 'package:s_timesheet_mobile/home/home_bloc.dart';
import 'package:s_timesheet_mobile/home/home_index_stack_model.dart';
import 'package:s_timesheet_mobile/home/identification/camera_screen.dart';
import 'package:s_timesheet_mobile/home/identification/display_picture_screen.dart';
import 'package:s_timesheet_mobile/home/identification/identification_sceen.dart';
import 'package:s_timesheet_mobile/home/statistic/statistic_screen.dart';
import 'package:s_timesheet_mobile/utils/bottombar_home_widget.dart';
import 'package:s_timesheet_mobile/utils/cache/share_prefer_utils.dart';
import 'package:s_timesheet_mobile/utils/model/dialog_model.dart';
import 'package:s_timesheet_mobile/utils/widget/dialog_util.dart';
import 'package:s_timesheet_mobile/utils/widget/drawer_widget.dart';
import 'package:s_timesheet_mobile/utils/widget/loadding_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  AppBloc appBloc;

  @override
  void initState() {

    BackStateBloc  backStateBloc = BackStateBloc.getInstance();
    backStateBloc.setStateToHome();
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      appBloc.authBloc.fullNameDrawer = await SharePreferUtils.getFullName();
      appBloc.authBloc.idDrawer = await SharePreferUtils.getID();
      appBloc.authBloc.userNameDrawer = await SharePreferUtils.getUserName();
    });
  }

  @override
  Widget build(BuildContext context) {
    appBloc = BlocProvider.of(context);
    //appBloc.backStateBloc.setStateToHome();
    return Scaffold(
        body: Stack(
      children: <Widget>[
        WillPopScope(
          onWillPop: () async {
            if (appBloc.backStateBloc.focusWidgetModel.state !=
                isFocusWidget.HOME) {
              //CHỖ NÀY SẼ HỨNG ĐẦU TIÊN, SAU ĐÓ MỚI ĐẾN CÁC HÀM OnWillPop bên trong, nên cần phải check để tránh đóng app
              return true;
            } else {
              appBloc.authBloc.requestExitApplicationNotLogout(context);
              return null;
            }
          },
          child: Scaffold(
              key: scaffoldKey,
              drawer: DrawerScreen(
                appBloc: appBloc,
                onExitApplication: () {
                  _requestExitApplication();
                },
              ),
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: BottomBarHome(),
              body: StreamBuilder(
                initialData: HomeIndexStackModel(
                    indexStack: appBloc.homeBloc.indexStackHome),
                stream: appBloc.homeBloc.homeIndexStackStream.stream,
                builder:
                    (context, AsyncSnapshot<HomeIndexStackModel> snapshot) {
                  int indexStack = (!snapshot.hasData || snapshot.data == null)
                      ? 2
                      : snapshot.data.indexStack;
                  return IndexedStack(
                    index: indexStack,
                    children: <Widget>[
                      Container(),
                      EventScreen(
                          callBackOpenMenu: () =>
                              scaffoldKey?.currentState?.openDrawer()),
                      CalendarWorkingScreen(
                          callBackOpenMenu: () =>
                              scaffoldKey?.currentState?.openDrawer()),
                      IdentificationScreen(
                          callBackOpenMenu: () =>
                              scaffoldKey?.currentState?.openDrawer()),
                      StatisticScreen(
                          callBackOpenMenu: () =>
                              scaffoldKey?.currentState?.openDrawer())
                    ],
                  );
                },
              )),
        ),
        StreamBuilder(
            initialData: false,
            stream: appBloc.homeBloc.loadingStream.stream,
            builder: (buildContext, AsyncSnapshot<bool> snapshotData) {
              return Visibility(
                child: Loading(),
                visible: snapshotData.data,
              );
            }),
        StreamBuilder(
            initialData: false,
            stream:
                appBloc.identificationBloc.statusFinishChamCongStream.stream,
            builder: (buildContext, snapshot) {
              if (snapshot.data) {
                return Container(
                  color: Color(0xff959ca7).withOpacity(0.85),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        appBloc.identificationBloc.statusFinishChamCongStream
                            .notify(false);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 34.w, right: 34.w),
//                      width: ScreenUtil().setWidth(889.0),
                        height: ScreenUtil().setHeight(360.3),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.w),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.16),
                                  blurRadius: 6.h,
                                  spreadRadius: 0)
                            ]),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 71.h),
                            Image.asset("asset/images/ic_success_dialog.png",
                                width: 95.w, height: 95.h),
                            SizedBox(height: 23.h),
                            Container(
                              child: Text('Ghi nhận thành công',
                                  style: TextStyle(
                                      color: Color(0xFF00b54e),
                                      fontFamily: 'Roboto-Regular',
                                      fontSize: 52.0.sp,
                                      height: 1.31)),
                            ),
                            Expanded(child: Container())
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            }),
        StreamBuilder(
            initialData: OtherLayoutModelStream(OtherLayoutState.NONE, null),
            stream: appBloc.homeBloc.showOtherLayoutStream.stream,
            builder: (buildContext,
                AsyncSnapshot<OtherLayoutModelStream> showLargeImage) {
              switch (showLargeImage.data.state) {
                case OtherLayoutState.CAMERA:
                  //CameraDescription cameraDescription;

                  return TakePictureScreen(showLargeImage.data.data, "");
                case OtherLayoutState.NONE:
                  return Container();
                case OtherLayoutState.PREVIEW_IMAGE:
                  return DisplayPictureScreen(showLargeImage.data.data, 0, 0);
//                  return Container();

                  break;
                default:
                  return Container();
              }
            })
      ],
    ));
  }

  void _requestExitApplication() {
    DialogUtil.showDialogProject(context,
        dialogModel: DialogModel(
            state: DialogType.AUTH,
            title: "Đăng Xuất",
            colorTitle: 0xffe10606,
            fontSizeTitle: 60,
            listRichText: [
              RichTextModel(
                  "Bạn có chắc muốn ", 0xff333333, 50, "Roboto-Regular"),
              RichTextModel("đăng xuất", 0xff005a88, 50, "Roboto-Bold"),
              RichTextModel(" không?", 0xff333333, 50, "Roboto-Regular"),
            ],
            marginRichText: EdgeInsets.only(
              bottom: 80.5.h,
              top: 34.0.h,
              left: 120.w,
              right: 120.w,
            ),
            titleButtonFirst: "Hủy",
            colorButtonFirst: 0xff959ca7,
            voidCallbackButtonFirst: () {
              Navigator.pop(context);
            },
            titleButtonSecond: "Có",
            colorButtonSecond: 0xff005a88,
            voidCallbackButtonSecond: () {
              Navigator.pop(context);
              appBloc.authBloc.logOut(context);
            }));
  }
}
