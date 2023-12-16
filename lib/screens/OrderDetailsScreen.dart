import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import '../cubits/order/orders_cubit.dart';
import '../cubits/order/orders_state.dart';
import '../utils/format_utils.dart';
import '../utils/gap.dart';

class OrderDetailsScreen extends StatelessWidget {
  static const String routeName = '/order-details';
  final bool? isShowPaymentButton;
  final bool? isShowFeedbackButton;
  final String orderId;
  const OrderDetailsScreen({Key? key, this.isShowPaymentButton, required this.orderId, this.isShowFeedbackButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderDetailsCubit>(
      create: (context) => OrderDetailsCubit(orderId: orderId),
      child: Scaffold(
        appBar: MyAppBar(
          title: 'Chi tiết đơn hàng',
        ),
        body: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
          builder: (context, state) {
            if (state is OrdersDetailsLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is OrderDetailsSuccessState) {
              var orderDetails = state.order.orderDetails;
              return Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(color: white),
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: orderDetails!.length,
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
                                  Gap.k4.height,
                                  Text(
                                    'Số lượng: ' + orderDetails[index].quantity.toString(),
                                    style: TextStyle(color: grey, fontSize: 12),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
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
                                  ),
                                ],
                              ).expand()
                            ],
                          ).paddingSymmetric(horizontal: 16),
                        );
                      },
                    ),
                    Gap.k16.height,
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(text: 'Tổng tiền: ', style: TextStyle(color: context.iconColor, fontSize: 14)),
                      TextSpan(text: '₫' + FormatUtils.formatPrice(state.order.amount!.toDouble()).toString(), style: TextStyle(color: Colors.orange.shade700, fontSize: 14))
                    ])),
                  ],
                ),
              );
            }
            return Center(child: Text('Không tìm thấy đơn hàng'),);
          },
        ),
      ),
    );
  }
}
