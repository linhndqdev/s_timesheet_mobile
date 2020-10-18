import 'package:camera/camera.dart';
import 'package:core_asgl/animation/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/core/style.dart';
import 'package:s_timesheet_mobile/utils/animation/button_animation.dart';
import 'package:s_timesheet_mobile/utils/widget/attendance_history_widget.dart';
import 'package:s_timesheet_mobile/utils/widget/custom_appbar.dart';
import '../../core/app_bloc.dart';
import '../../core/bloc_provider.dart';
import '../../core/qrcode_helper.dart';
import '../../home/identification/api_result_model.dart';
import '../../home/identification/identification_bloc.dart';
import '../../home/identification/qrcode_screen.dart';
import '../../home/identification/location_layout.dart';
import '../../utils/widget/tab_bar_with_border.dart';
import '../home_bloc.dart';

class IdentificationScreen extends StatefulWidget {
  final VoidCallback callBackOpenMenu;

  const IdentificationScreen({Key key, this.callBackOpenMenu})
      : super(key: key);

  @override
  _IdentificationScreenState createState() => _IdentificationScreenState();
}

class _IdentificationScreenState extends State<IdentificationScreen> {
  AppBloc appBloc;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      appBloc.identificationBloc.getLatestDataAttendance();
    });
    BackStateBloc backStateBloc = BackStateBloc.getInstance();
    backStateBloc.setStateToHome();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = BlocProvider.of(context);
    appBloc.identificationBloc.disableQrCode();
    appBloc.identificationBloc.indentificationStream
        ?.notify(IdentificationModel(IdentificationState.NONE, null));

    return WillPopScope(
      onWillPop: () async {
        if (appBloc.backStateBloc.focusWidgetModel.state ==
            isFocusWidget.LOCATION) {
          hideChildWidget(isLocation: true);
        } else if (appBloc.backStateBloc.focusWidgetModel.state ==
            isFocusWidget.QR) {
          hideChildWidget(isLocation: false);
        } else if (appBloc.backStateBloc.focusWidgetModel.state ==
            isFocusWidget.OPEN_CAMERA) {
//          SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
          appBloc.homeBloc.updateOtherLayout(OtherLayoutState.NONE);
          appBloc.backStateBloc.setStateToOther(state: isFocusWidget.LOCATION);
        } else if (appBloc.backStateBloc.focusWidgetModel.state ==
            isFocusWidget.PREVIEW_PICTURE) {
          SystemChrome.setEnabledSystemUIOverlays([]);
          CameraDescription cameraDescription;
          final cameras = await availableCameras();
          if (cameras != null && cameras.length > 0) {
            if (cameras.length == 1)
              cameraDescription = cameras.first;
            else
              cameraDescription = cameras[1];
            appBloc.homeBloc.updateOtherLayout(OtherLayoutState.CAMERA,
                data: cameraDescription);
          }
          appBloc.backStateBloc
              .setStateToOther(state: isFocusWidget.OPEN_CAMERA);
        } else {
          return true;
        }
        return false;
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Color(0xffffffff),
            appBar: PreferredSize(
              preferredSize:
                  Size(MediaQuery.of(context).size.width, 66.h + 47.1.h + 19.h),
              child: CustomAppBar(
                callBackOpenMenu: () => widget.callBackOpenMenu(),
                title: "Chấm công",
              ),
            ),
            body: TranslateVertical(
              startPosition: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder(
                        initialData: QrAndLocationModel(QrAndLocationState.QR),
                        stream: appBloc
                            .identificationBloc.qrAndLocationStream.stream,
                        builder: (buildContext,
                            AsyncSnapshot<QrAndLocationModel> snapshotQR) {
                          if (snapshotQR.data.state == QrAndLocationState.QR ||
                              snapshotQR.data.state ==
                                  QrAndLocationState.LOCATION) {
                            return TabbarWithBorder(snapshotQR.data.state);
                          } else {
                            return Container();
                          }
                        }),
                  ),
                  StreamBuilder(
                      initialData: QrAndLocationModel(QrAndLocationState.QR),
                      stream:
                          appBloc.identificationBloc.qrAndLocationStream.stream,
                      builder: (buildContext,
                          AsyncSnapshot<QrAndLocationModel> snapshotQR) {
                        if (snapshotQR.data.state == QrAndLocationState.QR) {
                          return qrAndLocation(
                            title: "Sử dụng mã QR để chấm công",
                          ); //ra ca
                        } else {
                          return qrAndLocation(
                            title: "Sử dụng vị trí để chấm công",
                          );
                        }
                      }),
                  SizedBox(
                    height: 11.h,
                  ),
                  Text(
                    "Vui lòng lựa chọn tính chất chấm công",
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontFamily: 'Roboto-Medium',
                      color: Color(0xff3333333),
                    ),
                  ),
                  Text(
                    "Vào ra",
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontFamily: 'Roboto-Bold',
                      color: Color(0xff3333333),
                    ),
                  ),
                  SizedBox(
                    height: 56.0.h,
                  ),
                  buttonInOut(
                      voidCallback: () => appBloc.identificationBloc
                          .checkAndOpenTypeAttendance(context, "in"),
                      title: "Vào ca",
                      color: 0xff005a88,
                      imageAsset: "asset/images/ic_in_shift.png"),
                  SizedBox(
                    height: 85.0.h,
                  ),
                  buttonInOut(
                      voidCallback: () => appBloc.identificationBloc
                          .checkAndOpenTypeAttendance(context, "out"),
                      title: "Ra ca",
                      color: 0xffe18c12,
                      imageAsset: "asset/images/ic_out_shift.png"),
                  Container(
                    margin: EdgeInsets.only(top: 91.5.h),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0xffe7e7e7), width: 2.h))),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      initialData: appBloc.identificationBloc.resultAttendance,
                      stream: appBloc
                          .identificationBloc.resultAttendanceStream.stream,
                      builder: (buildResultContext,
                          AsyncSnapshot<Map<String, List<AttendanceModel>>>
                              snapshotData) {
                        if (!snapshotData.hasData ||
                            snapshotData.data == null) {
                          return Container(
                            child: Text(
                              "Chưa có lịch sử chấm công",
                              style: TextStyle(
                                  color: blackColor,
                                  fontFamily: "Roboto",
                                  fontSize: 50.0.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                          );
                        }
                        return _buildLayoutDataResult(snapshotData.data);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          StreamBuilder(
              initialData: IdentificationModel(IdentificationState.NONE, null),
              stream: appBloc.identificationBloc.indentificationStream.stream,
              builder:
                  (buildContext, AsyncSnapshot<IdentificationModel> snapshot) {
                switch (snapshot.data.state) {
                  case IdentificationState.LOCATION:
                    return LocationLayout();
                    break;
                  case IdentificationState.QR:
                    return Container();
                    break;
                  case IdentificationState.NONE:
                    return Container();
                    break;
                  default:
                    return Container();
                    break;
                }
              }),
          StreamBuilder(
              initialData: false,
              stream: appBloc.identificationBloc
                  .showAndHideDialogSuccessConfirmStream.stream,
              builder: (buildContext, snapshot) {
                if (snapshot.data) {
                  return InkWell(
                    onTap: () {
                      appBloc.identificationBloc
                          .showAndHideDialogSuccessConfirmStream
                          .notify(false);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Color(0xff959ca7).withOpacity(0.85),
                      child: Center(
                        child: Container(
                          width: 1012.w,
                          height: 360.h,
                          padding: EdgeInsets.only(
                            left: 61.w,
                            right: 61.w,
                            top: 71.h,
                            bottom: 96.h,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.w),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 90, 136, 0.2),
                                    blurRadius: 10.w,
                                    spreadRadius: 0)
                              ]),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "asset/images/ic_success_dialog.png",
                                width: 95.w,
                                height: 95.w,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 23.h,
                                ),
                                child: Text('Ghi nhận thành công',
                                    style: TextStyle(
                                        color: Color(0xFF00b54e),
                                        fontFamily: 'Roboto-Regular',
                                        fontSize: 52.0.sp,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal)),
                              )
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
          StreamBuilder<QrCodeStreamModel>(
              initialData: QrCodeStreamModel(
                  stateData: QrCodeStateData.NONE, qrCodeData: ""),
              stream: appBloc.identificationBloc.showQrCodeStream.stream,
              builder: (buildContext,
                  AsyncSnapshot<QrCodeStreamModel> qrCodeSnapshot) {
                if (qrCodeSnapshot.data.stateData == QrCodeStateData.NONE) {
                  return Container();
                }
                return QrCodeScreen(
                  qrStreamModel: qrCodeSnapshot.data,
                  identificationBloc: appBloc.identificationBloc,
                );
              })
        ],
      ),
    );
  }

  Widget qrAndLocation(
      {String title,
      VoidCallback voidCallBackOut,
      VoidCallback voidCallBackIn}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(bottom: 0.h, top: 61.h),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 48.sp,
              fontFamily: 'Roboto-Bold',
              color: Color(0xff3333333),
            ),
          ),
        ],
      ),
    );
  }

  _buildLayoutDataResult(Map<String, List<AttendanceModel>> mapResultData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xfff7dfbf)))),
          padding:
              EdgeInsets.only(left: 25.w, right: 25.w, bottom: 21.h, top: 48.h),
          margin: EdgeInsets.only(left: 34.w, right: 34.w),
          child: Row(
            children: <Widget>[
              Image.asset("asset/images/ic_calendar_star.png",
                  width: 60.w, height: 60.w),
              SizedBox(
                width: 25.w,
              ),
              Text(
                "Lượt chấm công gần nhất",
                style: TextStyle(
                    fontFamily: 'Roboto-Medium',
                    fontSize: 48.sp,
                    color: Color(0xff333333)),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    child: Icon(
                      Icons.sync,
                      color: Colors.grey[400],
                    ),
                    onTap: () => appBloc.identificationBloc.reloadData(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: AttendanceHistoryWidget(
            dataModel: mapResultData,
          ),
        )
      ],
    );
  }

  Widget buttonInOut(
      {VoidCallback voidCallback, String title, int color, String imageAsset}) {
    return ButtonAnimation(
      child: InkWell(
        child: Container(
            decoration: BoxDecoration(
                color: Color(color),
                borderRadius: BorderRadius.all(Radius.circular(20.0.w))),
            width: 600.w,
            height: 120.h,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 179.w,
                  top: 35.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(imageAsset, width: 40.w, height: 50.h),
                      SizedBox(width: 30.w),
                      Text(
                        title,
                        style: TextStyle(
                            fontFamily: 'Roboto-Bold',
                            fontSize: 56.sp,
                            color: Color(0xffffffff)),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
      width: 600.0.w,
      height: 120.0.h,
      color: color,
      onClicked: (c) {
        c?.reverse();
        voidCallback();
      },
    );
  }

  hideChildWidget({bool isLocation = false}) {
    if (isLocation)
      appBloc.homeBloc.disableWithAnimation(() => appBloc
          .identificationBloc.indentificationStream
          .notify(IdentificationModel(IdentificationState.NONE, null)));
    else
      appBloc.homeBloc.disableWithAnimation(() {
        appBloc.identificationBloc.showQrCodeGen(
            QrCodeStreamModel(stateData: QrCodeStateData.NONE, qrCodeData: ""));
      });
    appBloc.backStateBloc.setStateToHome();
  }
}
