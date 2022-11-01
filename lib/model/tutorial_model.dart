class TutorialModel {
  int? id;
  String? categoryName;
  List<Tutorials>? tutorials;

  TutorialModel({this.id, this.categoryName, this.tutorials});

  TutorialModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    if (json['tutorials'] != null) {
      tutorials = <Tutorials>[];
      json['tutorials'].forEach((v) {
        tutorials!.add(new Tutorials.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    if (this.tutorials != null) {
      data['tutorials'] = this.tutorials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tutorials {
  int? id;
  String? name;
  String? categoryId;
  String? description;
  String? videoLink;
  String? sortOrder;
  String? status;
  String? createdAt;
  String? updatedAt;

  Tutorials(
      {this.id,
      this.name,
      this.categoryId,
      this.description,
      this.videoLink,
      this.sortOrder,
      this.status,
      this.createdAt,
      this.updatedAt});

  Tutorials.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    description = json['description'];
    videoLink = json['video_link'];
    sortOrder = json['sort_order'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['description'] = this.description;
    data['video_link'] = this.videoLink;
    data['sort_order'] = this.sortOrder;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
