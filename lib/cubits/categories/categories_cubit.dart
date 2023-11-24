import 'package:appetit/utils/get_it.dart';
import 'package:bloc/bloc.dart';

import '../../domains/repositories/categories_repo.dart';
import 'categories_state.dart';

//CATEGORY
class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesRepo _categoriesRepo = getIt<CategoriesRepo>();

  CategoriesCubit({String? categoryGroupId, String? campaignId, String? name}) :super(CategoriesState()){
    getCategories(categoryGroupId: categoryGroupId, campaignId: campaignId, name: name);
  }

  Future<void> getCategories({String? categoryGroupId, String? campaignId, String? name}) async {
    try {
      emit(CategoriesLoadingState());
      var categories = await _categoriesRepo.getCategories(categoryGroupId, campaignId, name);
      emit(CategoriesSuccessState(categories: categories));
    } on Exception catch (e) {
      emit(CategoriesFailedState(msg: e.toString()));
    }
  }

  // Future<void> getCategoriesByCampaignId(String campaignId)async{
  //   try {
  //     emit(CategoriesLoadingState());
  //     var categories = await _categoriesRepo.getCategoriesByCampaignId(campaignId);
  //     emit(CategoriesSuccessState(categories: categories));
  //   } on Exception catch (e) {
  //     emit(CategoriesFailedState(msg: e.toString()));
  //   }
  // }

  // Future<void> searchCategory(String name) async {
  //   try {
  //     emit(CategoriesLoadingState());
  //     var categories = await _categoriesRepo.searchCategory(name);
  //     emit(CategoriesSuccessState(categories: categories));
  //   } on Exception catch (e) {
  //     emit(CategoriesFailedState(msg: e.toString()));
  //   }
  // }
}