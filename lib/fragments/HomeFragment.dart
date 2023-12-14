import 'package:appetit/cubits/profile/account_cubit.dart';
import 'package:appetit/cubits/profile/account_state.dart';
import 'package:appetit/cubits/store/stores_cubit.dart';
import 'package:appetit/cubits/store/stores_state.dart';
import 'package:appetit/domains/repositories/stores_repo.dart';
import 'package:appetit/screens/BranchsScreen.dart';
import 'package:appetit/screens/CampaignsScreen.dart';
import 'package:appetit/screens/CreateStoreScreen.dart';
import 'package:appetit/screens/ManageOrdersScreen.dart';
import 'package:appetit/screens/ProductsScreen.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/main.dart';
import 'package:appetit/utils/gap.dart';
import 'package:appetit/widgets/SkeletonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';


class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  var bookmarkSelection = true;

  @override
  Widget build(BuildContext context) {
    final storesCubit = BlocProvider.of<StoresCubit>(context);
    storesCubit.getStoresByOwner();
    return Scaffold(
      backgroundColor: appLayout_background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
              if (state is AccountSuccessState) {
                return Image.network(state.account.avatarUrl!, height: 30, width: 30, fit: BoxFit.cover);
              }
              return Image.asset('image/appetit/avatar_placeholder.png', height: 30, width: 30, fit: BoxFit.cover);
            }),
          ),
        ),
      ),
      body: BlocBuilder<StoresCubit, StoresState>(builder: (context, state) {
        if (state is StoresLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is StoresSuccessState) {
          if (state.stores.stores!.isNotEmpty) {
            StoresRepo.storeId = state.stores.stores!.first.id.toString();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('Xin chào,', style: TextStyle(color: appStore.isDarkModeOn ? Colors.grey : Colors.black.withOpacity(0.4))),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
                        if (state is AccountLoadingState) {
                          return SkeletonWidget(borderRadius: 10, height: 20, width: 100);
                        }
                        if (state is AccountSuccessState) {
                          return Text(state.account.name!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500));
                        }
                        return SizedBox.shrink();
                      }),
                    ),
                  ],
                ),
                SizedBox(
                  height: context.height() / 1.6,
                  child: GridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 0), // Adjust the offset to change the shadow direction
                              blurRadius: 3.0, // Set the blur radius
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('image/appetit/campaign.png', color: Colors.orange.shade700),
                            Gap.k8.height,
                            Text(
                              'Chiến dịch',
                              style: TextStyle(color: appTextColorSecondary),
                            )
                          ],
                        ),
                      ).onTap((){
                        Navigator.pushNamed(context, CampaignsScreen.routeName);
                      }),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 0), // Adjust the offset to change the shadow direction
                              blurRadius: 3.0, // Set the blur radius
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('image/appetit/products.png', color: Colors.orange.shade400, width: 60, height: 60,),
                            Gap.k8.height,
                            Text(
                              'Sản phẩm',
                              style: TextStyle(color: appTextColorSecondary),
                            )
                          ],
                        ),
                      ).onTap((){
                        Navigator.pushNamed(context, ProductsScreen.routeName, arguments: state.stores.stores!.first.id);
                      }),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 0), // Adjust the offset to change the shadow direction
                              blurRadius: 3.0, // Set the blur radius
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('image/appetit/branches.png', color: Colors.orange.shade600),
                            Gap.k8.height,
                            Text(
                              'Chi nhánh',
                              style: TextStyle(color: appTextColorSecondary),
                            )
                          ],
                        ),
                      ).onTap((){
                        Navigator.pushNamed(context, BranchsScreen.routeName);
                      }),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 0), // Adjust the offset to change the shadow direction
                              blurRadius: 3.0, // Set the blur radius
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('image/appetit/sold.png', color: Colors.orange.shade500, height: 60,),
                            Gap.k8.height,
                            Text(
                              'Đơn hàng',
                              style: TextStyle(color: appTextColorSecondary),
                            )
                          ],
                        ),
                      ).onTap((){
                        Navigator.pushNamed(context, ManageOrdersScreen.routeName);
                      }),
                    ],
                  ),
                )
              ],
            );
          } else {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Tài khoản hiện chưa có cửa hàng'),
                  Gap.k16.height,
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, CreateStoreScreen.routeName);
                      },
                      style: ElevatedButton.styleFrom(primary: appStore.isDarkModeOn ? context.cardColor : Colors.orange.shade700),
                      child: Text(
                        'Tạo cửa hàng',
                        style: TextStyle(color: white),
                      ))
                ],
              ),
            );
          }
        }
        return SizedBox.shrink();
      }),
    );
  }
}
