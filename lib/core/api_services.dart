import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:s_timesheet_mobile/core/constant.dart';
import 'package:s_timesheet_mobile/utils/cache/share_prefer_utils.dart';

import 'package:http/http.dart' as Http;

///Ngày khởi tạo: [Thứ bảy, 08-02-2020]
///Người tạo [Nguyễn Hữu Bình]

///[ErrorType] => return type of error if call api failed
///[ErrorType.JWT_FOUND] => Không có JWT
///[ErrorType.TIME_OUT] => Hết thời gian chờ kết quả: 12s
///[ErrorType.RESPONSE_STATUS_FAILED] => Response status code != 200
///[ErrorType.CONNECTION_ERROR] => Kết nối trả về lỗi có SocketException
///[ErrorType.OTHER_ERROR] => Các lỗi khác có thể xảy ra
///[ErrorType.RESPONSE_BODY_NULL] => Request thành công nhưng không có body data
///[ErrorType.DATA_ERROR] =>Lỗi nếu status != true && code !="00"
///[ErrorType.CONVERT_DATA_ERROR] =>Lỗi nếu convert dữ liệu từ json -> model bị lỗi

enum ErrorType {
  JWT_FOUND,
  TIME_OUT,
  RESPONSE_STATUS_FAILED,
  CONNECTION_ERROR,
  OTHER_ERROR,
  RESPONSE_BODY_NULL,
  DATA_ERROR,
  CONVERT_DATA_ERROR,
  UNAUTHORIZED
}

typedef OnErrorApiCallback<T> = Function(T);
typedef OnResultData<T> = Function(T);

const int TIME_OUT = 60;

class ApiServices {
  ///[_getError] => Trả về nội dung của lỗi nếu có trong respone nhận được từ server
  ///[data] => Json được convert từ response.body
  String _getError(Map<String, dynamic> data) {
    String message = "";
    if (data['errors'] != null && data['errors'] != "") {
      message = data['errors'];
    } else if (data['message'] != null && data['message'] != "") {
      message = data['message'];
    }
    return message;
  }

  Future<void> getAccountInfo(
      {OnResultData onResultData,
      OnErrorApiCallback onErrorApiCallback}) async {
    String jwt = await SharePreferUtils.getAccessToken();
    Http.Response response =
        await Http.get(Constant.SERVER_BASE + "/parent/me", headers: {
      'Authorization': 'Bearer ' + jwt,
    }).then((Http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        onErrorApiCallback(ErrorModel(
            errorType: ErrorType.RESPONSE_STATUS_FAILED,
            errorMessage: "",
            isUsedTryIt: false));
        return null;
      } else {
        return response;
      }
    }).catchError((onError) {
      if (onError.toString().contains("SocketException")) {
        onErrorApiCallback(ErrorModel(
            errorType: ErrorType.CONNECTION_ERROR, isUsedTryIt: false));
      }
      return null;
    }).timeout(Duration(seconds: TIME_OUT), onTimeout: () {
      onErrorApiCallback(
          ErrorModel(errorType: ErrorType.TIME_OUT, isUsedTryIt: false));
      return null;
    });
    if (response != null) {
      if (response.body != null && response.body != "") {
        dynamic data = json.decode(response.body);
        if (data != null && data != "") {
          if (data['status']?.toString() == "true" && data['code'] == "00") {
            try {
              onResultData(data['data']['data']);
            } catch (ex) {
              onErrorApiCallback(ErrorModel(
                  errorType: ErrorType.CONVERT_DATA_ERROR,
                  errorMessage: "",
                  isUsedTryIt: false));
            }
          } else {
            String message = _getError(data);
            onErrorApiCallback(ErrorModel(
                errorType: ErrorType.DATA_ERROR,
                errorMessage: message,
                isUsedTryIt: false));
          }
        } else {
          onErrorApiCallback(ErrorModel(
              errorType: ErrorType.RESPONSE_BODY_NULL,
              errorMessage: "",
              isUsedTryIt: false));
        }
      }
    }
  }

  Future<void> createPostNoJWT(
      {String account,
      OnResultData onResultData,
      OnErrorApiCallback onErrorApiCallback}) async {
    Http.Response response = await Http.post(
        Constant.SERVER_BASE + "/api/auth/password/email",
        body: {"login": "$account"}).then((response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        if (statusCode == 401) {
          onErrorApiCallback(ErrorModel.unAuthorized);
        } else if (statusCode == 403) {
          onErrorApiCallback(ErrorModel.banned);
        } else if (statusCode == 405) {
          onErrorApiCallback(ErrorModel.unAuthorized);
        } else {
          onErrorApiCallback(ErrorModel.unAuthorized);
        }
        return null;
      } else {
        return response;
      }
    }).catchError((onError) {
      if (onError.toString().contains("SocketException")) {
        onErrorApiCallback(ErrorModel.netError);
      }
      return null;
    }).timeout(Duration(seconds: TIME_OUT), onTimeout: () {
      onErrorApiCallback(ErrorModel.netError);
      return null;
    });
    if (response != null && response.body != null) {
      dynamic data = jsonDecode(response.body.toString());
      if (data['success'] != null && data['success'].toString() == 'true') {
        onResultData(data);
      } else {
        onErrorApiCallback(ErrorModel.userInvailid);
      }
    }
  }

  Future<void> loginASGL(
      {String account,
      String password,
      OnResultData onResultData,
      OnErrorApiCallback onErrorApiCallback}) async {
    Http.Response response =
        await Http.post(Constant.SERVER_BASE + "/api/auth/login", body: {
      "login": "$account",
      "password": "$password",
    }).then((response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        if (statusCode == 401) {
          onErrorApiCallback(ErrorModel.unAuthorized);
        } else if (statusCode == 403) {
          onErrorApiCallback(ErrorModel.banned);
        } else {
          onErrorApiCallback(ErrorModel.unAuthorized);
        }
        return null;
      } else {
        return response;
      }
    }).catchError((onError) {
      if (onError.toString().contains("SocketException")) {
        onErrorApiCallback(ErrorModel.netError);
      }
      return null;
    }).timeout(Duration(seconds: TIME_OUT), onTimeout: () {
      onErrorApiCallback(ErrorModel.netError);
      return null;
    });
    if (response != null && response.body != null) {
      dynamic data = jsonDecode(response.body.toString());
      if (data['success'] != null && data['success'].toString() == 'true') {
        onResultData(data);
      }
    }
  }
}

///[errorType] == [ErrorType.DATA_ERROR] => [errorType] có dữ liệu trả về
///Các trường hợp [errorMessage] = ""
class ErrorModel {
  ErrorType errorType;
  String errorMessage;
  bool isUsedTryIt;
  final String _netErrorHasTryIt =
      "Không tìm thấy kết nối mạng trên thiết bị của bạn. Vui lòng kết nối mạng sau đó nhấn nút \"Thử lại\".";
  final String _netSlowHasTryIt =
      "Kết nối mạng của bạn quá yếu hoặc cần được gia hạn. Vui lòng đổi kết nối mạng sau đó nhấn nút \"Thử lại\".";
  final String _netErrorNoTryIt =
      "Không tìm thấy kết nối mạng trên thiết bị của bạn. Vui lòng kết nối mạng và thử lại.";
  final String _netSlowNoTryIt =
      "Kết nối mạng của bạn quá yếu hoặc cần được gia hạn. Vui lòng đổi kết nối mạng và thử lại.";
  final String _jwtExpired =
      "Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại để tiếp tục sử dụng.";

  static String netError =
      "Kết nối mạng không ổn định hoặc cần được gia hạn. Vui lòng kiểm tra kết nối của bạn và thử lại";
  static String unAuthorized = "Thông tin xác thực không chính xác.";
  static String banned = "Bạn không đủ quyền hạn thực hiện hành động này.";
  static String notFindPackageInfo =
      "Không tìm thấy thông tin khóa học. Vui lòng thử lại";
  static String userInvailid =
      "Thông tin xác thực không đúng, Vui lòng liên hệ bộ phận hỗ trợ để nhận được hướng dẫn!";
  static String otherError = "Đã xảy ra lỗi bất ngờ. Xin vui lòng thử lại sau.";

  ErrorModel(
      {@required this.errorType,
      String errorMessage,
      @required this.isUsedTryIt}) {
    switch (errorType) {
      case ErrorType.CONNECTION_ERROR:
        this.errorMessage = isUsedTryIt ? _netErrorHasTryIt : _netErrorNoTryIt;
        break;
      case ErrorType.TIME_OUT:
        this.errorMessage = isUsedTryIt ? _netSlowHasTryIt : _netSlowNoTryIt;
        break;
      case ErrorType.JWT_FOUND:
        this.errorMessage = _jwtExpired;
        break;
      default:
        this.errorMessage = errorMessage;
        break;
    }
  }
}

enum GenderType {
  male,
  female,
}
