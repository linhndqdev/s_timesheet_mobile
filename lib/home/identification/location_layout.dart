import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:core_asgl/core_asgl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/utils/animation/animation_open_qr_location.dart';
import 'package:s_timesheet_mobile/utils/animation/button_animation.dart';
import 'package:s_timesheet_mobile/utils/model/dialog_model.dart';
import 'package:s_timesheet_mobile/utils/widget/dialog_util.dart';
import '../../core/app_bloc.dart';
import '../../core/bloc_provider.dart';
import '../../home/home_bloc.dart';
import '../../home/identification/identification_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:camera/camera.dart';

class LocationLayout extends StatefulWidget {
  @override
  _LocationLayoutState createState() => _LocationLayoutState();
}

class _LocationLayoutState extends State<LocationLayout> {
  LocationData currentLocation;
  CameraDescription cameraDescription;
  AppBloc appBloc;

//  AnimationController controller;
  Timer _timerReloadLocation;

  void cancelTimer() {
    _timerReloadLocation?.cancel();
    _timerReloadLocation = null;
  }

  void startReloadLocation() {
    cancelTimer();
    _timerReloadLocation = Timer.periodic(Duration(seconds: 5), (timer) async {
      debugPrint("Reload location: ${DateTime.now().millisecondsSinceEpoch}");
      await _getLocation();
    });
  }

  Future<void> _getLocation() async {
    var location = new Location();
    try {
      currentLocation = await location.getLocation();

      appBloc.identificationBloc.myLocationStream.notify(MyLocation(
          currentLocation.latitude,
          currentLocation.longitude,
          MyLocationState.SHOW));
      debugPrint(currentLocation.toString());
    } catch (ex) {
      currentLocation = null;
      appBloc.identificationBloc.myLocationStream
          .notify(MyLocation(null, null, MyLocationState.NONE));
    } finally {
      startReloadLocation();
    }
  }

  @override
  void initState() {

    super.initState();
    BackStateBloc backStateBloc = BackStateBloc.getInstance();
    backStateBloc.setStateToOther(state: isFocusWidget.LOCATION);

    Future.delayed(Duration.zero, () {
       _getLocation();
    });
  }

  @override
  Future<void> dispose() async {
    currentLocation = null;
    cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = BlocProvider.of(context);

    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            appBloc.homeBloc.disableWithAnimation(() => appBloc
                .identificationBloc.indentificationStream
                .notify(IdentificationModel(IdentificationState.NONE, null)));
          },
          child: Container(
            color: Color(0xffa4aab3).withOpacity(0.7),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
        Positioned(
          bottom: 0,
          child: OpenAnimationQRandLocation(
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.w),
                    topRight: Radius.circular(30.w),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Color(0xfff3d09e), width: 2.w))),
                        width: MediaQuery.of(context).size.width,
                        height: 149.h,
                        padding: EdgeInsets.only(top: 55.h, bottom: 15.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("asset/images/ic_location_qr.png",
                                height: 59.9.w, width: 59.9.w),
                            SizedBox(
                              width: 24.9.w,
                            ),
                            Text(
                              "Vị Trí",
                              style: TextStyle(
                                  fontSize: 60.sp,
                                  fontFamily: 'Roboto-Bold',
                                  color: Color(0xffe18c12)),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0.h,
                        right: 0,
                        child: InkWell(
                            onTap: () {
                              appBloc.homeBloc.disableWithAnimation(() =>
                                  appBloc
                                      .identificationBloc.indentificationStream
                                      .notify(IdentificationModel(
                                          IdentificationState.NONE, null)));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                right: 0.0.w,
                                top: 50.0.h,
                                bottom: 59.h,
                              ),
                              height: 149.h,
                              width: 108.h,
                              child: Image.asset(
                                "asset/images/ic_cancel.png",
                                width: 40.w,
                                height: 40.w,
                              ),
                            )),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 52.h, bottom: 15.h),
                    child: Text(
                      "Sử dụng Vị trí để chấm công",
                      style: TextStyle(
                        fontFamily: 'Roboto-Bold',
                        fontSize: 48.sp,
                        color: Color(0xff333333),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 182.w, right: 180.w),
                    width: MediaQuery.of(context).size.width,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            'Vị trí trong thời gian làm việc của bạn theo quyền mà bạn cho phép ',
                        style: TextStyle(
                          fontSize: 42.0.sp,
                          color: Color(0xFF0333333),
                          fontFamily: "Roboto-Regular",
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '(Chi tiết)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 42.sp,
                              color: Color(0xFF005a88),
                              fontFamily: "Roboto-Bold",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  StreamBuilder(
                      initialData: MyLocation(null, null, MyLocationState.NONE),
                      stream:
                          appBloc.identificationBloc.myLocationStream.stream,
                      builder: (buildContext,
                          AsyncSnapshot<MyLocation> myLoacationSnapshot) {
                        if (myLoacationSnapshot.data.myLocationState ==
                            MyLocationState.SHOW) {
                          appBloc.identificationBloc.isAvairibleMyLocation =
                              true;
                          return Container(
                            margin: EdgeInsets.only(top: 15.h, bottom: 38.h),
                            height: 830.h,
                            width: 864.w,
                            child: GoogleMap(
                              zoomGesturesEnabled: true,
                              onMapCreated: (GoogleMapController controller) {},
                              initialCameraPosition: CameraPosition(
                                target: LatLng(currentLocation.latitude,
                                    currentLocation.longitude),
                                zoom: 20,
                              ),
                              myLocationButtonEnabled: true,
                              myLocationEnabled: true,
                            ),
                          );
                        }
                        else {
                          appBloc.identificationBloc.isAvairibleMyLocation =
                              false;
                          return Container(
                              height: 609.h,
                              width: 864.w,
                              child: Center(
                                child: Container(
                                  width: 100.w,
                                  height: 100.w,
                                  child: CircularProgressIndicator(),
                                ),
                              ));
                        }
                      }),
                  Text(
                    "Thông tin chi tiết vị trí",
                    style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        color: Color(0xff959ca7),
                        fontSize: 36.w),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 15.h, bottom: 59.h),
                    width: 600.w,
                    height: 120.h,
                    child: ButtonAnimation(
                      child: Container(
                          alignment: Alignment.center,
                          width: 600.w,
                          height: 120.h,
                          decoration: BoxDecoration(
                              color: Color(0xff005a88),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.w))),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                left: 236.w,
                                top: 36.w,
                                child: Text(
                                  "Chụp ảnh",
                                  style: TextStyle(
                                    fontFamily: "Roboto-Bold",
                                    fontSize: 52.sp,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 145.w,
                                top: 36.w,
                                child: Image.asset(
                                  "asset/images/ic_camera.png",
                                  width: 61.5.w,
                                  height: 50.w,
                                ),
                              )
                            ],
                          )),
                      width: 600,
                      height: 120,
                      color: 0xff005a88,
                      onClicked: (c) async {
                        openCamera(c);
                      },
                    ),
                  )
                ],
              ),
            ),
            voidCallback: (c) {
              appBloc.homeBloc.animationController = c;
            },
          ),
        )
      ],
    );
  }

  void openCamera(AnimationController controller) async {
    bool isCheckedCamera = await checkCameraPermission();
    controller?.reverse();
    if (!isCheckedCamera) {
      DialogUtil.showDialogProject(
        context,
        dialogModel: DialogModel(
          state: DialogType.INAPP,
          urlAssetImageLogo: "asset/images/ic_location_qr.png",
          colorIcon: 0xff005a88,
          title: "Cảnh báo",
          colorTitle: 0xff005a88,
          listRichText: [
            RichTextModel("Vui lòng cấp quyền sử dụng ", 0xff333333, 50,
                "Roboto-Regular"),
            RichTextModel("CAMERA ", 0xff333333, 50, "Roboto-Bold"),
            RichTextModel("và ", 0xff333333, 50, "Roboto-Regular"),
            RichTextModel("Microphone ", 0xff333333, 50, "Roboto-Bold"),
            RichTextModel("để tiếp tục sử dụng \"Chấm công Vị trí\"",
                0xff333333, 50, "Roboto-Regular"),
          ],
          voidCallbackButtonFirst: () {
            Navigator.of(context).pop();
          },
          titleButtonFirst: "Bỏ qua",
          colorButtonFirst: 0xff959ca7,
          voidCallbackButtonSecond: () {
            Navigator.of(context).pop();
            AppSettings.openAppSettings();
          },
          titleButtonSecond: "Cài đặt",
          colorButtonSecond: 0xff005a88,
        ),
      );
    } else {
      final cameras = await availableCameras();
      if (appBloc.identificationBloc.isAvairibleMyLocation) {
        if (cameras != null && cameras.length > 0) {
          if (cameras.length == 1)
            cameraDescription = cameras.first;
          else
            cameraDescription = cameras[1];
          appBloc.homeBloc.updateOtherLayout(OtherLayoutState.CAMERA,
              data: cameraDescription);
        } else {
          Toast.showShort("Thiết bị không hỗ trợ Camera");
        }
      } else {
        Toast.showShort(
            "Không tìm thấy vị trí của bạn. Vui lòng đợi trong giây lát hoặc khởi động lại ứng dụng.");
      }
    }
  }

  Future<bool> checkCameraPermission() async {
    try {
      permission.PermissionStatus cameraStatus;
      cameraStatus = await permission.Permission.camera.request();
      debugPrint(cameraStatus.toString());

      permission.PermissionStatus microPhoneStatus;
      microPhoneStatus = await permission.Permission.microphone.request();
      debugPrint(microPhoneStatus.toString());
      return cameraStatus == permission.PermissionStatus.granted &&
          microPhoneStatus == permission.PermissionStatus.granted;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
