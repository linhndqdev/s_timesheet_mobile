import 'package:flutter/material.dart';
import '../../core/app_bloc.dart';
import '../../core/bloc_provider.dart';
import 'package:flutter_screenutil/size_extension.dart';

class TableDiaryWidget extends StatefulWidget {
  @override
  _TableDiaryWidgetState createState() => _TableDiaryWidgetState();
}

class _TableDiaryWidgetState extends State<TableDiaryWidget> {
  AppBloc appBloc;
  ScrollController _controller;

  @override
  Widget build(BuildContext context) {
    appBloc = BlocProvider.of(context);
    return Theme(
        data: Theme.of(context).copyWith(highlightColor: Color(0xffe18c12)),
        child: Scrollbar(
          child: SingleChildScrollView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    color: Color(0xff005a88),
                    child: Row(
                      children: <Widget>[
                        buildItem(
                          content: "NGÀY THÁNG",
                          width: 295.8.w,
                          isTitle: true,
                        ),
                        buildItem(
                          content: "TÊN CA",
                          width: 327.7.w,
                          isTitle: true,
                        ),
                        buildItem(
                          content: "GIỜ VÀO",
                          width: 220.6.w,
                          isTitle: true,
                        ),
                        buildItem(
                          content: "GIỜ RA",
                          width: 220.6.w,
                          isTitle: true,
                        ),
                        buildItem(
                          content: "ĐỊA ĐIỂM",
                          width: 590.w,
                          isTitle: true,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _buildCells(
                            appBloc.statisticBloc.listDiaryDataModel.length),
                      ),
                    ),
                  )
                ],
              )),
        ));
  }

  List<Widget> _buildCells(int count) {
    return List.generate(count, (index) {
      return Container(
        color: index % 2 == 0 ? Color(0xfff8f8f8) : Color(0xffffffff),
        child: Row(
          children: <Widget>[
            buildItem(
                content: appBloc.statisticBloc.listDiaryDataModel[index]
                    .getDate()
                    .toString(),
                width: 295.8.w,
                isTitle: false),
            buildItem(
                content:
                    appBloc.statisticBloc.listDiaryDataModel[index].shift.name,
                width: 327.7.w,
                isTitle: false),
            buildItem(
                content:
                    appBloc.statisticBloc.listDiaryDataModel[index].getInTime(),
                width: 220.6.w,
                isTitle: false),
            buildItem(
                content: appBloc.statisticBloc.listDiaryDataModel[index]
                    .getOutTime(),
                width: 220.6.w,
                isTitle: false),
            buildItem(
                content: appBloc.statisticBloc.listDiaryDataModel[index]
                    .getLocation(),
                width: 590.w,
                isTitle: false),
          ],
        ),
      );
    });
  }

  Widget buildItem({int index, String content, double width, bool isTitle}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
              color: isTitle ? Color(0xff40789c) : Color(0xfff3f2f2),
              width: 2.0.w),
        ),
      ),
      constraints: BoxConstraints(minHeight: isTitle ? 114.h : 90.h),
      padding: EdgeInsets.only(left: 32.w),
      width: width,
      alignment: Alignment.centerLeft,
      child: Text(content,
          style: TextStyle(
              color: isTitle ? Color(0xffffffff) : Color(0xff333333),
              fontSize: 36.sp,
              fontFamily: "Roboto-Regular")),
    );
  }
}
