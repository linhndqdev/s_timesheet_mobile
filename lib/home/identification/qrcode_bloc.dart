import 'dart:async';
import 'dart:convert';

import 'package:core_asgl/core_asgl.dart';
import 'package:flutter/material.dart';
import 'package:s_timesheet_mobile/core/api_services.dart';
import 'package:s_timesheet_mobile/core/constant.dart';
import 'package:s_timesheet_mobile/core/qrcode_helper.dart';
import 'package:http/http.dart' as Http;

import 'identification_bloc.dart';

class QrCodeScreenBloc {
  Timer _timerRefreshQr;
  int countRefresh = 0;
  IdentificationBloc identificationBloc;
  CoreStream<String> qrImageDataStream = CoreStream();

  void cancelTimerRefresh() {
    _timerRefreshQr?.cancel();
    _timerRefreshQr = null;
  }

  Future<String> getCodeOnline(String data) async {
    debugPrint(data);
    Http.Response response = await Http.post(
        Constant.SERVER_WORK_SCHEDULE +
            "/api/internal/attendance/generate-qrcode",
        headers: {"x-api-key": "2273eq8182lpva08otgvrh6lo1r6epe3"},
        body: {"secret": "$data"}).then((res) {
      int statusCode = res?.statusCode ?? 400;
      if (statusCode == 200) {
        return res;
      } else {
        return null;
      }
    }).catchError((onError) {
      return null;
    }).timeout(Duration(seconds: TIME_OUT), onTimeout: () {
      return null;
    });
    if (response != null) {
      if (response.body != null && response.body != "") {
        try {
          dynamic data = json.decode(response.body);
          if (data['success']) {
            String result = data['data'];
            if (result != null && result != "") {
              return result;
            }
          }
          return null;
        } catch (ex) {
          return null;
        }
      } else {
        return null;
      }
    }
    return null;
  }

  //Khởi động timer refresh QrCode sau 5s
  void startTimerRefreshData(QrCodeStreamModel qrCodeStreamModel) async {

    _timerRefreshQr = Timer.periodic(Duration(seconds: 5), (time){
      countRefresh += 1;
      cancelTimerRefresh();
      if (countRefresh >4) {
        identificationBloc.showQrCodeGen(QrCodeStreamModel(
            stateData: QrCodeStateData.NONE, qrCodeData: null));
      } else {
        genQrCode(qrCodeStreamModel);
      }
    });
  }

  void showQrImage(String dataGen) {
    qrImageDataStream?.notify(dataGen);
  }

  void dispose() {
    cancelTimerRefresh();
  }

  Future<void> genQrCode(QrCodeStreamModel qrCodeStreamModel) async {
    showQrImage(null);
    debugPrint("$countRefresh");
    QrCodeHelper helper = QrCodeHelper();
    Map<dynamic, String> mapResult = await helper.genQrCodeInputData();
    String data = await getCodeOnline(
        qrCodeStreamModel.stateData == QrCodeStateData.INPUT
            ? mapResult[3]
            : mapResult[4]);
    if (data == null) {
      data = mapResult[qrCodeStreamModel.stateData];
    }
    showQrImage(data);
    startTimerRefreshData(qrCodeStreamModel);
  }
}
