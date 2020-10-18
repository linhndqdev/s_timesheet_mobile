class StatisticDataModel{
  var data =[
    {
      "congthangtruoc": "120",
      "congthangnay": "100",
      "phepdanghi": "1",
      "phepconlai":"12",
      "dimuon":"1",
      "vesom":"0"
    }
  ];
  String congthangtruoc;
  String congthangnay;
  String phepdanghi;
  String phepconlai;
  String dimuon;
  String vesom;

  StatisticDataModel({this.congthangtruoc, this.congthangnay, this.phepdanghi, this.phepconlai,
    this.dimuon, this.vesom});
//  StatisticDataModel.fromJson(Map<String, dynamic> json) {
//    congthangtruoc = json[data['congthangtruoc']];
//    s2 = json['2'];
//    s3 = json['3'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['1'] = this.s1;
//    data['2'] = this.s2;
//    data['3'] = this.s3;
//    return data;
//  }
}