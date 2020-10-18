import 'package:flutter/material.dart';
import 'package:s_timesheet_mobile/utils/model/dialog_model.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComponentDialogAuth extends StatefulWidget {
  DialogModel dialogModel;

  ComponentDialogAuth(this.dialogModel);

  @override
  _ComponentDialogAuthState createState() => _ComponentDialogAuthState();
}

class _ComponentDialogAuthState extends State<ComponentDialogAuth> {
  List<TextSpan> listTextSpan = [];

  @override
  void initState() {
    if (widget.dialogModel.listRichText != null) {
      for (var i = 0; i < widget.dialogModel.listRichText.length; i++) {
        listTextSpan.add(TextSpan(
            text: widget.dialogModel.listRichText[i].content,
            style: TextStyle(
              color: Color(widget.dialogModel.listRichText[i].color),
              fontSize: widget.dialogModel.listRichText[i].fontSize.sp,
              fontFamily: widget.dialogModel.listRichText[i].fontFamily,
            )));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: 962.w,
          margin: EdgeInsets.only(
            left: 59.0.w,
            right: 59.0.w,
            top: 615.h,
          ),
          padding: EdgeInsets.only(top: 36.5.h),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.w))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.dialogModel.title != null &&
                  widget.dialogModel.title.isNotEmpty &&
                  widget.dialogModel.colorTitle != null &&
                  widget.dialogModel.fontSizeTitle != null) ...{
                Container(
                  margin: EdgeInsets.only(
                    top: 60.h,
                  ),
                  child: Text(
                    widget.dialogModel.title,
                    style: TextStyle(
                        color: Color(widget.dialogModel.colorTitle),
                        fontSize: widget.dialogModel.fontSizeTitle.sp,
                        fontFamily: 'Roboto-Bold'),
                  ),
                )
              },
              if (widget.dialogModel.urlAssetImageLogo != null &&
                  widget.dialogModel.urlAssetImageLogo.isNotEmpty) ...{
                Container(
                  margin: EdgeInsets.only(top: 71.h, bottom: 30.h),
                  child: Image.asset(
                    widget.dialogModel.urlAssetImageLogo,
                    width: 95.w,
                    height: 95.w,
                  ),
                )
              },
              if (widget.dialogModel.urlAssetImageLogo != null &&
                  widget.dialogModel.urlAssetImageLogo.isNotEmpty &&
                  widget.dialogModel.colorIcon != null &&
                  widget.dialogModel.title != null &&
                  widget.dialogModel.title.isNotEmpty &&
                  widget.dialogModel.colorTitle != null) ...{
                Container(
                  margin: EdgeInsets.only(top: 51.h, bottom: 45.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        widget.dialogModel.urlAssetImageLogo,
                        width: 60.w,
                        height: 60.w,
                        color: Color(widget.dialogModel.colorIcon),
                      ),
                      SizedBox(
                        width: 25.w,
                      ),
                      Text(
                        widget.dialogModel.title,
                        style: TextStyle(
                            color: Color(widget.dialogModel.colorTitle),
                            fontFamily: 'Roboto-Bold',
                            fontSize: 60.sp),
                      )
                    ],
                  ),
                )
              },
              if (widget.dialogModel.listRichText != null) ...{
                Container(
                  margin: widget.dialogModel.marginRichText != null
                      ? widget.dialogModel.marginRichText
                      : EdgeInsets.all(0),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: listTextSpan,
                      )),
                )
              },
              if (widget.dialogModel.titleButtonSecond != null &&
                  widget.dialogModel.titleButtonSecond.isNotEmpty &&
                  widget.dialogModel.titleButtonFirst != null &&
                  widget.dialogModel.titleButtonFirst.isNotEmpty &&
                  widget.dialogModel.voidCallbackButtonFirst != null &&
                  widget.dialogModel.colorButtonFirst != null &&
                  widget.dialogModel.voidCallbackButtonSecond != null &&
                  widget.dialogModel.colorButtonSecond != null) ...{
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Color(0xff0959ca7), width: 2.w))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            widget.dialogModel.voidCallbackButtonFirst();
                          },
                          child: Container(
                            height: 187.5.h,
                            child: Center(
                              child: Text(
                                widget.dialogModel.titleButtonFirst,
                                style: TextStyle(
                                    fontFamily: 'Roboto-Regular',
                                    color: Color(
                                        widget.dialogModel.colorButtonFirst),
                                    fontSize: 50.sp,
                                    fontWeight: FontWeight.normal),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(188.0),
                        width: ScreenUtil().setWidth(1.0),
                        color: Color(0xff0959ca7),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            widget.dialogModel.voidCallbackButtonSecond();
                          },
                          child: Container(
                            height: 187.5.h,
                            child: Center(
                              child: Text(
                                "Có",
                                style: TextStyle(
                                    fontFamily: 'Roboto-Regular',
                                    color: Color(
                                        widget.dialogModel.colorButtonSecond),
                                    fontSize: 50.sp,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              }
            ],
          ),
        ),
      ),
    );
  }
}
