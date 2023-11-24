import 'package:appetit/cubits/branch/branchs_cubit.dart';
import 'package:appetit/cubits/branch/branchs_state.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
import '../utils/Colors.dart';
import '../utils/gap.dart';

class CreateBranchScreen extends StatefulWidget {
  static const String routeName = '/create-branch';
  const CreateBranchScreen({Key? key}) : super(key: key);

  @override
  State<CreateBranchScreen> createState() => _CreateBranchScreenState();
}

class _CreateBranchScreenState extends State<CreateBranchScreen> {
  Position _currentPosition =
      Position(longitude: 0, latitude: 0, timestamp: DateTime.timestamp(), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  // ignore: unused_field
  GoogleMapController? _controller;
  LatLng? _selectedLatLng;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }
  
  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  void _addMarker(LatLng latLng) {
  setState(() {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: MarkerId('marker_id'),
        position: latLng,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: 'Your Marker',
          snippet: 'Description of your marker',
        ),
      ),
    );
  });
}

  void _getCurrentLocation() async {
    PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      try {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentPosition = position;
          print(_currentPosition);
        });
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Location permission denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    final createBranchCubit = BlocProvider.of<CreateBranchCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        title: 'Tạo chi nhánh',
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
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
            SizedBox(height: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                  child: (_currentPosition.latitude != 0 && _currentPosition.longitude != 0)
                      ? GoogleMap(
                          initialCameraPosition: CameraPosition(target: LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 12.0),
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          markers: _markers,
                          onMapCreated: (controller) {
                            setState(() {
                              _controller = controller;
                            });
                          },
                          onTap: (latLng) {
                            setState(() {
                              _selectedLatLng = latLng;
                              _addMarker(latLng);
                            });
                          },
                        )
                      : SizedBox.shrink(),
                ),
              ),
            ),
            Gap.k16.height,
            Text(
              '(*): Bắt buộc nhập',
              style: TextStyle(color: grey),
            ),
            Gap.k16.height,
            (_addressController.text != '' && _phoneController.text != '' && _selectedLatLng != null) ? ElevatedButton(
              onPressed: () async {
                await createBranchCubit.createBranch(_addressController.text, _selectedLatLng!.latitude, _selectedLatLng!.longitude, _phoneController.text);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ProcessingPopup(
                        state: createBranchCubit.state,
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
            ) : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class ProcessingPopup extends StatelessWidget {
  final CreateBranchState state;
  const ProcessingPopup({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 150,
        width: 150,
        padding: const EdgeInsets.all(32.0),
        child: Builder(builder: (context) {
          if (state is CreateBranchLoadingState) {
            return Column(
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
                Gap.k16.height,
                Text('Đang xử lý, vui lòng chờ.')
              ],
            );
          }
          if (state is CreateBranchSuccessState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Tạo chiến dịch thành công'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text(
                      'Đóng',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            );
          }
          return Column(
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
          );
        }),
      ),
    );
  }
}
