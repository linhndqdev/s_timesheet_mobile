class SocketHelper {
  static SocketHelper _instance;

  SocketHelper._internal();

  static SocketHelper getInstance() {
    if (_instance == null) {
      _instance = SocketHelper._internal();
    }
    return _instance;
  }
}
