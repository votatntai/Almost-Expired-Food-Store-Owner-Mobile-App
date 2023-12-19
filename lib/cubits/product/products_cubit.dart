import 'package:appetit/cubits/product/products_state.dart';
import 'package:appetit/domains/models/product/createProduct.dart';
import 'package:appetit/domains/models/product/updateProduct.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:bloc/bloc.dart';

import '../../domains/repositories/products_repo.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepo _productsRepo = getIt<ProductsRepo>();

  ProductsCubit(
      {String? categoryId,
      String? campaignId,
      String? storeId,
      String? name,
      bool? isPriceHighToLow,
      bool? isPriceLowToHight})
      : super(ProductsState()) {
    getProducts(
        categoryId: categoryId,
        campaignId: campaignId,
        storeId: storeId,
        name: name,
        isPriceHighToLow: isPriceHighToLow,
        isPriceLowToHight: isPriceLowToHight);
  }

  Future<void> getProducts(
      {String? categoryId,
      String? campaignId,
      String? storeId,
      String? name,
      bool? isPriceHighToLow,
      bool? isPriceLowToHight}) async {
    try {
      emit(ProductsLoadingState());
      final products = await _productsRepo.getProducts(
          categoryId, campaignId, storeId, name, isPriceHighToLow, isPriceLowToHight);
      emit(ProductsSuccessState(products: products));
    } on Exception catch (e) {
      emit(ProductsFailedState(msg: e.toString()));
    }
  }

  void refresh(){
    emit(ProductsLoadingState());
    getProducts();
  }

  // Future<void> getProductsByCampaignId(String campaignId) async {
  //   try {
  //     emit(ProductsLoadingState());
  //     final products = await _productsRepo.getProductsByCampaignId(campaignId);
  //     emit(ProductsSuccessState(products: products));
  //   } on Exception catch (e) {
  //     emit(ProductsFailedState(msg: e.toString()));
  //   }
  // }
}

//Create product
class CreateProductCubit extends Cubit<CreateProductState> {
  final ProductsRepo _productsRepo = ProductsRepo();
  CreateProductCubit():super(CreateProductState());

  Future<void> createProduct({required CreateProduct product}) async {
    try {
      emit(CreateProductLoadingState());
      var statusCode = await _productsRepo.createProduct(product);
      emit(CreateProductSuccessState(statusCode: statusCode));
    } on Exception catch (e) {
      emit(CreateProductFailedState(msg: e.toString()));
    }
  }
}

//Update product
class UpdateProductCubit extends Cubit<UpdateProductState> {
  final ProductsRepo _productsRepo = ProductsRepo();
  UpdateProductCubit():super(UpdateProductState());

  Future<void> updateProduct({required UpdateProduct product}) async {
    try {
      emit(UpdateProductLoadingState());
      var statusCode = await _productsRepo.updateProduct(product: product);
      emit(UpdateProductSuccessState(statusCode: statusCode));
    } on Exception catch (e) {
      emit(UpdateProductFailedState(msg: e.toString()));
    }
  }
}
