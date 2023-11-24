import '../../domains/models/categories.dart';

//CATEGORIES
class CategoriesState {
  
}

class CategoriesLoadingState extends CategoriesState {
  
}

class CategoriesFailedState extends CategoriesState {
  final String msg;
  CategoriesFailedState({required this.msg});
}

class CategoriesSuccessState extends CategoriesState {
  final Categories categories;
  CategoriesSuccessState({required this.categories});
}