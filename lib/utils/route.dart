import 'package:appetit/cubits/branch/branchs_cubit.dart';
import 'package:appetit/cubits/campaign/campaigns_cubit.dart';
import 'package:appetit/cubits/product/products_cubit.dart';
import 'package:appetit/cubits/store/stores_cubit.dart';
import 'package:appetit/domains/models/campaign/campaigns.dart';
import 'package:appetit/screens/BranchsScreen.dart';
import 'package:appetit/screens/CampaignScreen.dart';
import 'package:appetit/screens/CreateBranchScreen.dart';
import 'package:appetit/screens/CreateCampaignScreen.dart';
import 'package:appetit/screens/CreateProductScreen.dart';
import 'package:appetit/screens/CreateStoreScreen.dart';
import 'package:appetit/screens/DashboardScreen.dart';
import 'package:appetit/screens/HistoryScreen.dart';
import 'package:appetit/screens/LoginScreen.dart';
import 'package:appetit/screens/OrderDetailsScreen.dart';
import 'package:appetit/screens/ProductsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/order/orders_cubit.dart';
import '../screens/CampaignsScreen.dart';

PageRoute? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (_) => LoginScreen());
    case CreateStoreScreen.routeName:
      return MaterialPageRoute(builder: (_) => BlocProvider<CreateStoreCubit>(create: (context) => CreateStoreCubit(), child: CreateStoreScreen()));
    case DashboardScreen.routeName:
      return MaterialPageRoute(builder: (_) => DashboardScreen());
    case BranchsScreen.routeName:
      return MaterialPageRoute(builder: (_) => BlocProvider<BranchsCubit>(create: (context) => BranchsCubit(), child: BranchsScreen()));
    case CreateBranchScreen.routeName:
      return MaterialPageRoute(builder: (_) => BlocProvider<CreateBranchCubit>(create: (context) => CreateBranchCubit(), child: CreateBranchScreen()));
    case CreateCampaignScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(providers: [
                BlocProvider<CreateCampaignCubit>(create: (context) => CreateCampaignCubit()),
                BlocProvider<BranchsCubit>(
                  create: (context) => BranchsCubit(),
                )
              ], child: CreateCampaignScreen()));
    case CampaignScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => CampaignScreen(
                campaign: settings.arguments as Campaign,
              ));
    case CampaignsScreen.routeName:
      return MaterialPageRoute(builder: (_) => BlocProvider<CampaignsCubit>(create: (context) => CampaignsCubit(), child: CampaignsScreen()));
    case ProductsScreen.routeName:
      return MaterialPageRoute(builder: (_) => BlocProvider<ProductsCubit>(create: (context) => ProductsCubit(storeId: settings.arguments as String), child: ProductsScreen()));
    case CreateProductScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(providers: [
                BlocProvider<CampaignsCubit>(create: (context) => CampaignsCubit()),
                BlocProvider<StoresCubit>(create: (context) => StoresCubit()),
                BlocProvider<CreateProductCubit>(create: (context) => CreateProductCubit())
              ], child: CreateProductScreen()));
    case HistoryScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
                create: (context) => OrdersCubit(),
                child: HistoryScreen(),
              ));
    case OrderDetailsScreen.routeName:
    return MaterialPageRoute(builder: (_) => OrderDetailsScreen());
    default:
  }
  return null;
}
