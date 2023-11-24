import '../categories.dart';

class Products {
  Pagination? pagination;
  List<Product>? products;

  Products({this.pagination, this.products});

  Products.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      products = <Product>[];
      json['data'].forEach((v) {
        products!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.products != null) {
      data['data'] = this.products!.map((v) => v.toJson()).toList();
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

class Product {
  String? id;
  String? name;
  List<ProductCategories>? productCategories;
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
      productCategories = <ProductCategories>[];
      json['productCategories'].forEach((v) {
        productCategories!.add(new ProductCategories.fromJson(v));
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

class ProductCategories {
  Category? category;

  ProductCategories({this.category});

  ProductCategories.fromJson(Map<String, dynamic> json) {
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}