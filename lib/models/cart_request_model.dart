class CartRequestModel {
  int? userId = -1;
  List<CartProducts> products = [];

  CartRequestModel({this.userId, required this.products});

  CartRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];

    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products.add(new CartProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;

    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class CartProducts {
  int? productId;
  int? quantity;
  int? categoryId;
  String? productName;
  double? price;
  String? thumbnail;
  String? size;

  CartProducts({this.productId, this.quantity,this.productName,this.price,this.thumbnail,this.categoryId,this.size});

  CartProducts.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['product_name'] = this.productName;
    data['product_price'] = this.price;
    data['thumbnail'] = this.thumbnail;
    data['categoryId'] = this.categoryId;
    data['size'] = this.size;

    return data;
  }
}
