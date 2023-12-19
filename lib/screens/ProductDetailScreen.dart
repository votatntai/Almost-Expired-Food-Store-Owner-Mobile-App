import 'package:appetit/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/DiscussionComponent.dart';
import '../domains/models/product/products.dart';
import '../utils/format_utils.dart';

// ignore: must_be_immutable
class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';
  final Product product;
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: FadeInImage.assetNetwork(
                      image: widget.product.thumbnailUrl.toString(), placeholder: 'image/appetit/placeholder.png', width: MediaQuery.of(context).size.width, height: 250, fit: BoxFit.cover),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 7,
                      child: Text(
                        widget.product.name.toString(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Còn ' + widget.product.quantity!.toString() + ' sản phẩm',
                          style: TextStyle(fontWeight: FontWeight.bold, color: white, fontSize: 10),
                        ),
                      ),
                    )
                  ],
                ),
                Gap.k8.height,
                Row(
                  children: widget.product.productCategories!.map((e) {
                    return Row(
                      children: [
                        Text(
                          e.category!.name.toString() + '| ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                Gap.k16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₫' + FormatUtils.formatPrice(widget.product.promotionalPrice!.toDouble()).toString(),
                          style: TextStyle(color: Colors.orange.shade600, fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Gap.k4.width,
                        Text(
                          '₫' + FormatUtils.formatPrice(widget.product.price!.toDouble()).toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 14.0,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Gap.k16.height,
                Text(
                  'Mô tả sản phẩm',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Gap.k8.height,
                Text(
                  widget.product.description.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
                Gap.kSection.height,

                //Discussion title
                Text('Đánh giá sản phẩm', style: TextStyle(fontWeight: FontWeight.w600)),

                SizedBox(height: 16),

                DiscussionComponent(
                  productId: widget.product.id!,
                ),
                Gap.kSection.height,
                Gap.kSection.height,
                Gap.kSection.height,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

