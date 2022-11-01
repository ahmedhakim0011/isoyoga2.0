class LoginResponseModel {
  User? user;
  String? accessToken;
  String? tokenId;

  LoginResponseModel({this.user, this.accessToken, this.tokenId});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    accessToken = json['access_token'];
    tokenId = json['token_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['access_token'] = this.accessToken;
    data['token_id'] = this.tokenId;
    return data;
  }
}

class User {
  int? id;
  String? roleId;
  String? name;
  String? email;
  String? avatar;
  int? notify;
  dynamic emailVerifiedAt;
  dynamic otpVerifiedAt;
  List<Null>? settings;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.roleId,
      this.name,
      this.email,
      this.avatar,
      this.emailVerifiedAt,
      this.otpVerifiedAt,
      this.settings,
      this.notify,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    emailVerifiedAt = json['email_verified_at'];
    otpVerifiedAt = json['otp_verified_at'];
    notify =
        int.parse((json['notify'] == null) ? "0" : json['notify'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_id'] = this.roleId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['notify'] = this.notify;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
