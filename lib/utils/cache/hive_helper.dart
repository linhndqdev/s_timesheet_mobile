import 'package:hive/hive.dart';

class HiveHelper {
  static HiveHelper _instance;

  HiveHelper._internal();

  static HiveHelper getInstance() {
    if (_instance == null) {
      _instance = HiveHelper._internal();
    }
    return _instance;
  }
}
