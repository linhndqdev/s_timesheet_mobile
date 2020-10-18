import 'package:core_asgl/animation/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/core/bloc_provider.dart';
import 'package:s_timesheet_mobile/home/event/event_bloc.dart';
import 'package:s_timesheet_mobile/home/event/event_screen_has_data.dart';
import 'package:s_timesheet_mobile/home/event/event_screen_no_data.dart';
import 'package:s_timesheet_mobile/utils/widget/custom_appbar.dart';

class EventScreen extends StatefulWidget {
  final VoidCallback callBackOpenMenu;

  const EventScreen({Key key, this.callBackOpenMenu}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with SingleTickerProviderStateMixin {
  AppBloc appBloc;
  ScrollController _controller;

  _scrollListener() {
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      appBloc.eventBloc.scrollListStatusStream.notify(false);
    }
    if (_controller.offset > 200) {
      appBloc.eventBloc.scrollListStatusStream.notify(true);
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      appBloc.eventBloc.createSampleData();
    });
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    BackStateBloc backStateBloc = BackStateBloc.getInstance();
    backStateBloc.setStateToHome();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = BlocProvider.of(context);

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: PreferredSize(
        preferredSize:
            Size(MediaQuery.of(context).size.width, 66.h + 47.1.h + 19.h),
        child: CustomAppBar(
          title: "Sự kiện",
          callBackOpenMenu: () => widget.callBackOpenMenu(),
        ),
      ),
      body: TranslateVertical(
        startPosition: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            StreamBuilder<EventsDataModel>(
                initialData: EventsDataModel(state: EventsDataState.YES),
                stream: appBloc.eventBloc.eventsDataStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.data.state == EventsDataState.NO)
                    return EventScreenNoData();
                  else
                    return SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _controller,
                        child: EventScreenHasData(appBloc));
                }),
            StreamBuilder<bool>(
                initialData: false,
                stream: appBloc.eventBloc.scrollListStatusStream.stream,
                builder: (context, snapshot) {
                  if (!snapshot.data) return Container();
                  return Positioned(
                    bottom: 28.2.h,
                    right: 34.w,
                    child: buildBtnSuKienMoiNhat(),
                  );
                })
          ],
        ),
      ),
    );
  }

  buildBtnSuKienMoiNhat() {
    return InkWell(
      onTap: () {
        appBloc.eventBloc.scrollListStatusStream.notify(false);
        _controller.animateTo(0,
            curve: Curves.linear, duration: Duration(milliseconds: 500));
      },
      child: Container(
        width: 340.w,
        height: 70.h,
        decoration: BoxDecoration(
            color: Color(0xffe18c12).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.w)),
        child: Row(
          children: <Widget>[
            SizedBox(width: 17.w),
            Image.asset("asset/images/ic_arrow_move_up.png",
                width: 26.9.w, height: 25.h),
            SizedBox(width: 11.6.w),
            Text("Sự kiện mới nhất",
                style: TextStyle(
                    color: Color(0xffe18c12),
                    fontSize: 36.sp,
                    height: 1.67,
                    fontFamily: "Roboto-Regular"))
          ],
        ),
      ),
    );
  }
}
