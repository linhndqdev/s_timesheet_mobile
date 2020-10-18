import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:s_timesheet_mobile/core/core.dart';
import 'package:s_timesheet_mobile/utils/common/datetime_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final AppBloc appBloc;

  const CalendarWidget({Key key, this.appBloc}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget>
    with TickerProviderStateMixin {
  CalendarController _calendarController;

  Map<DateTime, List> _events;

  AnimationController _animationController;

  void initState() {
    super.initState();

    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) async {
    widget.appBloc.calendarWorkBloc
        .onDaySelectedParent(day: day, calendarController: _calendarController);
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    widget.appBloc.calendarWorkBloc.onVisibleDaysChanged(
        first: first, last: last, calendarController: _calendarController);
  }

  @override
  Widget build(BuildContext context) {
//    widget.appBloc.calendarWorkBloc.selectedDay = DateTime.now();
//    DateTime selectedDay = widget.appBloc.calendarWorkBloc.selectedDay;
    AppBloc appBloc = widget.appBloc;
    return StreamBuilder<DateTime>(
        initialData: DateTime.now(),
        stream: appBloc.calendarWorkBloc.selectTimeStream.stream,
        builder: (context, snapshot) {
//          if (snapshot.data == null) {
          return _buildTableCalendarWithBuilders(snapshot.data);
//          } else {
////            selectDate(snapshot.data);
//            if (_calendarController?.selectedDay != null) {
//              _calendarController?.setSelectedDay(
//                snapshot.data,
//                runCallback: false,
//              );
//            }
//            return _buildTableCalendarWithBuilders(snapshot.data);
//          }
        });
  }

  void selectDate(DateTime data) {
    Future.delayed(Duration.zero, () {
      _calendarController.setSelectedDay(
        data,
        runCallback: false,
      );
    });
  }

  buildBtnToday() {
    return InkWell(
      onTap: () {
        widget.appBloc.calendarWorkBloc.isSelectToday = true;
        widget.appBloc.calendarWorkBloc.selectToday(_calendarController);
      },
      child: Row(
        children: <Widget>[
          Text("HÔM NAY",
              style: TextStyle(
                  color: Color(0xff959ca7),
                  fontSize: 36.sp,
                  height: 1.33,
                  fontFamily: "Roboto-Medium")),
          SizedBox(width: 48.3.w),
          Image.asset('asset/images/ic_refresh.png',
              width: 34.7.w, height: 47.7.h),
        ],
      ),
    );
  }

  Widget _buildTableCalendarWithBuilders(DateTime selectedDay) {
    return Column(
      children: <Widget>[
        Row(
//                      mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(child: Container()),
            buildBtnToday(),
            SizedBox(width: 59.w),
          ],
        ),
        Container(
//      padding: EdgeInsets.only(left:60.w,right: 60.w ),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      width: 1.h, color: Color.fromRGBO(48, 50, 70, 0.2)),
                  bottom: BorderSide(
                      width: 1.h, color: Color.fromRGBO(48, 50, 70, 0.2)))),
          child: TableCalendar(
            locale: 'vi_VN',
            calendarController: _calendarController,
            events: widget.appBloc.calendarWorkBloc.mapDataSchedule,
            initialCalendarFormat: CalendarFormat.month,
            initialSelectedDay: selectedDay,
            formatAnimation: FormatAnimation.slide,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableGestures: AvailableGestures.none,
            availableCalendarFormats: const {
              CalendarFormat.month: '',
              CalendarFormat.twoWeeks: ''
            },

            headerStyle: HeaderStyle(
              centerHeaderTitle: true,
              titleTextStyle: TextStyle(
                  color: Color(0xffe18c12),
                  fontSize: 52.sp,
                  fontFamily: "Roboto-Medium"),
              leftChevronPadding: EdgeInsets.only(left: 80.9.w - 12.0),
              rightChevronPadding: EdgeInsets.only(right: 80.9.w - 12.0),
              leftChevronIcon:
                  Icon(Icons.chevron_left, color: Color(0xFF005a88)),
              rightChevronIcon:
                  Icon(Icons.chevron_right, color: Color(0xFF005a88)),
              titleTextBuilder: (dateTime, dynamic) {
                // print(dateTime.toString());
                return "Tháng " +
                    dateTime.month.toString() +
                    " - " +
                    dateTime.year.toString();
              },
              formatButtonVisible: false,
            ),

            calendarStyle: CalendarStyle(
              contentPadding:
                  EdgeInsets.only(left: 60.w - 8.0, right: 60.w - 8.0),
              weekdayStyle: TextStyle().copyWith(
                  color: Color(0xFF333333),
                  fontFamily: "Roboto-Regular",
                  fontSize: 42.sp),
              outsideDaysVisible: false,
              outsideStyle: TextStyle(color: const Color(0xFF9E9E9E)),
              outsideWeekendStyle: TextStyle(color: const Color(0xFF9E9E9E)),

              weekendStyle: TextStyle().copyWith(
                  color: Color(0xFF959ca7),
                  fontFamily: "Roboto-Regular",
                  fontSize: 42.sp),
              holidayStyle: TextStyle().copyWith(
                  color: Colors.blue[800], fontWeight: FontWeight.bold),
            ),

            daysOfWeekStyle: DaysOfWeekStyle(
              dowTextBuilder: (dateTime, dynamic) {
                String date = DateFormat('EEEE').format(dateTime);
                String date_vi = "";
                switch (date) {
                  case "Monday":
                    return date_vi = "Th2";
                  case "Tuesday":
                    return date_vi = "Th3";
                  case "Wednesday":
                    return date_vi = "Th4";
                  case "Thursday":
                    return date_vi = "Th5";
                  case "Friday":
                    return date_vi = "Th6";
                  case "Saturday":
                    return date_vi = "Th7";
                  case "Sunday":
                    return date_vi = "CN";
                }
                return date_vi;
              },
              weekdayStyle: TextStyle().copyWith(
                  color: Color(0xFF005a88),
                  fontFamily: "Roboto-Regular",
                  fontSize: 46.sp),
              weekendStyle: TextStyle().copyWith(
                  color: Color(0xFF959ca7),
//              fontWeight: FontWeight.bold,
                  fontFamily: "Roboto-Regular",
                  fontSize: 46.sp),
            ),
            builders: CalendarBuilders(
              dowWeekdayBuilder: (context, weekday) {
                if (weekday == "CN")
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      '${weekday}',
                      style: TextStyle().copyWith(
                          color: Color(0xFF959ca7),
                          fontFamily: "Roboto-Regular",
                          fontSize: 46.sp),
                    ),
                  );
                else
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      '${weekday}',
                      style: TextStyle().copyWith(
                          color: Color(0xFF005a88),
                          fontFamily: "Roboto-Regular",
                          fontSize: 46.sp),
                    ),
                  );
              },
              weekendDayBuilder: (context, datetimes, _) {
                String date = DateFormat('EEEE').format(datetimes);
                switch (date) {
                  case "Saturday":
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${datetimes.day}',
                        style: TextStyle().copyWith(
                            fontSize: 42.sp,
                            color: Color(0xFF333333),
                            fontFamily: "Roboto-Regular"),
                      ),
                    );
                  case "Sunday":
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${datetimes.day}',
                        style: TextStyle().copyWith(
                            fontSize: 42.sp,
                            color: Color(0xFF333333),
                            fontFamily: "Roboto-Regular"),
                      ),
                    );
                }
                return Container();
              },
              outsideWeekendDayBuilder: (context, datetimes, _) {
                //print(datetimes);
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${datetimes.day}',
                    style: TextStyle().copyWith(
                        fontSize: 42.sp,
                        color: Color(0xFF959ca7),
                        fontFamily: "Roboto-Regular"),
                  ),
                );
              },
              outsideDayBuilder: (context, datetimes, _) {
                //print(datetimes);
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${datetimes.day}',
                    style: TextStyle().copyWith(
                        fontSize: 42.sp,
                        color: Color(0xFF959ca7),
                        fontFamily: "Roboto-Regular"),
                  ),
                );
              },
              selectedDayBuilder: (context, date, _) {
                return FadeTransition(
                  opacity:
                      Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 5.w, color: Color(0xFF005a88)),
                        shape: BoxShape.circle),
                    margin: const EdgeInsets.all(10.0),
                    width: 90.w,
                    height: 90.h,
                    child: Text(
                      '${date.day}',
                      style: TextStyle().copyWith(
                          fontSize: 42.sp,
                          color: Color(0xFF333333),
                          fontFamily: "Roboto-Regular"),
                    ),
                  ),
                );
              },
              todayDayBuilder: (context, date, _) {
                // print(date.toString());
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${date.day}',
                    style: TextStyle().copyWith(
                        fontSize: 42.sp,
                        color: Color(0xFF333333),
                        fontFamily: "Roboto-Regular"),
                  ),
                );
              },
              markersBuilder: (context, date, events, holidays) {
                final children = <Widget>[];
                if (events.isNotEmpty) {
                  children.add(
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildEventsMarker(date, events),
                    ),
                  );
                }

                if (holidays.isNotEmpty) {
                  children.add(
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildHolidaysMarker(),
                    ),
                  );
                }
                return children;
              },
            ),

            onDaySelected: (date, events) {
              _onDaySelected(date, events);
              //widget.appBloc.calendarWorkBloc.onDaySelected(date, events);
              _animationController.forward(from: 0.0);
            },
            onVisibleDaysChanged:_onVisibleDaysChanged
          ),
        ),
      ],
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 300),
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: Colors.blue[400]),
      width: 8.0,
      height: 8.0,
      child: Container(),
    );
  }

  Widget _buildEventsMarker_old(DateTime date, List events) {
    DateTime now = DateTime.now();
    String formattedDateNow = DateFormat('yyyy-MM-dd').format(now);
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    String formattedSelectDaysDate = DateFormat('yyyy-MM-dd')
        .format(widget.appBloc.calendarWorkBloc.selectedDay);
    Color color;
//    if (formattedSelectDaysDate.contains(formattedDate)) {
//      color = Color(0xffffffff);
//      //Không màu
//    } else {
    color = Color(0xffe18c12);
//    }
//    else if (formattedDateNow.contains(formattedDate)) {
//      color = Color(0xffe18c12);
//    } else {
//      //Màu trắng
//      color = Color(0xffdc3023);
//    }

    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Container(
          child: Center(
            child: Icon(
              Icons.brightness_1,
              color: color,
              size: ScreenUtil().setHeight(13.0),
            ),
          ),
        ));
  }

  Widget _buildEventsMarker1(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }
}
