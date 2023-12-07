import 'package:appetit/screens/OrdersSoldScreen.dart';
import 'package:appetit/screens/OrdersWaitPickupScreen.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ManageOrdersScreen extends StatelessWidget {
  static const String routeName = '/manage-order';
  const ManageOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Quản lý đơn hàng',
      ),
      body: Column(children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, OrdersWaitPickupScreen.routeName);
          },
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Transform.scale(scale: 0.8, child: Image.asset('image/appetit/pickup.png')),
                      ),
                    ),
                    10.width,
                    Text(
                      'Đơn hàng chờ nhận',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                SizedBox(
                  width: 24,
                  child: Icon(
                    Icons.arrow_right_sharp,
                    color: Colors.orange.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, OrdersSoldScreen.routeName);
          },
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Transform.scale(scale: 0.8, child: Image.asset('image/appetit/bought.png')),
                      ),
                    ),
                    10.width,
                    Text(
                      'Đơn hàng đã bán',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                SizedBox(
                  width: 24,
                  child: Icon(
                    Icons.arrow_right_sharp,
                    color: Colors.orange.shade600,
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
