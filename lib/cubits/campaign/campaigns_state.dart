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
