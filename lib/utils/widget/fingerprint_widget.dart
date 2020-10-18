
import 'package:core_asgl/core_asgl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:s_timesheet_mobile/auth/auth_bloc.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/platform/platform_helper.dart';
import 'package:s_timesheet_mobile/core/style.dart' as prefix0;
import 'package:s_timesheet_mobile/utils/widget/dialog_fingerprint_widget.dart';

class FingerprintWidget extends StatefulWidget {
  final AppBloc appBloc;
  final BuildContext context;
  final bool statusFingerPrintKey;

  FingerprintWidget(this.appBloc, this.context, this.statusFingerPrintKey);

  @override
  _FingerprintWidgetState createState() => _FingerprintWidgetState();
}

class _FingerprintWidgetState extends State<FingerprintWidget> {
  String content = "Auth";
  bool haveUsernameAndPass = false;
  final MethodChannel methodChannel =
      MethodChannel("com.asgl.s_timesheet_mobile.fingerprint_channel");

  @override
  void initState() {
    super.initState();
    PlatformHelper.authenticateWithFingerPrint(widget.statusFingerPrintKey);
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == "com.asgl.s_timesheet_mobile.auth_result") {
        if (call.arguments is int) {
          int state = call.arguments as int;
          switch (state) {
            case -4:
              //Người dùng cập nhật vân tay mới hoặc xóa 1 vân tay
              content =
                  "Dữ liệu vân tay được cập nhật. Vui lòng đăng nhập lại với Tài khoản và mật khẩu.";
              widget.appBloc.authBloc.fingerPrintStatusStream
                  .notify(FingerPrintStatusModel(
                      FingerPrintStatusState.UPADATE,
                      "Thất bại",
                      content,
                      false,
                      TextStyle(
                        color: Color(0xffee8800),
                        fontFamily: 'Roboto-Bold',
                        fontSize: 50.sp,
                      ),
                      false));
              break;
            case -3:
              //Lỗi tạo key xác thực
              content =
                  "Xác thực vân tay không thành công vui lòng sử dụng tài khoản và mật khẩu để đăng nhập.";
              widget.appBloc.authBloc.fingerPrintStatusStream
                  .notify(FingerPrintStatusModel(
                      FingerPrintStatusState.KEYVERYFY,
                      "Thất bại",
                      content,
                      false,
                      TextStyle(
                        color: Color(0xffee8800),
                        fontFamily: 'Roboto-Bold',
                        fontSize: 50.sp,
                      ),
                      false));
              break;
            case -2:
              //Nếu người dùng chưa cài đặt vân tay cho ứng dụng
              content =
                  "Vui lòng cài đặt vân tay cho thiết bị để sử dụng tính năng này.";
              widget.appBloc.authBloc.fingerPrintStatusStream
                  .notify(FingerPrintStatusModel(
                      FingerPrintStatusState.HAVENFINGERPRINT,
                      "Thất bại",
                      content,
                      false,
                      TextStyle(
                        color: Color(0xffee8800),
                        fontFamily: 'Roboto-Bold',
                        fontSize: 50.sp,
                      ),
                      false));
              break;
            case -1:
              //Nếu người dùng chưa cài đặt khóa màn hình thì hiển thị thông báo ở đây
              content =
                  "Vui lòng cài đặt khóa màn hình cho thiết bị để sử dụng tính năng này.";
              widget.appBloc.authBloc.fingerPrintStatusStream
                  .notify(FingerPrintStatusModel(
                      FingerPrintStatusState.HAVENLOCKSCREEN,
                      "Thất bại",
                      content,
                      false,
                      TextStyle(
                        color: Color(0xffee8800),
                        fontFamily: 'Roboto-Bold',
                        fontSize: 50.sp,
                      ),
                      false));
              break;
            case 0:
              //Authenticate thất bại do sai vân tay
              content = "Xác thực thất bại vui lòng thử lại.";
              widget.appBloc.authBloc.fingerPrintStatusStream
                  .notify(FingerPrintStatusModel(
                      FingerPrintStatusState.ERRORFINGERPRINT,
                      "Thử lại",
                      content,
                      true,
                      TextStyle(
                        color: prefix0.accentColor,
                        fontFamily: 'Roboto-Bold',
                        fontSize: 50.sp,
                      ),
                      false));
              break;
            case 1:
              Toast.showShort("Xác thực thành công.");
              widget.appBloc.authBloc.checkAuth(widget.appBloc,
                  checkFromFingerPrint: true,
                  context: context,
                  fromFingerPrintAuth: true);
              await _cancelFingerprint();
              Navigator.of(context).pop();
              break;
            case 2:
              //Xác thực thất bại quá nhiều lần hoặc thao tác dùng vân tay bị hủy
              _cancelFingerprint();
              widget.appBloc.authBloc.enableAndDisableButton.notify(false);
              content =
                  "Xác thực thất bại quá 5 lần. Vui lòng sử dụng tài khoản và mật khẩu để đăng nhập.";
              widget.appBloc.authBloc.fingerPrintStatusStream
                  .notify(FingerPrintStatusModel(
                      FingerPrintStatusState.MULTIVERYFIFINGERPRINT,
                      "Thất bại",
                      content,
                      false,
                      TextStyle(
                        color: Color(0xffee8800),
                        fontFamily: 'Roboto-Bold',
                        fontSize: 50.sp,
                      ),
                      false));
              break;
            case 3:
              Navigator.of(context).pop();
              break;
          }
        }
      }
    });
  }

  _cancelFingerprint() {
    methodChannel
        .invokeMethod("com.asgl.s_timesheet_mobile.cancel_authenticate");
  }

  @override
  void dispose() {
    //Hủy luồng xác thực vân tay dưới native
    _cancelFingerprint();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: FingerPrintStatusModel(
            FingerPrintStatusState.NONE, null, null, null, null, null),
        stream: widget.appBloc.authBloc.fingerPrintStatusStream.stream,
        builder:
            (buildContent, AsyncSnapshot<FingerPrintStatusModel> snapshot) {
          switch (snapshot.data.state) {
            case FingerPrintStatusState.UPADATE:
              return DialogFingerPrint(
                  snapshot.data.title,
                  snapshot.data.message,
                  snapshot.data.haveButton,
                  snapshot.data.styleTitle,
                  snapshot.data.fingerPrintDisable);
              break;
            case FingerPrintStatusState.KEYVERYFY:
              return DialogFingerPrint(
                  snapshot.data.title,
                  snapshot.data.message,
                  snapshot.data.haveButton,
                  snapshot.data.styleTitle,
                  snapshot.data.fingerPrintDisable);
              break;
            case FingerPrintStatusState.HAVENFINGERPRINT:
              return DialogFingerPrint(
                  snapshot.data.title,
                  snapshot.data.message,
                  snapshot.data.haveButton,
                  snapshot.data.styleTitle,
                  snapshot.data.fingerPrintDisable);
              break;
            case FingerPrintStatusState.HAVENLOCKSCREEN:
              return DialogFingerPrint(
                  snapshot.data.title,
                  snapshot.data.message,
                  snapshot.data.haveButton,
                  snapshot.data.styleTitle,
                  snapshot.data.fingerPrintDisable);
              break;
            case FingerPrintStatusState.ERRORFINGERPRINT:
              return DialogFingerPrint(
                  snapshot.data.title,
                  snapshot.data.message,
                  snapshot.data.haveButton,
                  snapshot.data.styleTitle,
                  snapshot.data.fingerPrintDisable);
              break;
            case FingerPrintStatusState.SUCCERFINGERPRINT:
              //thành công

              return Container();
              break;
            case FingerPrintStatusState.MULTIVERYFIFINGERPRINT:
              return DialogFingerPrint(
                  snapshot.data.title,
                  snapshot.data.message,
                  snapshot.data.haveButton,
                  snapshot.data.styleTitle,
                  snapshot.data.fingerPrintDisable);
              break;
            case FingerPrintStatusState.NONE:
              return DialogFingerPrint(
                  "Đăng nhập bằng vân tay",
                  "Vui lòng quét vân tay để đăng nhập (Lưu ý: Có thể sử dụng vân tay đã đăng ký thành công trên thiết bị)",
                  true,
                  TextStyle(
                    color: prefix0.accentColor,
                    fontFamily: 'Roboto-Bold',
                    fontSize: 50.sp,
                  ),
                  false);

              break;
            default:
              return Container();
              break;
          }
        });
  }
}
