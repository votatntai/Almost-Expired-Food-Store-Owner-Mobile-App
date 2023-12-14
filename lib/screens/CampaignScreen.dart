import 'package:appetit/cubits/campaign/campaigns_cubit.dart';
import 'package:appetit/cubits/campaign/campaigns_state.dart';
import 'package:appetit/domains/models/campaign/campaigns.dart';
import 'package:appetit/screens/UpdateCampaignScreen.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../utils/gap.dart';
import 'CampaignsScreen.dart';

class CampaignScreen extends StatelessWidget {
  static const String routeName = '/campaign';
  final Campaign campaign;
  const CampaignScreen({Key? key, required this.campaign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deleteCampaignCubit = BlocProvider.of<DeleteCampaignCubit>(context);
    return Scaffold(
        appBar: MyAppBar(
          title: campaign.name,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, UpdateCampaignScreen.routeName, arguments: campaign);
                },
                icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Xác nhận'),
                        content: Text('Bạn có chắc chắn muốn xóa chiến dịch không?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false); // Đóng hộp thoại và trả về giá trị false
                            },
                            child: Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true); // Đóng hộp thoại và trả về giá trị true
                              // Navigator.pop(context);
                            },
                            child: Text('Xác nhận'),
                          ),
                        ],
                      );
                    },
                  ).then((value) async {
                    if (value != null && value) {
                      await deleteCampaignCubit.deleteCampaign(campaignId: campaign.id!);
                    }
                  });
                },
                icon: Icon(Icons.delete_outline))
          ],
        ),
        body: BlocListener<DeleteCampaignCubit, DeleteCampaignState>(
          listener: (context, state) {
            if (!(state is DeleteCampaignLoadingState)) {
              Navigator.pop(context);
            }
            showDialog(
                context: context,
                builder: (context) => ProcessingPopup(
                      state: state,
                    ));
          },
          child: Stack(children: [
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
          ]),
        ));
  }
}

class ProcessingPopup extends StatelessWidget {
  final DeleteCampaignState state;
  const ProcessingPopup({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state is DeleteCampaignLoadingState
        ? Dialog(
            child: Container(
                width: 150,
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    Gap.k16.height,
                    Text('Đang xử lý, vui lòng chờ.')
                  ],
                )),
          )
        : state is DeleteCampaignSuccessState
            ? Dialog(
                child: Container(
                    width: 150,
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Xóa chiến dịch thành công'),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacementNamed(CampaignsScreen.routeName);
                            },
                            child: Text(
                              'Đóng',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                      ],
                    )),
              )
            : state is DeleteCampaignFailedState
                ? Dialog(
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            (state as UpdateCampaignFailedState).msg.replaceAll('Exception: ', ''),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Đóng'))
                        ],
                      ),
                    ),
                  )
                : Dialog(
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Đã xãy ra sự cố, hãy thử lại'),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Đóng',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    ),
                  );
  }
}
