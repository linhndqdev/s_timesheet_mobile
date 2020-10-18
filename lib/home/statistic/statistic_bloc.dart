import 'package:core_asgl/stream/core_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:s_timesheet_mobile/home/statistic/diary_services.dart';
import 'package:s_timesheet_mobile/model/calendar_model.dart';

class StatisticBloc {
  CoreStream<StatisticModel> statisticStream = CoreStream();
  CoreStream<DiaryModel> diaryStream = CoreStream();
  CoreStream<int> monthSelectedStream = CoreStream();
  CoreStream<int> yearSelectedStream = CoreStream();

//  CoreStream<MonthYearModel> selectedMonthYearStream = CoreStream();
  CoreStream<ShowChooseMonthModel> showMonthSelectStream = CoreStream();
  CoreStream<ShowChooseMonthModel> showMonthSelectNhatKyStream = CoreStream();
  CoreStream<ShowChooseMonthModel> showMonthSelectThongKeStream = CoreStream();
  List<CalendarModel> listDiaryDataModel = [];
  int selectedMonth;
  int selectedYear;

  void genMonthYearOriginal() {
    selectedMonth = DateTime.now().month;
    selectedYear = DateTime.now().year;
  }

  Future<void> getDiaryData(BuildContext context) async {
    diaryStream?.notify(DiaryModel(DiaryState.LOADING, null));
    DiaryServices services = DiaryServices();
    DateTime current = DateTime.now();
    DateFormat format = DateFormat("yyyy-MM-dd");
    String startDate = "";
    String endDate = "";
    if (selectedMonth != null && selectedYear != null) {
      DateTime lastDayOfMonth =
          new DateTime(selectedYear, selectedMonth + 1, 0);
      DateTime firstDateOfMonth = DateTime(selectedYear, selectedMonth, 1);
      startDate = format.format(firstDateOfMonth);
      endDate = format.format(lastDayOfMonth);
    } else {
      DateTime lastDayOfMonth =
          new DateTime(current.year, current.month + 1, 0);
      DateTime firstDateOfMonth = DateTime(current.year, current.month, 1);
      startDate = format.format(firstDateOfMonth);
      endDate = format.format(lastDayOfMonth);
    }
    await services.getAllDataDiary(startDate, endDate, (result) {
      Iterable i = result['work_schedules'];
      if (i != null && i.length > 0) {
        List<CalendarModel> listData =
            i.map((data) => CalendarModel.fromJson(data)).toList();
        listData.sort((o1, o2) => o1.date.compareTo(o2.date));
        diaryStream?.notify(DiaryModel(DiaryState.SHOW_DIARY_DATA, listData));
      } else {
        diaryStream?.notify(DiaryModel(DiaryState.NONE, null));
      }
    }, (onError) {
      diaryStream?.notify(DiaryModel(DiaryState.NONE, null));
    });
  }

  void getDataFakeStatistic() async {}
}

enum StatisticState { THONG_KE, NHAT_KY }

class StatisticModel {
  StatisticState state;

  StatisticModel({this.state});
}

enum DiaryState { NONE, SHOW_DIARY_DATA, LOADING }

class DiaryModel {
  DiaryState state;
  List<CalendarModel> data;

  DiaryModel(this.state, this.data);
}

class MonthYearModel {
  int month;
  int year;

  MonthYearModel({this.month, this.year});
}

class ShowChooseMonthModel {
  StatisticState state;
  bool isShow;
  MonthYearModel data;

  ShowChooseMonthModel({this.state, this.isShow, this.data});
}
