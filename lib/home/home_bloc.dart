import 'dart:io';

import 'package:core_asgl/core_asgl.dart';
import 'package:flutter/material.dart';
import 'package:s_timesheet_mobile/core/platform/platform_helper.dart';
import 'package:s_timesheet_mobile/home/home_index_stack_model.dart';
import 'package:s_timesheet_mobile/utils/cache/share_prefer_utils.dart';

enum OtherLayoutState { NONE, CAMERA, IMAGE_SHOW, PREVIEW_IMAGE }

class OtherLayoutModelStream {
  OtherLayoutState state;
  dynamic data;

  OtherLayoutModelStream(this.state, this.data);
}

class HomeBloc {
  AnimationController animationController;
  CoreStream<OtherLayoutModelStream> showOtherLayoutStream = CoreStream();
  CoreStream<int> bottomBarStream = CoreStream();
  CoreStream<HomeIndexStackModel> homeIndexStackStream = CoreStream();
  CoreStream<bool> loadingStream = CoreStream();

  int bottomBarCurrentIndex = 2;
  int indexStackHome = 2;

  void disableWithAnimation(VoidCallback voidCallback){
    animationController.reverse();
    Future.delayed(Duration(milliseconds: 500), () {
      voidCallback();
    });
  }

  void clickItemBottomBar(int index) async {
    if (bottomBarCurrentIndex == index) {
      return;
    }
    bottomBarCurrentIndex = index;
    bottomBarStream.notify(index);
    if (index == 0) {
      changeIndexStackHome(0);
    } else if (index == 1) {
      changeIndexStackHome(1);
    } else if (index == 2) {
      changeIndexStackHome(2);
    } else if (index == 3) {
      changeIndexStackHome(3);
    } else if (index == 4) {
      changeIndexStackHome(4);
    }
  }

  void changeIndexStackHome(
    int indexStack,
  ) {
    if (indexStack == 0) {
      indexStackHome = 0;
      HomeIndexStackModel _indexModel = HomeIndexStackModel(
        indexStack: indexStack,
      );
      homeIndexStackStream?.notify(_indexModel);
    } else if (indexStack == 1) {
      indexStackHome = 1;
      HomeIndexStackModel _indexModel = HomeIndexStackModel(
        indexStack: indexStack,
      );
      homeIndexStackStream?.notify(_indexModel);
    } else if (indexStack == 2) {
      indexStackHome = 2;
      HomeIndexStackModel _indexModel = HomeIndexStackModel(
        indexStack: indexStack,
      );
      homeIndexStackStream?.notify(_indexModel);
    } else if (indexStack == 3) {
      indexStackHome = 3;
      HomeIndexStackModel _indexModel = HomeIndexStackModel(
        indexStack: indexStack,
      );
      homeIndexStackStream?.notify(_indexModel);
    } else if (indexStack == 4) {
      indexStackHome = 4;
      HomeIndexStackModel _indexModel = HomeIndexStackModel(
        indexStack: indexStack,
      );
      homeIndexStackStream?.notify(_indexModel);
    } else {
      clickItemBottomBar(5);
      indexStackHome = 5;
      HomeIndexStackModel _indexModel = HomeIndexStackModel(
        indexStack: indexStack,
      );
      homeIndexStackStream?.notify(_indexModel);
    }
  }

  void updateOtherLayout(OtherLayoutState state, {dynamic data}) {
    OtherLayoutModelStream stream = OtherLayoutModelStream(state, data);
    showOtherLayoutStream?.notify(stream);
  }

  void checkAndOpenAppWithPackageName(
      BuildContext context, String pkNameAndroid, String urlSchemeIOS) async {
    if (Platform.isAndroid) {
      bool isInstalledApplication =
          await PlatformHelper.checkAppInstalled(packageName: pkNameAndroid);
      if (isInstalledApplication) {
        String jwt = await SharePreferUtils.getAccessToken();
        if (jwt != null && jwt != "") {
          String userName = await SharePreferUtils.getUserName();
          String password = await SharePreferUtils.getPassword();
          PlatformHelper.openAppWithPackageName(
              packageName: pkNameAndroid,
              jwt: jwt,
              userName: userName,
              password: password);
        } else {
          //Không có jwt
          // AppBloc appBloc = BlocProvider.of(context);
//          appBloc.authBloc.logOut(context);
        }
      } else {
        Toast.showShort("Ứng dụng chưa được cài đặt.");
        //Đưa lên ChPlay để tải ứng dụng
      }
    } else if (Platform.isIOS) {
      String jwt = await SharePreferUtils.getAccessToken();
      if (jwt != null && jwt != "") {
        String userName = await SharePreferUtils.getUserName();
        String password = await SharePreferUtils.getPassword();
        PlatformHelper.openIOSAppWithData(
            urlScheme: urlSchemeIOS,
            jwt: jwt,
            userName: userName,
            password: password);
      } else {
        //Không có jwt
        //AppBloc appBloc = BlocProvider.of(context);
//        appBloc.authBloc.logOut(context);
      }
    }
  }
}
