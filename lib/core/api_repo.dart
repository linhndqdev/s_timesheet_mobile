import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:dio/dio.dart' as Dio;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as PathLib;
import 'package:http_parser/http_parser.dart';
import 'package:s_timesheet_mobile/core/constant.dart';
import 'package:s_timesheet_mobile/utils/cache/share_prefer_utils.dart';

typedef OnResultData = Function(dynamic);
typedef OnErrorApiCallBack = Function(dynamic);

class ApiRepo {
  Future<void> sendFileAttachment(String baseUrl, String endPoint,
      {@required String roomID, @required String path}) async {
    File file = File(path);
    String fileName = PathLib.basename(file.path);
    String extension = PathLib.extension(file.path).replaceAll(".", "");
    String type;
    String subType;
    if (extension == "txt") {
      type = 'text';
      subType = 'plain';
    } else {
      type = 'application';
    }

    Dio.FormData formData = new Dio.FormData.fromMap({
      "file": new Dio.MultipartFile.fromBytes(file.readAsBytesSync(),
          filename: fileName, contentType: MediaType(type, subType))
    });

    var resultResponse = await Dio.Dio().post("$baseUrl$endPoint$roomID",
        data: formData,
        options: Dio.Options(headers: {
          'X-Auth-Token': "",
          'X-User-Id': "",
        }, sendTimeout: 10, receiveTimeout: 10),
        onReceiveProgress: (count, total) {
      print("Count: $count");
      print("Total: $total");
    }, onSendProgress: (count, total) {
      print("Count: $count");
      print("Total: $total");
    }).catchError((onError) {
      if (onError is Dio.DioError) {
        if (onError.error.toString().contains("Broken pipe")) {
        } else if (onError.error.toString().contains("SocketException")) {
        } else {}
      } else {}
    });
    if (resultResponse != null) {}
  }

  Future<void> getHistoryTimeAttendance(
      {DateTime startTime,
      DateTime endTime,
      OnResultData resultData,
      OnErrorApiCallBack onErrorApiCallBack}) async {
    String jwt = await SharePreferUtils.getAccessToken();
    Map<String, String> header = {"Authorization": "Bearer $jwt"};
    Map<String, String> params = {
      "start": DateFormat('yyyy-MM-dd').format(startTime),
      "end": DateFormat('yyyy-MM-dd').format(endTime),
      "filter": "false"
    };

    Uri uri = Uri.http(Constant.SERVER_WORK_SCHEDULE_NO_HTTP,
        "/api/staff/attendances", params);
    Http.Response response =
        await Http.get(uri, headers: header).then((response) {
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        return response;
      } else {
        onErrorApiCallBack("");
        return null;
      }
    }).catchError((onError) {
      onErrorApiCallBack("");
      return null;
    }).timeout(Duration(seconds: 20), onTimeout: () {
      onErrorApiCallBack("");
      return null;
    });
    if (response != null) {
      try {
        dynamic data = json.decode(response.body);
        if (data != null && data != "") {
          resultData(data['data']['attendances']);
        } else {
          onErrorApiCallBack("");
        }
      } catch (ex) {
        onErrorApiCallBack("");
      }
    }
  }

  Future<void> sendImage_Location(
      {String type,
      double latitude,
      double longitude,
      String iPath,
      OnResultData resultData,
      OnErrorApiCallBack onErrorApiCallBack}) async {
    String jwt = await SharePreferUtils.getAccessToken();
    File file = File(iPath);
    String fileName = PathLib.basename(file.path);
    String extension = PathLib.extension(file.path).replaceAll(".", "");
    Dio.FormData formData = new Dio.FormData.fromMap({
      "type": type,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "image": Dio.MultipartFile.fromBytes(file.readAsBytesSync(),
          filename: fileName, contentType: MediaType("image", extension))
    });
    var resultResponse = await Dio.Dio().post(
        Constant.SERVER_WORK_SCHEDULE + "/api/staff/attendance",
        data: formData,
        options: Dio.Options(
            headers: {"Authorization": "Bearer $jwt"},
            followRedirects: false), onSendProgress: (count, total) {
      if (Platform.isAndroid) {
        int percent = 0;
        if (total == 0) {
          percent = 1;
        } else {
          percent = ((count / total) * 100).round();
          if (percent < 1) {
            percent = 1;
          } else if (percent == 100) {
            percent = 99;
          }
        }
      }
    }).then((resultResponse) {
      if (resultResponse != null) {
        print(resultResponse.data['success'].toString());
        if (resultResponse.data['success'].toString() == "true") {
          return resultResponse;
        } else {
          print("Tải ảnh thất bại.");
          return null;
        }
      }
      return null;
    }).catchError((onError) {
      onErrorApiCallBack(onError);
    });
    if (resultResponse != null) {
      if (resultResponse.data['success'].toString() == "true") {
        resultData(resultResponse);
      } else {
        onErrorApiCallBack("");
      }
    }
  }

  Future<void> getList(
      {DateTime startTime,
      DateTime endTime,
      OnResultData resultData,
      OnErrorApiCallBack onErrorApiCallBack}) async {
    String jwt = await SharePreferUtils.getAccessToken();
    Map<String, String> header = {
      //dùng token tài khoản của Bình
      "Authorization": "Bearer $jwt"
    };
    Map<String, String> params = {
      "start": DateFormat('yyyy-MM-dd').format(startTime),
      "end": DateFormat('yyyy-MM-dd').format(endTime),
      "filter": "true"
    };

    Uri uri = Uri.http(Constant.SERVER_WORK_SCHEDULE_NO_HTTP,
        "/api/staff/attendances", params);
    Http.Response response =
        await Http.get(uri, headers: header).then((response) {
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        return response;
      } else {
        onErrorApiCallBack("");
        return null;
      }
    }).catchError((onError) {
      onErrorApiCallBack("");
      return null;
    }).timeout(Duration(seconds: 20), onTimeout: () {
      onErrorApiCallBack("");
      return null;
    });
    if (response != null) {
      try {
        dynamic data = json.decode(response.body);
        if (data != null && data != "") {
          resultData(data['data']['attendances']);
        } else {
          onErrorApiCallBack("");
        }
      } catch (ex) {
        onErrorApiCallBack("");
      }
    }
  }
}
