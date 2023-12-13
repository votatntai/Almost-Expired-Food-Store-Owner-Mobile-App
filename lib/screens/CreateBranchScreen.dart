import 'package:appetit/cubits/branch/branchs_cubit.dart';
import 'package:appetit/cubits/branch/branchs_state.dart';
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
import '../utils/gap.dart';

class CreateBranchScreen extends StatefulWidget {
  static const String routeName = '/create-branch';
  const CreateBranchScreen({Key? key}) : super(key: key);

  @override
  State<CreateBranchScreen> createState() => _CreateBranchScreenState();
}

class _CreateBranchScreenState extends State<CreateBranchScreen> {
  // Position _currentPosition =
  //     Position(longitude: 0, latitude: 0, timestamp: DateTime.timestamp(), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  // ignore: unused_field
  GoogleMapController? _controller;
  LatLng? _selectedLatLng;
  Set<Marker> _markers = {};
  TextEditingController _searchPlaceController = TextEditingController();
  late LocationResult _locationResult;


  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _searchPlaceController.dispose();
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

  // void _getCurrentLocation() async {
  //   PermissionStatus status = await Permission.location.request();
  //   if (status == PermissionStatus.granted) {
  //     try {
  //       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //       setState(() {
  //         _currentPosition = position;
  //       });
  //     } catch (e) {
  //       print('Error: $e');
  //     }
  //   } else {
  //     print('Location permission denied');
  //   }
  // }

  void showPlacePicker() async {
    _locationResult = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlacePicker("AIzaSyClJMtxHGN3ZXNsMBbFSIQvzA2OBRxt6qU")));
    _addressController.text = _locationResult.formattedAddress!;
    setState(() {
      
    _selectedLatLng = _locationResult.latLng;
    });
  }

  // Future<void> _showGooglePlacesAutocomplete(BuildContext context) async {
  //   final places = GoogleMapsPlaces(apiKey: "AIzaSyDqrvt4F4XqPjMfkDhb5DYKLzSUYaWz-zI");
  //   Prediction? p = await PlacesAutocomplete.show(
  //     context: context,
  //     apiKey: "AIzaSyDqrvt4F4XqPjMfkDhb5DYKLzSUYaWz-zI",
  //     mode: Mode.overlay,
  //     language: "en",
  //   );
  //   if (p != null) {
  //     PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
  //     final lat = detail.result.geometry!.location.lat;
  //     final lng = detail.result.geometry!.location.lng;
  //     _controller?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
  //     setState(() {
  //       _selectedLatLng = LatLng(lat, lng);
  //       _addMarker(_selectedLatLng!);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final createBranchCubit = BlocProvider.of<CreateBranchCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        title: 'Tạo chi nhánh',
      ),
      body: Stack(
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
                      suffixIcon: Icon(Icons.map_outlined).onTap((){
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
                // Expanded(
                //   child: Stack(
                //     children: [
                //       ClipRRect(
                //         borderRadius: BorderRadius.circular(15),
                //         child: Container(
                //           width: MediaQuery.of(context).size.width,
                //           color: Colors.grey[300],
                //           child: (_currentPosition.latitude != 0 && _currentPosition.longitude != 0)
                //               ? GoogleMap(
                //                   initialCameraPosition: CameraPosition(target: LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 12.0),
                //                   myLocationButtonEnabled: true,
                //                   myLocationEnabled: true,
                //                   markers: _markers,
                //                   onMapCreated: (controller) {
                //                     setState(() {
                //                       _controller = controller;
                //                     });
                //                   },
                //                   onTap: (latLng) {
                //                     setState(() {
                //                       _selectedLatLng = latLng;
                //                       _addMarker(latLng);
                //                     });
                //                   },
                //                 )
                //               : SizedBox.shrink(),
                //         ),
                //       ),
                //       Positioned(
                //         top: 16,
                //         right: 62,
                //         left: 16,
                //         child: ClipRRect(
                //           borderRadius: BorderRadius.circular(16),
                //           child: TextField(
                //             // controller: _searchPlaceController,
                //             onChanged: (value) {_showGooglePlacesAutocomplete(_searchPlaceController.text);},
                //             decoration: InputDecoration(
                //               prefixIcon: Icon(Icons.search_outlined),
                //               border: InputBorder.none,
                //               fillColor: white,
                //               filled: true,
                //               labelStyle: TextStyle(color: Colors.grey),
                //               hintStyle: TextStyle(color: Colors.grey),
                //               labelText: 'Tìm địa điểm',
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Expanded(
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(15),
                //     child: Container(
                //       width: MediaQuery.of(context).size.width,
                //       color: Colors.grey[300],
                //       child: (_currentPosition.latitude != 0 && _currentPosition.longitude != 0)
                //           ? GoogleMap(
                //               initialCameraPosition: CameraPosition(target: LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 12.0),
                //               myLocationButtonEnabled: true,
                //               myLocationEnabled: true,
                //               markers: _markers,
                //               onMapCreated: (controller) {
                //                 setState(() {
                //                   _controller = controller;
                //                 });
                //               },
                //               onTap: (latLng) {
                //                 setState(() {
                //                   _selectedLatLng = latLng;
                //                   _addMarker(latLng);
                //                 });
                //               },
                //             )
                //           : SizedBox.shrink(),
                //     ),
                //   ),
                // ),
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
                Text('Tạo chi nhánh thành công'),
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
