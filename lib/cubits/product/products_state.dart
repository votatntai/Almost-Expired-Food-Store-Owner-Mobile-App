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

// Available products
class AvailableProductsState {}

class AvailableProductsLoadingState extends AvailableProductsState {}

class AvailableProductsFailedState extends AvailableProductsState {
  final String msg;
  AvailableProductsFailedState({required this.msg});
}

class AvailableProductsSuccessState extends AvailableProductsState {
  final Products products;
  AvailableProductsSuccessState({required this.products});
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

//Create product
class UpdateProductState {}

class UpdateProductLoadingState extends UpdateProductState {}

class UpdateProductFailedState extends UpdateProductState {
  final String msg;
  UpdateProductFailedState({required this.msg});
}

class UpdateProductSuccessState extends UpdateProductState {
  final int statusCode;
  UpdateProductSuccessState({required this.statusCode});
}
