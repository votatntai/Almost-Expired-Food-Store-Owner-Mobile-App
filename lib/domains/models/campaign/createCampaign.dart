import 'dart:io';

class CreateCampaign {
  String? branchId;
  String? name;
  File? thumbnail;
  String? startTime;
  String? endTime;

  CreateCampaign({this.branchId, this.name, this.thumbnail, this.startTime, this.endTime});
}