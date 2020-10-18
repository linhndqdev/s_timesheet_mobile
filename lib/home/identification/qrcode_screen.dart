import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/home/identification/qrcode_bloc.dart';
import 'package:s_timesheet_mobile/utils/animation/animation_open_qr_location.dart';
import '../../core/core.dart';
import '../../core/qrcode_helper.dart';
import '../../home/identification/identification_bloc.dart';

class QrCodeScreen extends StatefulWidget {
  final VoidCallback onClose;
  final QrCodeStreamModel qrStreamModel;
  final IdentificationBloc identificationBloc;

  const QrCodeScreen(
      {Key key, this.onClose, this.qrStreamModel, this.identificationBloc})
      : super(key: key);

  @override
  _QrCodeScreenState createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  AppBloc appBloc;
//  AnimationController controller;
  QrCodeScreenBloc _bloc = QrCodeScreenBloc();

  @override
  void initState() {
    _bloc.identificationBloc = widget.identificationBloc;
    super.initState();
    _bloc.genQrCode(widget.qrStreamModel);
  }

  @override
  void dispose() {
    appBloc.identificationBloc.getLatestDataAttendance();
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = BlocProvider.of(context);
    appBloc.backStateBloc.focusWidgetModel = FocusWidgetModel(state: isFocusWidget.QR);
    return buildQRScreen();
  }

  buildQRScreen() {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            appBloc.homeBloc.disableWithAnimation((){
              appBloc.identificationBloc.showQrCodeGen(QrCodeStreamModel(
                  stateData: QrCodeStateData.NONE, qrCodeData: ""));
            });
//            controller.reverse();
//            Future.delayed(Duration(milliseconds: 400), () {
//              appBloc.identificationBloc.showQrCodeGen(QrCodeStreamModel(
//                  stateData: QrCodeStateData.NONE, qrCodeData: ""));
//            });
          },
          child: Container(
            color: Color(0xffa4aab3).withOpacity(0.7),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
        Positioned(
          top: 430.h,
          child: OpenAnimationQRandLocation(
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.w),
                    topRight: Radius.circular(30.w),
                  )),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 149.h,
                        padding: EdgeInsets.only(top: 55.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "asset/images/ic_qr_deactive.png",
                              width: 60.w,
                              height: 60.h,
                              color: Color(0xffe18c12),
                            ),
                            SizedBox(width: 25.w),
                            Text("Mã QR",
                                style: TextStyle(
                                    color: Color(0xffe18c12),
                                    fontSize: 60.sp,
                                    fontFamily: "Roboto-Bold"))
                          ],
                        ),
                      ),

                      //tiêu đề chọn ca
                      Container(
                        height: 2.h,
                        width: MediaQuery.of(context).size.width,
                        color: Color(0xffe18c12),
                      ),
                      buildContent()
                    ],
                  ),
                  Positioned(
                    top: 0.h,
                    right: 0,
                    child: InkWell(
                        onTap: () {
                          appBloc.homeBloc.disableWithAnimation((){
                            appBloc.identificationBloc.showQrCodeGen(QrCodeStreamModel(
                                stateData: QrCodeStateData.NONE, qrCodeData: ""));
                          });

//                          controller.reverse();
//                          Future.delayed(Duration(milliseconds: 400), () {
//                            appBloc.identificationBloc.showQrCodeGen(
//                                QrCodeStreamModel(
//                                    stateData: QrCodeStateData.NONE,
//                                    qrCodeData: ""));
//                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            right: 0.0.w,
                            top: 50.0.h,
                            bottom: 59.h,
                          ),
                          height: 149.h,
                          width: 108.h,
                          child: Image.asset(
                            "asset/images/ic_cancel.png",
                            width: 40.w,
                            height: 40.w,
                          ),
                        )),
                  )
                ],
              ),
            ),
            voidCallback: (c) {
              appBloc.homeBloc.animationController = c;
            },
          ),
        )
      ],
    );
  }

  Widget buildContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50.h),
            Text("Sử dụng mã QR để chấm công",
                style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 48.sp,
                    height: 1.31,
                    fontFamily: "Roboto-Bold")),
            //dòng kẻ xanh,
            SizedBox(height: 15.h),
            Container(
                padding: EdgeInsets.only(left: 182.w, right: 184.w),
                child: Text("Đưa mã QR qua máy scan tại nơi làm",
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 42.sp,
                        fontFamily: "Roboto-Regular",
                        height: 1.1))),
            Container(
              padding: EdgeInsets.only(left: 182.w, right: 184.w),
              child: RichText(
                  text: TextSpan(
                text: "việc của bạn ",
                style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 42.sp,
                    fontFamily: "Roboto-Regular",
                    height: 1.1),
                children: <TextSpan>[
                  TextSpan(
                      text: "(Chi tiết)",
                      style: TextStyle(
                        color: Color(0xff005a88),
                        fontSize: 42.sp,
                        fontFamily: "Roboto-Bold",
                      )),
                ],
              )),
            ),
            SizedBox(height: 49.8.h),
            Container(
              height: 783.4.h,
              child: Center(
                child: StreamBuilder(
                  initialData: widget.qrStreamModel.qrCodeData,
                  stream: _bloc.qrImageDataStream.stream,
                  builder: (buildContext, AsyncSnapshot<String> snapshot) {
                    return snapshot.hasData && snapshot.data != null
                        ? InkWell(
                            onTap: () {},
                            child: QrImage(
                              data: snapshot.data,
                              version: QrVersions.auto,
                              size: 230.0,
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 49.8.h, bottom: 82.0.h),
              child: Text(
                "Thông tin chi tiết mã QR",
                style: TextStyle(
                    color: Color(0xff959ca7),
                    fontSize: 36.sp,
                    fontFamily: "Roboto-Regular"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
