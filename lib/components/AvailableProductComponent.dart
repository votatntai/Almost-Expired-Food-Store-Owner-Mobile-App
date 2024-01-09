import 'package:appetit/cubits/product/products_cubit.dart';
import 'package:appetit/cubits/product/products_state.dart';
import 'package:appetit/domains/models/campaign/campaigns.dart';
import 'package:appetit/domains/models/product/updateProduct.dart';
import 'package:appetit/utils/format_utils.dart';
import 'package:appetit/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../domains/models/product/products.dart';
import '../screens/ProductDetailScreen.dart';

class AvailableProductComponent extends StatefulWidget {
  final Product product;
  final Campaign campaign;
  AvailableProductComponent(
      {Key? key, required this.product, required this.campaign})
      : super(key: key);

  @override
  State<AvailableProductComponent> createState() =>
      _AvailableProductComponentState();
}

class _AvailableProductComponentState extends State<AvailableProductComponent> {
  @override
  Widget build(BuildContext context) {
    final updateProductCubit = BlocProvider.of<UpdateProductCubit>(context);
    if (DateTime.parse(widget.product.expiredAt!).isBefore(DateTime.now())) {
      return SizedBox.shrink();
    }
    return Container(
            width: context.width(),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: white),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              FadeInImage.assetNetwork(
                      image: widget.product.thumbnailUrl.toString(),
                      placeholder: 'image/appetit/placeholder.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover)
                  .cornerRadiusWithClipRRect(8),
              8.width,
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name!,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  widget.product.productCategories != null
                      ? Text(
                          widget.product.productCategories!.first.category!.name
                              .toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        )
                      : SizedBox.shrink(),
                  Text(
                    '₫' +
                        FormatUtils.formatPrice(
                                widget.product.price!.toDouble())
                            .toString(),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '₫' +
                            FormatUtils.formatPrice(
                                    widget.product.promotionalPrice!.toDouble())
                                .toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Gap.k8.width,
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          'Giảm ' +
                              (((widget.product.price! -
                                              widget
                                                  .product.promotionalPrice!) /
                                          widget.product.price!) *
                                      100)
                                  .round()
                                  .toString() +
                              '%',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ],
              ).expand(),
              Column(
                children: [
                  BlocBuilder<UpdateProductCubit, UpdateProductState>(
                    builder: (context, state) {
                      if (state is UpdateProductLoadingState) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  width: 1, color: Colors.orange.shade700)),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.orange.shade700,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }
                      if (state is UpdateProductSuccessState) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  width: 1, color: Colors.orange.shade700)),
                          child: Text(
                            'Đã thêm',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                            ),
                          ),
                        );
                      }
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.orange.shade700,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                width: 1, color: Colors.orange.shade700)),
                        child: Text(
                          'Thêm',
                          style: TextStyle(
                            color: white,
                          ),
                        ),
                      ).onTap(() {
                        updateProductCubit.updateProduct(
                            product:
                                UpdateProduct(id: widget.product.id, campaignId: widget.campaign.id));
                      });
                    },
                  ),
                  Gap.k8.height,
                  Text(
                    'Còn ' +
                        DateTime.parse(widget.product.expiredAt!)
                            .difference(DateTime.now())
                            .inDays
                            .toString() +
                        ' ngày',
                    style: TextStyle(
                        fontSize: 12,
                        color: DateTime.parse(widget.product.expiredAt!)
                                    .difference(DateTime.now())
                                    .inDays <=
                                10
                            ? Colors.redAccent
                            : DateTime.parse(widget.product.expiredAt!)
                                            .difference(DateTime.now())
                                            .inDays <=
                                        30 &&
                                    DateTime.parse(widget.product.expiredAt!)
                                            .difference(DateTime.now())
                                            .inDays >
                                        10
                                ? Colors.orangeAccent
                                : Colors.green),
                  ),
                ],
              )
            ]))
        .onTap(() => Navigator.pushNamed(context, ProductDetailScreen.routeName,
            arguments: widget.product));
  }
}
