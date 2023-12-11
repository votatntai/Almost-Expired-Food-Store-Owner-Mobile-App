import 'package:appetit/cubits/campaign/campaigns_state.dart';
import 'package:appetit/domains/repositories/campaign_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domains/models/campaign/createCampaign.dart';
import '../../domains/models/campaign/updateCampaign.dart';

final CampaignRepo _campaignRepo = getIt<CampaignRepo>();

class CampaignsCubit extends Cubit<CampaignsState> {
  CampaignsCubit() : super(CampaignsState());

  Future<void> getCampaignsList({String? storeOwnerId, String? storeId, String? branchId, String? name}) async {
    try {
      emit(CampaignsLoadingState());
      final campaigns = await _campaignRepo.getCampaignsList(storeOwnerId, branchId, storeId, name);
      emit(CampaignsSuccessState(campaigns: campaigns));
    } on Exception catch (e) {
      emit(CampaignsFailedState(msg: e.toString()));
    }
  }
}

class CreateCampaignCubit extends Cubit<CreateCampaignState> {
  CreateCampaignCubit() : super(CreateCampaignState());

  Future<void> createCampaign({required CreateCampaign campaign}) async {
    try {
      emit(CreateCampaignLoadingState());
      final status = await _campaignRepo.createCampaign(campaign: campaign);
      emit(CreateCampaignSuccessState(status: status));
    } on Exception catch (e) {
      emit(CreateCampaignFailedState(msg: e.toString()));
    }
  }
}

class UpdateCampaignCubit extends Cubit<UpdateCampaignState> {
  UpdateCampaignCubit() : super(UpdateCampaignState());

  Future<void> updateCampaign({required String campaignId, required UpdateCampaign campaign}) async {
    try {
      emit(UpdateCampaignLoadingState());
      final status = await _campaignRepo.updateCampaign(campaignId: campaignId, campaign: campaign);
      emit(UpdateCampaignSuccessState(status: status));
    } on Exception catch (e) {
      emit(UpdateCampaignFailedState(msg: e.toString()));
    }
  }
}

class DeleteCampaignCubit extends Cubit<DeleteCampaignState> {
  DeleteCampaignCubit() :super(DeleteCampaignState());

  Future<void> deleteCampaign({required String campaignId}) async {
    try {
      emit(DeleteCampaignLoadingState());
      final status = await _campaignRepo.deleteCampaign(campaignId: campaignId);
      emit(DeleteCampaignSuccessState(status: status));
    } on Exception catch (e) {
      emit(DeleteCampaignFailedState(msg: e.toString()));
    }
  }
}
