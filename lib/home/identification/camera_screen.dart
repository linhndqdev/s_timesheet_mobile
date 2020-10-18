import 'package:camera/camera.dart';
import 'package:core_asgl/core_asgl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import '../../core/app_bloc.dart';
import '../../core/core.dart';
import '../../home/home_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'dart:async';
import 'dart:io';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final String roomID;

  TakePictureScreen(this.camera, this.roomID);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  List<CameraDescription> cameras;
  AppBloc appBloc;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    BackStateBloc backStateBloc = BackStateBloc.getInstance();
    backStateBloc.setStateToOther(state: isFocusWidget.OPEN_CAMERA);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = BlocProvider.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(60.0),
                top: ScreenUtil().setHeight(40.0)),
            child: InkWell(
              onTap: () {
//                SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
                appBloc.homeBloc.updateOtherLayout(OtherLayoutState.NONE);
              },
              child: Image.asset(
                "asset/images/ic_dismiss.png",
                color: Colors.white,
                width: ScreenUtil().setWidth(60.6),
              ),
            ),
          ),
          /*Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                  bottom: ScreenUtil().setHeight( 65.6),
                  left: ScreenUtil().setWidth( 53.0),
                  right: ScreenUtil().setWidth( 53.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                      child: Icon(
                        Icons.image,
                        color: prefix0.white,
                      ),
                      onTap: () {}),
                  InkWell(
                      child: Image.asset(
                        "asset/images/ic_re_take_photo.png",
                        color: prefix0.white,
                        width: ScreenUtil().setWidth( 66.2),
                      ),
                      onTap: () {}),
                ],
              ),
            ),
          )*/
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: InkWell(
        onTap: () async {
          try {
            await _initializeControllerFuture;
            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );
            await _controller.takePicture(path);
            File file = File(path);
            if (file != null) {
              appBloc.homeBloc.updateOtherLayout(OtherLayoutState.PREVIEW_IMAGE,
                  data: path);
            } else {
              Toast.showShort("Chụp ảnh thất bại. Vui lòng thử lại.");
            }
          } catch (e) {
            Toast.showShort("Không thể khởi động camera.");
          }
        },
        child: Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(65.6)),
            height: ScreenUtil().setWidth(219.0),
            width: ScreenUtil().setWidth(219.0),
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Center(
              child: Container(
                height: ScreenUtil().setWidth(172.0),
                width: ScreenUtil().setWidth(172.0),
                decoration: BoxDecoration(
                    color: Color(0xFF959ca7), shape: BoxShape.circle),
              ),
            )),
      ),
    );
  }
}
