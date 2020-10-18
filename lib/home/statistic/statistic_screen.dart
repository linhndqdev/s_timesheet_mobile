import 'package:core_asgl/animation/animation.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'
//    as picker_old;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/core/bloc_provider.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:s_timesheet_mobile/home/statistic/choose_month_screen.dart';
import 'package:s_timesheet_mobile/home/statistic/diary_screen.dart';
import 'package:s_timesheet_mobile/home/statistic/statistic_bloc.dart';
import 'package:s_timesheet_mobile/utils/widget/custom_appbar.dart';
import 'package:s_timesheet_mobile/utils/widget/tab_bar_with_border_statistic.dart';

class StatisticScreen extends StatefulWidget {
  final VoidCallback callBackOpenMenu;

  const StatisticScreen({Key key, this.callBackOpenMenu}) : super(key: key);

  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  AppBloc appBloc;

  @override
  void initState() {
    super.initState();
    BackStateBloc backStateBloc = BackStateBloc.getInstance();
    backStateBloc.setStateToHome();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = BlocProvider.of(context);
    appBloc.statisticBloc.genMonthYearOriginal();
    appBloc.statisticBloc.showMonthSelectStream.notify(
        ShowChooseMonthModel(state: StatisticState.NHAT_KY, isShow: false));
    appBloc.statisticBloc.statisticStream
        .notify(StatisticModel(state: StatisticState.THONG_KE));

    return WillPopScope(
      onWillPop: () async {
//        if (appBloc.backStateBloc.focusWidgetModel.state ==
//            isFocusWidget.CHOOSE_MONTH) {
//          appBloc.statisticBloc.showMonthSelectStream
//              .notify(ShowChooseMonthModel(
//              state: widget.state, isShow: false));
//
//        } else if (appBloc.backStateBloc.focusWidgetModel.state ==
//            isFocusWidget.QR) {
//         // hideChildWidget(isLocation: false);
//        } else {
          return true;
//        }
//        return false;
      },
      child: Stack(
        children: <Widget>[
          Scaffold(
              backgroundColor: Color(0xffffffff),
              appBar: PreferredSize(
                preferredSize:
                    Size(MediaQuery.of(context).size.width, 66.h + 47.1.h + 19.h),
                child: CustomAppBar(
                  callBackOpenMenu: () => widget.callBackOpenMenu(),
                ),
              ),
              body: TranslateVertical(
                startPosition: MediaQuery.of(context).size.height,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: StreamBuilder(
                            initialData:
                                StatisticModel(state: StatisticState.THONG_KE),
                            stream: appBloc.statisticBloc.statisticStream.stream,
                            builder: (buildContext,
                                AsyncSnapshot<StatisticModel> snapshotQR) {
                              if (snapshotQR.data.state ==
                                  StatisticState.THONG_KE) {
                                return TabbarWithBorderStatistic(
                                  contentQR: "Thống kê",
                                  contentLocation: "Nhật ký",
                                  haveBorderInQR: true,
                                  voidCallbackQR: () {},
                                  voidCallbackLocation: () {
                                    appBloc.statisticBloc.statisticStream.notify(
                                        StatisticModel(
                                            state: StatisticState.NHAT_KY));
                                  },
                                  colorQR: Color(0xff005a88),
                                  colorLocation: Color(0xff959ca7),
                                );
                              } else {
                                return TabbarWithBorderStatistic(
                                  contentQR: "Thống kê",
                                  contentLocation: "Nhật ký",
                                  haveBorderInQR: false,
                                  voidCallbackQR: () {
                                    appBloc.statisticBloc.statisticStream.notify(
                                        StatisticModel(
                                            state: StatisticState.THONG_KE));
                                  },
                                  voidCallbackLocation: () {},
                                  colorQR: Color(0xff959ca7),
                                  colorLocation: Color(0xff005a88),
                                );
                              }
                            }),
                      ),
                      Expanded(
                        child: StreamBuilder(
                            initialData:
                                StatisticModel(state: StatisticState.THONG_KE),
                            stream: appBloc.statisticBloc.statisticStream.stream,
                            builder: (buildContext,
                                AsyncSnapshot<StatisticModel> snapshotData) {
                              switch (snapshotData.data.state) {
                                case StatisticState.THONG_KE:
                                  return _DetaiStatistic(
                                      title: 'Tháng 5 - 2020',
                                      Congthangtruoc: 120,
                                      Congthangnay: 100,
                                      phepnghi: 1,
                                      phepconlai: 11,
                                      dimuon: 1,
                                      vesom: 0);
                                  break;
                                case StatisticState.NHAT_KY:
                                  return DiaryScreen(
                                    appBloc: appBloc,
                                  );
                                default:
                                  return Container();
                                  break;
                              }
                            }),
                      )
                    ],
                  ),
                ),
              )),
          StreamBuilder<ShowChooseMonthModel>(
              initialData: ShowChooseMonthModel(
                  state: StatisticState.THONG_KE, isShow: false),
              stream: appBloc.statisticBloc.showMonthSelectStream.stream,
              builder: (mContext, snapshot) {
                if (snapshot.data.isShow)
                  return ChooseMonth(
                    state: snapshot.data.state,
                    month: snapshot.data.data.month,
                    year: snapshot.data.data.year,
                    appBloc: appBloc,
                    onResetData: () {
                      appBloc.statisticBloc.getDiaryData(context);
                    },
                  );
                else
                  return Container();
              })
        ],
      ),
    );
  }

  _BuildStatisticNodata() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 155.h,
        ),
        InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(left: 195.w, right: 195.w),
            child: Image.asset(
              'asset/images/img_Statistic.png',
              width: 690.0.w,
              height: 431.6.h,
            ),
          ),
        ),
        SizedBox(
          height: 87.4.w,
        ),
        Container(
          child: Text(
            'Hiện chưa có thống kê nào.',
            style: TextStyle(
              fontFamily: 'Roboto-Regular',
              fontSize: 48.sp,
              color: Color(0xff959ca7),
            ),
          ),
        )
      ],
    );
  }

  Widget _DetaiStatistic(
      {String title,
      int Congthangtruoc,
      int Congthangnay,
      int phepnghi,
      int phepconlai,
      int dimuon,
      int vesom}) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                appBloc.statisticBloc.showMonthSelectStream.notify(
                    ShowChooseMonthModel(
                        state: StatisticState.THONG_KE,
                        isShow: true,
                        data: MonthYearModel(
                            month: appBloc.statisticBloc.selectedMonth,
                            year: appBloc.statisticBloc.selectedYear)));
              },
              child: Container(
                padding: EdgeInsets.only(left: 287.5.w, top: 67.h),
                child: Image.asset(
                  'asset/images/ic_calendar_statistic.png',
                  width: 60.0.w,
                ),
              ),
            ),
            SizedBox(
              width: 25.0.w,
            ),
            StreamBuilder<ShowChooseMonthModel>(
                initialData: ShowChooseMonthModel(
                    isShow: false,
                    state: StatisticState.NHAT_KY,
                    data: MonthYearModel(
                        month: DateTime.now().month,
                        year: DateTime.now().year)),
                stream:
                    appBloc.statisticBloc.showMonthSelectThongKeStream.stream,
                builder: (context, snapshot) {
                  int months = appBloc.statisticBloc.selectedMonth;
                  int years = appBloc.statisticBloc.selectedYear;
                  return Container(
                    margin: EdgeInsets.only(top: 67.h),
                    child: Text(
                      "Tháng $months - $years",
                      style: TextStyle(
                        fontFamily: 'Roboto-Bold',
                        fontSize: 52.sp,
                        color: Color(0xffe18c12),
                      ),
                    ),
                  );
                }),
            SizedBox(
              width: 15.0.w,
            ),
            Container(
              padding: EdgeInsets.only(top: 67.h),
              child: InkWell(
                onTap: () {
                  print('chọn ngày');
                  //  _pickDateMeeting();
                  appBloc.statisticBloc.showMonthSelectStream.notify(
                      ShowChooseMonthModel(
                          state: StatisticState.THONG_KE,
                          isShow: true,
                          data: MonthYearModel(
                              month: appBloc.statisticBloc.selectedMonth,
                              year: appBloc.statisticBloc.selectedYear)));
                },
                child: Image.asset(
                  'asset/images/ic_dropdown.png',
                  width: 35.0.w,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.0.h,
        ),
        _BuildContent(
            Congthangtruoc: Congthangtruoc,
            Congthangnay: Congthangnay,
            phepnghi: phepnghi,
            phepconlai: phepconlai,
            dimuon: dimuon,
            vesom: vesom),
      ],
    );
  }

  _BuildContent(
      {int Congthangtruoc,
      int Congthangnay,
      int phepnghi,
      int phepconlai,
      int dimuon,
      int vesom}) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(34.0),
            right: ScreenUtil().setWidth(34.0),
          ),
          height: ScreenUtil().setHeight(3.0),
          width: ScreenUtil().setWidth(1000.0),
          color: Color(0xffe18c12).withOpacity(0.5),
        ),
        SizedBox(
          height: 15.0.h,
        ),
        _Buildngaycong(thangtruoc: Congthangtruoc, thangnay: Congthangnay),
        SizedBox(
          height: 50.0.h,
        ),
        Container(
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(34.0),
            right: ScreenUtil().setWidth(34.0),
          ),
          height: ScreenUtil().setHeight(2.0),
          width: ScreenUtil().setWidth(1000.0),
          color: Color(0xff005a88).withOpacity(0.5),
        ),
        SizedBox(
          height: 20.0.h,
        ),
        _BuildNgayphep(danghi: phepnghi, conlai: phepconlai),
        SizedBox(
          height: 50.0.h,
        ),
        Container(
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(34.0),
            right: ScreenUtil().setWidth(34.0),
          ),
          height: ScreenUtil().setHeight(2.0),
          width: ScreenUtil().setWidth(1000.0),
          color: Color(0xff005a88).withOpacity(0.5),
        ),
        SizedBox(
          height: 20.0.h,
        ),
        _BuildDImuonVessom(Dimuon: dimuon, vesom: vesom)
      ],
    );
  }

  _BuildDImuonVessom({int Dimuon, int vesom}) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 83.5.h),
              child: Text(
                'Số lần đi muộn trong tháng',
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                  fontSize: 52.sp,
                  color: Color(0xff333333),
                ),
              ),
            ),
            SizedBox(
              width: 33.0.w,
            ),
            Container(
              child: Text(
                Dimuon.toString(),
                style: TextStyle(
                  fontFamily: 'Roboto-Bold',
                  fontSize: 52.sp,
                  color: Color(0xff005a88),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30.0.h,
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 83.5.h),
              child: Text(
                'Số lần về sớm trong tháng',
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                  fontSize: 52.sp,
                  color: Color(0xff333333),
                ),
              ),
            ),
            SizedBox(
              width: 33.0.w,
            ),
            Container(
//              margin: EdgeInsets.only(left: 83.5.h),
              child: Text(
                vesom.toString(),
                style: TextStyle(
                  fontFamily: 'Roboto-Bold',
                  fontSize: 52.sp,
                  color: Color(0xff005a88),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _Buildngaycong({int thangtruoc, int thangnay}) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 83.5.h),
              child: Text(
                'Tổng công tháng trước',
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                  fontSize: 52.sp,
                  color: Color(0xff333333),
                ),
              ),
            ),
            SizedBox(
              width: 33.0.w,
            ),
            Container(
//              margin: EdgeInsets.only(left: 83.5.h),
              child: Text(
                thangtruoc.toString(),
                style: TextStyle(
                  fontFamily: 'Roboto-Bold',
                  fontSize: 52.sp,
                  color: Color(0xff005a88),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30.0.h,
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 83.5.h),
              child: Text(
                'Tổng công tháng này',
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                  fontSize: 52.sp,
                  color: Color(0xff333333),
                ),
              ),
            ),
            SizedBox(
              width: 33.0.w,
            ),
            Container(
//              margin: EdgeInsets.only(left: 83.5.h),
              child: Text(
                thangnay.toString(),
                style: TextStyle(
                  fontFamily: 'Roboto-Bold',
                  fontSize: 52.sp,
                  color: Color(0xff005a88),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _BuildNgayphep({int danghi, int conlai}) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 83.5.h),
              child: Text(
                'Số phép đã nghỉ',
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                  fontSize: 52.sp,
                  color: Color(0xff333333),
                ),
              ),
            ),
            SizedBox(
              width: 33.0.w,
            ),
            Container(
              child: Text(
                danghi.toString(),
                style: TextStyle(
                  fontFamily: 'Roboto-Bold',
                  fontSize: 52.sp,
                  color: Color(0xff005a88),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30.0.h,
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 83.5.h),
              child: Text(
                'Số phép còn lại',
                style: TextStyle(
                  fontFamily: 'Roboto-Regular',
                  fontSize: 52.sp,
                  color: Color(0xff333333),
                ),
              ),
            ),
            SizedBox(
              width: 33.0.w,
            ),
            Container(
              child: Text(
                conlai.toString(),
                style: TextStyle(
                  fontFamily: 'Roboto-Bold',
                  fontSize: 52.sp,
                  color: Color(0xff005a88),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget tabBarStatistic_History(
      {bool haveBorder, String content, VoidCallback voidCallback}) {
    return InkWell(
      onTap: () {
        voidCallback();
      },
      child: Container(
        height: 81.h,
        width: 456.w,
        padding: EdgeInsets.only(top: 18.h),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: haveBorder ? Color(0xff005a88) : Color(0xffffffff),
              width: 2.w,
            ),
            bottom: BorderSide(
              color: haveBorder ? Colors.transparent : Color(0xff005a88),
              width: 2.w,
            ),
            left: BorderSide(
              color: haveBorder ? Color(0xff005a88) : Color(0xffffffff),
              width: 2.w,
            ),
            right: BorderSide(
              color: haveBorder ? Color(0xff005a88) : Color(0xffffffff),
              width: 2.w,
            ),
          ),
        ),
        child: Center(
          child: Text(
            content,
            style: TextStyle(
              fontFamily: 'Roboto-Bold',
              fontSize: 42.sp,
              color: haveBorder ? Color(0xff005a88) : Color(0xff959ca7),
            ),
          ),
        ),
      ),
    );
  }
}
