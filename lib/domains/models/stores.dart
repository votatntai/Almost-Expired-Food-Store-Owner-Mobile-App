class Stores {
  Pagination? pagination;
  List<Store>? stores;

  Stores({this.pagination, this.stores});

  Stores.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      stores = <Store>[];
      json['data'].forEach((v) {
        stores!.add(new Store.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.stores != null) {
      data['data'] = this.stores!.map((v) => v.toJson()).toList();
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

class Store {
  String? id;
  String? name;
  String? thumbnailUrl;
  String? description;
  double? rated;
  StoreOwner? storeOwner;
  List<Branches>? branches;
  String? createAt;

  Store(
      {this.id,
      this.name,
      this.thumbnailUrl,
      this.description,
      this.rated,
      this.storeOwner,
      this.branches,
      this.createAt});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    thumbnailUrl = json['thumbnailUrl'];
    description = json['description'];
    rated = json['rated'];
    storeOwner = json['storeOwner'] != null
        ? new StoreOwner.fromJson(json['storeOwner'])
        : null;
    if (json['branches'] != null) {
      branches = <Branches>[];
      json['branches'].forEach((v) {
        branches!.add(new Branches.fromJson(v));
      });
    }
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['description'] = this.description;
    data['rated'] = this.rated;
    if (this.storeOwner != null) {
      data['storeOwner'] = this.storeOwner!.toJson();
    }
    if (this.branches != null) {
      data['branches'] = this.branches!.map((v) => v.toJson()).toList();
    }
    data['createAt'] = this.createAt;
    return data;
  }
}

class StoreOwner {
  String? id;
  String? email;
  String? name;
  String? phone;
  String? avatarUrl;
  String? status;

  StoreOwner(
      {this.id,
      this.email,
      this.name,
      this.phone,
      this.avatarUrl,
      this.status});

  StoreOwner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    avatarUrl = json['avatarUrl'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['avatarUrl'] = this.avatarUrl;
    data['status'] = this.status;
    return data;
  }
}

class Branches {
  String? id;
  String? address;
  double? latitude;
  double? longitude;
  String? phone;

  Branches({this.id, this.address, this.latitude, this.longitude, this.phone});

  Branches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['phone'] = this.phone;
    return data;
  }
}
