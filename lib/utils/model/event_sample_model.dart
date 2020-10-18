enum EventState{NONE, EDIT,CANCEL, ACCEPT}
class EventsSampleModel{
  String date;
  List<EventDataSample> listEventDataModel;
  EventsSampleModel();
  EventsSampleModel.createSample({this.date,this.listEventDataModel});
}
class EventDataSample{
  String time;

  EventState state;
  String location;
  String name;
  String request;
  String content;
  EventDataSample();
  EventDataSample.createSample({ this.time, this.state, this.location, this.name, this.request, this.content});
}