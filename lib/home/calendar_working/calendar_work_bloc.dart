import 'dart:convert';

import 'package:core_asgl/core_asgl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/home/calendar_working/calendar_services.dart';
import 'package:s_timesheet_mobile/home/calendar_working/information_shift_member_model.dart';
import 'package:s_timesheet_mobile/model/calendar_model.dart';
import 'package:s_timesheet_mobile/model/choose_shift_model.dart';
import 'package:s_timesheet_mobile/model/list_shift_can_change_model.dart';
import 'package:s_timesheet_mobile/utils/common/datetime_utils.dart';
import 'package:s_timesheet_mobile/utils/model/dialog_model.dart';
import 'package:s_timesheet_mobile/utils/widget/dialog_util.dart';
import 'package:table_calendar/table_calendar.dart';

enum CalendarDayStreamState {
  NO_DATA,
  SHOW,
  LOADING,
}

class CalendarDayStreamModel {
  CalendarDayStreamState state;
  dynamic data;

  CalendarDayStreamModel(this.state, this.data);
}

enum DataChooseShiftState { LOAD_DING, HAS_DATA, NO_DATA }

class DataChooseShiftModel {
  DataChooseShiftState state;

  DataChooseShiftModel({this.state});
}

class CalendarWorkBloc {
  DateTime selectedDay = DateTime.now();
  bool isSelectToday = false;

//  AnimationController animationController;
//  bool isClickToday = false;
  CoreStream<ShiftStateModel> shiftStateStream = CoreStream<ShiftStateModel>();
  CoreStream<ChooseShiftDataModel> choseItemShiftStream =
      CoreStream<ChooseShiftDataModel>();
  CoreStream<bool> sabbaticalStream = CoreStream<bool>();
  CoreStream<ChangeColorbuttonModel> ChangeColorbuttonStream =
      CoreStream<ChangeColorbuttonModel>();
  CoreStream<bool> searchMemberShift = CoreStream();
  CoreStream<DataChooseShiftModel> dataStatusStream = CoreStream();
  CoreStream<List<ChooseShiftModel>> listShiftDateStream = CoreStream();
  CoreStream<CalendarDayStreamModel> workScheduleStream = CoreStream();

  CoreStream<DateTime> selectedDateStream = CoreStream();
  CoreStream<CalendarModel> workScheduleDetailStream = CoreStream();
  CoreStream<List<Schedule>> listShiftCanChangeStream = CoreStream();
  InformationShiftMemberModel informationShiftMemberModel;
  List<InformationShiftMemberModel> listInformationShiftMemberModel = List();
  List<InformationShiftMemberModel> listShiftMemberModel = List();
  List<ChooseShiftModel> listShiftDates = [];
  Map<int, bool> mapShiftData = Map();
  CalendarModel workScheduleDetail;
  CoreStream<DateTime> selectTimeStream = CoreStream();

  CoreStream<bool> searchMentionsUserStream = CoreStream();
  InformationShiftMemberModel choosedShift;
  List<Schedule> listShiftCanChange;
  List<RichTextModel> listRichTextSucess = [];
  List<CalendarModel> listCalendarDataCurrent;

  Map<DateTime, List<dynamic>> mapDataSchedule = Map();

//  CoreStream<List<ListShiftMemberModel>> searchNameShiftStream = CoreStream();
//  bool isSendSwitchShip = false;
  void dispose() {
    listShiftDateStream?.close();
    listShiftCanChangeStream?.close();
    selectTimeStream?.close();
    selectedDateStream?.close();
    shiftStateStream?.close();
//    sabbaticalStream?.close();
    choseItemShiftStream?.close();
    dataStatusStream?.close();
  }

//  void disableWithAnimationCalendar(VoidCallback voidCallback){
//    animationController.reverse();
//    Future.delayed(Duration(milliseconds: 500), () {
//      voidCallback();
//    });
//  }
  void notifyNoData() {
    CalendarDayStreamModel model =
        CalendarDayStreamModel(CalendarDayStreamState.NO_DATA, null);
    workScheduleStream?.notify(model);
  }

  void onVisibleDaysChanged(
      {DateTime first, DateTime last, CalendarController calendarController}) {
//    if(isRunning)return;
    DateTime firstNew =
        DateTime(first.year, first.month, first.day, 0, 0, 0, 0, 0);
    if (isSelectToday) {
      return null;
    } else if (firstNew.millisecondsSinceEpoch >=
        selectedDay.millisecondsSinceEpoch) {
      //      print('ấn next');
      DateTime firstTimeInCurrentMonth =
          DateTime(selectedDay.year, selectedDay.month, 1);
      DateTime getDayOfNextMonth =
          firstTimeInCurrentMonth.add(Duration(days: 35));
      DateTime firstDayOfNextMonth = DateTime(
          getDayOfNextMonth.year, getDayOfNextMonth.month, 1, 0, 0, 0, 0);
      onDaySelectedParent(
          day: firstDayOfNextMonth, calendarController: calendarController);
    } else {
//      print('ấn prev');
      DateTime lastTimeInPrevMonth =
          DateTime(selectedDay.year, selectedDay.month, 1)
              .subtract(Duration(days: 1));
      DateTime firstTimeInPrevMonth =
          DateTime(lastTimeInPrevMonth.year, lastTimeInPrevMonth.month, 1);
      onDaySelectedParent(
          day: firstTimeInPrevMonth, calendarController: calendarController);
    }
  }

  void selectToday(CalendarController calendarController) {
    //calendarController?.setSelectedDay(DateTime.now());
    //onDaySelected(day: DateTime.now(), events: null);

    onDaySelectedParent(
        day: DateTime.now(), calendarController: calendarController);
    isSelectToday = false;
  }

  void onDaySelectedParent(
      {DateTime day, CalendarController calendarController}) async {
    String todayStr = DateTimeUtils.convertDate(DateTime.now());
    String dayStr = DateTimeUtils.convertDate(day);
    if (todayStr == dayStr)
      isSelectToday = true;
    else
      isSelectToday = false;
    String selectedDayStr = DateTimeUtils.convertMonthYear(selectedDay);
//    String selectedDay = DateTimeUtils.convertMonthYear(day);
    String nowS = DateTimeUtils.convertMonthYear(day);

    if (selectedDayStr == nowS) {
      calendarController?.setSelectedDay(day);
      //onDaySelected(day: day, events: null);
//      Map<int, String> mapDate = DateTimeUtils.getFirstDateAndLastDate(day);
      await getWorkSchedulesMonth(
          startDate: dayStr,
          endDate: dayStr,
          isInit: isSelectToday,
          inCurrentMonth: true);
      isSelectToday = false;
    } else {
      Map<int, String> mapDate = DateTimeUtils.getFirstDateAndLastDate(day);
      DateTime selectDate =
          isSelectToday ? DateTime.now() : DateTime.parse(mapDate[0]);
      calendarController?.setSelectedDay(selectDate);

      await getWorkSchedulesMonth(
          startDate: mapDate[0], endDate: mapDate[1], isInit: isSelectToday);
      isSelectToday = false;
    }
  }

  void onDaySelected({
    DateTime day,
    List events,
  }) {

    String selectedDayStr = DateTimeUtils.convertDate(day);
    List<CalendarModel> listModel = List<CalendarModel>();
    CalendarDayStreamModel model =
        CalendarDayStreamModel(CalendarDayStreamState.NO_DATA, null);
    if (listCalendarDataCurrent != null && listCalendarDataCurrent.length > 0) {
      listCalendarDataCurrent.forEach((key) {
        if (key.date == selectedDayStr) {
          listModel.add(key);
        }
      });
      if (listModel.length > 0) {
        model = CalendarDayStreamModel(CalendarDayStreamState.SHOW, listModel);
      } else {
        model = CalendarDayStreamModel(CalendarDayStreamState.NO_DATA, null);
      }
    } else {
      model = CalendarDayStreamModel(CalendarDayStreamState.NO_DATA, null);
    }
//    bool hasData = false;
//    if (listModel.length > 0) {
//      listModel.forEach((key) {
//        if (key.date == selectedDayStr) hasData = true;
//      });
//    }
    updateCalendarDate(day);
//    if (hasData)
      workScheduleStream?.notify(model);
//    else {
//      model = CalendarDayStreamModel(CalendarDayStreamState.NO_DATA, null);
//      workScheduleStream?.notify(model);
//    }
  }

//  bool isRunning = false;

  Future getWorkSchedulesMonth(
      {String startDate,
      String endDate,
      bool isInit = false,
      bool inCurrentMonth = false}) async {
    DateTime day = isInit ? DateTime.now() : DateTime.parse(startDate);
    selectedDay = DateTime(day.year, day.month, day.day, 0, 0, 0, 0);
//    if (isRunning) return;
//    isRunning = true;
    CalendarDayStreamModel model =
        CalendarDayStreamModel(CalendarDayStreamState.LOADING, null);
    workScheduleStream?.notify(model);

    if (!inCurrentMonth) {
      listCalendarDataCurrent = List();
      CalendarServices calendarServices = CalendarServices();
      await calendarServices.getWorkSchedules(
          startTime: startDate,
          endTime: endDate,
          resultData: (data) {
//            isRunning = false;
            if (data != null && data != "") {
              Iterable i = data['work_schedules'];
              if (i != null && i.length > 0) {
                listCalendarDataCurrent =
                    i.map((data) => CalendarModel.fromJson(data)).toList();
                mapDataSchedule = Map();
                listCalendarDataCurrent.forEach((key) {
                  List<DateTime> listDate = List();
                  DateTime dateKey = DateTime.parse(key.date);
                  listDate.add(dateKey);
                  mapDataSchedule[dateKey] = listDate;
                });
              } else {
                //notifyNoData();
                // isRunning = false;
              }
            }
          },
          onErrorApiCallBack: (onError) {
//            isRunning = false;
          });
    }
    onDaySelected(day: day, events: null);
//    isRunning = false;
  }

  Future getDataToSwitchShift({int idShift, AppBloc appBloc}) async {
//    AppBloc appBloc;
    appBloc.authBloc.loadingStream.notify(true);
    listInformationShiftMemberModel = [];
    CalendarServices calendarServices = CalendarServices();
    await calendarServices.getUsershift(
        idShift: idShift,
        onResultData: (data) {
          if (data != null && data != "") {
            appBloc.authBloc.loadingStream.notify(false);
            for (int i = 0; i < data['users'].length; i++) {
              listInformationShiftMemberModel.add(
                InformationShiftMemberModel.createInformationShiftMemberModel(
                    idMember: data['users'][i]['id'],
                    asglID: data['users'][i]['asgl_id'],
                    date: "",
                    time: "",
                    nameMember: data['users'][i]['full_name'],
                    nameShift: "",
                    idShift: idShift),
              );
            }
          }
        },
        onErrorApiCallBack: (onError) {
          workScheduleStream?.notify(
              CalendarDayStreamModel(CalendarDayStreamState.NO_DATA, null));
          Toast.showShort(
              "Không tải được dữ liệu hoặc kết nối không ổn định!");
          appBloc.authBloc.loadingStream.notify(false);
        });
  }

  void filterSearchResults(String query) {
    if (query?.trim() != "") {
      List<InformationShiftMemberModel> listAccountResult =
          listInformationShiftMemberModel.where((account) {
        if (account.nameMember.contains(query) ||
            account.nameMember.toLowerCase().contains(query.toLowerCase()) ||
            account.nameMember.toUpperCase().contains(query.toUpperCase())) {
          return true;
        } else {
          return false;
        }
      }).toList();
      listShiftMemberModel = List();
      if (listAccountResult != null && listAccountResult.length > 0) {
        for (int i = 0; i < listAccountResult.length; i++) {
          listShiftMemberModel.add(
            InformationShiftMemberModel.createInformationShiftMemberModel(
                idMember: listAccountResult[i].idMember,
                nameMember: listAccountResult[i].nameMember,
                idShift: listAccountResult[i].idShift,
                nameShift: listAccountResult[i].nameShift,
                time: listAccountResult[i].time,
                date: listAccountResult[i].date,
                asglID: listAccountResult[i].asglID,
                isInit: false,
                choseDay: listAccountResult[i].choseDay,
                idShiftChange: listAccountResult[i].idShiftChange),
          );
        }
        searchMemberShift.notify(true);
      }
    } else {
      listShiftMemberModel = listInformationShiftMemberModel;
      searchMemberShift.notify(true);
    }
  }

  void updateCalendarDate(DateTime day) {
    selectTimeStream?.notify(day);
    selectedDateStream?.notify(day);
  }

  Future getWorkSchedulesDetail({int id, AppBloc appBloc}) async {
    appBloc.authBloc.loadingStream.notify(true);
    CalendarServices calendarServices = CalendarServices();
    await calendarServices.getWorkSchedulesDetail(
        id: id,
        onResultData: (data) {
          if (data != null && data != "") {
            appBloc.authBloc.loadingStream.notify(false);
            appBloc.authBloc.loadingStream.notify(false);
            workScheduleDetail = CalendarModel.fromJson(data['work_schedule']);
            if (workScheduleDetail != null)
              workScheduleDetailStream?.notify(workScheduleDetail);
            else
              workScheduleStream?.notify(
                  CalendarDayStreamModel(CalendarDayStreamState.NO_DATA, null));
            appBloc.authBloc.loadingStream.notify(false);
          }
        },
        onErrorApiCallBack: (onError) {
          workScheduleStream?.notify(
              CalendarDayStreamModel(CalendarDayStreamState.NO_DATA, null));
          Toast.showShort(
              "Không tải được dữ liệu hoặc kết nối không ổn địng!");
          appBloc.authBloc.loadingStream.notify(false);
        });
  }

  Future getSabaticalDetail({int id, AppBloc appBloc}) async {
    appBloc.authBloc.loadingStream.notify(true);
    CalendarServices calendarServices = CalendarServices();
    await calendarServices.getWorkSchedulesDetail(
        id: id,
        onResultData: (data) {
          if (data != null && data != "") {
            appBloc.authBloc.loadingStream.notify(false);
            appBloc.authBloc.loadingStream.notify(false);
            workScheduleDetail = CalendarModel.fromJson(data['work_schedule']);
            if (workScheduleDetail != null)
              workScheduleDetailStream?.notify(workScheduleDetail);
            else
              workScheduleStream?.notify(
                  CalendarDayStreamModel(CalendarDayStreamState.NO_DATA, null));
            appBloc.authBloc.loadingStream.notify(false);
          }
        },
        onErrorApiCallBack: (onError) {
          workScheduleStream?.notify(
              CalendarDayStreamModel(CalendarDayStreamState.NO_DATA, null));
          Toast.showShort(
              "Không tải được dữ liệu hoặc kết nối không ổn địng!");
          appBloc.authBloc.loadingStream.notify(false);
        });
  }

  Future SendSabatical(BuildContext context,
      {int id, String lydoxinnghi, DateTime DT, AppBloc appBloc}) async {
    appBloc.authBloc.loadingStream.notify(true);
    CalendarServices calendarServices = CalendarServices();
    await calendarServices.postSendSablatical(
        id: id,
        lydo: lydoxinnghi,
        onResultData: (data) {
          if (data != null && data != "") {
            appBloc.authBloc.loadingStream.notify(false);
            if (data['data'] != null && data['success'] == true) {
              appBloc.calendarWorkBloc.onDaySelected(day: DT, events: null);
              appBloc.calendarWorkBloc.shiftStateStream
                  .notify(ShiftStateModel(state: ShiftState.NONE));
              DialogUtil.showDialogProject(
                context,
                dialogModel: DialogModel(
                  state: DialogType.INAPP,
                  urlAssetImageLogo: "asset/images/ic_success_accent.png",
                  listRichText: [
                    RichTextModel(data['message'].toString(), 0xff333333, 52,
                        "Roboto-Regular")
                  ],
                  marginRichText: EdgeInsets.only(
                    bottom: 144.0.h,
                  ),
                ),
              );
              appBloc.authBloc.loadingStream.notify(false);
            } else {
              appBloc.calendarWorkBloc.shiftStateStream
                  .notify(ShiftStateModel(state: ShiftState.NONE));
              DialogUtil.showDialogProject(
                context,
                dialogModel: DialogModel(
                  state: DialogType.INAPP,
                  urlAssetImageLogo: "asset/images/ic_info.png",
                  listRichText: [
                    RichTextModel(data['message'].toString(), 0xff333333, 52,
                        "Roboto-Regular")
                  ],
                  marginRichText: EdgeInsets.only(
                    bottom: 144.0.h,
                  ),
                ),
              );
            }
          }
        },
        onErrorApiCallBack: (onError) {
          workScheduleStream?.notify(
              CalendarDayStreamModel(CalendarDayStreamState.NO_DATA, null));
          Toast.showShort(
              "Không tải được dữ liệu hoặc kết nối không ổn định!");
          appBloc.authBloc.loadingStream.notify(false);
        });
  }

  void SendSwitchShift(
      BuildContext context,
      int base_schedule_id,
      int swap_schedule_id,
      String lydoxinnghi,
      AppBloc appBloc,
      DateTime dt) async {
    appBloc.authBloc.loadingStream.notify(true);
    CalendarServices calendarServices = CalendarServices();
    await calendarServices.postSendSwichshift(
        idShift: base_schedule_id,
        idShiftchange: swap_schedule_id,
        lydo: lydoxinnghi,
        onResultData: (data) {
          if (data != null && data != "") {
            appBloc.authBloc.loadingStream.notify(false);
            if (data['data'] == null && data['error_code'] == 500) {
              appBloc.calendarWorkBloc.shiftStateStream
                  .notify(ShiftStateModel(state: ShiftState.NONE));
//              appBloc.calendarWorkBloc.onDaySelected(day: dt, events: null);
              DialogUtil.showDialogProject(context,
                  dialogModel: DialogModel(
                      state: DialogType.INAPP,
                      urlAssetImageLogo: "asset/images/ic_success_accent.png",
                      listRichText: [
                        RichTextModel(data['message'].toString(), 0xff333333,
                            52, "Roboto-Regular")
                      ],
                      marginRichText: EdgeInsets.only(
                        bottom: 144.0.h,
                      )));
            } else {
              appBloc.calendarWorkBloc.shiftStateStream
                  .notify(ShiftStateModel(state: ShiftState.NONE));
              appBloc.calendarWorkBloc.onDaySelected(day: dt, events: null);
              DialogUtil.showDialogProject(context,
                  dialogModel: DialogModel(
                      state: DialogType.INAPP,
                      urlAssetImageLogo: "asset/images/ic_success_accent.png",
                      listRichText: [
                        RichTextModel(
                            "Yêu cầu của bạn đã được gửi thành công.Vui lòng chờ quản lý phê duyệt.",
                            0xff333333,
                            52,
                            "Roboto-Regular")
                      ],
                      marginRichText: EdgeInsets.only(
                        bottom: 144.0.h,
                      )));
              appBloc.authBloc.loadingStream.notify(false);
            }
          }
        },
        onErrorApiCallBack: (onError) {
          workScheduleStream?.notify(
              CalendarDayStreamModel(CalendarDayStreamState.NO_DATA, null));
          Toast.showShort(
              "Không tải được dữ liệu hoặc kết nối không ổn định!");
          appBloc.authBloc.loadingStream.notify(false);
        });
  }

  Future getShiftCanChange(
      {int idShift,
      int idUserWillChange,
      AppBloc appBloc,
      InformationShiftMemberModel oldData}) async {
    dataStatusStream
        .notify(DataChooseShiftModel(state: DataChooseShiftState.LOAD_DING));
    CalendarServices calendarServices = CalendarServices();
    await calendarServices.getShiftCanChangeService(
        idShift: idShift,
        idUserWillChange: idUserWillChange,
        onResultData: (data) {
          if (data != null && data != "") {
            listShiftCanChange =
                listShiftCanChangeFromJson(jsonEncode(data))?.schedules;
            if (listShiftCanChange != null) {
              listShiftCanChangeStream?.notify(listShiftCanChange);

              listShiftDates = [];
              mapShiftData = Map();
              for (int i = 0; i < listShiftCanChange.length; i++) {
                List<ShiftData> _listEventDataModel = List<ShiftData>();
                Schedule _schedule = listShiftCanChange[i];
                bool isSelected = false;
                if (oldData.idShiftChange != null &&
                    oldData.idShiftChange == _schedule.id) {
                  isSelected = true;
                }
                if (_schedule.shift.workTimes.length > 1 ||
                    _schedule.shift.workTimes.length <= 0) {
                  continue;
                }
                mapShiftData[i] = isSelected;
                String startAt = _schedule.shift?.workTimes[0]?.startAt;
                startAt = startAt != null
                    ? startAt.substring(0, startAt.length - 3)
                    : "";
                String finishAt = _schedule.shift?.workTimes[0]?.finishAt;
                finishAt = finishAt != null
                    ? finishAt.substring(0, finishAt.length - 3)
                    : "";

                _listEventDataModel.add(ShiftData.createShiftData(
                    idShift: _schedule.shift.id,
                    index: i,
                    shift: _schedule.shift.name,
                    timeIn: startAt,
                    timeOut: finishAt,
                    location: _schedule.location.name,
                    isSelected: isSelected));
                listShiftDates.add(ChooseShiftModel.createData(
                    date: "Ngày " + DateTimeUtils.convertDate2(_schedule.date),
                    listEventDataModel: _listEventDataModel));
              }
//              listShiftDateStream?.notify(listShiftDates);
              dataStatusStream.notify(
                  DataChooseShiftModel(state: DataChooseShiftState.HAS_DATA));
            } else {
//              Toast.showShort("Không lấy được dữ liệu ca");
              dataStatusStream.notify(
                  DataChooseShiftModel(state: DataChooseShiftState.NO_DATA));
            }
          }
        },
        onErrorApiCallBack: (onError) {
          appBloc.authBloc.loadingStream.notify(false);
          dataStatusStream.notify(
              DataChooseShiftModel(state: DataChooseShiftState.NO_DATA));
//          Toast.showShort(
//              "Không tải được dữ liệu hoặc kết nối không ổn địng!");
        });
  }

  ///tạo dữ liệu mẫu chọn ca
  createSampleChooseShiftData() {
    listShiftDates = [];
    List<ShiftData> listEventData = [];
    List<ShiftData> listEventData2 = [];
    List<ShiftData> listEventData3 = [];

    for (int i = 0; i < 3; i++) {
      mapShiftData[i] = false;
      listEventData.add(ShiftData.createShiftData(
        index: i,
        timeIn: "08:00",
        timeOut: "05:00",
        isSelected: false,
        shift: "Ca hành chính",
        location: "Văn phòng Hà Nội",
      ));
    }
    for (int i = 3; i < 5; i++) {
      mapShiftData[i] = false;
      listEventData2.add(ShiftData.createShiftData(
        index: i,
        timeIn: "08:00",
        timeOut: "05:00",
        isSelected: false,
        shift: "Ca hành chính",
        location: "Văn phòng Hà Nội",
      ));
    }
    for (int i = 6; i < 8; i++) {
      mapShiftData[i] = false;
      listEventData3.add(ShiftData.createShiftData(
        index: i,
        timeIn: "08:00",
        timeOut: "05:00",
        isSelected: false,
        shift: "Ca hành chính",
        location: "Văn phòng Hà Nội",
      ));
    }

    listShiftDates.add(ChooseShiftModel.createData(
        date: "Ngày 22-08-2020", listEventDataModel: listEventData));
    listShiftDates.add(ChooseShiftModel.createData(
        date: "Ngày 21-08-2020", listEventDataModel: listEventData2));
    listShiftDates.add(ChooseShiftModel.createData(
        date: "Ngày 20-08-2020", listEventDataModel: listEventData3));
    listShiftDateStream.notify(listShiftDates);
  }
}

enum ChangeColorbutton { YES, NO }

class ChangeColorbuttonModel {
  ChangeColorbutton state;

  ChangeColorbuttonModel({this.state});
}

enum ShiftState {
  NONE,
  DOI_CA,
  CHON_CA,
  XIN_NGHI,
  CHI_TIET,
  INFOMATIONSHIFT,
}

class ShiftCanChangeDataModel {
  int idShift;
  int idUserWillChange;

  ShiftCanChangeDataModel({this.idShift, this.idUserWillChange});
}

class ShiftStateModel {
  ShiftState state;

  //ShiftCanChangeDataModel dataShiftCanChange;
  dynamic data;
  dynamic status;
  dynamic days;

  ShiftStateModel({this.state, this.data, this.status, this.days});
}

enum DataCalendarState { YES, NO }

class DataCalendarModel {
  DataCalendarState state;
  dynamic data;

  DataCalendarModel({this.state, this.data});
}

class ChooseShiftDataModel {
  int id;
  bool state;

  ChooseShiftDataModel({this.id, @required this.state});
}
