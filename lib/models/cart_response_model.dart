class CartResponseModel{

  bool? status = false;
  List<CartItem> data = [];

  CartResponseModel({this.status,required this.data});

  CartResponseModel.fromJson(Map<String,dynamic> json)
  {
    status = json['status'];

    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new CartItem.fromJson(v));
      });
    }

  }


  Map<String,dynamic> toJson()
  {
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['status'] = this.status;

    if(this.data != null)
      data['data'] = this.data.map((v) => v.toJson()).toList();

    return data;
  }




}

class CartItem{

  int? productId = -1;
  String? productName = "";
  double? productRegularPrice;
  String? thumbnail;
  int qty = 0;
  double? lineSubtotal = 0;
  double? lineTotal = 0;
  String size = "";
  int? categoryId = -1;


  CartItem({
   this.productId,
   this.productName,
   this.productRegularPrice,
   this.thumbnail,
   this.qty = 0,
   this.lineSubtotal,
   this.lineTotal,
   this.categoryId,
   this.size = "",
});

  CartItem.fromJson(Map<String,dynamic> json)
  {
    productId = json['product_id'];
    productName = json['product_name'];
    productRegularPrice = double.parse(json['product_regular_price'].toString());
    thumbnail = json['thumbnail'];
    qty = json['quantity'];
    lineSubtotal = double.parse(json['line_subtotal'].toString());
    lineTotal = double.parse("" + json['line_total'].toString());

  }


  Map<String,dynamic> toJson()
  {
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_regular_price'] = this.productRegularPrice;
    data['thumbnail'] = this.thumbnail;
    data['line_subtotal'] = this.lineSubtotal;
    data['line_total'] = this.lineTotal;
    data['categoryId'] = this.categoryId;
    data['size'] = this.size;

    return data;

  }



}