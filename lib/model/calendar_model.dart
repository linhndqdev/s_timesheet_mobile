import 'package:intl/intl.dart';

class CalendarModel {
  int id;
  String date;
  Creator user;
  Creator creator;
  Shift shift;
  String status;
  LocationWithDepartment location;
  List<Time> times;

  CalendarModel();

  CalendarModel.create(this.id, this.date, this.user, this.creator, this.shift,
      this.status,
      this.location, this.times);

  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    Creator user = Creator();
    if (json.containsKey('user') &&
        json['user'] != null &&
        json['user'] != "") {
      user = Creator.fromJson(json['user']);
    }
    Creator creator = Creator();
    if (json.containsKey('creator') &&
        json['creator'] != null &&
        json['creator'] != "") {
      creator = Creator.fromJson(json['creator']);
    }
    Shift shift = Shift();
    if (json.containsKey('shift') &&
        json['shift'] != null &&
        json['shift'] != "") {
      shift = Shift.fromJson(json['shift']);
    }
    LocationWithDepartment locationWithDepartment = LocationWithDepartment();
    if (json.containsKey('location') &&
        json['location'] != null &&
        json['location'] != "") {
      locationWithDepartment =
          LocationWithDepartment.fromJson(json['location']);
    }
    List<Time> times = List();
    if (json.containsKey('times') &&
        json['times'] != null &&
        json['times'] != "") {
      Iterable i = json['times'];
      if (i != null && i.length > 0) {
        times = i.map((data) => Time.fromJson(data)).toList();
      }
    }
    return CalendarModel.create(
        json['id'],
        json['date'],
        user,
        creator,
        shift,
        json['status'] ??= "",
        locationWithDepartment, times);
  }

  getInTime() {
    if (this.times != null && this.times.length > 0) {
      if (this.times[0].inEvent != null &&
          this.times[0].inEvent.check_at != null) {
        try {
          DateTime dateTime =
          DateTime.parse(this.times[0].inEvent?.check_at?.date);
          DateFormat format = DateFormat("HH:mm");
          return format.format(dateTime);
        } catch (ex) {
          return "Không xác định";
        }
      } else {
        return "Không xác định";
      }
    }
    return "Không xác định";
  }

  getOutTime() {
    if (this.times != null && this.times.length > 0) {
      if (this.times[0].outEvent != null &&
          this.times[0].outEvent?.check_at != null) {
        try {
          DateTime dateTime =
          DateTime.parse(this.times[0].outEvent?.check_at?.date);
          DateFormat format = DateFormat("HH:mm");
          return format.format(dateTime);
        } catch (ex) {
          return "Không xác định";
        }
      } else {
        return "Không xác định";
      }
    }
    return "Không xác định";
  }

  getLocation() {
    if (this.location != null &&
        this.location.name != null &&
        this.location.name != "") {
      return this.location.name;
    } else {
      return "Không xác định";
    }
  }

  getDate() {
    if (this.date != null && this.date != "") {
      try {
        DateTime dateTime = DateTime.parse(this.date);
        DateFormat dateFormat = DateFormat("dd-MM-yyyy");
        return dateFormat.format(dateTime);
      } catch (ex) {
        return "--:--:--";
      }
    } else {
      return "--:--:--";
    }
  }
}

class Shift {
  int id;
  String name;
  String short_name;
  String type_id;
  Creator creator;
  String status;
  int breaks_time;
  int main_meal;
  int side_meal;
  int late_work;
  int leave_early;
  List<WorkTime> workTimes;

  Shift();

  Shift.create(this.id,
      this.name,
      this.short_name,
      this.type_id,
      this.creator,
      this.status,
      this.breaks_time,
      this.main_meal,
      this.side_meal,
      this.late_work,
      this.leave_early,
      this.workTimes);

  factory Shift.fromJson(Map<String, dynamic> json) {
    Creator creator = Creator();
    if (json.containsKey('creator') &&
        json['creator'] != null &&
        json['creator'] != "") {
      creator = Creator.fromJson(json['creator']);
    }
    List<WorkTime> workTimes = List();
    if (json.containsKey('workTimes') != null &&
        json['workTimes'] != null &&
        json['workTimes'] != "") {
      Iterable i = json['workTimes'];
      if (i != null && i.length > 0) {
        workTimes = i.map((data) => WorkTime.fromJson(data)).toList();
      }
    }
    return Shift.create(
        json['id'],
        json['name'],
        json['short_name'],
        json['type_id'],
        creator,
        json['status'],
        json['breaks_time'],
        json['main_meal'],
        json['side_meal'],
        json['late_work'],
        json['leave_early'],
        workTimes);
  }
}

class Position {
  Position({
    this.id,
    this.name,
    this.level,
    this.department,
  });

  int id;
  String name;
  Level level;
  Department department;

  factory Position.fromJson(Map<String, dynamic> json) {
    Level level;
    if (json.containsKey("level") &&
        json['level'] != null &&
        json['level'] != "") {
      level = Level.fromJson(json['level']);
    }
    Department department;
    if (json.containsKey("department") &&
        json['department'] != null &&
        json['department'] != "") {
      department = Department.fromJson(json['department']);
    }
    return Position(
      id: json["id"] == null ? null : json["id"],
      name: json["name"] == null ? null : json["name"],
      level: level,
      department: department,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "id": this.id,
        "name": this.name,
        "level": this.level,
        "department": this.department,
      };
}

class Creator {
  Creator({
    this.id,
    this.asglId,
    this.fullName,
    this.username,
    this.email,
    this.positions,
    this.parentId,
  });

  int id;
  String asglId;
  String fullName;
  String username;
  String email;
  List<Position> positions;
  dynamic parentId;

  factory Creator.fromJson(Map<String, dynamic> json) =>
      Creator(
        id: json["id"] == null ? null : json["id"],
        asglId: json["asgl_id"] == null ? null : json["asgl_id"],
        fullName: json["full_name"] == null ? null : json["full_name"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        positions: json["positions"] == null
            ? null
            : List<Position>.from(
            json["positions"].map((x) => Position.fromJson(x))),
        parentId: json["parent_id"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id == null ? null : id,
        "asgl_id": asglId == null ? null : asglId,
        "full_name": fullName == null ? null : fullName,
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "positions": positions == null
            ? null
            : List<dynamic>.from(positions.map((x) => x.toJson())),
        "parent_id": parentId,
      };
}

class WorkTime {
  WorkTime({
    this.id,
    this.startAt,
    this.finishAt,
  });

  int id;
  String startAt;
  String finishAt;

  factory WorkTime.fromJson(Map<String, dynamic> json) =>
      WorkTime(
        id: json["id"] == null ? null : json["id"],
        startAt: json["start_at"] == null ? null : json["start_at"],
        finishAt: json["finish_at"] == null ? null : json["finish_at"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id == null ? null : id,
        "start_at": startAt == null ? null : startAt,
        "finish_at": finishAt == null ? null : finishAt,
      };
}

class LocationWithDepartment {
  int id;
  String name;
  String short_code;
  bool active;
  Department department;

  LocationWithDepartment();

  LocationWithDepartment.create(this.id, this.name, this.short_code,
      this.active, this.department);

  factory LocationWithDepartment.fromJson(Map<String, dynamic> json) {
    Department department = Department();
    if (json.containsKey('department') != null &&
        json['department'] != null &&
        json['department'] != "") {
      department = Department.fromJson(json['department']);
    }
    return LocationWithDepartment.create(json['id'], json['name'],
        json['short_code'], json['active'], department);
  }
}

class Department {
  int id;
  String system_code;
  String name;
  String short_code;
  dynamic parent_id;
  Level level;
  dynamic children;

  Department();

  Department.create(this.id, this.system_code, this.name, this.short_code,
      this.parent_id, this.level, this.children);

  factory Department.fromJson(Map<String, dynamic> json) {
    Level level = Level();
    if (json.containsKey('level') &&
        json['level'] != null &&
        json['level'] != "") {
      level = Level.fromJson(json['level']);
    }
    return Department.create(
        json['id'],
        json['system_code'],
        json['name'],
        json['short_code'],
        json['parent_id'],
        level,
        json['children']);
  }
}

class Level {
  int id;
  String name;

  Level();

  Level.create(this.id, this.name);

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level.create(json['id'], json['name']);
  }
}

class Time {
  int id;
  TimeZone start_at;
  TimeZone finish_at;
  InOutEvent inEvent;
  InOutEvent outEvent;

  Time();

  Time.create(this.id, this.start_at, this.finish_at, this.inEvent,
      this.outEvent);

  factory Time.fromJson(Map<String, dynamic> json) {
    TimeZone start_at = TimeZone();
    if (json.containsKey('start_at') &&
        json['start_at'] != null &&
        json['start_at'] != "") {
      start_at = TimeZone.fromJson(json['start_at']);
    }
    TimeZone finish_at = TimeZone();
    if (json.containsKey('finish_at') &&
        json['finish_at'] != null &&
        json['finish_at'] != "") {
      finish_at = TimeZone.fromJson(json['finish_at']);
    }
    InOutEvent inEvent = InOutEvent();
    if (json.containsKey('inEvent') &&
        json['inEvent'] != null &&
        json['inEvent'] != "") {
      try {
        inEvent = InOutEvent.fromJson(json['inEvent']);
      } catch (ex) {}
    }
    InOutEvent outEvent = InOutEvent();
    if (json.containsKey('outEvent') &&
        json['outEvent'] != null &&
        json['outEvent'] != "") {
      try {
        outEvent = InOutEvent.fromJson(json['outEvent']);
      } catch (ex) {}
    }

    return Time.create(json['id'], start_at, finish_at, inEvent, outEvent);
  }
}

class InOutEvent {
  int id;
  int user_id;
  String asgl_id;
  String type;
  String method;
  TimeZone check_at;
  Location location;
  String image;

  InOutEvent();

  InOutEvent.createAt(this.id, this.user_id, this.asgl_id, this.type,
      this.method, this.check_at, this.location, this.image);

  factory InOutEvent.fromJson(Map<String, dynamic> json) {
    Location location = Location();
    if (json.containsKey("location") &&
        json['location'] != null &&
        json['location'] != "") {
      location = Location.fromjson(json['location']);
    }

    TimeZone checkAt = TimeZone();
    if (json.containsKey('check_at') &&
        json['check_at'] != null &&
        json['check_at'] != "") {
      checkAt = TimeZone.fromJson(json['check_at']);
    }
    return InOutEvent.createAt(
        json['id'],
        json['user_id'],
        json['asgl_id'],
        json['type'],
        json['method'],
        checkAt,
        location,
        json['image']);
  }
}

class TimeZone {
  String date;
  int timezone_type;
  String timezone;

  TimeZone.create(this.date, this.timezone_type, this.timezone);

  TimeZone();

  factory TimeZone.fromJson(Map<String, dynamic> json) {
    return TimeZone.create(
        json['date'], json['timezone_type'], json['timezone']);
  }
}

class Location {
  String name;
  String latitude;
  String longitude;

  Location.create(this.name, this.latitude, this.longitude);

  Location();

  factory Location.fromjson(Map<String, dynamic> json) {
    String lat = "0.0";
    String lon = "0.0";
    if (json.containsKey("coordinate") &&
        json['coordinate'] != null &&
        json['coordinate'] != "") {
      dynamic coordinate = json['coordinate'];
      if (coordinate.containsKey('latitude') &&
          coordinate['latitude'] != null &&
          coordinate['latitude'] != "") {
        lat = coordinate['latitude'];
      }
      if (coordinate.containsKey('longitude') &&
          coordinate['longitude'] != null &&
          coordinate['longitude'] != "") {
        lon = coordinate['longitude'];
      }
    }
    return Location.create(json['name'], lat, lon);
  }
}
