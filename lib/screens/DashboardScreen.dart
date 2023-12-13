import 'package:appetit/cubits/branch/branchs_cubit.dart';
import 'package:appetit/cubits/campaign/campaigns_cubit.dart';
import 'package:appetit/cubits/notification/notification_cubit.dart';
import 'package:appetit/cubits/notification/notification_state.dart';
import 'package:appetit/cubits/profile/account_cubit.dart';
import 'package:appetit/cubits/store/stores_cubit.dart';
import 'package:appetit/fragments/HomeFragment.dart';
import 'package:appetit/fragments/NotificationFragment.dart';
import 'package:appetit/fragments/ProfileFragment.dart';
import 'package:appetit/utils/Constants.dart';
import 'package:appetit/utils/app_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedItem = 0;

  void onTapSelection(int index) {
    // if (index == 1)
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => MultiBlocProvider(
    //                 providers: [BlocProvider<AccountCubit>(create: (context) => AccountCubit()), BlocProvider(create: (context) => StoresCubit())],
    //                 child: CreateCampaignScreen(),
    //               )));
    // else
      setState(() => selectedItem = index);
  }

  List<Widget> widgetOption = <Widget>[
    HomeFragment(),
    NotificationFragment(),
    ProfileFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StoresCubit>(create: (context) => StoresCubit()),
        BlocProvider<AccountCubit>(create: (context) => AccountCubit()),
        BlocProvider<CreateCampaignCubit>(create: (context) => CreateCampaignCubit()),
        BlocProvider<BranchsCubit>(create: (context) => BranchsCubit()),
         BlocProvider<NotificationCubit>(create: (context) {
          final notificationCubit = NotificationCubit();
          notificationCubit.getNotifications();
          return notificationCubit;
        })
      ],
      child: Scaffold(
        body: widgetOption.elementAt(selectedItem),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 25,
          backgroundColor: Color(0xFF462F4C),
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedItem,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          onTap: onTapSelection,
          elevation: 0,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.orangeAccent,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: StreamBuilder<int>(
              stream: watchCountNotify(),
              builder: (context, snapshot) {
                int value = snapshot.data ?? 0;

                if (value > 0) {
                // return Badge.count(count: state.notifications.notifications!.where((noti) => noti.isRead == false).length, child: Icon(Icons.notifications_outlined));
                return Badge.count(count: getIntAsync(AppConstant.NOTI_COUNT), child: Icon(Icons.notifications_outlined));
                }
                return Icon(Icons.notifications_outlined);
              }
            ), label: 'Notification'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
