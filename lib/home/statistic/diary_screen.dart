import 'package:flutter/material.dart';
import '../../core/app_bloc.dart';
import '../../home/statistic/statistic_bloc.dart';
import 'package:flutter_screenutil/size_extension.dart';
import '../../utils/widget/date_diary_widget.dart';
import '../../utils/widget/statistic_no_data_widget.dart';
import '../../utils/widget/table_diary_widget.dart';

class DiaryScreen extends StatefulWidget {
  final AppBloc appBloc;

  const DiaryScreen({Key key, this.appBloc}) : super(key: key);

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      widget.appBloc.statisticBloc.getDiaryData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StreamBuilder<ShowChooseMonthModel>(
            initialData: ShowChooseMonthModel(
                isShow: false, state: StatisticState.NHAT_KY),
            stream:
                widget.appBloc.statisticBloc.showMonthSelectNhatKyStream.stream,
            builder: (context, snapshot) {
              int months = widget.appBloc.statisticBloc.selectedMonth;
              int years = widget.appBloc.statisticBloc.selectedYear;

              return DateDiaryWidget(
                date: "Tháng $months - $years",
                voidCallback: () {
                  widget.appBloc.statisticBloc.showMonthSelectStream.notify(
                      ShowChooseMonthModel(
                          state: StatisticState.NHAT_KY,
                          isShow: true,
                          data: MonthYearModel(month: months, year: years)));
                },
              );
            }),
        Expanded(
          child: StreamBuilder(
              initialData: DiaryModel(DiaryState.LOADING, null),
              stream: widget.appBloc.statisticBloc.diaryStream.stream,
              builder: (context, AsyncSnapshot<DiaryModel> snapshot) {
                switch (snapshot.data.state) {
                  case DiaryState.NONE:
                    return StatisticNoDataWidget("Hiện chưa có nhật ký nào.");
                    break;
                  case DiaryState.SHOW_DIARY_DATA:
                    widget.appBloc.statisticBloc.listDiaryDataModel =
                        snapshot.data.data;
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10.w,
                              spreadRadius: 0,
                            )
                          ]),
                      margin: EdgeInsets.only(left: 34.w),
                      child: TableDiaryWidget(),
                    );
                    break;
                  case DiaryState.LOADING:
                    return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                    break;
                  default:
                    return Container();
                    break;
                }
              }),
        )
      ],
    );
  }
}
