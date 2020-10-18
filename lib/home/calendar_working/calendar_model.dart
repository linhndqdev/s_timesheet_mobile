import 'package:intl/intl.dart';

class CalendarModel {
  DateTime ngay;
  String Location;
  String Checkin;
  String Checkout;
  String Note;

  CalendarModel(
      {this.ngay, this.Location, this.Checkin, this.Checkout, this.Note});
}
