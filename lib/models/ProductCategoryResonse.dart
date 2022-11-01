class ProductCategoryResonse {
  int? id;
  String? categoryName;
  List<Products>? products;

  ProductCategoryResonse({this.id, this.categoryName, this.products});

  ProductCategoryResonse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  String? categoryId;
  String? name;
  String? price;
  String? size;
  String? quantity;
  String? description;
  String? image;
  String? sortOrder;
  String? status;
  String? createdAt;
  String? updatedAt;

  Products(
      {this.id,
        this.categoryId,
        this.name,
        this.price,
        this.size,
        this.quantity,
        this.description,
        this.image,
        this.sortOrder,
        this.status,
        this.createdAt,
        this.updatedAt});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    price = json['price'];
    size = json['size'];
    quantity = json['quantity'];
    description = json['description'];
    image = json['image'];
    sortOrder = json['sort_order'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['size'] = this.size;
    data['quantity'] = this.quantity;
    data['description'] = this.description;
    data['image'] = this.image;
    data['sort_order'] = this.sortOrder;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}