import 'package:appetit/cubits/campaign/campaigns_cubit.dart';
import 'package:appetit/fragments/HomeFragment.dart';
import 'package:appetit/fragments/ANotificationFragment.dart';
import 'package:appetit/fragments/AProfileFragment.dart';
import 'package:appetit/fragments/ASearchFragment.dart';
import 'package:appetit/screens/CreateCampaignScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedItem = 0;

  void onTapSelection(int index) {
    if (index == 2)
      Navigator.push(context, MaterialPageRoute(builder: (context) => BlocProvider<CreateCampaignCubit>(create: (context) => CreateCampaignCubit(), child: CreateCampaignScreen())));
    else
      setState(() => selectedItem = index);
  }

  List<Widget> widgetOption = <Widget>[
    HomeFragment(),
    ASearchFragment(),
    SizedBox(),
    ANotificationFragment(),
    AProfileFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline_outlined), label: 'Reels'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined), label: 'Profile'),
        ],
      ),
    );
  }
}
