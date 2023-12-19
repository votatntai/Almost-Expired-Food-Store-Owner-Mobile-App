import 'package:appetit/components/ProductComponent.dart';
import 'package:appetit/cubits/product/products_cubit.dart';
import 'package:appetit/cubits/product/products_state.dart';
import 'package:appetit/screens/CreateProductScreen.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:appetit/widgets/CreateNew.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/gap.dart';
import '../widgets/SkeletonWidget.dart';

class ProductsScreen extends StatefulWidget {
  static const String routeName = '/products';
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appLayout_background,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.orange.shade600,
        onPressed: () {
          Navigator.pushNamed(context, CreateProductScreen.routeName);
        },
        child: Icon(
          Icons.add_outlined,
          color: white,
        ),
      ),
      appBar: MyAppBar(title: 'Sản phẩm'),
      body: BlocBuilder<ProductsCubit, ProductsState>(builder: (context, state) {
        if (state is ProductsLoadingState) {
          return ListView.separated(
            separatorBuilder: (context, index) => Gap.k8.height,
              itemCount: 6,
              padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(color: white),
                  width: context.width(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SkeletonWidget(borderRadius: 8, height: 80, width: 80),
                      Gap.k8.width,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonWidget(borderRadius: 7, height: 14, width: 100),
                          SkeletonWidget(borderRadius: 7, height: 14, width: 70),
                          SkeletonWidget(borderRadius: 7, height: 14, width: 70),
                          Row(
                            children: [SkeletonWidget(borderRadius: 7, height: 14, width: 60), Gap.k8.width, SkeletonWidget(borderRadius: 4, height: 20, width: 60)],
                          )
                        ],
                      ).expand(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [SkeletonWidget(borderRadius: 8, height: 16, width: 80), Gap.k8.height, SkeletonWidget(borderRadius: 4, height: 32, width: 60)],
                      )
                    ],
                  ),
                );
              });
        }
        if (state is ProductsSuccessState) {
          if (state.products.products!.isNotEmpty) {
            var products = state.products.products;
            return ListView.separated(
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return ProductComponent(product: products![index]);
                },
                separatorBuilder: (context, index) => Gap.k8.height,
                itemCount: products!.length);
          } else {
            return CreateNew(routeName: CreateProductScreen.routeName, title: 'Cửa hàng hiện chưa có sản phẩm.', text: 'Tạo sản phẩm');
          }
        }
        return SizedBox.shrink();
      }),
    );
  }
}
