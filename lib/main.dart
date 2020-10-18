import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';
import 'package:s_timesheet_mobile/core/app_page.dart';
import 'package:s_timesheet_mobile/core/bloc_provider.dart';

import 'core/constant.dart';
import 'home/calendar_working/sabbatical_screen.dart';

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

class Application extends StatelessWidget {
  final AppBloc appBloc;

  const Application({Key key, this.appBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      appBloc: appBloc,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: AppPage(),
        ),
      ),
    );
  }
}
