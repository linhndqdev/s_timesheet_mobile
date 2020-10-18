import 'package:core_asgl/core_asgl.dart';
import 'package:s_timesheet_mobile/utils/model/event_sample_model.dart';

class EventBloc {
  CoreStream<List<EventsSampleModel>> listEventsDateStream = CoreStream();
  CoreStream<bool> scrollListStatusStream = CoreStream();
  CoreStream<EventsDataModel> eventsDataStream = CoreStream();
  List<EventsSampleModel> listEventDates = [];

  ///tạo dữ liệu mẫu
  createSampleData() {
    List<EventDataSample> listEventData = [];
    List<EventDataSample> listEventData2 = [];
    List<EventDataSample> listEventData3 = [];

    listEventData.add(EventDataSample.createSample(
        time: "08:00",
        state: EventState.NONE,
        name: "",
        location: "Bạn đã quẹt thẻ vào tại Văn phòng Nguyễn Văn Huyên",
        content: "",
        request: ""));
    listEventData.add(EventDataSample.createSample(
        time: "10:12",
        state: EventState.CANCEL,
        name: "",
        location: "",
        content: "Yêu cầu nghỉ ca hành chính ( 0918 ) bắt đầu lúc 09:00 và kết thúc lúc 18:00 ngày 25/05/2020 của bạn",
        request: "bị từ chối."));
    listEventData.add(EventDataSample.createSample(
        time: "08:00",
        state: EventState.EDIT,
        name: "Lều Tuấn Sơn ( ASGL-0001)",
        location: "Bạn đã quẹt thẻ vào tại Văn phòng Nguyễn Văn Huyên",
        content:
        "hành chính ( 0918 ) bắt đầu lúc 09:00 và kết thúc lúc 18:00 ngày 25/08/2020 với Nguyễn Đặng Quyền Linh ( ASGL-0001 )",
        request: "xin đổi ca"));
    listEventData.add(EventDataSample.createSample(
        time: "08:00",
        state: EventState.NONE,
        name: "",
        location: "Bạn đã quẹt thẻ vào tại Văn phòng Nguyễn Văn Huyên",
        content: "",
        request: ""));
    listEventData2.add(EventDataSample.createSample(
        time: "08:00",
        state: EventState.NONE,
        name: "",
        location: "Bạn đã quẹt thẻ vào tại Văn phòng Nguyễn Văn Huyên",
        content: "",
        request: ""));

    //Lều Tuấn Sơn ( ASGL-0001) xin đổi ca hành chính ( 0918 ) bắt đầu lúc 09:00 và kết thúc lúc 18:00 ngày 25/08/2020 với Nguyễn Đặng Quyền Linh ( ASGL-0001 )
    //Lều Tuấn Sơn ( ASGL-0001) xin nghỉ ca hành chính ( 0918 ) bắt đầu lúc 09:00 và kết thúc lúc 18:00 ngày 25/08/2020
    listEventData2.add(EventDataSample.createSample(
        time: "08:00",
        state: EventState.EDIT,
        name: "Lều Tuấn Sơn ( ASGL-0001)",
        location: "Bạn đã quẹt thẻ vào tại Văn phòng Nguyễn Văn Huyên",
        content:
            "hành chính ( 0918 ) bắt đầu lúc 09:00 và kết thúc lúc 18:00 ngày 25/08/2020 với Nguyễn Đặng Quyền Linh ( ASGL-0001 )",
        request: "xin đổi ca"));
    listEventData2.add(EventDataSample.createSample(
        time: "14:23",
        state: EventState.ACCEPT,
        name: "",
        location: "",
        content: "Yêu cầu nghỉ ca hành chính ( 0918 ) bắt đầu lúc 09:00 và kết thúc lúc 18:00 ngày 25/05/2020 của bạn",
        request: "được chấp thuận."));
    listEventData3.add(EventDataSample.createSample(
        time: "08:00",
        state: EventState.NONE,
        name: "",
        location: "Bạn đã quẹt thẻ vào tại Văn phòng Nguyễn Văn Huyên",
        content: "",
        request: ""));
    listEventData3.add(EventDataSample.createSample(
        time: "08:00",
        state: EventState.EDIT,
        name: "Lều Tuấn Sơn ( ASGL-0001)",
        location: "Bạn đã quẹt thẻ vào tại Văn phòng Nguyễn Văn Huyên",
        content:
            "ca hành chính ( 0918 ) bắt đầu lúc 09:00 và kết thúc lúc 18:00 ngày 25/08/2020",
        request: "xin nghỉ"));

    listEventDates.add(EventsSampleModel.createSample(
        date: "Ngày 22-08-2020", listEventDataModel: listEventData));
    listEventDates.add(EventsSampleModel.createSample(
        date: "Ngày 21-08-2020", listEventDataModel: listEventData2));
    listEventDates.add(EventsSampleModel.createSample(
        date: "Ngày 20-08-2020", listEventDataModel: listEventData3));
//    listEventDates.add(EventsSampleModel.createSample(date: "Ngày 20-08-2020",listEventDataModel: listEventData));

    //listEventDates.add(listEventData);
  }

  void dispose(){
    listEventsDateStream?.close();
    scrollListStatusStream?.close();
    eventsDataStream?.close();
  }
}
enum EventsDataState{NO, YES}
class EventsDataModel{
  EventsDataState state;
  dynamic data;
  EventsDataModel({this.state,this.data});
}