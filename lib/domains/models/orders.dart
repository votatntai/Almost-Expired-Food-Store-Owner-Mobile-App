import 'categories.dart';

class Orders {
  Pagination? pagination;
  List<Order>? orders;

  Orders({this.pagination, this.orders});

  Orders.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      orders = <Order>[];
      json['data'].forEach((v) {
        orders!.add(new Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.orders != null) {
      data['data'] = this.orders!.map((v) => v.toJson()).toList();
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

class Order {
  String? id;
  int? amount;
  bool? isPayment;
  String? createAt;
  String? status;
  List<OrderDetails>? orderDetails;

  Order(
      {this.id,
      this.amount,
      this.isPayment,
      this.createAt,
      this.status,
      this.orderDetails});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    isPayment = json['isPayment'];
    createAt = json['createAt'];
    status = json['status'];
    if (json['orderDetails'] != null) {
      orderDetails = <OrderDetails>[];
      json['orderDetails'].forEach((v) {
        orderDetails!.add(new OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['isPayment'] = this.isPayment;
    data['createAt'] = this.createAt;
    data['status'] = this.status;
    if (this.orderDetails != null) {
      data['orderDetails'] = this.orderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetails {
  String? id;
  Product? product;
  int? quantity;
  int? price;

  OrderDetails({this.id, this.product, this.quantity, this.price});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    return data;
  }
}

class Product {
  String? id;
  String? name;
  List<Category>? productCategories;
  String? description;
  int? sold;
  int? quantity;
  int? price;
  int? promotionalPrice;
  String? expiredAt;
  double? rated;
  String? createAt;
  String? status;
  String? thumbnailUrl;

  Product(
      {this.id,
      this.name,
      this.productCategories,
      this.description,
      this.sold,
      this.quantity,
      this.price,
      this.promotionalPrice,
      this.expiredAt,
      this.rated,
      this.createAt,
      this.status,
      this.thumbnailUrl});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['productCategories'] != null) {
      productCategories = <Category>[];
      json['productCategories'].forEach((v) {
        productCategories!.add(new Category.fromJson(v));
      });
    }
    description = json['description'];
    sold = json['sold'];
    quantity = json['quantity'];
    price = json['price'];
    promotionalPrice = json['promotionalPrice'];
    expiredAt = json['expiredAt'];
    rated = json['rated'];
    createAt = json['createAt'];
    status = json['status'];
    thumbnailUrl = json['thumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.productCategories != null) {
      data['productCategories'] =
          this.productCategories!.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['sold'] = this.sold;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['promotionalPrice'] = this.promotionalPrice;
    data['expiredAt'] = this.expiredAt;
    data['rated'] = this.rated;
    data['createAt'] = this.createAt;
    data['status'] = this.status;
    data['thumbnailUrl'] = this.thumbnailUrl;
    return data;
  }
}

