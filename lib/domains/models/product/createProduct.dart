import 'dart:core';
import 'dart:io';

class CreateProduct {
  String name;
  String campaignId;
  List<Map<String, String>> categoriesId;
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
