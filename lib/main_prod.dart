import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/main.dart';

import 'core/constant.dart';

void main() {
  final AppBloc appBloc = AppBloc();
  Constant.setEnvironment(Environment.PROD);
  initializeDateFormatting().then(
    (_) => runApp(
      Application(
        appBloc: appBloc,
      ),
    ),
  );
}
