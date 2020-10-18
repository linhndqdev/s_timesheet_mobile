class InformationShiftMemberModel {
  int idMember;
  String asglID;
  String nameMember;
  String nameShift;
  String time;
  String date;
  int idShift;
  int idShiftChange;
  bool isInit;
  DateTime choseDay;

  InformationShiftMemberModel();

  InformationShiftMemberModel.createInformationShiftMemberModel(
      {this.idMember,
      this.asglID,
      this.nameMember,
      this.nameShift,
      this.time,
      this.date,
      this.idShift,
      this.idShiftChange,
      this.isInit,
        this.choseDay
      });
}
