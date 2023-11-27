import 'package:appetit/domains/models/campaign/campaigns.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/gap.dart';

class CampaignScreen extends StatelessWidget {
  static const String routeName = '/campaign';
  final Campaign campaign;
  const CampaignScreen({Key? key, required this.campaign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: campaign.name,
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.edit))
          ],
        ),
        body: Stack(children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: FadeInImage.assetNetwork(
                      image: campaign.thumbnailUrl.toString(), placeholder: 'image/appetit/placeholder.png', width: MediaQuery.of(context).size.width, height: 250, fit: BoxFit.cover),
                ),
                Gap.k16.height,
                Text(
                  'Chi nhánh',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Gap.k8.height,
                Text(
                  campaign.branch!.address.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
                Gap.k16.height,
                Text(
                  'Ngày tạo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Gap.k8.height,
                Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.parse(campaign.createAt.toString())),
                  style: TextStyle(color: Colors.grey),
                ),
                Gap.k16.height,
                Text(
                  'Ngày bắt đầu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Gap.k8.height,
                Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.parse(campaign.startTime.toString())),
                  style: TextStyle(color: Colors.grey),
                ),
                Gap.k16.height,
                Text(
                  'Ngày kết thúc',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Gap.k8.height,
                Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.parse(campaign.endTime.toString())),
                  style: TextStyle(color: Colors.grey),
                ),
                Gap.kSection.height,
              ],
            ),
          )
        ]));
  }
}
