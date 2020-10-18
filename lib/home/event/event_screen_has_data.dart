import 'package:core_asgl/core_asgl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/utils/animation/button_animation.dart';
import 'package:s_timesheet_mobile/utils/model/event_sample_model.dart';

class EventScreenHasData extends StatefulWidget {
  final AppBloc appBloc;

  EventScreenHasData(this.appBloc);

  @override
  _EventScreenHasDataState createState() => _EventScreenHasDataState();
}

class _EventScreenHasDataState extends State<EventScreenHasData> {
  @override
  Widget build(BuildContext context) {
    return buildEventScreenHasData();
  }

  buildEventScreenHasData() {
    return Column(
      children: <Widget>[
        SizedBox(height: 23.h),
        //87.h - 19.h - 45.h
        //do lấy 19px đưa lên appbar cho đẹp và đảm bảo thiết kế giống
        //45px kia là trừ vào item ở dưới để cách đều
        buildListBigItemEvent(),
        SizedBox(height: 30.h),
        //chỗ này design ko có nhưng cho thêm để vuốt xuống cuối nhìn đẹp hơn
      ],
    );
  }

  buildListBigItemEvent() {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: widget.appBloc.eventBloc.listEventDates.length,
      itemBuilder: (context, index) {
        EventsSampleModel data = widget.appBloc.eventBloc.listEventDates[index];
        return buildBigItemEvent(eventsSampleModel: data);
      },
    );
  }

  buildBigItemEvent({EventsSampleModel eventsSampleModel}) {
    List<Widget> listItemChild = [];
    for (int i = 0; i < eventsSampleModel.listEventDataModel.length; i++) {
      EventDataSample data = eventsSampleModel.listEventDataModel[i];
      if (data.state == EventState.NONE)
        listItemChild.add(buildContentEvent(eventDataSample: data));
      else if (data.state == EventState.EDIT)
        listItemChild.add(buildContentEventHasEdit(eventDataSample: data));
      else if (data.state == EventState.CANCEL ||
          data.state == EventState.ACCEPT)
        listItemChild.add(buildContentEventHasAction(eventDataSample: data));
    }

    return Column(
      children: <Widget>[
        SizedBox(height: 45.h),
        Row(
          children: <Widget>[
            SizedBox(width: 59.w),
            Image.asset("asset/images/ic_calendar_event.png",
                width: 60.w, height: 60.h, color: Color(0xff005a88)),
            SizedBox(width: 25.w),
            Text(eventsSampleModel.date,
                style: TextStyle(
                    color: Color(0xff005a88),
                    fontSize: 52.sp,
                    fontFamily: "Roboto-Medium",
                    height: 1.15))
          ],
        ),
        //tiêu đề và ngày
        SizedBox(height: 20.h),
        Container(
          height: 1.h,
          margin: EdgeInsets.symmetric(horizontal: 34.w),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Color(0xff005a88),
                      width: 1.h,
                      style: BorderStyle.solid))),
        ),
        //dòng kẻ xanh
        Column(
          children: listItemChild,
        ),
      ],
    );
  }

  buildContentEvent({EventDataSample eventDataSample}) {
    return InkWell(
      onTap: () {
        Toast.showShort("click " + eventDataSample.location,
            msgColor: 0xFFFFFFFF, bgColor: 0xff005a88);
      },
      child: Column(
        children: <Widget>[
          SizedBox(height: 40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 59.0.w),
              Container(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 15.w,
                      height: 15.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xff005a88)),
                    ), //chấm xanh
                    SizedBox(width: 10.0),
                    Text(eventDataSample.time,
                        style: TextStyle(
                            color: Color(0xff005a88),
                            fontSize: 48.sp,
                            height: 1.25,
                            fontFamily: "Roboto-Medium")),
                  ],
                ),
              ),
              SizedBox(width: 10.0.w),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              width: 3.w, color: Color(0xff005a88)))),
                  padding: EdgeInsets.only(left: 25.w),
                  child: Text(
                    eventDataSample.location,
                    style: TextStyle(
                        color: Color(0xff959ca7),
                        fontSize: 42.sp,
                        fontFamily: "Roboto-Regular",
                        height: 1.43),
                  ),
                ),
              ),
              SizedBox(width: 34.w)
            ],
          ),
        ],
      ),
    );
  }

  buildContentEventHasEdit({EventDataSample eventDataSample}) {
    return InkWell(
      onTap: () {
        Toast.showShort("click " + eventDataSample.location,
            msgColor: 0xFFFFFFFF, bgColor: 0xff005a88);
      },
      child: Column(
        children: <Widget>[
          SizedBox(height: 40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 59.0.w),
              Container(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 15.w,
                      height: 15.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xff005a88)),
                    ), //chấm xanh
                    SizedBox(width: 10.0),
                    Text(eventDataSample.time,
                        style: TextStyle(
                            color: Color(0xffe18c12),
                            fontSize: 48.sp,
                            height: 1.25,
                            fontFamily: "Roboto-Medium")),
                  ],
                ),
              ),
              SizedBox(width: 10.0.w),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    width: 3.w, color: Color(0xffe18c12)))),
                        padding:
                            EdgeInsets.only(left: 25.w, bottom: 36.h + 50.h),
                        margin: EdgeInsets.only(bottom: 50.h),
                        child: RichText(
                          text: TextSpan(
                            text: eventDataSample.name + " ",
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 42.sp,
                                fontFamily: "Roboto-Medium",
                                height: 1.43),
                            children: <TextSpan>[
                              TextSpan(
                                  text: eventDataSample.request + " ",
                                  style: TextStyle(
                                      color: eventDataSample.request
                                                  .toLowerCase()
                                                  .trim() ==
                                              "xin đổi ca"
                                          ? Color(0xff005a88)
                                          : Color(0xffe10606),
                                      fontSize: 42.sp,
                                      fontFamily: "Roboto-Medium",
                                      height: 1.43)),
                              TextSpan(
                                  text: eventDataSample.content,
                                  style: TextStyle(
                                      color: Color(0xff333333),
                                      fontSize: 42.sp,
                                      fontFamily: "Roboto-Regular",
                                      height: 1.43)),
                            ],
                          ),
                        )), //nội dung chấm công hoặc nội dung xin đổi ca
                    Positioned(
                        bottom: 0.h,
                        right: 59.w - 34.w,
                        child: buildButtonBar())
                  ],
                ),
              ),
              SizedBox(width: 34.w)
            ],
          ),
        ],
      ),
    );
  }

  buildContentEventHasAction({EventDataSample eventDataSample}) {
    return InkWell(
      onTap: () {
        Toast.showShort("click " + eventDataSample.location,
            msgColor: 0xFFFFFFFF, bgColor: 0xff005a88);
      },
      child: Column(
        children: <Widget>[
          SizedBox(height: 40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 59.0.w),
              Container(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 15.w,
                      height: 15.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xff005a88)),
                    ), //chấm xanh
                    SizedBox(width: 10.0),
                    Text(eventDataSample.time,
                        style: TextStyle(
                            color: Color(0xffe18c12),
                            fontSize: 48.sp,
                            height: 1.25,
                            fontFamily: "Roboto-Medium")),
                  ],
                ),
              ),
              SizedBox(width: 10.0.w),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    width: 3.w, color: Color(0xffe18c12)))),
                        padding:
                            EdgeInsets.only(left: 25.w, bottom: 36.h + 50.h),
//                        margin: EdgeInsets.only(bottom: 50.h),
                        child: RichText(
                          text: TextSpan(
                            text: eventDataSample.content + " ",
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 42.sp,
                                fontFamily: "Roboto-Medium",
                                height: 1.43),
                            children: <TextSpan>[
                              TextSpan(
                                  text: eventDataSample.request + " ",
                                  style: TextStyle(
                                      color: eventDataSample.state ==
                                              EventState.CANCEL
                                          ? Color(0xffe10606)
                                          : Color(0xff005a88),
                                      fontSize: 42.sp,
                                      fontFamily: "Roboto-Medium",
                                      height: 1.43)),
                            ],
                          ),
                        )),
                    //nội dung chấm công hoặc nội dung xin đổi ca
//                    Positioned(
//                      bottom: 0.h,
//                      right: 429.w - 34.w,
//                      child: buildButtonCanCel(),
//                    ),
//                    Positioned(
//                      bottom: 0.h,
//                      right: 59.w - 34.w,
//                      child:eventDataSample.state !=EventState.CANCEL && eventDataSample.state != EventState.ACCEPT? buildButtonBar():Container(),,
//                    )
                  ],
                ),
              ),
              SizedBox(width: 34.w)
            ],
          ),
        ],
      ),
    );
  }

  buildButtonBar() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildButtonCanCel(),
          SizedBox(width: 50.w),
          buildButtonAccept(),
        ],
      ),
    );
  }

  buildButtonCanCel() {
    return Container(
      alignment: Alignment.center,
      height: 100.h,
      width: 320.w,
      child:
      ButtonAnimation(
        child: Container(
          alignment: Alignment.center,
          height: 120.h,
          width: 320.w,
          decoration: BoxDecoration(
              color: Color(0xffe8e8e8),
              borderRadius: BorderRadius.circular(20.w)),
          child: Center(
            child: Text(
              "Từ chối",
              style: TextStyle(
                  fontSize: 48.sp,
                  fontFamily: "Roboto-Regular",
                  color: Color(0xff6a6a6a)),
            ),
          ),
        ),
        width: 320.w,
        height: 100.h,
        color: 0xffe8e8e8,
        onClicked: (c) {
          c?.reverse();
          Toast.showShort("Chấp nhận ",
              msgColor: 0xFFFFFFFF, bgColor: 0xff005a88);
        },
      ),
    );
  }

  buildButtonAccept() {
    return Container(
      alignment: Alignment.center,
      height: 100.h,
      width: 320.w,
      child:
      ButtonAnimation(
        child: Container(
          alignment: Alignment.center,
          height: 120.h,
          width: 320.w,
          decoration: BoxDecoration(
              color: Color(0xff02880c),
              borderRadius: BorderRadius.circular(20.w)),
          child: Center(
            child: Text(
              "Chấp nhận",
              style: TextStyle(
                  fontSize: 48.sp,
                  fontFamily: "Roboto-Regular",
                  color: Color(0xffffffff)),
            ),
          ),
        ),
        width: 320.w,
        height: 100.h,
        color: 0xff02880c,
        onClicked: (c) {
          c?.reverse();
          Toast.showShort("Chấp nhận ",
              msgColor: 0xFFFFFFFF, bgColor: 0xff005a88);
        },
      ),
    );
  }
}
