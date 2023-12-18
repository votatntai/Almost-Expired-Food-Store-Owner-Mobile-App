
import 'package:appetit/screens/WalletScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/AccountComponent.dart';
import '../cubits/profile/account_cubit.dart';
import '../cubits/profile/account_state.dart';
import '../screens/UpdateProfileScreen.dart';
import '../services/auth_service.dart';
import '../utils/gap.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({Key? key}) : super(key: key);

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
      if (state is AccountLoadingState) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is AccountSuccessState) {
        var account = state.account;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: SizedBox.shrink(),
            elevation: 0,
            backgroundColor: transparentColor,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, UpdateProfileScreen.routeName, arguments: account);
                  },
                  icon: Icon(Icons.edit_outlined))
            ],
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              padding: EdgeInsets.all( 16),
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //1st content (Fixed height: 350)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 350,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25)),
                            child: Image.asset(
                                'image/appetit/backgroundprofile.jpg',
                                width: MediaQuery.of(context).size.width,
                                height: 220,
                                fit: BoxFit.cover),
                          ),
                        ),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 32.0, horizontal: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: FadeInImage.assetNetwork(
                                      placeholder:
                                          'image/appetit/avatar_placeholder.png',
                                      image: account.avatarUrl!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover),
                                ),
                                Gap.k8.height,
                                Text(account.name!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20)),
                                Text(account.email!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12)),
                                account.phone != null ? Text(account.phone!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12)) : SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap.kSection.height,
                  AccountComponent(icon: 'image/appetit/wallet.png', content: 'Ví').onTap(() {
                    Navigator.pushNamed(context, WalletScreen.routeName);
                  }),
                  Gap.kSection.height,
                  TextButton(
                      onPressed: () {
                        AuthService().signOut(context);
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            color: Colors.redAccent.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          ),
        );
      }
      return SizedBox.shrink();
    });
  }
}
