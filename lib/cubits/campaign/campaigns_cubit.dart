import 'package:appetit/cubits/campaign/campaigns_state.dart';
import 'package:appetit/domains/repositories/campaign_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domains/models/campaign/createCampaign.dart';

class CreateCampaignCubit extends Cubit<CreateCampaignState> {
  final CampaignRepo _campaignRepo = getIt<CampaignRepo>();

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

class CampaignsCubit extends Cubit<CampaignsState> {
  final CampaignRepo _campaignsRepo = getIt<CampaignRepo>();
  CampaignsCubit() :super(CampaignsState());

  Future<void> getCampaignsList({String? storeOwnerId, String? storeId, String? branchId, String? name}) async {
    try {
      emit(CampaignsLoadingState());
      final campaigns = await _campaignsRepo.getCampaignsList(storeOwnerId, branchId, storeId, name);
      emit(CampaignsSuccessState(campaigns: campaigns));
    } on Exception catch (e) {
      emit(CampaignsFailedState(msg: e.toString()));
    }
  }
}
