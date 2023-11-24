class Campaigns {
  Pagination? pagination;
  List<Campaign>? campaign;

  Campaigns({this.pagination, this.campaign});

  Campaigns.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      campaign = <Campaign>[];
      json['data'].forEach((v) {
        campaign!.add(new Campaign.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.campaign != null) {
      data['data'] = this.campaign!.map((v) => v.toJson()).toList();
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

class Campaign {
  String? id;
  StoreOwner? storeOwner;
  Branch? branch;
  String? name;
  String? thumbnailUrl;
  String? createAt;
  String? startTime;
  String? endTime;

  Campaign(
      {this.id,
      this.storeOwner,
      this.branch,
      this.name,
      this.thumbnailUrl,
      this.createAt,
      this.startTime,
      this.endTime});

  Campaign.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeOwner = json['storeOwner'] != null
        ? new StoreOwner.fromJson(json['storeOwner'])
        : null;
    branch =
        json['branch'] != null ? new Branch.fromJson(json['branch']) : null;
    name = json['name'];
    thumbnailUrl = json['thumbnailUrl'];
    createAt = json['createAt'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.storeOwner != null) {
      data['storeOwner'] = this.storeOwner!.toJson();
    }
    if (this.branch != null) {
      data['branch'] = this.branch!.toJson();
    }
    data['name'] = this.name;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['createAt'] = this.createAt;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
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

class Branch {
  String? id;
  String? address;
  String? phone;

  Branch({this.id, this.address, this.phone});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['phone'] = this.phone;
    return data;
  }
}
