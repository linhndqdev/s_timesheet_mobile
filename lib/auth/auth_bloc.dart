import 'dart:io';
import 'dart:convert';
import 'package:core_asgl/core_asgl.dart';
import 'package:flutter/services.dart';
import 'package:s_timesheet_mobile/core/api_services.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:s_timesheet_mobile/core/platform/platform_helper.dart';
import 'package:s_timesheet_mobile/model/asgl_user_model.dart';
import 'package:s_timesheet_mobile/model/auth_model.dart';
import 'package:s_timesheet_mobile/utils/cache/share_prefer_utils.dart';
import 'package:s_timesheet_mobile/utils/common/cache_helper.dart';
import 'package:s_timesheet_mobile/utils/model/dialog_model.dart';
import 'package:s_timesheet_mobile/utils/widget/dialog_util.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:s_timesheet_mobile/utils/common/validator.dart';

class AuthBloc {
  CoreStream<AuthenticationModel> authStream = CoreStream();
  CoreStream<bool> loadingStream = CoreStream();
  CoreStream<bool> haveUserNamePasswordStream = CoreStream();
  CoreStream<FingerPrintStatusModel> fingerPrintStatusStream = CoreStream();
  CoreStream<bool> enableAndDisableButton = CoreStream();
  CoreStream<bool> rememberPassStream = CoreStream();
  String newJwt = "";
  String newPassword = "";
  String newUserName = "";
  ASGUserModel asgUserModel;
  String email;
  bool isShowPass = false;
  bool isRememberPass = false;
  String userNameDrawer = "";
  String fullNameDrawer = "";
  String idDrawer = "";

//  AnimationController animationControllerButtonLogin;

//  ApiRepository _apiRepository = ApiRepository();
//  CoreStream<bool> loadingStream = CoreStream();
  CoreStream<RegisterOldValidateState> validateUserStream = CoreStream();
  CoreStream<RegisterOldValidateState> validatePassStream = CoreStream();
  CoreStream<RegisterOldValidateState> validateEmailForgotPass = CoreStream();
  CoreStream<bool> showPassStream = CoreStream();

  void disableLoaddingButtonWithAuth(
      AnimationController animationControllerButtonLogin) async {
    animationControllerButtonLogin?.reverse();
  }

  //Kiểm tra đăng nhập
  void checkAuthentication(BuildContext context) async {
    dynamic _jsonDataOpenApp = await PlatformHelper.getDataOpenApp();
    if (_jsonDataOpenApp != null && _jsonDataOpenApp != "") {
      if (Platform.isIOS) {
        dynamic data = json.decode(_jsonDataOpenApp);
        loginWith(context, data['userName'], data['password']);
      } else if (Platform.isAndroid) {
        loginWith(context, _jsonDataOpenApp['userName'],
            _jsonDataOpenApp['password']);
      }
    } else {
      bool isRememberPass = await SharePreferUtils.getStateRememberPass();
      if (isRememberPass && isRememberPass != null) {
        String username = await SharePreferUtils.getUserName();
        String password = await SharePreferUtils.getPassword();
        loginWith(context, username, password);
      } else {
        String accessToken = await SharePreferUtils.getAccessToken();
        if (accessToken != null && accessToken != "") {
          _changeStateAuth(state: AuthState.LOGIN_SUCCESS, data: null);
        } else {
          _changeStateAuth(state: AuthState.REQUEST_LOGIN);
        }
      }
    }
  }

  //Chuyển màn
  //chuyen man Quen mat khau
  void moveToForgotPassScreen() async {
    AuthenticationModel authenticationModel =
        AuthenticationModel(AuthState.FORGOTPASS, null, null);
    authStream.notify(authenticationModel);
  }

  void changeStateBackToLogin() {
    AuthenticationModel authenticationModel =
        AuthenticationModel(AuthState.REQUEST_LOGIN, false, null);
    authStream.notify(authenticationModel);
  }

  void updateStateRememberPass() async {
    isRememberPass = !isRememberPass;
    await CacheHelper.saveStateRememberPass(isRememberPass);
    rememberPassStream?.notify(isRememberPass);
  }

  void updateStateShowPass() async {
    isShowPass = !isShowPass;
    showPassStream?.notify(isShowPass);
  }

  void updateUser(String maNhanVien) {
    this.email = maNhanVien;
    if (this.email == null || this.email.trim() == "") {
      validateUserStream.notify(RegisterOldValidateState.NONE);
    } else {
      validateUserStream.notify(maNhanVien.length >= 4
          ? RegisterOldValidateState.MATCHED
          : RegisterOldValidateState.ERROR);
    }
  }

  void updateEmailForgotPass(String email) {
    this.email = email;
    if (this.email == null || this.email.trim() == "") {
      validateEmailForgotPass.notify(RegisterOldValidateState.NONE);
    } else {
      Validators validators = Validators();
      validateEmailForgotPass.notify(validators.validUser(this.email)
          ? RegisterOldValidateState.MATCHED
          : RegisterOldValidateState.ERROR);
    }
  }

  //Cập nhật data mới để authen
  void setData(dynamic argument) async {
    newJwt = argument['jwt'];
    newPassword = argument['password'];
    newUserName = argument['userName'];
    await SharePreferUtils.saveAccessToken(newJwt);
    await SharePreferUtils.saveUsername(newUserName);
    await SharePreferUtils.savePassword(password: newPassword);
  }

  _changeStateAuth({AuthState state, bool isAuth, dynamic data}) {
    AuthenticationModel authenticationModel =
        AuthenticationModel(state, isAuth, data);
    authStream.notify(authenticationModel);
  }


  void loginWith(BuildContext context, String account, String password,
      {bool isChangeApp = false,
      bool loginFromFingerPrint = false,
      AnimationController animationControllerButtonLogin}) async {
    loadingStream.notify(true);
    if (account != null && account != "") {
      if (password != null && password.trim().toString() != "") {
        ApiServices apiServices = ApiServices();
        await apiServices.loginASGL(
            account: account,
            password: password,
            onResultData: (resultData) async {
              disableLoaddingButtonWithAuth(animationControllerButtonLogin);
              loadingStream.notify(false);
              if (resultData != null &&
                  resultData['data'] != null &&
                  resultData['data'] != "") {
                PlatformHelper.resetNewDomain();
                String token = resultData['data']['token'];
                print('token: ' + token);
                SharePreferUtils.saveAccessToken(token);
                SharePreferUtils.saveUsername(account);
                SharePreferUtils.savePassword(password: password);
                if (loginFromFingerPrint) {
                  SharePreferUtils.saveStatusFingerPrint(status: false);
                } else {
                  SharePreferUtils.saveStatusFingerPrint(status: true);
                }
                asgUserModel =
                    ASGUserModel.fromJsonLogin(resultData['data']['user']);
                SharePreferUtils.saveIdUser(id: asgUserModel.id.toString());
                SharePreferUtils.saveFullName(
                    fullName: asgUserModel.full_name.toString());
                userNameDrawer = asgUserModel.username;
                idDrawer = asgUserModel.id.toString();
                fullNameDrawer = asgUserModel.full_name;
                AuthenticationModel authenticationModel =
                    AuthenticationModel(AuthState.LOGIN_SUCCESS, true, null);
                authStream.notify(authenticationModel);
              }
            },
            onErrorApiCallback: (onError) {
              loadingStream.notify(false);
              disableLoaddingButtonWithAuth(animationControllerButtonLogin);
              Toast.showShort(onError.toString());
              requestLogin();
            });
      } else {
        loadingStream.notify(false);
        disableLoaddingButtonWithAuth(animationControllerButtonLogin);
        if (!isChangeApp) requestLogin();
        Toast.showShort("Vui lòng nhập mật khẩu!");
      }
    } else {
      loadingStream.notify(false);
      disableLoaddingButtonWithAuth(animationControllerButtonLogin);
      if (!isChangeApp) requestLogin();
      Toast.showShort("Vui lòng nhập mã nhân viên.");
    }

  }

  //Hàm quên mật khẩu khi nhấn vào nút Quên mật khẩu
  void forgotPassword(BuildContext context, String account,
      {AnimationController controller}) async {
    loadingStream.notify(true);
    if (account.length >= 4) {
      ApiServices apiServices = ApiServices();
      await apiServices.createPostNoJWT(
          account: account,
          onResultData: (resultData) async {
            try {
              if (resultData != null &&
                  resultData['data'] != null &&
                  resultData['data'] != "") {
                loadingStream.notify(false);
                loadingStream.notify(false);
                if (resultData['data']['email'] == null ||
                    resultData['data']['email'] == "") {
                  DialogUtil.showDialogForgotSuccess(
                      context,
                      false,
                      "Quên mật khẩu",
                      "Vui lòng liên hệ bộ phận hỗ trợ để nhận được hướng dẫn!",
                      "",
                      false);
                } else {
                  DialogUtil.showDialogForgotSuccess(
                      context,
                      false,
                      "Quên mật khẩu",
                      resultData['data']['message'],
                      resultData['data']['email'],
                      true);
                }
              }
            } catch (onError) {
              loadingStream.notify(false);
              disableLoaddingButtonWithAuth(controller);

              DialogUtil.showDialogLogin(
                  context, false, "Thông báo", onError.toString());
            }
          },
          onErrorApiCallback: (onError) {
            loadingStream.notify(false);
            disableLoaddingButtonWithAuth(controller);

            DialogUtil.showDialogLogin(
                context, false, "Thông báo", onError.toString());
          });
    } else {
      loadingStream.notify(false);
      disableLoaddingButtonWithAuth(controller);

      DialogUtil.showDialogLogin(context, false, "Thông báo",
          "Vui lòng điền mã nhân viên đúng định dạng !");
//      Toast.showShort("Vui lòng điền mã nhân viên đúng định dạng !");
    }
    disableLoaddingButtonWithAuth(controller);
  }

  void requestLogin({ErrorType error}) {
    if (error == ErrorType.CONNECTION_ERROR) {
      Toast.showShort(
          "Kết nối mạng của bạn không ổn định. Vui lòng kiểm tra lại kết nối của bạn.");
    } else if (error == ErrorType.DATA_ERROR) {
      Toast.showShort(
          "Không tìm thấy thông tin của bạn. Vui lòng đăng nhập lại để cập nhật thông tin mới nhất.");
    }
    AuthenticationModel authenticationModel =
        AuthenticationModel(AuthState.REQUEST_LOGIN, false, error);
    loadingStream.notify(false);
    authStream.notify(authenticationModel);
  }

  void checkUserNamePassWord() async {
    String userName;
    String password;
    try {
      userName = await SharePreferUtils.getUserName();
      password = await SharePreferUtils.getPassword();
    } catch (error) {
      userName = null;
      password = null;
    }
    if (userName != null &&
        password != null &&
        userName != '' &&
        password != '') {
      haveUserNamePasswordStream.notify(true);
    } else {
      haveUserNamePasswordStream.notify(false);
    }
  }

  void authenticateFingerPrintIOS(BuildContext context) async {
    bool isAllowCreateNewDOmain = await SharePreferUtils.getStatusFingerPrint();
    PlatformHelper.authenticateWithFingerPrint(isAllowCreateNewDOmain);
    MethodChannel methodChannel =
        MethodChannel("com.asgl.s_timesheet_mobile.fingerprint_channel");
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == "com.asgl.s_timesheet_mobile.auth_result") {
        if (call.arguments is int) {
          int state = call.arguments as int;
          print("IOS state fringerprint: $state");
          switch (state) {
            case -5:
              //userCancel
              break;
            case -4:
              // systemCancel touch id
              break;
            case -3:
              //touchIDNotAvailable
              DialogUtil.showDialogAuthenticateFinger(context,
                  title: "Thất bại",
                  message:
                      "Vui lòng bật xác thực vân tay hoặc xác thực khuôn mặt trên thiết bị để có thể sử dụng tính năng này.",
                  styleTitle: TextStyle(
                    color: Color(0xffee8800),
                    fontFamily: 'Roboto-Bold',
                    fontSize: 50.sp,
                  ),
                  haveButton: false,
                  fingerPrintDisable: false);
              break;
            case -2:
              //Nếu người dùng chưa cài đặt vân tay cho ứng dụng
              DialogUtil.showDialogAuthenticateFinger(context,
                  title: "Thất bại",
                  message:
                      "Vui lòng cài đặt vân tay cho thiết bị để sử dụng tính năng này.",
                  styleTitle: TextStyle(
                    color: Color(0xffee8800),
                    fontFamily: 'Roboto-Bold',
                    fontSize: 50.sp,
                  ),
                  haveButton: false,
                  fingerPrintDisable: false);
              break;
            case -1:
              //Có lỗi ngoài ý muốn
              DialogUtil.showDialogAuthenticateFinger(context,
                  title: "Thất bại",
                  message:
                      "Vui lòng cài đặt khóa màn hình cho thiết bị để sử dụng tính năng này.",
                  styleTitle: TextStyle(
                    color: Color(0xffee8800),
                    fontFamily: 'Roboto-Bold',
                    fontSize: 50.sp,
                  ),
                  haveButton: false,
                  fingerPrintDisable: false);
              break;
            case 0:
              //Xác thực thất bại do sai vân tay
              //authenticationFailed
              DialogUtil.showDialogAuthenticateFinger(context,
                  title: "Thất bại",
                  message: "Xác thực thất bại vui lòng thử lại.",
                  styleTitle: TextStyle(
                    color: Color(0xffee8800),
                    fontFamily: 'Roboto-Bold',
                    fontSize: 50.sp,
                  ),
                  haveButton: false,
                  fingerPrintDisable: false);
              break;
            case 1:
              //Xác thực thành công
              Toast.showShort("Xác thực thành công.");
              AppBloc appBloc = BlocProvider.of(context);
              appBloc.authBloc.checkAuth(appBloc,
                  checkFromFingerPrint: true,
                  context: context,
                  fromFingerPrintAuth: true);
              break;
            case 2:
              //TouchIdLockout
              DialogUtil.showDialogAuthenticateFinger(context,
                  title: "Thất bại",
                  message:
                      "Xác thực thất bại quá 5 lần. Vui lòng sử dụng tài khoản và mật khẩu để đăng nhập.",
                  styleTitle: TextStyle(
                    color: Color(0xffee8800),
                    fontFamily: 'Roboto-Bold',
                    fontSize: 50.sp,
                  ),
                  haveButton: false,
                  fingerPrintDisable: false);
              break;
            case 4:
              //touchIDNotAvailable
              DialogUtil.showDialogAuthenticateFinger(context,
                  title: "Thất bại",
                  message:
                      "Dữ liệu vân tay được cập nhật. Vui lòng đăng nhập lại với Tài khoản và Mật khẩu.",
                  styleTitle: TextStyle(
                    color: Color(0xffee8800),
                    fontFamily: 'Roboto-Bold',
                    fontSize: 50.sp,
                  ),
                  haveButton: false,
                  fingerPrintDisable: false);
              break;
          }
        }
      }
    });
  }

  void checkAuth(AppBloc appBloc,
      {bool checkFromFingerPrint = false,
      BuildContext context,
      bool fromFingerPrintAuth = false}) async {
    if (checkFromFingerPrint) {
      String userName = await SharePreferUtils.getUserName();
      String password = await SharePreferUtils.getPassword();
      if (userName == null || userName == "") {
        requestLogin();
      } else if (password == null || password == "") {
        requestLogin();
      } else {
        loginWith(context, userName, password,
            loginFromFingerPrint: fromFingerPrintAuth);
      }
    } else {
      bool isRememberPass = await SharePreferUtils.getStateRememberPass();
      if (isRememberPass) {
        String userName = await SharePreferUtils.getUserName();
        String password = await SharePreferUtils.getPassword();
        String jwt = await SharePreferUtils.getAccessToken();
        if (userName == null || userName == "") {
          requestLogin();
        } else if (password == null || password == "") {
          requestLogin();
        } else if (jwt == null || jwt == "") {
          requestLogin();
        } else {
          loginWith(context, userName, password);
        }
      } else {
        Future.delayed(Duration(seconds: 2), () {
          authStream.notify(
            AuthenticationModel(AuthState.REQUEST_LOGIN, false, null),
          );
        });
      }
    }
  }

  void logOut(BuildContext context) async {
    AppBloc appBloc = BlocProvider.of(context);
    appBloc.homeBloc.loadingStream.notify(true);
    await SharePreferUtils.removeCachedWhenLogOut();
    appBloc.homeBloc.bottomBarCurrentIndex = 2;
    appBloc.homeBloc.indexStackHome = 2;
    requestLogin();
    appBloc.homeBloc.loadingStream.notify(false);
  }

  void logOutAndReLogin(AppBloc appBloc) async {
    appBloc.homeBloc.loadingStream.notify(true);
    await SharePreferUtils.removeCachedWhenLogOut();
    appBloc.homeBloc.bottomBarCurrentIndex = 2;
    appBloc.homeBloc.indexStackHome = 2;
    appBloc.homeBloc.loadingStream.notify(false);
    authStream.notify(AuthenticationModel(AuthState.SPLASH, false, null));
  }
  void requestExitApplicationNotLogout(BuildContext context) {
    DialogUtil.showDialogProject(context,
        dialogModel: DialogModel(
            state: DialogType.AUTH,
            title: "Thoát",
            colorTitle: 0xffe10606,
            fontSizeTitle: 60,
            listRichText: [
              RichTextModel(
                  "Bạn có chắc chắn muốn thoát ứng dụng ?", 0xff333333, 50, "Roboto-Regular"),
//              RichTextModel("ứng dụng ?", 0xff005a88, 50, "Roboto-Bold"),
//              RichTextModel(" không?", 0xff333333, 50, "Roboto-Regular"),
            ],

            marginRichText: EdgeInsets.only(
              bottom: 80.5.h,
              top: 34.0.h,
              left: 120.w,
              right: 120.w,
            ),
            titleButtonFirst: "Không",
            colorButtonFirst: 0xff959ca7,
            voidCallbackButtonFirst: () {
              Navigator.pop(context);
            },
            titleButtonSecond: "Có",
            colorButtonSecond: 0xff005a88,
            voidCallbackButtonSecond: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//              appBloc.authBloc.logOut(context);
            }));
  }
}

enum FingerPrintStatusState {
  //Người dùng cập nhật vân tay mới hoặc xóa 1 vân tay
  UPADATE,
  //Lỗi tạo key xác thực
  KEYVERYFY,
  //Nếu người dùng chưa cài đặt vân tay cho ứng dụng
  HAVENFINGERPRINT,
  //Nếu người dùng chưa cài đặt khóa màn hình thì hiển thị thông báo ở đây
  HAVENLOCKSCREEN,
  //Authenticate thất bại do sai vân tay
  ERRORFINGERPRINT,
  //THÀNH CÔNG
  SUCCERFINGERPRINT,
  //Xác thực thất bại quá nhiều lần hoặc thao tác dùng vân tay bị hủy
  MULTIVERYFIFINGERPRINT,
  //None
  NONE
}

class FingerPrintStatusModel {
  FingerPrintStatusState state;
  String title;
  String message;
  bool haveButton;
  TextStyle styleTitle;
  bool fingerPrintDisable;

  FingerPrintStatusModel(this.state, this.title, this.message, this.haveButton,
      this.styleTitle, this.fingerPrintDisable);
}

enum RegisterOldValidateState { NONE, ERROR, MATCHED }
enum ForgotPassState { NONE, ERROR, SUCESS, LOADING }

class ForgotPassModel {
  ForgotPassState state;
  dynamic data;

  ForgotPassModel(this.state, this.data);
}
