import 'package:appetit/cubits/campaign/campaigns_cubit.dart';
import 'package:appetit/cubits/campaign/campaigns_state.dart';
import 'package:appetit/cubits/profile/account_cubit.dart';
import 'package:appetit/cubits/profile/account_state.dart';
import 'package:appetit/screens/CreateCampaignScreen.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:appetit/widgets/CreateNew.dart';
import 'package:appetit/widgets/SkeletonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import '../cubits/product/products_cubit.dart';
import '../cubits/product/products_state.dart';
import 'CampaignScreen.dart';

// ignore: must_be_immutable
class CampaignsScreen extends StatefulWidget {
  static const String routeName = '/campaigns';
  const CampaignsScreen();

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  @override
  Widget build(BuildContext context) {
    final campaignsCubit = BlocProvider.of<CampaignsCubit>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.orange.shade600,
        onPressed: () {
          Navigator.pushNamed(context, CreateCampaignScreen.routeName);
        },
        child: Icon(
          Icons.add_outlined,
          color: white,
        ),
      ),
      appBar: MyAppBar(
        title: 'Chiến dịch',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: BlocProvider<AccountCubit>(
          create: (context) => AccountCubit(),
          child: BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
            if (state is AccountSuccessState) {
              campaignsCubit.getCampaignsList(storeOwnerId: state.account.id);
              return BlocBuilder<CampaignsCubit, CampaignsState>(builder: (context, state) {
                if (state is CampaignsLoadingState) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: (1 / 1.3), mainAxisSpacing: 16, crossAxisSpacing: 16),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    padding: EdgeInsets.only(left: 12, right: 16, top: 0, bottom: 16),
                    shrinkWrap: true,
                    itemBuilder: (context, indext) => SkeletonWidget(borderRadius: 20, height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),
                  );
                }
                if (state is CampaignsSuccessState) {
                  var campaigns = state.campaigns.campaign;
                  if (campaigns!.isNotEmpty) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: (1 / 1.3), mainAxisSpacing: 16, crossAxisSpacing: 16),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: campaigns.length,
                      padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        // productsCubit
                        //     .getProductsByCampaignId(widget.campaigns.campaign![index].id!);

                        return BlocProvider<ProductsCubit>(
                          create: (context) => ProductsCubit(campaignId: campaigns[index].id),
                          child: BlocBuilder<ProductsCubit, ProductsState>(builder: (context, state) {
                            if (state is ProductsLoadingState) {
                              return SkeletonWidget(borderRadius: 20, height: 0, width: 0);
                            }
                            if (state is ProductsSuccessState) {
                              var products = state.products.products;
                              // Map<String, dynamic> arguments = {
                              //   'products': products,
                              //   'campaign': campaigns[index],
                              // };
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FadeInImage.assetNetwork(
                                      image: campaigns[index].thumbnailUrl.toString(),
                                      placeholder: 'image/appetit/placeholder.png',
                                      height: MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // Positioned(
                                  //   top: 16,
                                  //   right: 16,
                                  //   child: Container(
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(8),
                                  //       color: Colors.black.withOpacity(0.4),
                                  //     ),
                                  //     child: IconButton(
                                  //       onPressed: () =>
                                  //           setState(() {
                                  //             widget.campaigns.campaign![index].isBookMark = !widget.campaigns.campaign![index].isBookMark;
                                  //           }),
                                  //       icon: !widget.campaigns.campaign![index].isBookMark
                                  //           ? Icon(Icons.bookmark_border_outlined, color: Colors.white.withOpacity(0.70), size: 30)
                                  //           : Icon(Icons.bookmark, color: Colors.orange.withOpacity(0.70), size: 30),
                                  //       // color: Colors.black.withOpacity(0.4),
                                  //       splashRadius: 25,
                                  //     ),
                                  //   ),
                                  // ),
                                  Positioned(
                                    bottom: 16,
                                    left: 16,
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black.withOpacity(0.4)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(products!.length.toString() + ' Sản phẩm', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300)),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              campaigns[index].name.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ).onTap(() => Navigator.pushNamed(
                                    context,
                                    CampaignScreen.routeName,
                                    arguments: campaigns[index],
                                  ));
                            }
                            return SizedBox.shrink();
                          }),
                        );
                      },
                    );
                  } else {
                    return CreateNew(routeName: CreateCampaignScreen.routeName, title: 'Cửa hàng chưa có chiến dịch', text: 'Tạo chiến dịch');
                  }
                }
                return SizedBox.shrink();
              });
            }
            return SizedBox.shrink();
          }),
        ),
      ),
    );
  }
}
