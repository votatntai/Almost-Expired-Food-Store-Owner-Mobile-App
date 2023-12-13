import 'package:appetit/cubits/campaign/campaigns_cubit.dart';
import 'package:appetit/cubits/campaign/campaigns_state.dart';
import 'package:appetit/domains/models/campaign/campaigns.dart';
import 'package:appetit/domains/models/campaign/updateCampaign.dart';
import 'package:appetit/main.dart';
import 'package:appetit/screens/CampaignsScreen.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/utils/format_utils.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/gap.dart';

class UpdateCampaignScreen extends StatefulWidget {
  static const String routeName = '/update-campaign';
  final Campaign campaign;
  UpdateCampaignScreen({Key? key, required this.campaign}) : super(key: key);

  @override
  State<UpdateCampaignScreen> createState() => _UpdateCampaignScreenState();
}

class _UpdateCampaignScreenState extends State<UpdateCampaignScreen> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController _campaignNameController = TextEditingController();
  List<String> _status = ['Pending', 'Opening', 'Cancel', 'Completed'];
  String _statusSelected = '';

  @override
  void initState() {
    super.initState();
    _selectedStartDate = DateTime.tryParse(widget.campaign.startTime!);
    _selectedEndDate = DateTime.tryParse(widget.campaign.endTime!);
    _startTimeController.text = FormatUtils.formatDate(widget.campaign.startTime!);
    _endTimeController.text = FormatUtils.formatDate(widget.campaign.endTime!);
    _campaignNameController.text = widget.campaign.name!;
    if (widget.campaign.status != null) {
      _statusSelected = widget.campaign.status!;
    }
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    _campaignNameController.dispose();
    super.dispose();
  }

  void _selectStartTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate != null && !_selectedStartDate!.isBefore(DateTime.now()) ? _selectedStartDate! : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: _selectedEndDate != null ? _selectedEndDate!.subtract(Duration(days: 1)) : DateTime(2100),
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        _startTimeController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  void _selectEndTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate != null && !_selectedStartDate!.isBefore(DateTime.now())? _selectedStartDate!.add(Duration(days: 1)) : DateTime.now().add(Duration(days: 1)),
      firstDate: _selectedStartDate != null && !_selectedStartDate!.isBefore(DateTime.now()) ? _selectedStartDate!.add(Duration(days: 1)) : DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
        _endTimeController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final updateCampaignCubit = BlocProvider.of<UpdateCampaignCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        title: ' Cập nhật chiến dịch',
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: TextField(
                      controller: _campaignNameController,
                      // onChanged: (value) {
                      //   setState(() {
                      //     _campaignName = value;
                      //   });
                      // },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                        filled: true,
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Tên chiến dịch*',
                        hintText: 'Nhập tên chiến dịch',
                      ),
                    ),
                  ),
                  Gap.k16.height,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: TextField(
                      controller: _startTimeController,
                      readOnly: true,
                      onTap: () {
                        _selectStartTime(context); // Show the date picker when the text field is tapped
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                        filled: true,
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Ngày bắt đầu*',
                        hintText: 'Chọn ngày bắt đầu',
                      ),
                    ),
                  ),
                  Gap.k16.height,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: TextField(
                      controller: _endTimeController,
                      readOnly: true,
                      onTap: () {
                        _selectEndTime(context); // Show the date picker when the text field is tapped
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                        filled: true,
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Ngày kết thúc*',
                        hintText: 'Chọn ngày kết thúc',
                      ),
                    ),
                  ),
                  Gap.k16.height,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: DropdownButtonFormField<String>(
                      value: _statusSelected,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        border: InputBorder.none,
                        fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor, // Change this to the color you want
                        filled: true,
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Trạng thái*',
                        hintText: 'Chọn trạng thái*',
                      ),
                      // value: selectedBranch,
                      onChanged: (String? newValue) {
                        setState(() {
                          _statusSelected = newValue!;
                        });
                      },
                      items: _status.map<DropdownMenuItem<String>>((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                    ),
                  ),
                  Gap.k16.height,
                  Text(
                    '(*): Bắt buộc nhập',
                    style: TextStyle(color: grey),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: (_campaignNameController.text != '')
                    ? ElevatedButton(
                        onPressed: () async {
                          await updateCampaignCubit.updateCampaign(
                              campaignId: widget.campaign.id!,
                              campaign: UpdateCampaign(
                                  name: _campaignNameController.text,
                                  startTime: DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(DateFormat("dd/MM/yyyy").parse(_startTimeController.text).toString()).toString(),
                                  endTime: DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(DateFormat("dd/MM/yyyy").parse(_endTimeController.text).toString()).toString(),
                                  status: _statusSelected));

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ProcessingPopup(
                                  state: updateCampaignCubit.state,
                                );
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Lưu', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange.shade600,
                          padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Lưu', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey.shade400,
                          padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProcessingPopup extends StatelessWidget {
  final UpdateCampaignState state;
  const ProcessingPopup({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state is UpdateCampaignLoadingState
        ? Dialog(
            child: Container(
                height: 150,
                width: 150,
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    Gap.k16.height,
                    Text('Đang xử lý, vui lòng chờ.')
                  ],
                )),
          )
        : state is UpdateCampaignSuccessState
            ? Dialog(
                child: Container(
                    height: 150,
                    width: 150,
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Text('Cập nhật chiến dịch thành công'),
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
            : state is UpdateCampaignFailedState
                ? Dialog(
                    child: Container(
                      height: 150,
                      width: 150,
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
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
                      height: 150,
                      width: 150,
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
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
