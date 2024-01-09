import 'package:appetit/cubits/product/products_cubit.dart';
import 'package:appetit/cubits/product/products_state.dart';
import 'package:appetit/domains/models/campaign/campaigns.dart';
import 'package:appetit/screens/CreateProductScreen.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:appetit/widgets/CreateNew.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/AvailableProductComponent.dart';
import '../utils/gap.dart';
import '../widgets/SkeletonWidget.dart';
import 'CampaignScreen.dart';

class AddProductToCampaignScreen extends StatefulWidget {
  static const String routeName = '/available-products';
  final Campaign campaign;
  const AddProductToCampaignScreen({Key? key, required this.campaign}) : super(key: key);

  @override
  State<AddProductToCampaignScreen> createState() =>
      _AddProductToCampaignScreenState();
}

class _AddProductToCampaignScreenState
    extends State<AddProductToCampaignScreen> {
  bool expiredAsc = false;
  bool expiredDesc = false;

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
      appBar: MyAppBar(
        title: 'Sản phẩm',
        routeName: CampaignScreen.routeName,
        arguments: {'campaign' : widget.campaign, 'campaignId' : widget.campaign.id},
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.filter_alt_outlined),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Hạn tăng dần'),
                value: 'expiredAsc',
              ),
              PopupMenuItem(
                child: Text('Hạn giảm dần'),
                value: 'expiredDesc',
              ),
            ],
            onSelected: (value) {
              if (value == 'expiredAsc') {
                setState(() {
                  expiredAsc = true;
                  expiredDesc = false;
                });
              } else {
                setState(() {
                  expiredDesc = true;
                  expiredAsc = false;
                });
              }
            },
          )
        ],
      ),
      body: BlocBuilder<AvailableProductsCubit, AvailableProductsState>(
          builder: (context, state) {
        if (state is AvailableProductsLoadingState) {
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
                          SkeletonWidget(
                              borderRadius: 7, height: 14, width: 100),
                          SkeletonWidget(
                              borderRadius: 7, height: 14, width: 70),
                          SkeletonWidget(
                              borderRadius: 7, height: 14, width: 70),
                          Row(
                            children: [
                              SkeletonWidget(
                                  borderRadius: 7, height: 14, width: 60),
                              Gap.k8.width,
                              SkeletonWidget(
                                  borderRadius: 4, height: 20, width: 60)
                            ],
                          )
                        ],
                      ).expand(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SkeletonWidget(
                              borderRadius: 8, height: 16, width: 80),
                          Gap.k8.height,
                          SkeletonWidget(borderRadius: 4, height: 32, width: 60)
                        ],
                      )
                    ],
                  ),
                );
              });
        }
        if (state is AvailableProductsSuccessState) {
          if (state.products.products!.isNotEmpty) {
            var products = state.products.products;

            expiredAsc == true
                ? products!.sort((a, b) => DateTime.parse(a.expiredAt!)
                    .compareTo(DateTime.parse(b.expiredAt!)))
                : products!.sort((a, b) => DateTime.parse(b.expiredAt!)
                    .compareTo(DateTime.parse(a.expiredAt!)));
            return ListView.separated(
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return BlocProvider<UpdateProductCubit>(
                      create: (context) => UpdateProductCubit(),
                      child:
                          AvailableProductComponent(product: products[index], campaign: widget.campaign,));
                },
                separatorBuilder: (context, index) => Gap.k8.height,
                itemCount: products.length);
          } else {
            return CreateNew(
                routeName: CreateProductScreen.routeName,
                title: 'Cửa hàng hiện chưa có sản phẩm.',
                text: 'Tạo sản phẩm');
          }
        }
        return SizedBox.shrink();
      }),
    );
  }
}
