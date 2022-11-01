class ClassesResponseModel {
  int? id;
  String? name;
  String? image;
  String? fee;
  String? totalSeats;
  String? reservedSeats;
  String? details;
  String? createdAt;
  String? updatedAt;
  List<YogaClassTiming>? yogaClassTiming;

  ClassesResponseModel(
      {this.id,
        this.name,
        this.image,
        this.fee,
        this.totalSeats,
        this.reservedSeats,
        this.details,
        this.createdAt,
        this.updatedAt,
        this.yogaClassTiming});

  ClassesResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    fee = json['fee'];
    totalSeats = json['total_seats'];
    reservedSeats = json['reserved_seats'];
    details = json['details'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['yoga_class_timing'] != null) {
      yogaClassTiming = <YogaClassTiming>[];
      json['yoga_class_timing'].forEach((v) {
        yogaClassTiming!.add(new YogaClassTiming.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['fee'] = this.fee;
    data['total_seats'] = this.totalSeats;
    data['reserved_seats'] = this.reservedSeats;
    data['details'] = this.details;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.yogaClassTiming != null) {
      data['yoga_class_timing'] =
          this.yogaClassTiming!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class YogaClassTiming {
  int? id;
  String? classId;
  String? fromTime;
  String? toTime;
  String? createdAt;
  String? updatedAt;

  YogaClassTiming(
      {this.id,
        this.classId,
        this.fromTime,
        this.toTime,
        this.createdAt,
        this.updatedAt});

  YogaClassTiming.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classId = json['class_id'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['class_id'] = this.classId;
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}