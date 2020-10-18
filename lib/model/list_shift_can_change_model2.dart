class Location {
  int id;
  String name;
  String shortCode;
  bool active;
}

class LocationDepartment {
  int id;
  String systemCode;
  String name;
  String shortCode;
  String parentId;
  DepartmentLevel level;

  LocationDepartment();

  LocationDepartment.create(
      {this.id,
      this.name,
      this.shortCode,
      this.systemCode,
      this.parentId,
      this.level});

  factory LocationDepartment.fromJson(Map<String, dynamic> json) {
    DepartmentLevel level = DepartmentLevel();

    if (json.containsKey('level') && json['level'] != null) {
      level = DepartmentLevel.fromJson(json['level']);
    }

    return LocationDepartment.create(
        id: json['id'],
        name: json['name'],
        level: level,
        parentId: json['parent_id'],
        shortCode: json['short_code'],
        systemCode: json['system_code']);
  }
}

class DepartmentLevel {
  int id;
  String name;

  DepartmentLevel();

  DepartmentLevel.create({this.id, this.name});

  factory DepartmentLevel.fromJson(Map<String, dynamic> json) {
    int id;
    String name;
    if (json.containsKey('name') && json['name'] != null && json[id] != "") {
      name = json['name'];
    }
    if (json.containsKey('id') && json['id'] != null && json[id] != "") {
      id = json['id'];
    }
    return DepartmentLevel.create(id: id, name: name);
  }
}

//-----------------------------------------------------------------------
class Times {
  int id;
  TimesAt startAt;
  TimesAt finishAt;
  dynamic inEvent;
  dynamic outEvent;

  Times();

  Times.create(
      {this.id, this.startAt, this.finishAt, this.inEvent, this.outEvent});

  factory Times.fromJson(Map<String, dynamic> json) {
    int id;
    TimesAt startAt = TimesAt();
    TimesAt finishAt = TimesAt();
    dynamic inEvent;
    dynamic outEvent;
    if (json.containsKey('id') && json['id'] != null && json['id'] != "") {
      id = json['id'];
    }
    if (json.containsKey('start_at') && json['start_at'] != null) {
      startAt = TimesAt.fromJson(json['start_at']);
    }
    if (json.containsKey('finish_at') && json['finish_at'] != null) {
      finishAt = TimesAt.fromJson(json['finish_at']);
    }
    if (json.containsKey('inEvent') && json['inEvent'] != null) {
      inEvent = json['inEvent'];
    }
    if (json.containsKey('outEvent') && json['outEvent'] != null) {
      outEvent = json['outEvent'];
    }
    return Times.create(
        id: id,
        startAt: startAt,
        finishAt: finishAt,
        inEvent: inEvent,
        outEvent: outEvent);
  }
}

class TimesAt {
  DateTime date;
  int timezoneType;
  String timezone;

  TimesAt();

  TimesAt.create({this.date, this.timezoneType, this.timezone});

  factory TimesAt.fromJson(Map<String, dynamic> json) {
    //DateTime.parse
    DateTime date;
    int timeZoneType;
    String timezone;
    if (json.containsKey('date') &&
        json['date'] != null &&
        json['date'] != "") {
      date = DateTime.parse(json['date']);
    }
    if (json.containsKey('timezone_type') &&
        json['timezone_type'] != null &&
        json['timezone_type'] != "") {
      timeZoneType = json['date'];
    }
    if (json.containsKey('timezone') &&
        json['timezone'] != null &&
        json['timezone'] != "") {
      timezone = json['timezone'];
    }
    return TimesAt.create(
        date: date, timezone: timezone, timezoneType: timeZoneType);
  }
}
