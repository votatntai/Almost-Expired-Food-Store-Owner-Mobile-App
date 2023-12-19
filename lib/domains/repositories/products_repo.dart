import 'package:appetit/domains/models/product/createProduct.dart';
import 'package:appetit/utils/messages.dart';
import 'package:dio/dio.dart';

import '../../utils/get_it.dart';
import '../models/product/products.dart';
import '../models/product/updateProduct.dart';


class ProductsRepo {
final Dio apiClient = getIt.get<Dio>();
  Future<Products> getProducts(String? categoryId, String? campaignId, String? storeId, String? name, bool? isPriceHighToLow, bool? isPriceLowToHight) async {
    try {
      var res = await apiClient.get('/api/products',
          queryParameters: {'categoryId': categoryId, 'campaignId': campaignId, 'storeId': storeId, 'name': name, 'isPriceHighToLow': isPriceHighToLow, 'isPriceLowToHight': isPriceLowToHight});
      return Products.fromJson(res.data);
    } on DioException {
      throw Exception(msg_server_error);
    }
  }

  Future<int> createProduct(CreateProduct product) async {
    try {
      FormData formData = FormData();

      formData.fields.addAll([
        MapEntry('name', product.name),
        MapEntry('campaignId', product.campaignId.toString()),
        MapEntry('description', product.description),
        MapEntry('price', product.price.toString()),
        MapEntry('promotionalPrice', product.promotionalPrice.toString()),
        MapEntry('expiredAt', product.expiredAt),
        MapEntry('createAt', product.createAt),
        MapEntry('quantity', product.quantity.toString()),
        MapEntry('status', product.status.toString()),
      ]);

      // Iterate through category IDs and add them to the form data
      for (int i = 0; i < product.categoriesId.length; i++) {
        formData.fields.add(MapEntry('productCategories[$i][categoryId]', product.categoriesId[i].id.toString()));
      }

      formData.files.add(MapEntry(
        'thumbnail',
        await MultipartFile.fromFile(
          product.thumbnail.path,
          filename: '${product.name}_product_thumbnail',
        ),
      ));
      apiClient.options.headers['Content-Type'] = 'multipart/form-data';
      var res = await apiClient.post('/api/products', data: formData);
      return res.statusCode!;
    } on DioException catch (e) {
      print(e.toString());
      throw Exception(msg_server_error);
    }
  }

  Future<int> updateProduct({required UpdateProduct product}) async {
    try {
      var res = await apiClient.put('/api/products/${product.id}', data: {
        'name': product.name,
        'description': product.description,
        'sold': product.sold,
        'price': product.price,
        'promotionalPrice': product.promotionalPrice,
        'expiredAt': product.expiredAt,
        'createAt': product.createAt,
        'status': product.status,
        'quantity': product.quantity
      });
      return res.statusCode!;
    } on DioException catch (e) {
      print('Exception at update product: ' + e.response!.data);
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
