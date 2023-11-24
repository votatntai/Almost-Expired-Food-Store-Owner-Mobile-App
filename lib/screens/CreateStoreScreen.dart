import 'dart:io';
import 'package:appetit/cubits/store/stores_cubit.dart';
import 'package:appetit/cubits/store/stores_state.dart';
import 'package:appetit/main.dart';
import 'package:appetit/screens/DashboardScreen.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/gap.dart';

class CreateStoreScreen extends StatefulWidget {
  static const String routeName = '/create-store';
  CreateStoreScreen({Key? key}) : super(key: key);

  @override
  State<CreateStoreScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> {
  File? _imageFile;
  String _storeName = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getImage(BuildContext context) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
      // widget.onImageSelected(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final createStoreCubit = BlocProvider.of<CreateStoreCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MyAppBar(
        title: ' Tạo cửa hàng',
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
                          _storeName = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                        filled: true,
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Tên cửa hàng*',
                        hintText: 'Nhập tên cửa hàng',
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
                                Text('Tải lên ảnh đại diện cho cửa hàng*', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
                                // Text('*maximum size 2MB', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.grey)),
                              ],
                            )
                          : Image.file(_imageFile!, fit: BoxFit.cover,),
                    ).onTap(() {
                      // _pickImage(ImageSource.gallery);
                      _getImage(context);
                    }),
                  ),
                  Gap.k16.height,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: TextField(
                      maxLines: null,
                      onChanged: (value) {
                        setState(() {
                          _description = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                        filled: true,
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Mô tả về cửa hàng của bạn*',
                        hintText: 'Nhập mô tả cửa hàng',
                      ),
                    ),
                  ),
                  Gap.k16.height,
                  Text('(*): Bắt buộc nhập', style: TextStyle(color: grey),)
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: (_storeName != '' && _imageFile != null && _description != '' && !(MediaQuery.of(context).viewInsets.bottom > 0))
                    ? ElevatedButton(
                        onPressed: () async {
                          await createStoreCubit.createStore(
                            _storeName,
                            _imageFile!,
                            _description
                          );
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ProcessingPopup(
                                  state: createStoreCubit.state,
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
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProcessingPopup extends StatelessWidget {
  final CreateStoreState state;
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
          if (state is CreateStoreLoadingState) {
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
          if (state is CreateStoreSuccessState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Tạo cửa hàng thành công'),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.routeName, (route) => false);
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
