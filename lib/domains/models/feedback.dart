
class Feedback {
  Pagination? pagination;
  List<Comment>? data;

  Feedback({this.pagination, this.data});

  Feedback.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <Comment>[];
      json['data'].forEach((v) {
        data!.add(new Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? pageNumber;
  int? pageSize;
  int? totalRow;

  Pagination({this.pageNumber, this.pageSize, this.totalRow});

  Pagination.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    totalRow = json['totalRow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['totalRow'] = this.totalRow;
    return data;
  }
}

class Comment {
  String? id;
  int? star;
  String? message;
  Customer? customer;
  String? createAt;

  Comment({this.id, this.star, this.message, this.customer, this.createAt});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    star = json['star'];
    message = json['message'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['star'] = this.star;
    data['message'] = this.message;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['createAt'] = this.createAt;
    return data;
  }
}

class Customer {
  String? id;
  String? email;
  String? name;
  String? phone;
  String? address;
  String? avatarUrl;
  String? status;

  Customer(
      {this.id,
      this.email,
      this.name,
      this.phone,
      this.address,
      this.avatarUrl,
      this.status});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    avatarUrl = json['avatarUrl'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['avatarUrl'] = this.avatarUrl;
    data['status'] = this.status;
    return data;
  }
}

