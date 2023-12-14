import 'package:appetit/cubits/branch/branchs_cubit.dart';
import 'package:appetit/cubits/branch/branchs_state.dart';
import 'package:appetit/screens/CreateBranchScreen.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/utils/gap.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:appetit/widgets/SkeletonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'UpdateBranchScreen.dart';

class BranchsScreen extends StatelessWidget {
  static const String routeName = '/branchs';
  const BranchsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final branchsCubit = BlocProvider.of<BranchsCubit>(context);
    branchsCubit.getBranchsOfOwner();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.orange.shade600,
        onPressed: () {
        Navigator.pushNamed(context, CreateBranchScreen.routeName);
      }, child: Icon(Icons.add_outlined, color: white,),),
      backgroundColor: appLayout_background,
      appBar: MyAppBar(
        title: 'Chi nhánh',
      ),
      body: BlocBuilder<BranchsCubit, BranchsState>(
        builder: (context, state) {
          if (state is BranchsLoadingState) {
            return Column(
              children: [SkeletonWidget(borderRadius: 12, height: 60, width: context.width())],
            ).paddingAll(16);
          }
          if (state is BranchsSuccessState) {
            if (state.branchs.branchs!.isNotEmpty) {
              var branchs = state.branchs.branchs;
              return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: context.width() * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text(branchs![index].address!, maxLines: 1, overflow: TextOverflow.ellipsis,), Gap.k4.height, Text('Số điện thoại: ' + branchs[index].phone!, style: TextStyle(color: grey),)],
                            ),
                          ),
                          Icon(
                            Icons.edit,
                            color: iconColorSecondary,
                          ).onTap((){
                              Navigator.pushNamed(context, UpdateBranchScreen.routeName, arguments: branchs[index]);
                          })
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Gap.k8.height,
                  itemCount: branchs!.length);
            } else {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Cửa hàng hiện chưa có chi nhánh'),
                    Gap.k16.height,
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, CreateBranchScreen.routeName);
                        },
                        style: ElevatedButton.styleFrom(primary: appStore.isDarkModeOn ? context.cardColor : Colors.orange.shade700),
                        child: Text(
                          'Tạo chi nhánh',
                          style: TextStyle(color: white),
                        ))
                  ],
                ),
              );
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
