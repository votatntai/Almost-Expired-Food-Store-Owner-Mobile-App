//Get campaign
import '../../domains/models/campaign/campaigns.dart';

class CampaignsState {}

class CampaignsLoadingState extends CampaignsState {}

class CampaignsFailedState extends CampaignsState {
  final String msg;
  CampaignsFailedState({required this.msg});
}

class CampaignsSuccessState extends CampaignsState {
  final Campaigns campaigns;
  CampaignsSuccessState({required this.campaigns});
}

//Create campaign
class CreateCampaignState {}

class CreateCampaignLoadingState extends CreateCampaignState {}

class CreateCampaignFailedState extends CreateCampaignState {
  final String msg;
  CreateCampaignFailedState({required this.msg});
}

class CreateCampaignSuccessState extends CreateCampaignState {
  final int status;
  CreateCampaignSuccessState({required this.status});
}

//Update campaign
class UpdateCampaignState {}

class UpdateCampaignLoadingState extends UpdateCampaignState {}

class UpdateCampaignFailedState extends UpdateCampaignState {
  final String msg;
  UpdateCampaignFailedState({required this.msg});
}

class UpdateCampaignSuccessState extends UpdateCampaignState {
  final int status;
  UpdateCampaignSuccessState({required this.status});
}

//Update campaign
class DeleteCampaignState {}

class DeleteCampaignLoadingState extends DeleteCampaignState {}

class DeleteCampaignFailedState extends DeleteCampaignState {
  final String msg;
  DeleteCampaignFailedState({required this.msg});
}

class DeleteCampaignSuccessState extends DeleteCampaignState {
  final int status;
  DeleteCampaignSuccessState({required this.status});
}
