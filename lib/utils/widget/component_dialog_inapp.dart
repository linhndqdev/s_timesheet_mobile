import 'package:flutter/material.dart';
import 'package:s_timesheet_mobile/utils/model/dialog_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComponentDialogInApp extends StatefulWidget {
  DialogModel dialogModel;

  ComponentDialogInApp(this.dialogModel);

  @override
  _ComponentDialogInAppState createState() => _ComponentDialogInAppState();
}

class _ComponentDialogInAppState extends State<ComponentDialogInApp> {
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
          body:Center(
            child: Container(
              width: 1012.w,
              margin: EdgeInsets.only(left: 34.0.w, right: 34.0.w),
              padding: EdgeInsets.only(left: 61.w, right: 61.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.w))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (widget.dialogModel.title != null &&
                      widget.dialogModel.title.isNotEmpty &&
                      widget.dialogModel.urlAssetImageLogo == null &&
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
                  if (widget.dialogModel.title == null &&
                      widget.dialogModel.urlAssetImageLogo != null &&
                      widget.dialogModel.urlAssetImageLogo.isNotEmpty &&
                      widget.dialogModel.colorTitle == null &&
                      widget.dialogModel.fontSizeTitle == null) ...{
                    Container(
                      margin: EdgeInsets.only(top: 71.h, bottom: 30.h),
                      child: Image.asset(
                        widget.dialogModel.urlAssetImageLogo,
                        width: 95.w,
                        height: 95.w,
                      ),
                    )
                  },
                  if (widget.dialogModel.title != null &&
                      widget.dialogModel.title.isNotEmpty &&
                      widget.dialogModel.urlAssetImageLogo != null &&
                      widget.dialogModel.urlAssetImageLogo.isNotEmpty &&
                      widget.dialogModel.colorTitle != null &&
                      widget.dialogModel.colorIcon != null) ...{
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
                  if (widget.dialogModel.voidCallbackButtonFirst != null &&
                      widget.dialogModel.titleButtonFirst != null &&
                      widget.dialogModel.titleButtonFirst.isNotEmpty &&
                      widget.dialogModel.colorButtonFirst != null &&
                      widget.dialogModel.voidCallbackButtonSecond != null &&
                      widget.dialogModel.titleButtonSecond != null &&
                      widget.dialogModel.titleButtonSecond.isNotEmpty &&
                      widget.dialogModel.colorButtonSecond != null) ...{
                    Container(
                      margin: EdgeInsets.only(top: 35.5.h, bottom: 28.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              widget.dialogModel.voidCallbackButtonFirst();
                            },
                            child: Container(
                                width: 186.w,
                                height: 140.h,
                                child: Center(
                                  child: Text(
                                    widget.dialogModel.titleButtonFirst,
                                    style: TextStyle(
                                        color: Color(
                                            widget.dialogModel.colorButtonFirst),
                                        fontFamily: 'Roboto-Medium',
                                        fontSize: 56.sp),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              widget.dialogModel.voidCallbackButtonSecond();
                            },
                            child: Container(
                                width: 186.w,
                                height: 140.h,
                                child: Center(
                                  child: Text(
                                    widget.dialogModel.titleButtonSecond,
                                    style: TextStyle(
                                        color: Color(
                                            widget.dialogModel.colorButtonSecond),
                                        fontFamily: 'Roboto-Medium',
                                        fontSize: 56.sp),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    )
                  }
                ],
              ),
            ),
          )),
    );
  }
}
