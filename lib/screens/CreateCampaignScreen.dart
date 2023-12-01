import 'dart:io';

import 'package:appetit/cubits/campaign/campaigns_cubit.dart';
import 'package:appetit/cubits/campaign/campaigns_state.dart';
import 'package:appetit/main.dart';
import 'package:appetit/screens/CampaignsScreen.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../cubits/branch/branchs_cubit.dart';
import '../cubits/branch/branchs_state.dart';
import '../domains/models/branchs.dart';
import '../domains/models/campaign/createCampaign.dart';
import '../utils/gap.dart';

class CreateCampaignScreen extends StatefulWidget {
  static const String routeName = '/create-campaign';
  CreateCampaignScreen({Key? key}) : super(key: key);

  @override
  State<CreateCampaignScreen> createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
  File? _imageFile;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  late TextEditingController _startTimeController = TextEditingController();
  late TextEditingController _endTimeController = TextEditingController();
  String _campaignName = '';
  Branch _selectedBranch = Branch();

  @override
  void initState() {
    super.initState();
    if (_selectedStartDate != null && _selectedEndDate != null) {
      _startTimeController = TextEditingController(
        text: '${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}',
      );
      _endTimeController = TextEditingController(
        text: '${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year}',
      );
    }
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  void _selectStartTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate != null ? _selectedStartDate! : DateTime.now(),
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
      initialDate: _selectedStartDate != null ? _selectedStartDate!.add(Duration(days: 1)) : DateTime.now().add(Duration(days: 1)),
      firstDate: _selectedStartDate != null ? _selectedStartDate!.add(Duration(days: 1)) : DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
        _endTimeController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _getImage(BuildContext context) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final createCampaignCubit = BlocProvider.of<CreateCampaignCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        title: ' Tạo chiến dịch',
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
                      onChanged: (value) {
                        setState(() {
                          _campaignName = value;
                        });
                      },
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
                  SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 220,
                      color: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                      child: _imageFile == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.file_upload_outlined, color: Colors.grey),
                                SizedBox(height: 8),
                                Text('Tải lên ảnh bìa chiến dịch*', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
                                // Text('*maximum size 2MB', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.grey)),
                              ],
                            )
                          : Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                    ).onTap(() {
                      // _pickImage(ImageSource.gallery);
                      _getImage(context);
                    }),
                  ),
                  Gap.k16.height,
                  BlocProvider<BranchsCubit>(
                    create: (context) => BranchsCubit(),
                    child: BlocBuilder<BranchsCubit, BranchsState>(builder: (context, state) {
                      if (state is BranchsInitialState) {
                        context.read<BranchsCubit>().getBranchsOfOwner();
                      }
                      if (state is BranchsSuccessState) {
                        var branchs = state.branchs.branchs;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: DropdownButtonFormField<Branch>(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              border: InputBorder.none,
                              fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor, // Change this to the color you want
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: 'Chọn chi nhánh*',
                            ),
                            // value: selectedBranch,
                            onChanged: (Branch? newValue) {
                              setState(() {
                                _selectedBranch = newValue!;
                              });
                            },
                            items: branchs!.map<DropdownMenuItem<Branch>>((Branch branch) {
                              return DropdownMenuItem<Branch>(
                                value: branch,
                                child: Text(branch.address.toString()),
                              );
                            }).toList(),
                          ),
                        );
                      }
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                            filled: true,
                            labelStyle: TextStyle(color: Colors.grey),
                            hintStyle: TextStyle(color: Colors.grey),
                            labelText: 'Chi nhánh*',
                            hintText: 'Chọn chiến dịch',
                          ),
                        ),
                      );
                    }),
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
                      enabled: _selectedStartDate != null,
                      onTap: () {
                        _selectEndTime(context); // Show the date picker when the text field is tapped
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: _selectedStartDate != null ? (appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor) : Colors.grey.shade200,
                        filled: true,
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Ngày kết thúc*',
                        hintText: 'Chọn ngày kết thúc',
                      ),
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
                child: (_campaignName != '' && _imageFile != null && _selectedBranch.address != '')
                    ? ElevatedButton(
                        onPressed: () async {
                          await createCampaignCubit.createCampaign(
                              campaign: CreateCampaign(
                                  branchId: _selectedBranch.id,
                                  name: _campaignName,
                                  thumbnail: _imageFile,
                                  startTime: DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(DateFormat("dd/MM/yyyy").parse(_startTimeController.text).toString()).toString(),
                                  endTime: DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(DateFormat("dd/MM/yyyy").parse(_endTimeController.text).toString()).toString()));
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ProcessingPopup(
                                  state: createCampaignCubit.state,
                                );
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Tạo', style: TextStyle(fontSize: 18)),
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
                            Text('Tạo', style: TextStyle(fontSize: 18)),
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
  final CreateCampaignState state;
  const ProcessingPopup({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(state);
    return state is CreateCampaignLoadingState
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
        : state is CreateCampaignSuccessState
            ? Dialog(
                child: Container(
                    height: 150,
                    width: 150,
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Text('Tạo chiến dịch thành công'),
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
            : state is CreateCampaignFailedState
                ? Dialog(
                    child: Container(
                      height: 150,
                      width: 150,
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text((state as CreateCampaignFailedState).msg.replaceAll('Exception: ', ''), textAlign: TextAlign.center,),
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
    // return Dialog(
    //   child: Container(
    //     height: 150,
    //     width: 150,
    //     padding: const EdgeInsets.all(32.0),
    //     child: Builder(builder: (context) {
    //       if (state is CreateCampaignLoadingState) {
    //         return Column(
    //           children: [
    //             Center(
    //               child: CircularProgressIndicator(),
    //             ),
    //             Gap.k16.height,
    //             Text('Đang xử lý, vui lòng chờ.')
    //           ],
    //         );
    //       }
    //       if (state is CreateCampaignSuccessState) {
    //         return Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: [
    //             Text('Tạo chiến dịch thành công'),
    //             TextButton(
    //                 onPressed: () {
    //                   Navigator.of(context).pop();
    //                   Navigator.of(context).pop();
    //                   Navigator.of(context).pushReplacementNamed(CampaignsScreen.routeName);
    //                 },
    //                 child: Text(
    //                   'Đóng',
    //                   style: TextStyle(fontWeight: FontWeight.bold),
    //                 ))
    //           ],
    //         );
    //       }
    //       if (state is CreateCampaignFailedState) {
    //         var msg = (state as CreateCampaignFailedState).msg;
    //         Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           Text(msg.toString()),
    //           TextButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //               child: Text(
    //                 'Đóng',
    //                 style: TextStyle(fontWeight: FontWeight.bold),
    //               ))
    //         ],
    //       );
    //       }
    //       return Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           Text('Đã xãy ra sự cố, hãy thử lại'),
    //           TextButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //               child: Text(
    //                 'Đóng',
    //                 style: TextStyle(fontWeight: FontWeight.bold),
    //               ))
    //         ],
    //       );
    //     }),
    //   ),
    // );
  }
}
