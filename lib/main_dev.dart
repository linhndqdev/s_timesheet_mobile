import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/constant.dart';
import 'package:s_timesheet_mobile/main.dart';

void main() {
  final AppBloc appBloc = AppBloc();
  Constant.setEnvironment(Environment.DEV);
  initializeDateFormatting().then(
    (_) => runApp(
      Application(
        appBloc: appBloc,
      ),
    ),
  );
}
