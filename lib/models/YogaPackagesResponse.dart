class YogaPackagesResponse {
  List<Packages> list = [];
//  List<Null>? packageBooking;

  YogaPackagesResponse({required this.list});

  YogaPackagesResponse.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <Packages>[];
      json['list'].forEach((v) {
        list.add(new Packages.fromJson(v));
      });
    }
   // if (json['packageBooking'] != null) {
     // packageBooking = [];
      // json['packageBooking'].forEach((v) {
      //   packageBooking!.add(new Null.fromJson(v));
      // });
    //}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    // if (this.packageBooking != null) {
    //   data['packageBooking'] =
    //       this.packageBooking!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Packages {
  int? id;
  String? name;
  String? image;
  String? price;
  Null? description;
  String? frequency;
  String? createdAt;
  String? updatedAt;

  Packages(
      {this.id,
        this.name,
        this.image,
        this.price,
        this.description,
        this.frequency,
        this.createdAt,
        this.updatedAt});

  Packages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    description = json['description'];
    frequency = json['frequency'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['description'] = this.description;
    data['frequency'] = this.frequency;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}