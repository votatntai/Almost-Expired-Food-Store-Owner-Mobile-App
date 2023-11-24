import 'dart:io';

import 'package:appetit/cubits/campaign/campaigns_cubit.dart';
import 'package:appetit/cubits/campaign/campaigns_state.dart';
import 'package:appetit/cubits/categories/categories_cubit.dart';
import 'package:appetit/cubits/categories/categories_state.dart';
import 'package:appetit/cubits/product/products_cubit.dart';
import 'package:appetit/cubits/product/products_state.dart';
import 'package:appetit/cubits/store/stores_cubit.dart';
import 'package:appetit/cubits/store/stores_state.dart';
import 'package:appetit/domains/models/categories.dart';
import 'package:appetit/domains/models/product/createProduct.dart';
import 'package:appetit/screens/CreateCampaignScreen.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:appetit/widgets/CreateNew.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/Colors.dart';
import '../utils/gap.dart';

class CreateProductScreen extends StatefulWidget {
  static const String routeName = '/create-product';
  const CreateProductScreen({Key? key}) : super(key: key);

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  File? _imageFile;
  late DateTime _selectedDate;
  TextEditingController _createAtController = TextEditingController();
  TextEditingController _expiredAtController = TextEditingController();
  String _productName = '';
  String _productStatus = 'unavailable';
  String _productDescription = '';
  Category _selectedCategory = Category();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _createAtController = TextEditingController(
      text: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
    );
    _expiredAtController = TextEditingController(
      text: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
    );
  }

  void _selectStartTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      // You can customize other properties of the date picker
      // For example, locale, initial entry mode, etc.
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        // _selectedDate = picked;
        // _selectedDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(picked.toString());
        _createAtController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  void _selectEndTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      // You can customize other properties of the date picker
      // For example, locale, initial entry mode, etc.
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        // _selectedDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(picked.toString());
        _expiredAtController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
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
    final createProductCubit = BlocProvider.of<CreateProductCubit>(context);
    final storeCubit = BlocProvider.of<StoresCubit>(context);
    storeCubit.getStoresByOwner();
    return Scaffold(
      appBar: MyAppBar(
        title: 'Tạo sản phẩm',
      ),
      body: BlocBuilder<StoresCubit, StoresState>(builder: (context, storesState) {
        if (storesState is StoresSuccessState) {
          final campaignsCubit = BlocProvider.of<CampaignsCubit>(context);
          campaignsCubit.getCampaignsList(storeId: storesState.stores.stores!.first.id);
          return BlocBuilder<CampaignsCubit, CampaignsState>(builder: (context, campaignState) {
            if (campaignState is CampaignsLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (campaignState is CampaignsSuccessState) {
              if (campaignState.campaigns.campaign!.isNotEmpty) {
                return Stack(
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
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                                  filled: true,
                                  labelStyle: TextStyle(color: Colors.grey),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelText: 'Tên sản phẩm*',
                                  hintText: 'Nhập tên sản phẩm',
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
                                          Text('Tải lên ảnh của sản phẩm*', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                                        filled: true,
                                        labelStyle: TextStyle(color: Colors.grey),
                                        hintStyle: TextStyle(color: Colors.grey),
                                        labelText: 'Giá (₫)*',
                                        hintText: 'Nhập giá sản phẩm',
                                      ),
                                    ),
                                  ),
                                ),
                                Gap.k16.width,
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                                        filled: true,
                                        labelStyle: TextStyle(color: Colors.grey),
                                        hintStyle: TextStyle(color: Colors.grey),
                                        labelText: 'Giá giảm (₫)*',
                                        hintText: 'Nhập giá giảm',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap.k16.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                                        filled: true,
                                        labelStyle: TextStyle(color: Colors.grey),
                                        hintStyle: TextStyle(color: Colors.grey),
                                        labelText: 'Số lượng*',
                                        hintText: 'Nhập số lượng sản phẩm',
                                      ),
                                    ),
                                  ),
                                ),
                                Gap.k16.width,
                                Flexible(
                                  flex: 3,
                                  child: BlocProvider<CategoriesCubit>(
                                    create: (context) => CategoriesCubit(),
                                    child: BlocBuilder<CategoriesCubit, CategoriesState>(builder: (context, state) {
                                      if (state is CategoriesLoadingState) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                                              filled: true,
                                              labelStyle: TextStyle(color: Colors.grey),
                                              hintStyle: TextStyle(color: Colors.grey),
                                              labelText: 'Loại*',
                                              hintText: 'Chọn thể loại',
                                            ),
                                            onChanged: (value) {},
                                            items: [],
                                          ),
                                        );
                                      }
                                      if (state is CategoriesSuccessState) {
                                        var categories = state.categories.categories;
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: DropdownButtonFormField<Category>(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                                              filled: true,
                                              labelStyle: TextStyle(color: Colors.grey),
                                              hintStyle: TextStyle(color: Colors.grey),
                                              labelText: 'Loại*',
                                              hintText: 'Chọn thể loại',
                                            ),
                                            onChanged: (Category? value) {
                                              setState(() {
                                                _selectedCategory = value!;
                                              });
                                            },
                                            items: categories!.map<DropdownMenuItem<Category>>((Category category) {
                                              return DropdownMenuItem<Category>(value: category, child: Text(category.name.toString()));
                                            }).toList(),
                                          ),
                                        );
                                      }
                                      return Text('Sự cố tải lên thể loại');
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            Gap.k16.height,
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: TextField(
                                maxLines: null,
                                onChanged: (value) {
                                  setState(() {
                                    _productDescription = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                                  filled: true,
                                  labelStyle: TextStyle(color: Colors.grey),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelText: 'Mô tả về sản phẩm*',
                                  hintText: 'Nhập mô tả sản phẩm',
                                ),
                              ),
                            ),
                            Gap.k16.height,
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: TextField(
                                controller: _createAtController,
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
                                  labelText: 'Ngày sản xuất*',
                                  hintText: 'Chọn ngày sản xuất',
                                ),
                              ),
                            ),
                            Gap.k16.height,
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: TextField(
                                controller: _expiredAtController,
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
                                  labelText: 'Hạn sử dụng*',
                                  hintText: 'Chọn hạn sử dụng',
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
                          child: (_productName != '' && _imageFile != null)
                              ? ElevatedButton(
                                  onPressed: () async {
                                    // await createProductCubit.createProduct(
                                    //     product: CreateProduct(
                                    //         campaignId: '',
                                    //         name: _productName,
                                    //         categoriesId: [],
                                    //         description: '',
                                    //         price: 0,
                                    //         status: _productStatus,
                                    //         quantity: 0,
                                    //         promotionalPrice: 0,
                                    //         thumbnail: _imageFile!,
                                    //         createAt: DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(DateFormat("dd/MM/yyyy").parse(_createAtController.text).toString()).toString(),
                                    //         expiredAt: DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(DateFormat("dd/MM/yyyy").parse(_expiredAtController.text).toString()).toString(),
                                    //         ));
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ProcessingPopup(
                                            state: createProductCubit.state,
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
                );
              } else {
                return CreateNew(routeName: CreateCampaignScreen.routeName, title: 'Cửa hàng hiện chưa có chiến dịch.', text: 'Tạo chiến dịch');
              }
            }
            return SizedBox.shrink();
          });
        }
        return SizedBox.shrink();
      }),
    );
  }
}

class ProcessingPopup extends StatelessWidget {
  final CreateProductState state;
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
          if (state is CreateProductLoadingState) {
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
          if (state is CreateProductSuccessState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Tạo sản phẩm thành công'),
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
