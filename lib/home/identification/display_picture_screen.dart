import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import '../../core/app_bloc.dart';
import '../../core/bloc_provider.dart';
import '../../home/home_bloc.dart';
import 'dart:io';
import 'package:location/location.dart';
import '../../home/identification/camera_bloc.dart';
import '../../core/style.dart' as prefix0;
import '../../home/identification/identification_bloc.dart';
import '../../utils/widget/loadding_widget.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  double latitude;
  double longitude;

//  final WsRoomModel roomModel;

  DisplayPictureScreen(this.imagePath, this.latitude, this.longitude);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  AppBloc appBloc;
  CameraBloc cameraBloc = CameraBloc();
  LocationData currentLocation;

  _getLocation() async {
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
      widget.latitude = currentLocation.latitude;
      widget.longitude = currentLocation.longitude;
    } on Exception {
      currentLocation = null;
    }
  }

  @override
  void initState() {
    super.initState();
    BackStateBloc backStateBloc = BackStateBloc.getInstance();
    backStateBloc.setStateToOther(state: isFocusWidget.PREVIEW_PICTURE);
    _getLocation();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = BlocProvider.of(context);


    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: <Widget>[
              Container(
                color: Colors.black,
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: ScreenUtil().setHeight(160.0),
                  width: ScreenUtil().setWidth(160.0),
                  margin: EdgeInsets.only(
                      right: ScreenUtil().setWidth(87.0),
                      bottom: ScreenUtil().setHeight(65.6)),
                  decoration: BoxDecoration(
                      color: prefix0.accentColor, shape: BoxShape.circle),
                  child: StreamBuilder<InOutModel>(
                      initialData: null,
                      stream: appBloc.identificationBloc.inoutStatusStream.stream,
                      builder: (context, snapshot) {
                        return InkWell(
                          onTap: () async {
                            cameraBloc.previewImageStream.notify(PreviewImageModel(PreviewImageState.LOADING, null));

                            String Inout = appBloc.identificationBloc.inOutModel;
                            print(Inout);
                            if (Inout != null && Inout != "") {
                              cameraBloc.sendImage(
                                  context,
                                  appBloc,
                                  Inout,
                                  widget.latitude,
                                  widget.longitude,
                                  widget.imagePath);
                            }
                          },
                          child: Center(
                            child: Image.asset(
                              "asset/images/ic_submit_image.png",
                              width: ScreenUtil().setWidth(100.0),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(60.0),
            top: ScreenUtil().setHeight(40.0),
          ),
          child: InkWell(
            onTap: () async {
              SystemChrome.setEnabledSystemUIOverlays([]);
              CameraDescription cameraDescription;
              final cameras = await availableCameras();
              if (cameras != null && cameras.length > 0) {
                if (cameras.length == 1)
                  cameraDescription = cameras.first;
                else
                  cameraDescription = cameras[1];
                appBloc.homeBloc.updateOtherLayout(OtherLayoutState.CAMERA,
                    data: cameraDescription);

//                appBloc.homeBloc.updateOtherLayout(OtherLayoutState.CAMERA);
              }
            },
            child: Image.asset(
              "asset/images/back_color_white.png",
              width: ScreenUtil().setWidth(65.3),
            ),
          ),
        ),
        StreamBuilder(
            initialData: PreviewImageModel(PreviewImageState.NONE, null),
            stream: cameraBloc.previewImageStream.stream,
            builder: (BuildContext context,
                AsyncSnapshot<PreviewImageModel> snapshot) {
              switch (snapshot.data.state) {
                case PreviewImageState.LOADING:
                  return Loading();
                  break;
                default:
                  return Container();
                  break;
              }
            }),
      ],
    );
  }
}
