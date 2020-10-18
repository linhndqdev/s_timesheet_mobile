import 'package:core_asgl/core_asgl.dart';
import 'package:flutter/material.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/core/style.dart' as prefix0;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/home/calendar_working/calendar_work_bloc.dart';
import 'package:s_timesheet_mobile/home/calendar_working/information_shift_member_model.dart';
import 'package:s_timesheet_mobile/utils/animation/animation_switch_shift.dart';
import 'package:s_timesheet_mobile/utils/model/dialog_model.dart';
import 'package:s_timesheet_mobile/utils/widget/dialog_util.dart';

class SwitchShiftInformationWidget extends StatefulWidget {
  final AppBloc appBloc;
  final DateTime Choseday;
  final InformationShiftMemberModel data;

  SwitchShiftInformationWidget({this.appBloc, this.data, this.Choseday});

  @override
  _SwitchShiftInformationWidgetState createState() =>
      _SwitchShiftInformationWidgetState();
}

class _SwitchShiftInformationWidgetState
    extends State<SwitchShiftInformationWidget> {
  TextEditingController _searchController = TextEditingController();
  List<RichTextModel> listRichText = [];
  List<RichTextModel> listRichTextSucess = [];

//  AnimationController controller;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackStateBloc backStateBloc = BackStateBloc.getInstance();
    backStateBloc.setStateToOther(state: isFocusWidget.SWITCH_SHIFT);
  }
  @override
  Widget build(BuildContext context) {


    return switchShiftScreen();
  }

  Widget switchShiftScreen() {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            widget.appBloc.homeBloc
                .disableWithAnimation(() {
              widget.appBloc.calendarWorkBloc.shiftStateStream
                  .notify(ShiftStateModel(state: ShiftState.NONE));
            });
          },
          child: Container(
            color: Color(0xff959ca7).withOpacity(0.85),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
        Positioned(
          bottom: 0,
          child: AnimationSwitchShift(
            widgetAction: InkWell(
              onTap: () {
                widget.appBloc.calendarWorkBloc.searchMemberShift.notify(false);
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: informationShift(),
            ),
            voidCallback: (c) {
              widget.appBloc.homeBloc.animationController = c;
            },
          ),
        ),
      ],
    );
  }

  Widget informationShift() {
    return Container(
      height: 149.h + 942.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ScreenUtil().setWidth(40.0)),
            topRight: Radius.circular(ScreenUtil().setWidth(40.0)),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Color(0xffe18c12), width: 2.h))),
                padding: EdgeInsets.only(
                    left: 0.w, right: 0.w, bottom: 24.5.h, top: 64.5.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("asset/images/ic_calendar_changeShift.png",
                        width: 60.w, height: 60.w, color: Color(0xffe18c12)),
                    SizedBox(
                      width: 25.w,
                    ),
                    Text(
                      "Đổi ca",
                      style: TextStyle(
                          fontSize: 60.sp,
                          color: Color(0xffe18c12),
                          fontFamily: 'Roboto-Bold'),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0.w,
                bottom: 50.h,
                child: InkWell(
                  onTap: () {
                    widget.appBloc.homeBloc
                        .disableWithAnimation(() {
                      widget.appBloc.calendarWorkBloc.shiftStateStream
                          .notify(ShiftStateModel(state: ShiftState.NONE));
                    });
                  },
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    padding: EdgeInsets.all(30.w),
                    child: Image.asset("asset/images/ic_cancel.png",
                        width: 40.w, height: 40.w),
                  ),
                ),
              ),
            ],
          ), //title bar

          _buidMainContent(),
        ],
      ),
    );
  }

  Widget _buidMainContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 68.h,
              margin: EdgeInsets.only(top: 28.h, right: 34.w, bottom: 53.h),
              child: Stack(
                children: <Widget>[
                  StreamBuilder<bool>(
                    initialData: false,
                    stream: widget.appBloc.authBloc.loadingStream.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data == false) {
                        return Positioned(
                          right: 0,
                          child: !checkDataSendRequest(widget.data) ||
                                  widget.data == null
                              ? Text(
                                  "Gửi yêu cầu".toUpperCase(),
                                  style: TextStyle(
                                      color: Color(0xff005a88).withOpacity(0.5),
                                      fontSize: 52.sp,
                                      fontFamily: 'Roboto-Medium'),
                                )
                              : InkWell(
                                  onTap: () {
                                    listRichText.add(RichTextModel(
                                        "Bạn chắc chắn muốn gửi yêu cầu đổi ca với ",
                                        0xff333333,
                                        52,
                                        "Roboto-Regular"));
                                    listRichText.add(RichTextModel(
                                        (widget.data).nameMember,
                                        0xff333333,
                                        52,
                                        "Roboto-Medium"));
                                    DialogUtil.showDialogProject(
                                      context,
                                      dialogModel: DialogModel(
                                        state: DialogType.INAPP,
                                        urlAssetImageLogo:
                                            "asset/images/ic_calendar_changeShift.png",
                                        colorIcon: 0xff959ca7,
                                        title: "Đổi ca",
                                        colorTitle: 0xff959ca7,
                                        listRichText: listRichText,
                                        voidCallbackButtonFirst: () {
                                          Navigator.of(context).pop();
                                        },
                                        titleButtonFirst: "HỦY",
                                        colorButtonFirst: 0xff959ca7,
                                        voidCallbackButtonSecond: () {
                                          widget.appBloc.calendarWorkBloc
                                              .SendSwitchShift(
                                                  context,
                                                  (widget.data).idShift,
                                                  (widget.data).idShiftChange,
                                                  "",
                                                  widget.appBloc,
                                                  (widget.data).choseDay);
                                          Navigator.of(context).pop();
                                        },
                                        titleButtonSecond: "GỬI",
                                        colorButtonSecond: 0xff005a88,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Gửi yêu cầu".toUpperCase(),
                                    style: TextStyle(
                                        color: Color(0xff005a88),
                                        fontSize: 52.sp,
                                        fontFamily: 'Roboto-Medium'),
                                  ),
                                ),
                        );
                      } else {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    prefix0.accentColor)),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 59.w, right: 59.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(57.w),
                  border: Border.all(width: 1.w, color: Color(0xFF707070)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(top: 12.h, left: 45.w, right: 37.7.w),
                      child: Image.asset(
                        "asset/images/ic_search.png",
                        width: 49.1.h,
                        height: 49.1.h,
                        color: Color(0xffe8e8e8),
                      ),
                    ),
                    Container(
                      width: 800.w,
                      height: 100.h,
                      child: TextField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.start,
                        controller: _searchController,
//                          ..text = widget.data.nameMember,
                        maxLines: 1,
                        obscureText: false,
                        enabled: true,
                        onChanged: (value) {
                          if (_searchController.text == "") {
                            widget.appBloc.calendarWorkBloc.searchMemberShift
                                .notify(false);
                          } else {
                            widget.appBloc.calendarWorkBloc.searchMemberShift
                                .notify(true);
                            widget.appBloc.calendarWorkBloc
                                .filterSearchResults(_searchController.text);
                          }
                        },
                        onTap: () {
                          widget.appBloc.calendarWorkBloc.searchMemberShift
                              .notify(true);
                          if (_searchController.text.length == 0) {
                            widget.appBloc.calendarWorkBloc
                                .filterSearchResults("");
                          } else {
                            widget.appBloc.calendarWorkBloc.searchMemberShift
                                .notify(true);
                            widget.appBloc.calendarWorkBloc
                                .filterSearchResults(_searchController.text);
                          }
                        },
                        style: TextStyle(
                          fontFamily: "Roboto-Regular",
                          fontSize: ScreenUtil().setSp(52.0),
                          color: Color(0xff333333),
                        ),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              bottom: 45.0.h,
                              top: 13.h,
                            ),
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    )
                  ],
                )),
            Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(left: 59.w, right: 59.w, top: 41.h),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            "asset/images/ic_calendar_choseShift.png",
                            width: 100.w,
                            height: 100.w,
                            color: Color(0xff005a88),
                          ),
                          SizedBox(
                            width: 50.w,
                          ),
                          InkWell(
                            onTap: () {
                              if (widget.data?.asglID == "") {
                                Toast.showShort(
                                    "Phải chọn nhân viên trước khi chọn ca");
                              } else {
                                widget.appBloc.calendarWorkBloc.shiftStateStream
                                    ?.notify(ShiftStateModel(
                                        state: ShiftState.CHON_CA,
                                        data: widget.data,
                                        days: widget.Choseday));
                                //xử lý nút bấm chọn ca
                              }
                            },
                            child: Text(
                              "Chọn ca",
                              style: TextStyle(
                                fontFamily: 'Roboto-Medium',
                                fontSize: 56.sp,
                                color: Color(0xff333333),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(left: 59.w, top: 21.w, bottom: 16.h),
                      child: Text(
                        "Thông tin chi tiết của ca muốn đổi",
                        style: TextStyle(
                          fontFamily: 'Roboto-Medium',
                          fontSize: 56.sp,
                          color: Color(0xff333333),
                        ),
                      ),
                    ),
                    itemInfomationShift(
                        "Mã nhân viên",
                        checkDataAndTypeData(widget.data)
                            ? (widget.data).asglID
                            : "",
                        false),
                    itemInfomationShift(
                        "Tên nhân viên",
                        checkDataAndTypeData(widget.data)
                            ? (widget.data).nameMember
                            : "",
                        false),
                    itemInfomationShift(
                        "Tên ca",
                        checkDataAndTypeData(widget.data)
                            ? (widget.data).nameShift
                            : "",
                        true),
                    itemInfomationShift(
                        "Thời gian làm việc dự kiến",
                        checkDataAndTypeData(widget.data)
                            ? (widget.data).time
                            : "",
                        false),
                    itemInfomationShift(
                        "Ngày",
                        checkDataAndTypeData(widget.data)
                            ? (widget.data).date
                            : "",
                        false),
                    SizedBox(
                      height: 45.h,
                    ),
                  ],
                ),
                StreamBuilder(
                    initialData: false,
                    stream: widget
                        .appBloc.calendarWorkBloc.searchMemberShift.stream,
                    builder: (buildContext, snapshot) {
                      if (snapshot.data) {
                        return Positioned(
                          child: Container(
                            color: Colors.white,
                            child: Container(
                              constraints: BoxConstraints(maxHeight: 658.h),
                              margin: EdgeInsets.only(
                                  left: 59.w, right: 59.w, bottom: 25.2.h),
                              padding: EdgeInsets.only(bottom: 16.h),
                              decoration: BoxDecoration(
                                  color: Color(0xff005a88).withOpacity(0.05),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0.w))),
                              width: 962.w,
                              child: widget.appBloc.calendarWorkBloc
                                          .listShiftMemberModel.length >
                                      0
                                  ? ListView.builder(
                                      padding: EdgeInsets.all(0.0),
                                      physics: AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: widget.appBloc.calendarWorkBloc
                                          .listShiftMemberModel.length,
                                      itemBuilder: (BuildContext buildContext,
                                          int index) {
                                        return InkWell(
                                          onTap: () {
                                            InformationShiftMemberModel
                                                .createInformationShiftMemberModel(
                                                    idShift: widget
                                                        .appBloc
                                                        .calendarWorkBloc
                                                        .listShiftMemberModel[
                                                            index]
                                                        .idShift,
                                                    date: "",
                                                    time: "",
                                                    nameShift: "",
                                                    idShiftChange: null,
                                                    nameMember: widget
                                                        .appBloc
                                                        .calendarWorkBloc
                                                        .listShiftMemberModel[
                                                            index]
                                                        .nameMember,
                                                    idMember: null,
                                                    asglID: widget
                                                        .appBloc
                                                        .calendarWorkBloc
                                                        .listShiftMemberModel[
                                                            index]
                                                        .asglID,
                                                    isInit: true,
                                                    choseDay:
                                                        widget.data.choseDay);
                                            widget.appBloc.calendarWorkBloc
                                                .shiftStateStream
                                                .notify(ShiftStateModel(
                                                    state: ShiftState
                                                        .INFOMATIONSHIFT,
                                                    data: widget
                                                            .appBloc
                                                            .calendarWorkBloc
                                                            .listShiftMemberModel[
                                                        index],
                                                    days: widget.Choseday));
                                            widget.appBloc.calendarWorkBloc
                                                .searchMemberShift
                                                .notify(false);
                                            _searchController.text = widget
                                                .appBloc
                                                .calendarWorkBloc
                                                .listShiftMemberModel[index]
                                                .nameMember;
                                            FocusScope.of(context)
                                                .requestFocus(new FocusNode());
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 128.w, top: 12.h),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  widget
                                                      .appBloc
                                                      .calendarWorkBloc
                                                      .listShiftMemberModel[
                                                          index]
                                                      .nameMember,
                                                  style: TextStyle(
                                                      color: Color(0xff333333),
                                                      fontFamily:
                                                          'Roboto-Regular',
                                                      fontSize: 52.sp),
                                                ),
                                                Text(
                                                  widget
                                                      .appBloc
                                                      .calendarWorkBloc
                                                      .listShiftMemberModel[
                                                          index]
                                                      .asglID,
                                                  style: TextStyle(
                                                      color: Color(0xff959ca7),
                                                      fontFamily:
                                                          'Roboto-Regular',
                                                      fontSize: 42.sp),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 20.h, bottom: 20.h),
                                          child: Text('Không có ai để đổi ca',
                                              style: TextStyle(
                                                  color: Color(0xff333333),
                                                  fontFamily: 'Roboto-Regular',
                                                  fontSize: 52.sp)),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget itemInfomationShift(
      String title, String context, bool haveColorAccent) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h, left: 103.w),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 52.sp,
              fontFamily: 'Roboto-Regular',
              color: Color(0xff959ca7),
            ),
          ),
          SizedBox(
            width: 26.w,
          ),
          Flexible(
              child: Text(
            context,
            style: haveColorAccent
                ? TextStyle(
                    fontSize: 52.sp,
                    fontFamily: 'Roboto-Bold',
                    color: Color(0xff005a88),
                  )
                : TextStyle(
                    fontSize: 52.sp,
                    fontFamily: 'Roboto-Regular',
                    color: Color(0xff333333),
                  ),
          ))
        ],
      ),
    );
  }

  bool checkDataAndTypeData(dynamic data) {
    if (data != null) {
      return true;
    } else {
      return false;
    }
  }

  bool checkDataSendRequest(dynamic data) {
    if (data != null) {
      if (data.nameMember == null || data.nameMember == "") return false;
      if (data.idMember == null || data.idMember == "") return false;
      if (data.idShift == null || data.idShift == "") return false;
      if (data.date == null || data.date == "") return false;
      if (data.time == null || data.time == "") return false;
      if (data.nameShift == null || data.nameShift == "") return false;
      if (data.idShiftChange == null || data.idShiftChange == "") return false;
      if (data.asglID == null || data.asglID == "") return false;

      return true;
    } else {
      return false;
    }
  }
}
