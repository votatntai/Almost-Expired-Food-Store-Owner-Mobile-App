import 'package:appetit/domains/models/product/createProduct.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

import '../../utils/get_it.dart';
import '../models/product/products.dart';

class ProductsRepo {
  final Dio apiClient = getIt.get<Dio>();

  Future<Products> getProducts(String? categoryId, String? campaignId, String? storeId,
      String? name, bool? isPriceHighToLow, bool? isPriceLowToHight) async {
    try {
      var res = await apiClient.get('/api/products', queryParameters: {
        'categoryId': categoryId,
        'campaignId': campaignId,
        'storeId' : storeId,
        'name': name,
        'isPriceHighToLow': isPriceHighToLow,
        'isPriceLowToHight': isPriceLowToHight
      });
      return Products.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }

  Future<int> createProduct(CreateProduct product) async {
    try {
      FormData formData = FormData.fromMap({
        'name' : product.name,
        'campaignId' : product.campaignId,
        'productCategories' : product.categoriesId,
        'description' : product.description,
        'price' : product.price,
        'promotionalPrice' : product.promotionalPrice,
        'expiredAt' : product.expiredAt,
        'createAt' : product.createAt,
        'thumbnail' : product.thumbnail,
        'quantity' : product.quantity
      });
      apiClient.options.headers['Content-Type'] = 'multipart/form-data';
      var res = await apiClient.post('/api/products',
      data: formData);
      return res.statusCode!;
    } on DioException {
      throw Exception(msg_server_error);
    }
  }

  // Future<Products> getProductsByCampaignId(String campaignId) async {
  //   try {
  //     var res = await apiClient.get('/api/products?campaignId=$campaignId');
  //     return Products.fromJson(res.data);
  //   } on DioException {
  //     throw Exception(msg_server_error);
  //   }
  // }
}
