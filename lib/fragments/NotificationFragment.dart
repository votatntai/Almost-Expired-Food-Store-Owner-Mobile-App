import 'package:appetit/cubits/notification/notification_cubit.dart';
import 'package:appetit/cubits/notification/notification_state.dart';
import 'package:appetit/domains/repositories/notification_repo.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screens/OrderDetailsScreen.dart';
import '../utils/gap.dart';

class NotificationFragment extends StatefulWidget {
  const NotificationFragment({Key? key}) : super(key: key);

  @override
  State<NotificationFragment> createState() => _NotificationFragmentState();
}

class _NotificationFragmentState extends State<NotificationFragment> {
  late NotificationCubit _notificationCubit;
  @override
  void initState() {
    _notificationCubit = BlocProvider.of<NotificationCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _notificationCubit.getNotifications();
    return Scaffold(
      backgroundColor: appLayout_background,
      body: RefreshIndicator(
        onRefresh: () async {
          _notificationCubit.getNotifications();
        },
        child: BlocBuilder<NotificationCubit, NotificationState>(builder: (context, state) {
          if (state is NotificationLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is NotificationSuccessState) {
            var notifications = state.notifications.notifications;
            if (notifications!.isNotEmpty) {
              return SingleChildScrollView(
                physics: ScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: notifications.length,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(color: notifications[index].isRead! ? appLayout_background : appetitAppContainerColor),
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                notifications[index].title == 'Đơn hàng mới'
                                    ? Image.asset(
                                        'image/appetit/order.png',
                                        width: 36,
                                      )
                                    : notifications[index].title == 'Tạo yêu cầu rút tiền thành công'
                                        ? Image.asset(
                                            'image/appetit/request.png',
                                            width: 36,
                                          )
                                        : notifications[index].title == 'Rút tiền thành công'
                                            ? Image.asset(
                                                'image/appetit/withdrawal.png',
                                                width: 36,
                                              )
                                            : Image.asset(
                                                'image/appetit/notification.png',
                                                width: 36,
                                              ),
                                Gap.k16.width,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(notifications[index].message!),
                                      SizedBox(height: 8),
                                      Text(
                                          DateTime.now().difference(DateTime.parse(notifications[index].createAt!)).inHours <= 24
                                              ? DateTime.now().difference(DateTime.parse(notifications[index].createAt!)).inHours.toString() + ' giờ trước'
                                              : DateTime.now().difference(DateTime.parse(notifications[index].createAt!)).inDays.toString() + ' ngày trước',
                                          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).onTap(() async {
                            await NotificationRepo().markAsRead(notificationId: notifications[index].id!);
                            setValue(AppConstant.NOTI_COUNT, notifications.length);
                            if (notifications[index].type == 'Order') {
                              Navigator.pushNamed(context, OrderDetailsScreen.routeName, arguments: notifications[index].id);
                            }
                            setState(() {
                              
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Text('Chưa có thông báo'),
              );
            }
          }
          return SizedBox.shrink();
        }),
      ),
    );
  }
}
