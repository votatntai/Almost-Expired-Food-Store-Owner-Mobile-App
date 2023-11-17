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
