class AttendanceModel {
  int id;
  String asgl_id;
  String type;
  TimeModel check_at;
  LocationCheck location;
  String image;

  AttendanceModel(this.id, this.asgl_id, this.type, this.check_at,
      this.location, this.image);

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    TimeModel checkAt;
    if (json['check_at'] != null && json['check_at'] != "") {
      checkAt = TimeModel.fromJson(json['check_at']);
    }
    LocationCheck locationCheck;
    if (json['location'] != null && json['location'] != "") {
      locationCheck = LocationCheck.fromJson(json['location']);
    }
    String image = "";
    if (json['image'] != null && json['image'] != "") {
      image = json['image'];
    }
    return AttendanceModel(json['id'], json['asgl_id'], json['type'], checkAt,
        locationCheck, image);
  }
}

class TimeModel {
  String date;
  int timezone_type;
  String timezone;

  TimeModel();

  TimeModel.createWith(this.date, this.timezone_type, this.timezone);

  factory TimeModel.fromJson(Map<String, dynamic> json) {
    return TimeModel.createWith(
        json['date'], json['timezone_type'] ?? 0, json['timezone'] ?? "UTC");
  }
}

class LocationCheck {
  String name;
  String latitude;
  String longitude;

  LocationCheck();

  LocationCheck.createWith(this.name, this.latitude, this.longitude);

  factory LocationCheck.fromJson(Map<String, dynamic> json) {
    String lat = "";
    String lon = "";
    try {
      if (json['coordinate'] != null && json['coordinate'] != "") {
        lat = json['coordinate']['latitude'] ?? "";
        lon = json['coordinate']['longitude'] ?? "";
      }
    } catch (ex) {
      print(ex.toString());
    }
    return LocationCheck.createWith(json['name'], lat, lon);
  }
}
