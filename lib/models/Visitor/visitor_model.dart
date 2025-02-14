class VisitorModel {
  int? id;
  String? rank;
  String? name;
  String? phone_number;
  String? additional_phone_number;
  String? department;

  VisitorModel(
      {this.id,
      this.rank,
      this.name,
      this.phone_number,
      this.additional_phone_number,
      this.department});

  VisitorModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    rank = json['rank'];
    name = json['name'];
    phone_number = json['phone_number'];
    additional_phone_number = json['additional_phone_number'];
    department = json['department'];
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'rank': rank,
      'name': name,
      'phone_number': phone_number,
      'additional_phone_number': additional_phone_number,
      'department': department,
    };
  }

}
