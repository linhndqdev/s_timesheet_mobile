import 'package:intl/intl.dart';

class DateTimeUtils {
  static Map<int, String> getFirstDateAndLastDate(DateTime dateTime) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    String startDate = "";
    String endDate = "";
    DateTime lastDayOfMonth =
        new DateTime(dateTime.year, dateTime.month + 1, 0);
    DateTime firstDateOfMonth = DateTime(dateTime.year, dateTime.month, 1);
    startDate = format.format(firstDateOfMonth);
    endDate = format.format(lastDayOfMonth);
    return {0: startDate, 1: endDate};
  }

  static String convertDate(DateTime dateTime){
    DateFormat format = DateFormat("yyyy-MM-dd");
    return format.format(dateTime);
  }
  static String convertDate2(DateTime dateTime){
    DateFormat format = DateFormat("dd-MM-yyyy");
    return format.format(dateTime);
  }
  static String convertDate3(DateTime dateTime){
    DateFormat format = DateFormat("dd/MM/yyyy");
    return format.format(dateTime);
  }
  static String convertMonthYear(DateTime dateTime){
    DateFormat format = DateFormat("MM/yyyy");
    return format.format(dateTime);
  }
  static String convertTime(DateTime dateTime){
    DateFormat format = DateFormat("HH:mm");
    return format.format(dateTime);
  }
}
