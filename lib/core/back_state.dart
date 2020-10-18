import 'package:core_asgl/core_asgl.dart';
import 'package:flutter/cupertino.dart';
//WillPopScope(
//onWillPop: () async {
//if (widget.appBloc.backStateBloc.focusWidgetModel.state ==
//isFocusWidget.CHOOSE_MONTH) {
//widget.appBloc.statisticBloc.showMonthSelectStream
//    .notify(ShowChooseMonthModel(state: widget.state, isShow: false));
//} else {
//return true;
//}
//return false;
//Hướng dẫn:
//vòng if đầu tiên là check state hiện tại, trong hàm if là hàm quay trở lại, có thể đặt ở chính trang con luôn
//vòng else return true: nghĩa là nếu vào đấy thì bỏ qua vòng back này, để nhảy sang 1 onwillpopscope khác, nó sẽ nhảy từng vòng một từ ngoài vào trong, nếu trúng vòng if nào thì sẽ thực thi
//còn không sẽ return true ở vòng else của các onwillpopscrope

//return false dưới cùng. Chỗ này tức là sẽ đặt ở vòng sau cùng, tứ là không còn gì nữa, thì sẽ bị hạ ứng dụng xuống.
//khi load mỗi  page con thì phải set state cho nó ở mỗi page
//muốn back lại trang trước thì gọi hàm close ở mỗi trang con tại onwillpop, sau đó set trang thái về trang muốn quay về.

enum isFocusWidget {
  SPLASH,
  HOME, //đây là trạng thái trang home, khi ở 4 tab cũng đều là home, tại home ấn back sẽ hiện thông báo.
  LOGIN,
  FORGOT_PASSWORD,
  DRAWER,
  EVENT,
  REQUEST_OFF_SHIFT,
  DETAIL_SHIFT,
  SWITCH_SHIFT,
  CHOOSE_SHIFT,
  LOCATION,
  QR,
  OPEN_CAMERA,
  PREVIEW_PICTURE,
  CHOOSE_MONTH
}

class FocusWidgetModel {
  isFocusWidget state;

  FocusWidgetModel({this.state});
}

class BackStateBloc {
  FocusWidgetModel focusWidgetModel =
      FocusWidgetModel(state: isFocusWidget.HOME);
  static BackStateBloc _instance;

  BackStateBloc._internal() {
    focusWidgetModel = FocusWidgetModel(state: isFocusWidget.HOME);
  }

  static BackStateBloc getInstance() {
    if (_instance == null) {
      _instance = BackStateBloc._internal();
    }
    return _instance;
  }

  CoreStream hideLayoutWithStream;
  void setStateToHome(){
    focusWidgetModel =
        FocusWidgetModel(state: isFocusWidget.HOME);
  }
  void setStateToOther({@required isFocusWidget state}){
    focusWidgetModel =
        FocusWidgetModel(state: state);
  }
}
