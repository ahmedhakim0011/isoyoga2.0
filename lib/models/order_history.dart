class OrderHistoryResponse {
  List<Orders>? success;

  OrderHistoryResponse({this.success});

  OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['success'] != null) {
      success = <Orders>[];
      json['success'].forEach((v) {
        success!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.success != null) {
      data['success'] = this.success!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int? id;
  String? userId;
  String? orderStatusId;
  String? transactionId;
  String? totalOrderAmount;
  String? shippingCharges;
  String? paymentDetails;
  String? createdAt;
  String? updatedAt;
  List<OrderProduct>? orderProduct;

  Orders(
      {this.id,
        this.userId,
        this.orderStatusId,
        this.transactionId,
        this.totalOrderAmount,
        this.shippingCharges,
        this.paymentDetails,
        this.createdAt,
        this.updatedAt,
        this.orderProduct});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderStatusId = json['order_status_id'];
    transactionId = json['transaction_id'];
    totalOrderAmount = json['total_order_amount'];
    shippingCharges = json['shipping_charges'];
    paymentDetails = json['payment_details'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['order_product'] != null) {
      orderProduct = <OrderProduct>[];
      json['order_product'].forEach((v) {
        orderProduct!.add(new OrderProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['order_status_id'] = this.orderStatusId;
    data['transaction_id'] = this.transactionId;
    data['total_order_amount'] = this.totalOrderAmount;
    data['shipping_charges'] = this.shippingCharges;
    data['payment_details'] = this.paymentDetails;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.orderProduct != null) {
      data['order_product'] =
          this.orderProduct!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderProduct {
  int? id;
  String? orderId;
  String? productId;
  String? name;
  String? quantity;
  Null? size;
  String? price;
  String? subTotal;
  String? createdAt;
  String? updatedAt;

  OrderProduct(
      {this.id,
        this.orderId,
        this.productId,
        this.name,
        this.quantity,
        this.size,
        this.price,
        this.subTotal,
        this.createdAt,
        this.updatedAt});

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    name = json['name'];
    quantity = json['quantity'];
    size = json['size'];
    price = json['price'];
    subTotal = json['sub_total'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['size'] = this.size;
    data['price'] = this.price;
    data['sub_total'] = this.subTotal;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}