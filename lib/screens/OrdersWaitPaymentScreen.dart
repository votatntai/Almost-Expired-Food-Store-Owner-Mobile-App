
import 'package:appetit/domains/repositories/stores_repo.dart';
import 'package:appetit/screens/DashboardScreen.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import '../cubits/order/orders_cubit.dart';
import '../cubits/order/orders_state.dart';
import '../utils/format_utils.dart';
import '../utils/gap.dart';
import 'OrderDetailsScreen.dart';

class OrdersWaitPaymentScreen extends StatefulWidget {
  static const String routeName = '/wait-payment';
  const OrdersWaitPaymentScreen({Key? key}) : super(key: key);

  @override
  State<OrdersWaitPaymentScreen> createState() => _OrdersWaitPaymentScreenState();
}

class _OrdersWaitPaymentScreenState extends State<OrdersWaitPaymentScreen> {
  String urlPayment = '';
  bool paymentStatus = false;
  OrdersCubit? ordersCubit;
  bool isRefresh = false;
  // WebViewController? _webviewController;
  // void _launchURL(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    ordersCubit = BlocProvider.of<OrdersCubit>(context);
    ordersCubit!.getOrdersList(status: 'Pending Payment', storeId: StoresRepo.storeId);
    // WidgetsBinding.instance.addObserver(this);
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // Future<bool> didPopRoute() async {
  //     print('aaaaa');
  //     checkOrder();
  //     if (paymentStatus) {
  //       showDialog(
  //           context: context,
  //           builder: (_) {
  //             return Dialog(
  //               child: Container(
  //                 height: 100,
  //                 width: 150,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [Text('Thanh toán thành công'), TextButton(onPressed: () {
  //                   Navigator.pop(context);
  //                   Navigator.pop(context);
  //                   Navigator.pushReplacementNamed(context, OrdersWaitPaymentScreen.routeName);
  //                 }, child: Text('Đóng'))]),
  //               ),
  //             );
  //           });
  //     } else {
  //       showDialog(
  //           context: context,
  //           builder: (_) {
  //             return Dialog(
  //               child: Container(
  //                 height: 100,
  //                 width: 150,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [Text('Thanh toán thất bại. Hãy thử lại.'), TextButton(onPressed: () {
  //                   Navigator.pop(context);
  //                 }, child: Text('Đóng'))]),
  //               ),
  //             );
  //           });

  //   }
  //   return false;
  // }

  // Future<void> checkOrder() async {
  //   try {
  //     await ordersCubit!.getOrdersList(status: 'Pending Payment');
  //     ordersCubit!.stream.listen((state) {
  //       if (state is OrdersSuccessState) {
  //         if (state.orders.orders!.any((order) => order.isPayment == true)) {
  //           setState(() {
  //             paymentStatus = true;
  //           });
  //         } else {
  //           paymentStatus = false;
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     // Xử lý các trường hợp ngoại lệ nếu có
  //     print('Error loading orders: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {


    ordersCubit!.getOrdersList(status: 'Pending Payment', storeId: StoresRepo.storeId);
    return Scaffold(
      appBar: MyAppBar(
        title: 'Chờ thanh toán',
        routeName: DashboardScreen.routeName,
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersSuccessState) {
            var orders = state.orders.orders;
            if (orders!.isNotEmpty) {
              return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  itemBuilder: (context, index) {
                    var orderItem = orders[index].orderDetails!.first.product!;
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: white),
                      child: Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FadeInImage.assetNetwork(
                                  placeholder: 'image/appetit/placeholder.png',
                                  image: orderItem.thumbnailUrl.toString(),
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                                Gap.k8.width,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(orderItem.name.toString()),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Số lượng: ' + orders[index].orderDetails!.first.quantity.toString(),
                                          style: TextStyle(color: grey, fontSize: 12),
                                        ),
                                        // Text('Còn ' + DateTime.parse(orderItem.createAt!).add(Duration(minutes: 15)).difference(DateTime.now()).inMinutes.toString() + ' phút để thanh toán', style: TextStyle(color: grey, fontSize: 12),)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '₫' + FormatUtils.formatPrice(orderItem.price!.toDouble()).toString(),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                        Gap.k8.width,
                                        Text(
                                          '₫' + FormatUtils.formatPrice(orderItem.promotionalPrice!.toDouble()).toString(),
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
                          ),
                          orders[index].orderDetails!.length > 1
                              ? Column(
                                  children: [
                                    Divider(),
                                    Text(
                                      'Xem thêm sản phẩm',
                                      style: TextStyle(color: grey, fontSize: 12),
                                    )
                                  ],
                                ).onTap(() {
                                  Navigator.pushNamed(context, OrderDetailsScreen.routeName, arguments: {'orderDetails' : orders[index].orderDetails, 'amount' : orders[index].amount});
                                })
                              : SizedBox.shrink(),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                orders[index].orderDetails!.length.toString() + ' sản phẩm',
                                style: TextStyle(fontSize: 12, color: grey),
                              ),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(text: 'Tổng tiền: ', style: TextStyle(color: context.iconColor, fontSize: 14)),
                                TextSpan(text: '₫' + FormatUtils.formatPrice(orders[index].amount!.toDouble()).toString(), style: TextStyle(color: Colors.orange.shade700, fontSize: 14))
                              ])),
                            ],
                          ).paddingSymmetric(horizontal: 16),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Gap.k8.height,
                  itemCount: orders.length);
            } else {
              return Center(
                child: Text('Chưa có đơn hàng.'),
              );
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
