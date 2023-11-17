import 'package:appetit/cubits/campaign/campaigns_state.dart';
import 'package:appetit/domains/models/CreateCampaign.dart';
import 'package:appetit/domains/repositories/campaign_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
