import 'dart:convert';

import 'package:s_timesheet_mobile/core/api_services.dart';
import 'package:s_timesheet_mobile/core/constant.dart';
import 'package:s_timesheet_mobile/utils/cache/share_prefer_utils.dart';
import 'package:http/http.dart' as Http;

class CalendarServices {
  //Toàn bộ các API dùng cho phần lịch làm việc sẽ viết trong đây
  Future<void> getWorkSchedules(
      {String startTime,
      String endTime,
      OnResultData resultData,
      OnErrorApiCallback onErrorApiCallBack}) async {
    String jwt = await SharePreferUtils.getAccessToken();
    Map<String, String> header = {"Authorization": "Bearer $jwt"};
    Map<String, String> params = {
      "from_date": startTime,
      "to_date": endTime,
      //"filter":"true"
    };

    Uri uri = Uri.http(Constant.SERVER_WORK_SCHEDULE_NO_HTTP,
        "/api/staff/work-schedules", params);
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
        Map<String, dynamic> data = json.decode(response.body);
        if (data != null) {
          if (data.containsKey("data") &&
              data['data'] != null &&
              data['data'] != "") {
            resultData(data['data']);
          } else {
            onErrorApiCallBack("");
          }
        } else {
          onErrorApiCallBack("");
        }
      } catch (ex) {
        onErrorApiCallBack("");
      }
    }
  }

  Future<void> getUsershift(
      {int idShift,
      OnResultData onResultData,
      OnErrorApiCallback onErrorApiCallBack}) async {
    String jwt = await SharePreferUtils.getAccessToken();
    Map<String, String> _header = {
      "Authorization": "Bearer $jwt",
    };
    Uri uri = Uri.http(Constant.SERVER_WORK_SCHEDULE_NO_HTTP,
        "/api/staff/swap-requests/schedules/$idShift/swappable-users");
    Http.Response response =
        await Http.get(uri, headers: _header).then((response) {
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        return response;
      } else {
        if (statusCode == 401) {
          onErrorApiCallBack(ErrorModel.unAuthorized);
        } else if (statusCode == 403) {
          onErrorApiCallBack(ErrorModel.banned);
        } else if (statusCode == 405) {
          onErrorApiCallBack(ErrorModel.unAuthorized);
        } else {
          onErrorApiCallBack(ErrorModel.unAuthorized);
        }
        return null;
      }
    }).catchError((onError) {
      onErrorApiCallBack(ErrorModel.netError);
      return null;
    }).timeout(Duration(seconds: 10), onTimeout: () {
      onErrorApiCallBack(ErrorModel.netError);
      return null;
    });

    try {
      if (response != null && response.body != null) {
        dynamic data = jsonDecode(response.body.toString());
        if (data['success'] != null && data['success'].toString() == 'true') {
          onResultData(data['data']);
        }
      } else {
        onErrorApiCallBack("");
      }
    } catch (ex) {
      onErrorApiCallBack("");
    }
  }

  Future<void> getWorkSchedulesDetail(
      {int id,
      OnResultData onResultData,
      OnErrorApiCallback onErrorApiCallBack}) async {
    String jwt = await SharePreferUtils.getAccessToken();
    Map<String, String> header = {
      //dùng token tài khoản của Bình
      "Authorization": "Bearer $jwt",
    };
    Uri uri = Uri.http(
        Constant.SERVER_WORK_SCHEDULE_NO_HTTP, "/api/staff/work-schedules/$id");
    Http.Response response =
        await Http.get(uri, headers: header).then((response) {
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        return response;
      } else {
        if (statusCode == 401) {
          onErrorApiCallBack(ErrorModel.unAuthorized);
        } else if (statusCode == 403) {
          onErrorApiCallBack(ErrorModel.banned);
        } else if (statusCode == 405) {
          onErrorApiCallBack(ErrorModel.unAuthorized);
        } else {
          onErrorApiCallBack(ErrorModel.unAuthorized);
        }
        return null;
      }
    }).catchError((onError) {
      onErrorApiCallBack(ErrorModel.netError);
      return null;
    }).timeout(Duration(seconds: 10), onTimeout: () {
      onErrorApiCallBack(ErrorModel.netError);
      return null;
    });

    try {
      if (response != null && response.body != null) {
        dynamic data = jsonDecode(response.body.toString());
        if (data['success'] != null && data['success'].toString() == 'true') {
          onResultData(data['data']);
        }
      } else {
        onErrorApiCallBack("");
      }
    } catch (ex) {
      onErrorApiCallBack("");
    }
  }

  Future<void> postSendSablatical(
      {int id,
      String lydo,
      OnResultData onResultData,
      OnErrorApiCallback onErrorApiCallBack}) async {
    String jwt = await SharePreferUtils.getAccessToken();
    Map<String, String> _header = {
      'Authorization': 'Bearer $jwt',
    };
    Map<String, String> body = {
      'schedule_id': '$id',
      'reason': '$lydo',
    };
    Http.Response response = await Http.post(
            Constant.SERVER_WORK_SCHEDULE + "/api/staff/absence-requests",
            headers: _header,
            body: body)
        .then((Http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 500) {
        return response;
      } else {
        if (statusCode == 401) {
          onErrorApiCallBack(ErrorModel.unAuthorized);
        } else if (statusCode == 403) {
          onErrorApiCallBack(ErrorModel.banned);
        } else if (statusCode == 405) {
          onErrorApiCallBack(ErrorModel.unAuthorized);
        } else {
          onErrorApiCallBack(ErrorModel.unAuthorized);
        }
        return null;
      }
    }).catchError((onError) {
      if (onError.toString().contains("SocketException")) {
        onErrorApiCallBack(ErrorModel.netError);
      }
      return null;
    }).timeout(Duration(seconds: TIME_OUT), onTimeout: () {
      onErrorApiCallBack(ErrorModel.netError);
      return null;
    });
    if (response != null &&
        response.bodyBytes != null &&
        response.bodyBytes.length > 0) {
      dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data['success'] != null &&
          data['success'] != '' &&
          data['success'].toString() == 'true') {
        onResultData(data);
      } else if (data['success'] != null &&
          data['success'] != '' &&
          data['success'].toString() == 'false') {
        onResultData(data);
      } else {
        onErrorApiCallBack("Gửi request không thành công.");
      }
    }
  }

  Future<void> postSendSwichshift(
      {int idShift,
      int idShiftchange,
      String lydo,
      OnResultData onResultData,
      OnErrorApiCallback onErrorApiCallBack}) async {
    String jwt = await SharePreferUtils.getAccessToken();
    Map<String, String> _header = {
      'Authorization': 'Bearer $jwt',
    };
    Map<String, String> body = {
      'base_schedule_id': '$idShift',
      'swap_schedule_id': '$idShiftchange',
      'reason': '$lydo',
    };
    Http.Response response = await Http.post(
            Constant.SERVER_WORK_SCHEDULE + "/api/staff/swap-requests",
            headers: _header,
            body: body)
        .then((Http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 500) {
        return response;
      } else {
        if (statusCode == 401) {
          onErrorApiCallBack(ErrorModel.unAuthorized);
        } else if (statusCode == 403) {
          onErrorApiCallBack(ErrorModel.banned);
        } else if (statusCode == 405) {
          onErrorApiCallBack(ErrorModel.unAuthorized);
        } else {
          onErrorApiCallBack(ErrorModel.unAuthorized);
        }
        return null;
      }
    }).catchError((onError) {
      if (onError.toString().contains("SocketException")) {
        onErrorApiCallBack(ErrorModel.netError);
      }
      return null;
    }).timeout(Duration(seconds: 10), onTimeout: () {
      onErrorApiCallBack(ErrorModel.netError);
      return null;
    });
    if (response != null &&
        response.bodyBytes != null &&
        response.bodyBytes.length > 0) {
      dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data['success'] != null &&
          data['success'] != '' &&
          data['success'].toString() == 'true') {
        onResultData(data);
      } else if (data['success'] != null &&
          data['success'] != '' &&
          data['success'].toString() == 'false') {
        onResultData(data);
      } else {
        onErrorApiCallBack("Gửi request không thành công.");
      }
    }
  }

  Future<void> getShiftCanChangeService({
    int idShift,
    int idUserWillChange,
    OnResultData onResultData,
    OnErrorApiCallback onErrorApiCallBack,
  }) async {
    String jwt = await SharePreferUtils.getAccessToken();
    Map<String, String> header = {
      //dùng token tài khoản của Bình
      "Authorization": "Bearer $jwt",
    };
// /api/staff/work-schedules/1 (Số 1 đó chính là Id của công việc cần xem chi tiết, tạm thời fix =1 )
    Uri uri = Uri.http(Constant.SERVER_WORK_SCHEDULE_NO_HTTP,
        "/api/staff/swap-requests/schedules/$idShift/swappable-users/$idUserWillChange/swappable-schedules");
    Http.Response response =
        await Http.get(uri, headers: header).then((response) {
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        return response;
      } else {
        if (statusCode == 401) {
          onErrorApiCallBack(ErrorModel.unAuthorized);
        } else if (statusCode == 403) {
          onErrorApiCallBack(ErrorModel.banned);
        } else if (statusCode == 405) {
          onErrorApiCallBack(ErrorModel.unAuthorized);
        } else {
          onErrorApiCallBack(ErrorModel.unAuthorized);
        }
        return null;
      }
    }).catchError((onError) {
      onErrorApiCallBack(ErrorModel.netError);
      return null;
    }).timeout(Duration(seconds: 10), onTimeout: () {
      onErrorApiCallBack(ErrorModel.netError);
      return null;
    });

    try {
      if (response != null && response.body != null) {
        dynamic data = jsonDecode(response.body.toString());
        if (data['success'] != null && data['success'].toString() == 'true') {
          var data1 = data['data'];
          onResultData(data1);
        }
      } else {
        onErrorApiCallBack("");
      }
    } catch (ex) {
      onErrorApiCallBack("");
    }
  }
}
