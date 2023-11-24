import '../../domains/models/product/products.dart';

class ProductsState {}

class ProductsLoadingState extends ProductsState {}

class ProductsFailedState extends ProductsState {
  final String msg;
  ProductsFailedState({required this.msg});
}

class ProductsSuccessState extends ProductsState {
  final Products products;
  ProductsSuccessState({required this.products});
}

//Create product
class CreateProductState {}

class CreateProductLoadingState extends CreateProductState {}

class CreateProductFailedState extends CreateProductState {
  final String msg;
  CreateProductFailedState({required this.msg});
}

class CreateProductSuccessState extends CreateProductState {
  final int statusCode;
  CreateProductSuccessState({required this.statusCode});
}
