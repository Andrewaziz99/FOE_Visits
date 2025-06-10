class UserModel {
  int? id;
  int? region;
  String? username;
  String? name;
  String? nationalId;
  String? phone;
  String? user_id;
  String? image;
  bool? is_admin;
  String? password;

  UserModel({this.id, this.region, this.username, this.name, this.nationalId, this.phone, this.user_id, this.is_admin, this.image, this.password});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    region = json['region'] is int ? json['region'] : int.tryParse(json['region']?.toString() ?? '');
    username = json['username'];
    name = json['name'];
    nationalId = json['nationalId'];
    phone = json['phone'];
    user_id = json['user_id'];
    image = json['image'];
    is_admin = json['is_admin'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'region': region,
      'username': username,
      'name': name,
      'nationalId': nationalId,
      'phone': phone,
      'user_id': user_id,
      'image': image,
      'is_admin': is_admin,
      'password': password,
    };
  }
}
