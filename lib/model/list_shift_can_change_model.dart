// To parse this JSON data, do
//
//     final listShiftCanChange = listShiftCanChangeFromJson(jsonString);

import 'dart:convert';

ListShiftCanChange listShiftCanChangeFromJson(String str) => ListShiftCanChange.fromJson(json.decode(str));

String listShiftCanChangeToJson(ListShiftCanChange data) => json.encode(data.toJson());

class ListShiftCanChange {
  ListShiftCanChange({
    this.schedules,
  });

  List<Schedule> schedules;

  factory ListShiftCanChange.fromJson(Map<String, dynamic> json) => ListShiftCanChange(
    schedules: List<Schedule>.from(json["schedules"].map((x) => Schedule.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "schedules": List<dynamic>.from(schedules.map((x) => x.toJson())),
  };
}

class Schedule {
  Schedule({
    this.id,
    this.date,
    this.user,
    this.creator,
    this.shift,
    this.location,
    this.times,
  });

  int id;
  DateTime date;
  Creator user;
  Creator creator;
  Shift shift;
  Location location;
  List<Time> times;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json["id"],
    date: DateTime.parse(json["date"]),
    user: Creator.fromJson(json["user"]),
    creator: Creator.fromJson(json["creator"]),
    shift: Shift.fromJson(json["shift"]),
    location: Location.fromJson(json["location"]),
    times: List<Time>.from(json["times"].map((x) => Time.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "user": user.toJson(),
    "creator": creator.toJson(),
    "shift": shift.toJson(),
    "location": location.toJson(),
    "times": List<dynamic>.from(times.map((x) => x.toJson())),
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

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
    id: json["id"],
    asglId: json["asgl_id"],
    fullName: json["full_name"],
    username: json["username"],
    email: json["email"],
    positions: List<Position>.from(json["positions"].map((x) => Position.fromJson(x))),
    parentId: json["parent_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "asgl_id": asglId,
    "full_name": fullName,
    "username": username,
    "email": email,
    "positions": List<dynamic>.from(positions.map((x) => x.toJson())),
    "parent_id": parentId,
  };
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

  factory Position.fromJson(Map<String, dynamic> json) => Position(
    id: json["id"],
    name: json["name"],
    level: Level.fromJson(json["level"]),
    department: Department.fromJson(json["department"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "level": level.toJson(),
    "department": department.toJson(),
  };
}

class Department {
  Department({
    this.id,
    this.systemCode,
    this.name,
    this.shortCode,
    this.parentId,
    this.level,
    this.children,
  });

  int id;
  String systemCode;
  String name;
  String shortCode;
  int parentId;
  Level level;
  dynamic children;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    id: json["id"],
    systemCode: json["system_code"],
    name: json["name"],
    shortCode: json["short_code"],
    parentId: json["parent_id"] == null ? null : json["parent_id"],
    level: Level.fromJson(json["level"]),
    children: json["children"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "system_code": systemCode,
    "name": name,
    "short_code": shortCode,
    "parent_id": parentId == null ? null : parentId,
    "level": level.toJson(),
    "children": children,
  };
}

class Level {
  Level({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Level.fromJson(Map<String, dynamic> json) => Level(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Location {
  Location({
    this.id,
    this.name,
    this.shortCode,
    this.active,
    this.department,
  });

  int id;
  String name;
  String shortCode;
  bool active;
  Department department;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"],
    name: json["name"],
    shortCode: json["short_code"],
    active: json["active"],
    department: Department.fromJson(json["department"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "short_code": shortCode,
    "active": active,
    "department": department.toJson(),
  };
}

class Shift {
  Shift({
    this.id,
    this.name,
    this.shortName,
    this.typeId,
    this.creator,
    this.status,
    this.breaksTime,
    this.mainMeal,
    this.sideMeal,
    this.lateWork,
    this.leaveEarly,
    this.workTimes,
  });

  int id;
  String name;
  String shortName;
  String typeId;
  Creator creator;
  String status;
  int breaksTime;
  int mainMeal;
  int sideMeal;
  int lateWork;
  int leaveEarly;
  List<WorkTime> workTimes;

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
    id: json["id"],
    name: json["name"],
    shortName: json["short_name"],
    typeId: json["type_id"],
    creator: Creator.fromJson(json["creator"]),
    status: json["status"],
    breaksTime: json["breaks_time"],
    mainMeal: json["main_meal"],
    sideMeal: json["side_meal"],
    lateWork: json["late_work"],
    leaveEarly: json["leave_early"],
    workTimes: List<WorkTime>.from(json["workTimes"].map((x) => WorkTime.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "short_name": shortName,
    "type_id": typeId,
    "creator": creator.toJson(),
    "status": status,
    "breaks_time": breaksTime,
    "main_meal": mainMeal,
    "side_meal": sideMeal,
    "late_work": lateWork,
    "leave_early": leaveEarly,
    "workTimes": List<dynamic>.from(workTimes.map((x) => x.toJson())),
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

  factory WorkTime.fromJson(Map<String, dynamic> json) => WorkTime(
    id: json["id"],
    startAt: json["start_at"],
    finishAt: json["finish_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "start_at": startAt,
    "finish_at": finishAt,
  };
}

class Time {
  Time({
    this.id,
    this.startAt,
    this.finishAt,
    this.inEvent,
    this.outEvent,
  });

  int id;
  At startAt;
  At finishAt;
  List<dynamic> inEvent;
  List<dynamic> outEvent;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
    id: json["id"],
    startAt: At.fromJson(json["start_at"]),
    finishAt: At.fromJson(json["finish_at"]),
    inEvent: List<dynamic>.from(json["inEvent"].map((x) => x)),
    outEvent: List<dynamic>.from(json["outEvent"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "start_at": startAt.toJson(),
    "finish_at": finishAt.toJson(),
    "inEvent": List<dynamic>.from(inEvent.map((x) => x)),
    "outEvent": List<dynamic>.from(outEvent.map((x) => x)),
  };
}

class At {
  At({
    this.date,
    this.timezoneType,
    this.timezone,
  });

  DateTime date;
  int timezoneType;
  String timezone;

  factory At.fromJson(Map<String, dynamic> json) => At(
    date: DateTime.parse(json["date"]),
    timezoneType: json["timezone_type"],
    timezone: json["timezone"],
  );

  Map<String, dynamic> toJson() => {
    "date": date.toIso8601String(),
    "timezone_type": timezoneType,
    "timezone": timezone,
  };
}
