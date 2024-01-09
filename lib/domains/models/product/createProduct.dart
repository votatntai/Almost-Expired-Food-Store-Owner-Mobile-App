import 'dart:core';
import 'dart:io';

import 'package:appetit/domains/models/categories.dart';

class CreateProduct {
  String name;
  String campaignId;
  String storeId;
  List<Category> categoriesId;
  String description;
  int price;
  int promotionalPrice;
  String createAt;
  String expiredAt;
  String status;
  File thumbnail;
  int quantity;

  CreateProduct(
      {required this.name,
      required this.campaignId,
      required this.storeId,
      required this.categoriesId,
      required this.description,
      required this.price,
      required this.promotionalPrice,
      required this.createAt,
      required this.expiredAt,
      required this.status,
      required this.thumbnail,
      required this.quantity});
}
