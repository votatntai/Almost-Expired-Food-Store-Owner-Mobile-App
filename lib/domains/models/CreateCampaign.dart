import 'dart:io';

class CreateCampaign {
  String? branchId;
  String? name;
  File? thumbnailUrl;
  String? startTime;
  String? endTime;

  CreateCampaign({this.branchId, this.name, this.thumbnailUrl, this.startTime, this.endTime});
}