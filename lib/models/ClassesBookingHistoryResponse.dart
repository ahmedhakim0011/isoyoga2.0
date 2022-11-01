class ClassBookingHistoryResponse {
  int? id;
  String? classId;
  String? userId;
  String? classTimingId;
  String? transactionId;
  String? refId;
  String? paymentDetails;
  String? transactionAmount;
  String? fromDate;
  String? toDate;
  String? status;
  String? className;
  String? classImage;
  String? classFee;
  String? classDetails;
  String? totalSeats;
  String? reservedSeats;
  String? fromTime;
  String? toTime;

  ClassBookingHistoryResponse(
      {this.id,
        this.classId,
        this.userId,
        this.classTimingId,
        this.transactionId,
        this.refId,
        this.paymentDetails,
        this.transactionAmount,
        this.fromDate,
        this.toDate,
        this.status,
        this.className,
        this.classImage,
        this.classFee,
        this.classDetails,
        this.totalSeats,
        this.reservedSeats,
        this.fromTime,
        this.toTime});

  ClassBookingHistoryResponse.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['class_id'] = this.classId;
    data['user_id'] = this.userId;
    data['class_timing_id'] = this.classTimingId;
    data['transaction_id'] = this.transactionId;
    data['ref_id'] = this.refId;
    data['payment_details'] = this.paymentDetails;
    data['transaction_amount'] = this.transactionAmount;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['status'] = this.status;
    data['class_name'] = this.className;
    data['class_image'] = this.classImage;
    data['class_fee'] = this.classFee;
    data['class_details'] = this.classDetails;
    data['total_seats'] = this.totalSeats;
    data['reserved_seats'] = this.reservedSeats;
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    return data;
  }
}