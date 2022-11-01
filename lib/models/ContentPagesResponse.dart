class ContentPagesResponse {
  List<Page>? success;

  ContentPagesResponse({this.success});

  ContentPagesResponse.fromJson(Map<String, dynamic> json) {
    if (json['success'] != null) {
      success = <Page>[];
      json['success'].forEach((v) {
        success!.add(new Page.fromJson(v));
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

class Page {
  String? id;
  String? title;
  String? body;
  Null? image;
  String? status;

  Page({this.id, this.title, this.body, this.image, this.status});

  Page.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['image'] = this.image;
    data['status'] = this.status;
    return data;
  }
}