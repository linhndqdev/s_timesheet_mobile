import 'package:core_asgl/core_asgl.dart';
import 'package:flutter/cupertino.dart';
import 'package:s_timesheet_mobile/auth/auth_bloc.dart';
import 'package:s_timesheet_mobile/core/back_state.dart';
import 'package:s_timesheet_mobile/home/calendar_working/calendar_work_bloc.dart';
import 'package:s_timesheet_mobile/home/event/event_bloc.dart';
import 'package:s_timesheet_mobile/home/home_bloc.dart';
import 'package:s_timesheet_mobile/home/identification/identification_bloc.dart';
import 'package:s_timesheet_mobile/home/statistic/statistic_bloc.dart';

class AppBloc {
  CoreStream<bool> showMyProfileStream = CoreStream();

  CalendarWorkBloc _calendarWorkBloc;

  CalendarWorkBloc get calendarWorkBloc => _calendarWorkBloc;

  HomeBloc _homeBloc;

  HomeBloc get homeBloc => _homeBloc;

  IdentificationBloc _identificationBloc;

  IdentificationBloc get identificationBloc => _identificationBloc;

  StatisticBloc _statisticBloc;

  StatisticBloc get statisticBloc => _statisticBloc;

  EventBloc _eventBloc;

  EventBloc get eventBloc => _eventBloc;

  AuthBloc _authBloc;

  AuthBloc get authBloc => _authBloc;

  BackStateBloc _backStateBloc;

  BackStateBloc get backStateBloc => _backStateBloc;

  AppBloc() {
    this._authBloc = AuthBloc();
    this._homeBloc = HomeBloc();
    this._calendarWorkBloc = CalendarWorkBloc();
    this._statisticBloc = StatisticBloc();
    this._identificationBloc = IdentificationBloc();
    this._eventBloc = EventBloc();
    this._backStateBloc = BackStateBloc.getInstance();

  }

}
