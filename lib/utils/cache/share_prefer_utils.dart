import 'package:shared_preferences/shared_preferences.dart';

class Const {
  static const String ACCESS_TOKEN = "AccessToken"; //"access_token
  static const REMEMBERPASS = "rememberPass";
  static const USERNAME = "Username";
  static const PASSWORD = "Password";
  static const String chatUserNameKey = "userNameKey";
  static const String LOCALE = "LOCALE";
  static const String TOKEN = "Token";
  static const String VI = "vi";
  static const String statusFingerPrint = "statusFingerPrint";
  static const String emailKey = "emailKey";
  static const String ID = "ID";
  static const String FullName = "FullName";
  static const String lastTimeUpdateJWTKey = "lastTimeUpdateJWTKey";

}

class SharePreferUtils {
  static Future<String> getAccessToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String accessToken = pref.getString(Const.ACCESS_TOKEN);
    return accessToken ?? "";
  }

  static Future<void> saveAccessToken(String accessToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(Const.ACCESS_TOKEN, accessToken);
  }

  static Future<void> saveStateRememberPass(bool isRememberPass) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(Const.REMEMBERPASS, isRememberPass.toString());
  }

  static Future<bool> getStateRememberPass() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String remember = pref.getString(Const.REMEMBERPASS) ?? "false";
    return remember == "true";
  }

  static Future<String> getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String username = pref.getString(Const.USERNAME);
    return username;
  }

  static Future<void> saveUsername(String username) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(username);
    await pref.setString(Const.USERNAME, username);
  }

  static Future<String> getPassword() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String password = pref.getString(Const.PASSWORD);
    return password;
  }

  static Future<void> savePassword({String password}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(Const.PASSWORD, password);
  }

  static Future<void> saveLanguage(String languageCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(Const.LOCALE, languageCode);
  }

  static Future<String> getLocale() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String locale = pref.getString(Const.LOCALE) ?? Const.VI;
    return locale;
  }

  static Future<void> saveFCMToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(Const.TOKEN, token);
  }

  static Future<String> getFCMToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String fcmToken = pref.getString(Const.TOKEN) ?? "";
    return fcmToken;
  }
  static Future<String> getFullName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String fullName = pref.getString(Const.FullName) ?? "Không xác định";
    return fullName;
  }
  static Future<void> removeCachedWhenLogOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(Const.emailKey);
    await preferences.remove(Const.ID);
    await preferences.remove(Const.ACCESS_TOKEN);
    await preferences.setString(Const.REMEMBERPASS, "false");
  }

  static Future<void> saveStatusFingerPrint({ bool status}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(Const.statusFingerPrint, status.toString());
  }
  static Future<bool> getStatusFingerPrint() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String status = preferences.getString(Const.statusFingerPrint)??"false";
    return status == "true";
  }


  static Future<void> saveLastTimeUpdateJWT(int timestamp) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(Const.lastTimeUpdateJWTKey, "$timestamp");
  }

  static Future<String> getLastTimeUpdateJWT() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String time = preferences.getString(Const.lastTimeUpdateJWTKey);
    return time;
  }
  static Future<void> saveIdUser({String id}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(Const.ID, id);
  }
  static Future<void> saveFullName({String fullName}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(Const.FullName, fullName);
  }
  static Future<String> getID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String ID = preferences.getString(Const.ID);
    return ID;
  }

}
