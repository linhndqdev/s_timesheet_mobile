enum Environment { DEV, TEST, PROD }

class Constant {
  static Map<String, dynamic> _config;
  static Environment _environment;
  static int TIME_OUT = 10;

  static get ENVIRONMENT => _environment;

  static void setEnvironment(Environment env) {
    _environment = env;
    switch (env) {
      case Environment.DEV:
        _config = _Config.debugConstants;
        break;
      case Environment.PROD:
        _config = _Config.prodConstants;
        break;
      case Environment.TEST:
        _config = _Config.testConstants;
        break;
    }
  }

  static get SERVER_BASE => _config[_Config.SERVER_BASE];

  static get SERVER_BASE_NO_HTTP => _config[_Config.SERVER_BASE_NO_HTTP];

  static get SERVER_WORK_SCHEDULE => _config[_Config.SERVER_WORK_SCHEDULE];

  static get SERVER_WORK_SCHEDULE_NO_HTTP =>
      _config[_Config.SERVER_WORK_SCHEDULE_NO_HTTP];

  static get SERVER_CHAT => _config[_Config.SERVER_CHAT];
}

class _Config {
  static const SERVER_BASE = "SERVER_BASE";
  static const SERVER_BASE_NO_HTTP = "SERVER_BASE_NO_HTTP";
  static const SERVER_WORK_SCHEDULE = "SERVER_WORK_SCHEDULE";
  static const SERVER_WORK_SCHEDULE_NO_HTTP = "SERVER_WORK_SCHEDULE_NO_HTTP";
  static const SERVER_CHAT = "SERVER_CHAT";

  static Map<String, dynamic> debugConstants = {
    SERVER_BASE: "https://id-dev.asgl.net.vn",
    SERVER_BASE_NO_HTTP: "id-dev.asgl.net.vn",
    SERVER_WORK_SCHEDULE: "http://work-schedule-dev.asgl.net.vn",
    SERVER_WORK_SCHEDULE_NO_HTTP: "work-schedule-dev.asgl.net.vn",
    SERVER_CHAT: "http://chattest.asgl.net.vn",
  };

  static Map<String, dynamic> testConstants = {
    SERVER_BASE: "https://id-dev.asgl.net.vn",
    SERVER_BASE_NO_HTTP: "id-dev.asgl.net.vn",
    SERVER_WORK_SCHEDULE: "http://work-schedule-dev.asgl.net.vn",
    SERVER_WORK_SCHEDULE_NO_HTTP: "work-schedule-dev.asgl.net.vn",
    SERVER_CHAT: "https://chattest.asgl.net.vn",
  };

  static Map<String, dynamic> prodConstants = {
    SERVER_BASE: "https://id.asgl.net.vn",
    SERVER_BASE_NO_HTTP: "id.asgl.net.vn",
    SERVER_WORK_SCHEDULE: "http://work-schedule.asgl.net.vn",
    SERVER_WORK_SCHEDULE_NO_HTTP: "work-schedule.asgl.net.vn",
    SERVER_CHAT: "https://chatplatform.asgl.net.vn",
  };
}
