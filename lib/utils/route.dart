import 'package:appetit/cubits/branch/branchs_cubit.dart';
import 'package:appetit/cubits/campaign/campaigns_cubit.dart';
import 'package:appetit/cubits/product/products_cubit.dart';
import 'package:appetit/cubits/store/stores_cubit.dart';
import 'package:appetit/domains/models/branchs.dart';
import 'package:appetit/domains/models/campaign/campaigns.dart';
import 'package:appetit/domains/repositories/stores_repo.dart';
import 'package:appetit/screens/BranchsScreen.dart';
import 'package:appetit/screens/CampaignScreen.dart';
import 'package:appetit/screens/CreateBranchScreen.dart';
import 'package:appetit/screens/CreateCampaignScreen.dart';
import 'package:appetit/screens/CreateProductScreen.dart';
import 'package:appetit/screens/CreateStoreScreen.dart';
import 'package:appetit/screens/DashboardScreen.dart';
import 'package:appetit/screens/ManageOrdersScreen.dart';
import 'package:appetit/screens/OrdersSoldScreen.dart';
import 'package:appetit/screens/OrderDetailsScreen.dart';
import 'package:appetit/screens/OrdersWaitPaymentScreen.dart';
import 'package:appetit/screens/ProductsScreen.dart';
import 'package:appetit/screens/UpdateBranchScreen.dart';
import 'package:appetit/screens/UpdateCampaignScreen.dart';
import 'package:appetit/screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/order/orders_cubit.dart';
import '../cubits/profile/account_cubit.dart';
import '../domains/models/account.dart';
import '../domains/models/orders.dart';
import '../screens/CampaignsScreen.dart';
import '../screens/OrdersCanceledScreen.dart';
import '../screens/OrdersWaitPickupScreen.dart';
import '../screens/UpdateProfileScreen.dart';

PageRoute? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case WelcomeScreen.routeName:
      return MaterialPageRoute(builder: (_) => WelcomeScreen());
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
          builder: (_) => BlocProvider<DeleteCampaignCubit>(
                create: (context) => DeleteCampaignCubit(),
                child: CampaignScreen(
                  campaign: settings.arguments as Campaign,
                ),
              ));
    case CampaignsScreen.routeName:
      return MaterialPageRoute(builder: (_) => BlocProvider<CampaignsCubit>(create: (context) => CampaignsCubit(), child: CampaignsScreen()));
    case ProductsScreen.routeName:
      return MaterialPageRoute(builder: (_) => BlocProvider<ProductsCubit>(create: (context) => ProductsCubit(storeId: StoresRepo.storeId), child: ProductsScreen()));
    case CreateProductScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(providers: [
                BlocProvider<CampaignsCubit>(create: (context) => CampaignsCubit()),
                BlocProvider<StoresCubit>(create: (context) => StoresCubit()),
                BlocProvider<CreateProductCubit>(create: (context) => CreateProductCubit())
              ], child: CreateProductScreen()));
    case OrdersSoldScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
                create: (context) => OrdersCubit(),
                child: OrdersSoldScreen(),
              ));
    case OrdersWaitPickupScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
                create: (context) => OrdersCubit(),
                child: OrdersWaitPickupScreen(),
              ));
    case OrdersWaitPaymentScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
                create: (context) => OrdersCubit(),
                child: OrdersWaitPaymentScreen(),
              ));
    case OrdersCanceledScreen.routeName:
      return MaterialPageRoute(builder: (_) => BlocProvider<OrdersCubit>(create: (context) => OrdersCubit(), child: OrdersCanceledScreen()));
    case OrderDetailsScreen.routeName:
      Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
      final orderDetails = arguments['orderDetails'] as List<OrderDetails>;
      final amount = arguments['amount'] as int;
      return MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(
                orderDetails: orderDetails,
                amout: amount,
              ));
    case ManageOrdersScreen.routeName:
      return MaterialPageRoute(builder: (_) => ManageOrdersScreen());
    case UpdateCampaignScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => BlocProvider<UpdateCampaignCubit>(
              create: (context) => UpdateCampaignCubit(),
              child: UpdateCampaignScreen(
                campaign: settings.arguments as Campaign,
              )));
    case UpdateProfileScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => BlocProvider<UpdateProfileCubit>(
              create: (context) => UpdateProfileCubit(),
              child: UpdateProfileScreen(
                profile: settings.arguments as Account,
              )));
    case UpdateBranchScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => BlocProvider<UpdateBranchCubit>(
                create: (context) => UpdateBranchCubit(),
                child: UpdateBranchScreen(
                  branch: settings.arguments as Branch,
                ),
              ));
    default:
  }
  return null;
}
