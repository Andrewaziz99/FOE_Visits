class UserModel {
  int? id;
  int? region;
  String? username;
  String? user_id;
  String? image;
  bool? is_admin;
  String? password;

  UserModel({this.id, this.region, this.username, this.user_id, this.is_admin, this.image, this.password});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    region = json['region'];
    username = json['username'];
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
      'user_id': user_id,
      'image': image,
      'is_admin': is_admin,
      'password': password,
    };
  }
}
