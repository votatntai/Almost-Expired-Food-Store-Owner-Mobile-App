import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../domains/models/orders.dart';
import '../utils/format_utils.dart';
import '../utils/gap.dart';

class OrderDetailsScreen extends StatelessWidget {
  static const String routeName = '/order-details';
  final bool? isShowPaymentButton;
  final int amout;
  final List<OrderDetails> orderDetails;
  const OrderDetailsScreen({Key? key, this.isShowPaymentButton, required this.amout, required this.orderDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: 'Chi tiết đơn hàng',
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(color: white),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemCount: orderDetails.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FadeInImage.assetNetwork(
                        placeholder: 'image/appetit/placeholder.png',
                        image: orderDetails[index].product!.thumbnailUrl.toString(),
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                      Gap.k8.width,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(orderDetails[index].product!.name.toString()),
                          Text(
                            'Số lượng: ' + orderDetails[index].product!.quantity.toString(),
                            style: TextStyle(color: grey, fontSize: 12),
                          ),
                          Row(
                            children: [
                              Text(
                                '₫' + FormatUtils.formatPrice(orderDetails[index].product!.price!.toDouble()).toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Gap.k8.width,
                              Text(
                                '₫' + FormatUtils.formatPrice(orderDetails[index].product!.promotionalPrice!.toDouble()).toString(),
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ).paddingSymmetric(horizontal: 16),
                );
                }, 
              ),
              // orderDetails[index]!.length > 1
              //     ? Column(
              //         children: [
              //           Divider(),
              //           Text(
              //             'Xem thêm sản phẩm',
              //             style: TextStyle(color: grey, fontSize: 12),
              //           )
              //         ],
              //       ).onTap(() {
              //         Navigator.pushNamed(context, OrderDetailsScreen.routeName);
              //       })
              //     : SizedBox.shrink(),
              // Divider(),
              Gap.k16.height,
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: 'Tổng tiền: ', style: TextStyle(color: context.iconColor, fontSize: 14)),
                    TextSpan(text: '₫' + FormatUtils.formatPrice(amout.toDouble()).toString(), style: TextStyle(color: Colors.orange.shade700, fontSize: 14))
                  ])),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       orders[index].orderDetails!.length.toString() + ' sản phẩm',
              //       style: TextStyle(fontSize: 12, color: grey),
              //     ),
              //     Container(
              //       padding: EdgeInsets.all(8),
              //       decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.orange.shade700), borderRadius: BorderRadius.circular(4)),
              //       child: Row(
              //         children: [
              //           Image.asset(
              //             'image/appetit/payment.png',
              //             width: 16,
              //           ),
              //           Gap.k8.width,
              //           Text(
              //             'Thanh toán',
              //             style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
              //           )
              //         ],
              //       ),
              //     ).onTap(() {
              //       paymentCubit.payment(amount: orders[index].amount!, orderId: orders[index].id!);
              //     })
              //   ],
              // ).paddingSymmetric(horizontal: 16),
            ],
          ),
        ));
  }
}
