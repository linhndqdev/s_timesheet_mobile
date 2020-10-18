import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:s_timesheet_mobile/core/crypto/rsa_crypto.dart';
import 'package:s_timesheet_mobile/utils/cache/share_prefer_utils.dart';

//import 'package:hrm/core/core.dart';
//import 'package:hrm/utils/preference_utils.dart';

enum QrCodeStateData { INPUT, OUTPUT, NONE }

class QrCodeHelper {
  ///Get Unix TimeStamp
  int getCurrentTimeStampUnix() {
    DateTime dateTime = DateTime.now();
//    debugPrint("Time GenQrCode: ${dateTime.toIso8601String()}");
    int timeStamp = dateTime.millisecondsSinceEpoch;
//    debugPrint("Timestamp: $timeStamp");
    return timeStamp;
  }

  Map<String, String> timeStampRounding(int timeStamp) {
    String checkTimeStamp = timeStamp.toString();
    //Lấy ra 4 ký tự cuối trong timeStamp
    Map<String, String> mapResult = Map();
    String fourCharLastTimeStamp = checkTimeStamp.substring(
        checkTimeStamp.length - 4, checkTimeStamp.length);
    String timeC1 = "";
    String timeC2 = "";
    if (int.parse(fourCharLastTimeStamp) < 5000) {
      timeC1 = checkTimeStamp.replaceRange(
          checkTimeStamp.length - 4, checkTimeStamp.length, "0000");
      timeC2 = checkTimeStamp.replaceRange(
          checkTimeStamp.length - 4, checkTimeStamp.length, "5000");
    } else {
      timeC1 = checkTimeStamp.replaceRange(
          checkTimeStamp.length - 4, checkTimeStamp.length, "5000");
      String newTimeStamp = checkTimeStamp.replaceRange(
          checkTimeStamp.length - 4, checkTimeStamp.length, "5000");
      int x = int.parse(newTimeStamp) + 5000;
      timeC2 = x.toString();
    }
    mapResult["c1"] = timeC1;
    mapResult["c2"] = timeC2;
    return mapResult;
  }

  ///Gen String input of QrCode
  ///[userID] Chỉ lấy phần số đằng sau của ASGL ID. Ví dụ: asgl-0228 -> [userID] = 228
  Future<Map<dynamic, String>> genQrCodeInputData() async {
    ///Lấy ra asgl-id
    String userID = await getUserID();

    ///Lấy ra Unix TimeStamp tại thời điểm gọi
    int timeStamp = getCurrentTimeStampUnix();

    ///Làm tròn Unix TimeStamp đến 5s
    Map<String, String> mapRounding = timeStampRounding(timeStamp);

    ///Lấy ra c1 timestamp sau khi làm tròn xuống
    String timeC1 = mapRounding['c1'];
//    debugPrint("TimeStamp đã làm tròn: $timeC1");
    ///Lấy ra c2 timestamp sau khi làm tròn lên
    String timeC2 = mapRounding['c2'];
//    debugPrint("TimeStamp đã làm tròn: $timeC2");
    //Tính b theo công thức ( b * 18 + 4 )
    int b = int.parse(userID);
    int bConverted = b * 18 + 4;
//    print("B: $b");

    ///Lấy ra MD5 của userID

    String c1 = timeC1 + " " + convertBData(bConverted);
//    print("C1: $c1");

    String c2 = timeC2 + " " + convertBData(bConverted);
//    print("C2: $c2");

    String input =
        finalJoin(state: 0, bMD5: b.toString(), c1MD5: c1, c2MD5: c2);
//    print(input);
    String output =
        finalJoin(state: 1, bMD5: b.toString(), c1MD5: c1, c2MD5: c2);
//    print(output);
    String inEncrypt = await Crypto.endCryptData(textDataToEncrypt: input);
//    print("In: $inEncrypt");
    String outEncrypt = await Crypto.endCryptData(textDataToEncrypt: output);
//    print("Out: $outEncrypt");

    Map<dynamic, String> mapDataResult = Map();
    mapDataResult[QrCodeStateData.INPUT] = inEncrypt;
    mapDataResult[QrCodeStateData.OUTPUT] = outEncrypt;
    mapDataResult[3] = input;
    mapDataResult[4] = output;
    return mapDataResult;
  }

  ///Khởi tạo final MD5 theo trạng thái
  ///[state] có 2 trạng thái tương ứng là 0: Vào và 1: Ra
  String finalJoin({int state, String bMD5, String c1MD5, String c2MD5}) {
    return "$state&$bMD5&$c1MD5&$c2MD5";
  }

  ///Convert b về định dạng 6 ký tự
  String convertBData(int b) {
    String data = "";
    if (b <= 9) {
      data = "00000$b";
    } else if (b <= 99) {
      data = "0000$b";
    } else if (b <= 999) {
      data = "000$b";
    } else if (b <= 9999) {
      data = "00$b";
    } else if (b <= 99999) {
      data = "0$b";
    } else {
      data = "$b";
    }
    return data;
  }

  //Lấy ra phần số trong asgl-id
  Future<String> getUserID() async {
    String asglID = await SharePreferUtils.getUserName();
    List<String> listData = asglID.split("-");
    return listData[1];
  }
}
