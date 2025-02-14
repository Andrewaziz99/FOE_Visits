class UserModel {
  int? id;
  int? region;
  String? username;
  String? user_id;
  bool? is_admin;

  UserModel({this.id, this.region, this.username, this.user_id, this.is_admin});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    region = json['region'];
    username = json['username'];
    user_id = json['user_id'];
    is_admin = json['is_admin'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'region': region,
      'username': username,
      'user_id': user_id,
      'is_admin': is_admin,
    };
  }
}
