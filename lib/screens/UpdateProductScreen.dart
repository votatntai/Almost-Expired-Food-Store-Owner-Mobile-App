import 'package:appetit/cubits/product/products_cubit.dart';
import 'package:appetit/cubits/product/products_state.dart';
import 'package:appetit/domains/models/product/products.dart';
import 'package:appetit/screens/ProductsScreen.dart';
import 'package:appetit/utils/format_utils.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../domains/models/product/updateProduct.dart';
import '../main.dart';
import '../utils/Colors.dart';
import '../utils/gap.dart';

class UpdateProductScreen extends StatefulWidget {
  static const String routeName = '/update-product';
  final Product product;
  const UpdateProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  DateTime? _selectedDate;
  TextEditingController _createAtController = TextEditingController(text: 'Chọn ngày sản xuất');
  TextEditingController _expiredAtController = TextEditingController(text: 'Chọn hạn sử dụng');
  TextEditingController _productName = TextEditingController();
  TextEditingController _productDescription = TextEditingController();
  TextEditingController _productPrice = TextEditingController();
  TextEditingController _productPromotionalPrice = TextEditingController();
  TextEditingController _productQuantity = TextEditingController();
  TextEditingController _soldController = TextEditingController();
  bool _isValidProPrice = true;
  // bool _isValidExpiredTime = true;

  @override
  void initState() {
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
    _productName.text = widget.product.name!;
    _productPrice.text = widget.product.price.toString();
    _productPromotionalPrice.text = widget.product.promotionalPrice.toString();
    _productQuantity.text = widget.product.quantity.toString();
    _soldController.text = widget.product.sold.toString();
    _productDescription.text = widget.product.description!;
    _createAtController.text = FormatUtils.formatDate(widget.product.createAt!);
    _expiredAtController.text = FormatUtils.formatDate(widget.product.expiredAt!);
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

  void comparePriceAndProPrice() {
    if (_productPrice.text.toInt() != 0 && _productPromotionalPrice.text.toInt() != 0) {
      setState(() {
        _isValidProPrice = _productPrice.text.toInt() > _productPromotionalPrice.text.toInt();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final updateProductCubit = BlocProvider.of<UpdateProductCubit>(context);
    return Scaffold(
        appBar: MyAppBar(
          title: 'Cập nhật sản phẩm',
        ),
        body: BlocListener<UpdateProductCubit, UpdateProductState>(
          listener: (context, state) {
            if (!(state is UpdateProductLoadingState)) {
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: TextField(
                          controller: _soldController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                            filled: true,
                            labelStyle: TextStyle(color: Colors.grey),
                            hintStyle: TextStyle(color: Colors.grey),
                            labelText: 'Đã bán*',
                            hintText: 'Nhập số lượng đã bán',
                          ),
                        ),
                      ),
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
                    child: (_productName.text != '' &&
                            _productDescription.text != '' &&
                            _isValidProPrice &&
                            _productPrice.text != '' &&
                            _productPromotionalPrice.text != '' &&
                            _productQuantity.text != '' &&
                            _soldController.text != '' &&
                            _createAtController.text != '' &&
                            _expiredAtController.text != '')
                        ? ElevatedButton(
                            onPressed: () async {
                              await updateProductCubit.updateProduct(
                                  product: UpdateProduct(
                                id: widget.product.id,
                                name: _productName.text,
                                description: _productDescription.text,
                                price: _productPrice.text.toInt(),
                                sold: _soldController.text.toInt(),
                                status: 'Available',
                                quantity: _productQuantity.text.toInt(),
                                promotionalPrice: _productPromotionalPrice.text.toInt(),
                                createAt: DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(DateFormat("dd/MM/yyyy").parse(_createAtController.text).toString()).toString(),
                                expiredAt: DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(DateFormat("dd/MM/yyyy").parse(_expiredAtController.text).toString()).toString(),
                              ));
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
        ));
  }
}

class ProcessingPopup extends StatelessWidget {
  final UpdateProductState state;
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
          if (state is UpdateProductLoadingState) {
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
          if (state is UpdateProductSuccessState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Cập nhật sản phẩm thành công'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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
