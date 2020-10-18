import 'package:core_asgl/core_asgl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class PlatformHelper {
  static const String _obligatoryCreateKey = "obligatoryCreateKey";
  static MethodChannel _methodChannel =
      MethodChannel("com.asgl.s_timesheet_mobile");
  static String _getDataOpenAppMethod =
      "com.asgl.s_timesheet_mobile.getDataOpenApp";
  static const String _resetNewDomain = "resetNewDomain";
  static String _resetNewDomainkey =
      "com.asgl.s_timesheet_mobile.login_success";
  static String _authenticateFingerprint =
      "com.asgl.s_timesheet_mobile.fingerprints";

  //Key share data Flutter -> Native và S-Conenct -> Other App
  static const String _keyPackageName = "pkName";
  static const String _keyUserName = "userName";
  static const String _keyPassWord = "password";
  static const String _keyJWT = "jwt";

  ///S-Connect check app installed method name
  static String _checkAppInstalledMethodName =
      "com.asgl.s_timesheet_mobile.checkAppInstalled";

  //S-Connect open app method name
  static String _openOtherApp = "com.asgl.s_timesheet_mobile.openOtherApp";

  ///Check and get data when app is open
  ///If [_data] = "" => Không được mở từ bất kỳ ứng dụng nào khác
  ///Nếu [_data] != null && data !="" => Kiểm tra data nhận được và loading theo dữ liệu mới nhất
  static Future<dynamic> getDataOpenApp() async {
    dynamic _data = await _methodChannel.invokeMethod(_getDataOpenAppMethod);
    return _data;
  }

  ///Kiểm tra xem ứng dụng đã được cài đặt hay chưa.
  ///[packageName] Tên gói ứng dụng cần kiểm tra
  static Future<bool> checkAppInstalled({@required String packageName}) async {
    bool result = await _methodChannel
        .invokeMethod(_checkAppInstalledMethodName, {"pkName": "$packageName"});
    return result;
  }

  ///[packageName] : Tên gói ứng dụng sẽ được mở
  ///[jwt] : Json Web Token sẽ được truyền từ S-Connect sang ứng dụng khác
  ///[userName] : Tài khoản đăng nhập từ S-Connect
  ///[password] : Mật khẩu đăng nhập trên S-Connect
  static void openAppWithPackageName(
      {@required String packageName,
      @required String jwt,
      @required String userName,
      @required String password}) async {
    await _methodChannel.invokeMethod(_openOtherApp, {
      _keyPackageName: "$packageName",
      _keyJWT: jwt,
      _keyUserName: userName,
      _keyPassWord: password
    });
  }

  /// Chỉ sử dụng cho IOS
  /// [urlScheme] Kiểu url định nghĩa cho ứng dụng
  /// [jwt] JWT of S-Connect
  /// [userName] Tài khoản S-Connect
  /// [password] Mật khẩu S-Connect
  static void openIOSAppWithData(
      {@required String urlScheme,
        @required String jwt,
        @required String userName,
        @required String password}) async {
    dynamic data = await _methodChannel.invokeMethod(_openOtherApp, {
      _keyPackageName: "$urlScheme",
      _keyJWT: jwt,
      _keyUserName: userName,
      _keyPassWord: password
    });
    if (data is int) {
      Toast.showShort("Ứng dụng chưa được cài đặt");
    }
  }

  static void resetNewDomain()async{
    if(Platform.isIOS) {
      _methodChannel?.invokeMethod(
          _resetNewDomainkey, {_resetNewDomain: _resetNewDomain});
    }
  }
  ///  Tạo yêu cầu xác thực vân tay
  ///  Nếu được gọi lần đầu thì [obligatoryCreateKey] chắc chắn = false
  ///  Nếu được gọi lại thêm 1 lần nữa khi gặp lỗi -4 thì
  ///  [obligatoryCreateKey] = true để buộc application tạo 1 key mới
  ///  Để có thể xác thực theo key mới
  static Future<dynamic> authenticateWithFingerPrint(
      bool obligatoryCreateKey) async {
    _methodChannel?.invokeMethod(
        _authenticateFingerprint, {_obligatoryCreateKey: obligatoryCreateKey});
  }
}
