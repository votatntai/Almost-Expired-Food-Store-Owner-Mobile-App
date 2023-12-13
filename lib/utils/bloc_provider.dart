
import 'package:appetit/cubits/campaign/campaigns_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


List<BlocProvider> multiBlocProvider(){
  return [
    BlocProvider(create: (context) => CreateCampaignCubit()),
   
  ];
}