import 'package:appetit/cubits/branch/branchs_cubit.dart';
import 'package:appetit/cubits/branch/branchs_state.dart';
import 'package:appetit/domains/models/branchs.dart';
import 'package:appetit/screens/BranchsScreen.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import '../main.dart';
import '../utils/Colors.dart';
import '../utils/format_utils.dart';
import '../utils/gap.dart';

class UpdateBranchScreen extends StatefulWidget {
  static const String routeName = '/update-branch';
  final Branch branch;
  const UpdateBranchScreen({Key? key, required this.branch}) : super(key: key);

  @override
  State<UpdateBranchScreen> createState() => _UpdateBranchScreenState();
}

class _UpdateBranchScreenState extends State<UpdateBranchScreen> {
  // Position _currentPosition =
  //     Position(longitude: 0, latitude: 0, timestamp: DateTime.timestamp(), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  // ignore: unused_field
  GoogleMapController? _controller;
  LatLng? _selectedLatLng;
  TextEditingController _searchPlaceController = TextEditingController();
  late LocationResult _locationResult;
  bool _phoneValidate = true;

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.branch.address!;
    _phoneController.text = widget.branch.phone!;
    _selectedLatLng = LatLng(widget.branch.latitude!, widget.branch.longitude!);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _searchPlaceController.dispose();
    super.dispose();
  }

  void showPlacePicker() async {
    _locationResult = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlacePicker("AIzaSyClJMtxHGN3ZXNsMBbFSIQvzA2OBRxt6qU")));
    _addressController.text = _locationResult.formattedAddress!;
    setState(() {
      _selectedLatLng = _locationResult.latLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _updateBranchCubit = BlocProvider.of<UpdateBranchCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        title: 'Cập nhật chi nhánh',
      ),
      body: BlocListener<UpdateBranchCubit, UpdateBranchState>(
        listener: (context, state) {
          if (!(state is UpdateBranchLoadingState)) {
            Navigator.pop(context);
          }
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return ProcessingPopup(
                  state: state,
                );
              });
        },
        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        // suffix: Icon(Icons.map_outlined).onTap((){}),
                        suffixIcon: Icon(Icons.map_outlined).onTap(() {
                          showPlacePicker();
                        }),
                        border: InputBorder.none,
                        fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                        filled: true,
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Địa chỉ*',
                        hintText: 'Nhập Địa chỉ',
                      ),
                    ),
                  ),
                  Gap.k16.height,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: TextField(
                      onChanged: (value) => setState(() {
                        _phoneValidate = FormatUtils.phoneValidate(value);
                        print(FormatUtils.phoneValidate(value));
                      }),
                      keyboardType: TextInputType.phone,
                      maxLines: null,
                      controller: _phoneController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                        filled: true,
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Số điện thoại*',
                        hintText: 'Nhập số điện thoại',
                      ),
                    ),
                  ),
                  !_phoneValidate && _phoneController.text != ''
                      ? Column(
                          children: [
                            Gap.k4.height,
                            Text(
                              'Số điện thoại gồm 10 số và các đầu số hợp lệ: 03, 05, 07, 08, 09',
                              style: TextStyle(color: redColor, fontSize: 10),
                            )
                          ],
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: 16),
                  Gap.k16.height,
                  Text(
                    '(*): Bắt buộc nhập',
                    style: TextStyle(color: grey),
                  ),
                  Gap.k16.height,
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: (_addressController.text != '' && _phoneController.text != '' && _selectedLatLng != null)
                      ? ElevatedButton(
                          onPressed: () {
                            _updateBranchCubit.updateBranch(branchId: widget.branch.id!, address: _addressController.text, lat: _selectedLatLng!.latitude, lng: _selectedLatLng!.longitude, phone: _phoneController.text);
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
      ),
    );
  }
}

class ProcessingPopup extends StatelessWidget {
  final UpdateBranchState state;
  const ProcessingPopup({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: state is UpdateBranchLoadingState
            ? Container(
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
                ))
            : state is UpdateBranchSuccessState
                ? Container(
                    width: 150,
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Cập nhật chi nhánh thành công'),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacementNamed(BranchsScreen.routeName);
                            },
                            child: Text(
                              'Đóng',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                      ],
                    ))
                : state is UpdateBranchFailedState
                    ? Container(
                        width: 150,
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              (state as UpdateBranchFailedState).msg.replaceAll('Exception: ', ''),
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Đóng'))
                          ],
                        ),
                      )
                    : Container(
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
                      ));
  }
}
