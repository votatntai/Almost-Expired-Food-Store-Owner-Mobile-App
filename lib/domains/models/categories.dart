class Categories {
  Pagination? pagination;
  List<Category>? categories;

  Categories({this.pagination, this.categories});

  Categories.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      categories = <Category>[];
      json['data'].forEach((v) {
        categories!.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.categories != null) {
      data['data'] = this.categories!.map((v) => v.toJson()).toList();
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

class Category {
  String? id;
  String? name;
  String? thumbnailUrl;
  CategoryGroup? categoryGroup;

  Category({this.id, this.name, this.thumbnailUrl, this.categoryGroup});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    thumbnailUrl = json['thumbnailUrl'];
    categoryGroup = json['categoryGroup'] != null
        ? new CategoryGroup.fromJson(json['categoryGroup'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['thumbnailUrl'] = this.thumbnailUrl;
    if (this.categoryGroup != null) {
      data['categoryGroup'] = this.categoryGroup!.toJson();
    }
    return data;
  }
}

class CategoryGroup {
  String? id;
  String? name;

  CategoryGroup({this.id, this.name});

  CategoryGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
