import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:s_timesheet_mobile/core/style.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:s_timesheet_mobile/home/identification/api_result_model.dart';

class AttendanceHistoryWidget extends StatelessWidget {
  final Map<String, List<AttendanceModel>> dataModel;

  const AttendanceHistoryWidget({Key key, this.dataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (dataModel != null &&
              dataModel.keys != null &&
              dataModel.keys.length > 0) ...{
            for (String key in dataModel?.keys) ...{
              _buildLineDate(context, key),
              _buildListItemView(context, dataModel[key]),
              Container(
                padding: EdgeInsets.only(left: 25.w, right: 25.w),
                margin: EdgeInsets.only(left: 34.w, right: 34.w, top: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: accentColor, width: 0.5))),
              )
            }
          },
        ],
      ),
    );
  }

  _buildLineDate(BuildContext context, String key) {
    List<String> data = key.split("-");
    String time = data[2] + "-" + data[1] + "-" + data[0];
    return Container(
      padding: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 10.0),
      margin: EdgeInsets.only(left: 34.w, right: 34.w, top: 10.0,),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: accentColor, width: 0.5),
        ),
      ),
      child: Text(
        "Ngày $time",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: blackColor,
            fontFamily: "Roboto",
            fontSize: 50.0.sp),
      ),
    );
  }

  _buildListItemView(BuildContext context, List<AttendanceModel> data) {
    List<AttendanceModel> dataModel = data.reversed.toList();
    if (dataModel == null || dataModel.length == 0) {
      return Container(
        margin: EdgeInsets.only(left: 20.0.w),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text(
            "Không có dữ liệu chấm công",
            style: TextStyle(
                color: blackColor333,
                fontWeight: FontWeight.bold,
                fontFamily: "Roboto-Bold",
                fontSize: 50.0.sp),
          ),
        ),
      );
    } else {
      return ListView.builder(
        reverse: true,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: dataModel?.length,
        itemBuilder: (buildContext, index) {
          String timeCheck;
          try {
            DateFormat dateFormat = DateFormat("HH:mm");
            DateTime dateTime = DateTime.parse(dataModel[index].check_at.date);
            timeCheck = dateFormat.format(dateTime);
          } catch (ex) {
            debugPrint(ex);
            timeCheck = "--:--";
          }
          return Container(
            margin: EdgeInsets.only(top: 34.h, left: 25.w),
            child: Row(
              children: <Widget>[
                Container(
                  width: 180.0.w,
                  padding: EdgeInsets.only(
                      top: 14.h, bottom: 27.h, left: 34.w, right: 34.w),
                  child: Center(
                    child: Text(
                      dataModel[index].type == "in" ? "Vào" : "Ra",
                      style: TextStyle(
                        fontFamily: 'Roboto-Bold',
                        fontSize: 56.sp,
                        color: dataModel[index].type == "in"
                            ? Color(0xff005a88)
                            : Color(0xFFe18c12),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              color: Color(0xff005a88), width: 2.w))),
                  padding: EdgeInsets.only(left: 16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        timeCheck,
                        style: TextStyle(
                          fontFamily: 'Roboto-Medium',
                          fontSize: 48.sp,
                          color: dataModel[index].type == "in"
                              ? Color(0xff005a88)
                              : Color(0xFFe18c12),
                        ),
                      ),
                      Text(
                        dataModel[index]?.location?.name ?? "Không xác định",
                        style: TextStyle(
                          fontFamily: 'Roboto-Regular',
                          fontSize: 42.sp,
                          color: Color(0xff959ca7),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    }
  }
}
