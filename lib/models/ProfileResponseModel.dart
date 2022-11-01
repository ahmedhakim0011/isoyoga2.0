class ProfileResponseModel {
  ProfileResponseModel();
  late final User user;
  late final List<ClassBooking> classBooking;
  late final List<dynamic> packageBooking;

  ProfileResponseModel.fromJson(Map<dynamic, dynamic> json) {
    user = User.fromJson(json['user']);
    classBooking = List.from(json['classBooking'])
        .map((e) => ClassBooking.fromJson(e))
        .toList();
    packageBooking = List.castFrom<String, dynamic>(json['packageBooking']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user'] = user.toJson();
    //  _data['classBooking'] = classBooking.map((e)=>e.toJson()).toList();
    // _data['packageBooking'] = packageBooking;
    return _data;
  }
}

class User {
  User({
    required this.id,
    required this.roleId,
    required this.name,
    required this.email,
    required this.avatar,
    this.emailVerifiedAt,
    required this.settings,
    required this.notify,
    this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String roleId;
  late final String name;
  late final String email;
  late final String avatar;
  late final Null emailVerifiedAt;
  late final List<dynamic> settings;
  late final int? notify;
  late final Null fcmToken;
  late final String createdAt;
  late final String updatedAt;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    emailVerifiedAt = null;
    notify = int.tryParse(json['notify'].toString()) ?? 1;
    fcmToken = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['role_id'] = roleId;
    _data['name'] = name;
    _data['email'] = email;
    _data['avatar'] = avatar;
    _data['email_verified_at'] = emailVerifiedAt;
    _data['settings'] = settings;
    _data['notify'] = notify;
    _data['fcm_token'] = fcmToken;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}

class ClassBooking {
  ClassBooking({
    required this.id,
    required this.classId,
    required this.userId,
    required this.classTimingId,
    required this.transactionId,
    required this.refId,
    required this.paymentDetails,
    required this.transactionAmount,
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.className,
    required this.classImage,
    required this.classFee,
    required this.classDetails,
    required this.totalSeats,
    required this.reservedSeats,
    required this.fromTime,
    required this.toTime,
  });
  late final int id;
  late final String classId;
  late final String userId;
  late final String classTimingId;
  late final String transactionId;
  late final String refId;
  late final String paymentDetails;
  late final String transactionAmount;
  late final String fromDate;
  late final String toDate;
  late final String status;
  late final String className;
  late final String classImage;
  late final String classFee;
  late final String classDetails;
  late final String totalSeats;
  late final String reservedSeats;
  late final String fromTime;
  late final String toTime;

  ClassBooking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classId = json['class_id'];
    userId = json['user_id'];
    classTimingId = json['class_timing_id'];
    transactionId = json['transaction_id'];
    refId = json['ref_id'];
    paymentDetails = json['payment_details'];
    transactionAmount = json['transaction_amount'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    status = json['status'];
    className = json['class_name'];
    classImage = json['class_image'];
    classFee = json['class_fee'];
    classDetails = json['class_details'];
    totalSeats = json['total_seats'];
    reservedSeats = json['reserved_seats'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['class_id'] = classId;
    _data['user_id'] = userId;
    _data['class_timing_id'] = classTimingId;
    _data['transaction_id'] = transactionId;
    _data['ref_id'] = refId;
    _data['payment_details'] = paymentDetails;
    _data['transaction_amount'] = transactionAmount;
    _data['from_date'] = fromDate;
    _data['to_date'] = toDate;
    _data['status'] = status;
    _data['class_name'] = className;
    _data['class_image'] = classImage;
    _data['class_fee'] = classFee;
    _data['class_details'] = classDetails;
    _data['total_seats'] = totalSeats;
    _data['reserved_seats'] = reservedSeats;
    _data['from_time'] = fromTime;
    _data['to_time'] = toTime;
    return _data;
  }
}
