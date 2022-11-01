class OrderModel{
  int? customerId = -1;
  String? paymentDetails = "";
  String? comments = "";
  double? shippingCharges = 0;
  String? transactionId = "";
  List<LineItems>? lineItems = [];

  int? orderId = -1;
  String? orderNumber = "";
  String? status = "";
  DateTime? orderDate = new DateTime(2022);



  OrderModel({
    this.customerId,
    this.paymentDetails,
    this.comments,
    this.shippingCharges,
    this.transactionId,
    this.lineItems,
    this.orderId,
    this.orderNumber,
    this.status,
    this.orderDate,

  });

  OrderModel.fromJson(Map<String,dynamic> json)
  {
    customerId = json['customer_id'];
    orderId = json['id'];
    status = json['status'];
    orderNumber = json['order_key'];
    orderDate = DateTime.parse(json['date_created']);

  }

  Map<String,dynamic> toJson()
  {
    final Map<String,dynamic> data = new Map<String,dynamic>();

    data['user_id'] = customerId;
    data['payment_details'] = paymentDetails;
    data['comment'] = comments;
    data['shipping_charges'] = shippingCharges;
    data['transaction_id'] = transactionId;
    data['total_order_amount'] = 0;
    data['order_status_id'] = 1;

    if(lineItems != null)
    {
      data['products'] = lineItems?.map((v) => v.toJson()).toList();
      data['total_order_amount'] = lineItems
          ?.map<double>((e) => e.subTotal!)
          .reduce((value, element) => value + element);
    }


    return data;

  }


}

class LineItems{

  int? productId;
  int? quantity;
  int? categoryId;
  String? productName;
  double? price;
  double? subTotal;
  LineItems({
    this.productId,
    this.quantity,
    this.categoryId,
    this.productName,
    this.price,
    this.subTotal,

  });



  Map<String,dynamic> toJson()
  {
    final Map<String,dynamic> data = new Map();
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['categoryId'] = this.categoryId;
    data['productName'] = this.productName;
    data['price'] = this.price;
    data['subTotal'] = this.subTotal;

    return data;
  }

  LineItems.fromJsonOrderLines(Map<String, dynamic> json)
  {

    productId = json['id'];
    productName = json['product_name'];
    price = double.parse(json['price'].toString());
    quantity =  int.parse(json['quantity'].toString());
    subTotal = double.parse(json['subtotal'].toString());


  }


}