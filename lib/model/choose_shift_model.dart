//enum EventState{NONE, SELECTED}
class ChooseShiftModel{
  String date;
  List<ShiftData> listEventDataModel;
  ChooseShiftModel();
  ChooseShiftModel.createData({this.date,this.listEventDataModel});
}
class ShiftData{
  int index;
  int idShift;
  String timeIn;
  String timeOut;
  bool isSelected;
  String shift;
  String location;

  ShiftData();
  ShiftData.createShiftData({this.idShift,this.index, this.timeIn,this.timeOut,this.shift, this.isSelected, this.location});
}