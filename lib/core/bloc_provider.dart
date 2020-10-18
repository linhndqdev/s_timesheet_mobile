import 'package:flutter/material.dart';
import 'package:s_timesheet_mobile/core/app_bloc.dart';

class BlocProvider extends InheritedWidget {
  final AppBloc appBloc;

  BlocProvider({Key key, @required this.appBloc, @required Widget child})
      : super(key: key, child: child);

  static AppBloc of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BlocProvider>().appBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
