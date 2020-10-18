import 'dart:convert';

import 'package:http/http.dart' as Http;
import 'package:s_timesheet_mobile/core/api_services.dart';
import 'package:s_timesheet_mobile/core/constant.dart';
import 'package:s_timesheet_mobile/utils/common/cache_helper.dart';

class DiaryServices {
  Future<void> getAllDataDiary(String startDate, String endDate,
      OnResultData resultData, OnErrorApiCallback onErrorApiCallback) async {
    String jwt = await CacheHelper.getAccessToken();
    if (jwt == null || jwt == "") {
      onErrorApiCallback(ErrorType.JWT_FOUND);
    } else {
      Http.Response response = await Http.get(
          Constant.SERVER_WORK_SCHEDULE +
              "/api/staff/work-schedules?from_date=$startDate&to_date=$endDate",
          headers: {"Authorization": "Bearer $jwt"}).then((res) {
        return res;
      }).catchError((onError) {
        onErrorApiCallback(onError);
        return null;
      }).timeout(Duration(seconds: TIME_OUT), onTimeout: () {
        onErrorApiCallback(ErrorType.TIME_OUT);
        return null;
      });
      if (response != null) {
        if (response.body != null && response.body != "") {
          try {
            dynamic data = json.decode(response.body);
            if (data != null && data != "") {
              resultData(data['data']);
            } else {
              onErrorApiCallback(ErrorType.CONVERT_DATA_ERROR);
            }
          } catch (ex) {
            onErrorApiCallback(ErrorType.CONVERT_DATA_ERROR);
          }
        } else {
          onErrorApiCallback(ErrorType.RESPONSE_BODY_NULL);
        }
      }
    }
  }
}
