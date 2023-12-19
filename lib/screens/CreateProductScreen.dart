import 'dart:io';

import 'package:appetit/cubits/campaign/campaigns_cubit.dart';
import 'package:appetit/cubits/campaign/campaigns_state.dart';
import 'package:appetit/cubits/categories/categories_cubit.dart';
import 'package:appetit/cubits/categories/categories_state.dart';
import 'package:appetit/cubits/product/products_cubit.dart';
import 'package:appetit/cubits/product/products_state.dart';
import 'package:appetit/domains/models/campaign/campaigns.dart';
import 'package:appetit/domains/models/categories.dart';
import 'package:appetit/domains/models/product/createProduct.dart';
import 'package:appetit/domains/repositories/stores_repo.dart';
import 'package:appetit/screens/CreateCampaignScreen.dart';
import 'package:appetit/screens/ProductsScreen.dart';
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
  DateTime? _selectedDate;
  TextEditingController _createAtController = TextEditingController(text: 'Chọn ngày sản xuất');
  TextEditingController _expiredAtController = TextEditingController(text: 'Chọn hạn sử dụng');
  TextEditingController _productName = TextEditingController();
  TextEditingController _productDescription = TextEditingController();
  TextEditingController _productPrice = TextEditingController();
  TextEditingController _productPromotionalPrice = TextEditingController();
  TextEditingController _productQuantity = TextEditingController();
  List<Category> _selectedCategories = [];
  List<Map<String, bool>> _isCheckCategory = [];
  Campaign _selectedCampaign = Campaign();
  bool _isShowCategoryList = false;
  bool _isValidProPrice = true;
  // bool _isValidExpiredTime = true;

  @override
  void initState() {
    final campaignsCubit = BlocProvider.of<CampaignsCubit>(context);
    campaignsCubit.getCampaignsList(storeId: StoresRepo.store.id);
    if (_selectedDate != null) {
      _createAtController = TextEditingController(
        text: '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
      );
      _expiredAtController = TextEditingController(
        text: '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
      );
    } else {
      _createAtController = TextEditingController();
      _expiredAtController = TextEditingController();
    }
    super.initState();
  }

  @override
  void dispose() {
    _createAtController.dispose();
    _expiredAtController.dispose();
    _productName.dispose();
    _productDescription.dispose();
    _productPrice.dispose();
    _productPromotionalPrice.dispose();
    _productQuantity.dispose();
    super.dispose();
  }

  void _selectCreateAt(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate! : DateTime.now().subtract(Duration(days: 1)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().subtract(Duration(days: 1)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _createAtController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  void _selectExpiredAt(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
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
    }
  }

  void comparePriceAndProPrice() {
    if (_productPrice.text.toInt() != 0 && _productPromotionalPrice.text.toInt() != 0) {
      setState(() {
        _isValidProPrice = _productPrice.text.toInt() > _productPromotionalPrice.text.toInt();
      });
    }
  }

  // void compareCreateAndExpiredTime() {
  //   if (_createAtController.text != '' && _expiredAtController.text != '') {
  //     List<String> createTimeParts = _createAtController.text.split('/');
  //     List<String> expiredTimeParts = _expiredAtController.text.split('/');
  //     int createDay = int.tryParse(createTimeParts[0])!;
  //     int createMonth = int.tryParse(createTimeParts[1])!;
  //     int createYear = int.tryParse(createTimeParts[2])!;
  //     int expiredDay = int.tryParse(expiredTimeParts[0])!;
  //     int expiredMonth = int.tryParse(expiredTimeParts[1])!;
  //     int expiredYear = int.tryParse(expiredTimeParts[2])!;
  //     setState(() {
  //       _isValidExpiredTime = DateTime(createYear, createMonth, createDay).isBefore(DateTime(expiredYear, expiredMonth, expiredDay));
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final createProductCubit = BlocProvider.of<CreateProductCubit>(context);

    return Scaffold(
        appBar: MyAppBar(
          title: 'Tạo sản phẩm',
        ),
        body: BlocListener<CreateProductCubit, CreateProductState>(
          listener: (context, state) {
            if (!(state is CreateProductLoadingState)) {
              Navigator.pop(context);
            }
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ProcessingPopup(
                    state: state,
                  );
                });
          },
          child: Stack(
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
                          controller: _productName,
                          // onChanged: (value) {
                          //   setState(() {});
                          // },
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
                                onChanged: (value) => comparePriceAndProPrice(),
                                controller: _productPrice,
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
                                onChanged: (value) => comparePriceAndProPrice(),
                                controller: _productPromotionalPrice,
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
                      _isValidProPrice
                          ? SizedBox.shrink()
                          : Column(
                              children: [
                                Text(
                                  'Giá khuyến mãi phải thấp hơn giá niêm yết.',
                                  style: TextStyle(fontSize: 12, color: Colors.red),
                                ),
                                Gap.k16.height
                              ],
                            ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: TextField(
                          controller: _productQuantity,
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
                      Gap.k16.height,
                      BlocProvider<CategoriesCubit>(
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
                            categories!.forEach((element) => _isCheckCategory.add({element.id.toString(): false}));
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 16),
                                  height: 64,
                                  width: context.width(),
                                  decoration: BoxDecoration(
                                    color: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _selectedCategories.isEmpty
                                          ? Text(
                                              'Chọn thể loại',
                                              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                                            ).expand()
                                          : SizedBox(
                                              width: context.width() * 0.73,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Wrap(
                                                    children: _selectedCategories.map((item) {
                                                  return Chip(
                                                    label: Text(item.name.toString()),
                                                    onDeleted: () {
                                                      setState(() {
                                                        _selectedCategories.remove(item);
                                                      });
                                                    },
                                                  ).paddingRight(8);
                                                }).toList()),
                                              ),
                                            ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: grey,
                                      )
                                    ],
                                  ),
                                ).onTap(() {
                                  setState(() {
                                    _isShowCategoryList = !_isShowCategoryList;
                                  });
                                }),
                                _isShowCategoryList
                                    ? Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: white, border: Border.all(width: 1), borderRadius: BorderRadius.circular(8)),
                                        height: 100,
                                        width: 100,
                                        child: ListView.separated(
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (context, index) {
                                              return Text(categories[index].name.toString()).onTap(() {
                                                if (_selectedCategories.any((element) => element.id == categories[index].id)) {
                                                  setState(() {
                                                    _selectedCategories.remove(categories[index]);
                                                    _isCheckCategory[index][categories[index].id.toString()] = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    _isCheckCategory[index][categories[index].id.toString()] = true;
                                                    _selectedCategories.add(categories[index]);
                                                  });
                                                }
                                              });
                                            },
                                            separatorBuilder: (context, index) => Divider(),
                                            itemCount: categories.length),
                                      )
                                    : SizedBox.shrink(),
                              ],
                            );
                          }
                          return Text('Sự cố tải lên thể loại');
                        }),
                      ),
                      Gap.k16.height,
                      BlocBuilder<CampaignsCubit, CampaignsState>(builder: (context, campaignState) {
                        if (campaignState is CampaignsLoadingState) {
                          return SizedBox.shrink();
                        }
                        if (campaignState is CampaignsSuccessState) {
                          if (campaignState.campaigns.campaign!.isNotEmpty) {
                            var campaigns = campaignState.campaigns.campaign;
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: DropdownButtonFormField<Campaign>(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                  border: InputBorder.none,
                                  fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor, // Change this to the color you want
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  hintText: 'Chọn chiến dịch',
                                ),
                                // value: selectedBranch,
                                onChanged: (Campaign? newValue) {
                                  setState(() {
                                    _selectedCampaign = newValue!;
                                  });
                                },
                                items: campaigns!.map<DropdownMenuItem<Campaign>>((Campaign campaign) {
                                  return DropdownMenuItem<Campaign>(
                                    value: campaign,
                                    child: Text(campaign.name.toString()),
                                  );
                                }).toList(),
                              ),
                            );
                          } else {
                            return CreateNew(routeName: CreateCampaignScreen.routeName, title: 'Cửa hàng hiện chưa có chiến dịch.', text: 'Tạo chiến dịch');
                          }
                        }
                        return SizedBox.shrink();
                      }),
                      Gap.k16.height,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: TextField(
                          controller: _productDescription,
                          maxLines: null,
                          // onChanged: (value) {
                          //   setState(() {
                          //     _productDescription = value;
                          //   });
                          // },
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
                            _selectCreateAt(context);
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
                            _selectExpiredAt(context);
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
                      Gap.kSection.height,
                      Gap.kSection.height,
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                    child: (_productName.text != '' && _productDescription.text != '' && _imageFile != null && _isValidProPrice)
                        ? ElevatedButton(
                            onPressed: () async {
                              await createProductCubit.createProduct(
                                  product: CreateProduct(
                                campaignId: _selectedCampaign.id.toString(),
                                name: _productName.text,
                                categoriesId: _selectedCategories,
                                description: _productDescription.text,
                                price: _productPrice.text.toInt(),
                                status: 'Available',
                                quantity: _productQuantity.text.toInt(),
                                promotionalPrice: _productPromotionalPrice.text.toInt(),
                                thumbnail: _imageFile!,
                                createAt: DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(DateFormat("dd/MM/yyyy").parse(_createAtController.text).toString()).toString(),
                                expiredAt: DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(DateFormat("dd/MM/yyyy").parse(_expiredAtController.text).toString()).toString(),
                              ));
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
        ));
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
        width: 150,
        padding: const EdgeInsets.all(32.0),
        child: Builder(builder: (context) {
          if (state is CreateProductLoadingState) {
            return Column(
                      mainAxisSize: MainAxisSize.min,

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
                      mainAxisSize: MainAxisSize.min,

              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Tạo sản phẩm thành công'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed(ProductsScreen.routeName);
                    },
                    child: Text(
                      'Đóng',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            );
          }
          return Column(
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
          );
        }),
      ),
    );
  }
}
