import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:core_asgl/core_asgl.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/api_repo.dart';
import '../../core/qrcode_helper.dart';
import '../../home/identification/api_result_model.dart';
import 'package:intl/intl.dart';
import '../../utils/model/dialog_model.dart';
import '../../utils/widget/dialog_util.dart';

enum InOutState { IN, OUT }

class InOutModel {
  InOutState inOutState;

  InOutModel({this.inOutState});
}

class IdentificationBloc {
  String inOutModel = "";
  ApiRepo _apiRepo = ApiRepo();
  IdentificationState stateQrAndLocation = IdentificationState.QR;
  bool isAvairibleMyLocation = false;

  CoreStream<QrAndLocationModel> qrAndLocationStream = CoreStream();
  CoreStream<IdentificationModel> indentificationStream = CoreStream();
  CoreStream<MyLocation> myLocationStream = CoreStream();
  CoreStream<AttendanceModel> showNotifiStream = CoreStream();
  CoreStream<QrCodeStreamModel> showQrCodeStream = CoreStream();
  CoreStream<bool> statusFinishChamCongStream = CoreStream();
  CoreStream<Map<String, List<AttendanceModel>>> resultAttendanceStream =
      CoreStream();
  CoreStream<InOutModel> inoutStatusStream = CoreStream<InOutModel>();
  CoreStream<bool> showAndHideDialogSuccessConfirmStream = CoreStream();

  Map<String, List<AttendanceModel>> resultAttendance = Map();

  void showQrCodeGen(QrCodeStreamModel qrCodeStreamModel) async {
    showQrCodeStream?.notify(qrCodeStreamModel);
  }

  void updateTimeAttendanceLocation() {
    if (resultAttendance != null && resultAttendance.keys.length > 0) {
      resultAttendanceStream?.notify(resultAttendance);
    } else {
      resultAttendanceStream?.notify(null);
    }
  }

  Future<bool> checkLocation() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      PermissionStatus status;
      if (Platform.isIOS) {
        status = await Permission.locationWhenInUse.request();
      } else {
        status = await Permission.location.request();
      }
      debugPrint(status.toString());
      if (status != null && status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  void checkAndOpenTypeAttendance(BuildContext context, String type) async {
    if (stateQrAndLocation == IdentificationState.QR) {
      inoutStatusStream?.notify(InOutModel(
          inOutState: type == "int" ? InOutState.IN : InOutState.OUT));
      showQrCodeGen(QrCodeStreamModel(
          stateData:
              type == "in" ? QrCodeStateData.INPUT : QrCodeStateData.OUTPUT,
          qrCodeData: null));
    } else {
      bool isCheckLocationPermission = await checkLocation();
      if (!isCheckLocationPermission) {
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
              RichTextModel("Vị trí ", 0xff333333, 50, "Roboto-Bold"),
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
        inOutModel = type;
        indentificationStream
            .notify(IdentificationModel(IdentificationState.LOCATION, null));
      }
    }
  }

  ///Lấy ra lượt chấm công gần nhất của ngày hiện tại
  Future<void> getLatestDataAttendance() async {
    debugPrint("Here");
    DateTime currentTime = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    resultAttendance?.clear();
    await _apiRepo.getHistoryTimeAttendance(
        startTime: DateTime.now().subtract(Duration(days: 1)),
        endTime: currentTime,
        resultData: (data) {
          debugPrint("Latest: data: $data");
          if (data != null && data != "") {
            List<AttendanceModel> listData = (data as Iterable)
                .map((dataJson) => AttendanceModel.fromJson(dataJson))
                .toList();
            listData?.forEach((attendanceModel) {
              DateTime time = DateTime.parse(attendanceModel.check_at.date);
              String sTime = dateFormat.format(time);
              if (resultAttendance.containsKey(sTime) &&
                  resultAttendance[sTime].length > 0) {
                resultAttendance[sTime].add(attendanceModel);
              } else {
                resultAttendance[sTime] = [];
                resultAttendance[sTime].add(attendanceModel);
              }
            });
            updateTimeAttendanceLocation();
          }
        },
        onErrorApiCallBack: (onError) {
          updateTimeAttendanceLocation();
        });
  }

  ///Tắt QrCode và timer
  void disableQrCode() {
    showQrCodeStream?.notify(
        QrCodeStreamModel(stateData: QrCodeStateData.NONE, qrCodeData: ""));
  }

  bool isReloading = false;

  reloadData() async {
    if (!isReloading) {
      isReloading = true;
      await getLatestDataAttendance();
      Toast.showShort(
          "Đã cập nhật dữ liệu mới nhất");
      isReloading = false;
    } else {
      Toast.showShort(
          "Bạn đang bấm quá nhanh. Dữ liệu đang cập nhật. Vui lòng đợi");
    }
  }
}

enum QrAndLocationState { LOCATION, QR }

class QrAndLocationModel {
  QrAndLocationState state;

  QrAndLocationModel(this.state);
}

enum IdentificationState { QR, LOCATION, NONE }

class IdentificationModel {
  IdentificationState state;
  dynamic data;

  IdentificationModel(this.state, this.data);
}

class MyLocation {
  double latitude;
  double longitude;
  MyLocationState myLocationState;

  MyLocation(this.latitude, this.longitude, this.myLocationState);
}

enum MyLocationState { NONE, SHOW }

class QrCodeStreamModel {
  QrCodeStateData stateData;
  String qrCodeData;

  QrCodeStreamModel({@required this.stateData, @required this.qrCodeData});
}

enum AttendanceState {
  LOADING,
  SHOW,
}
