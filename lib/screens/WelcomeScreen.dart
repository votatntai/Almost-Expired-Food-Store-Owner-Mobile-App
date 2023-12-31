import 'package:appetit/domains/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:appetit/main.dart';
import '../cubits/login/login_cubit.dart';
import '../cubits/login/login_state.dart';
import '../utils/messages.dart';
import 'DashboardScreen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = '/welcome';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void dispose() {
    super.dispose();
    setStatusBarColor(Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginByGoogleCubit>(
      create: (context) => LoginByGoogleCubit(),
      child: BlocConsumer<LoginByGoogleCubit, LoginByGoogleState>(listener: (context, state) {
        if (state is LoginByGooglelSuccessState) {
          UserRepo().sendDeviceToken();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
          return;
        } else if (state is LoginByGooglelFailedState) {
          showModalBottomSheet(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text(msg_login_by_google_failed_title),
                    content: Text(state.message.replaceAll('Exception: ', '')),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'),
                      ),
                    ],
                  ));
        }
      }, builder: (context, state) {
        final cubit = BlocProvider.of<LoginByGoogleCubit>(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Align(
              alignment: Alignment.center,
              child: Text('Store Owner', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, color: context.iconColor)),
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Image with content
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('image/appetit/createaccount.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.40), BlendMode.darken),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Đăng nhập', style: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.w600)),
                      16.height,
                      Text('Đăng nhập bằng Google sẽ tạo tài khoản mới nếu bạn chưa có và bạn có thể bắt đầu sử dụng dịch vụ', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                //Register using email
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 16.0),
                //   height: 60,
                //   width: MediaQuery.of(context).size.width,
                //   child: ElevatedButton(
                //     onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ARegisterScreen())),
                //     style: ElevatedButton.styleFrom(primary: Color(0xFFF2894F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(Icons.email_outlined),
                //         SizedBox(width: 8),
                //         Text('Register using email', style: TextStyle(fontSize: 18)),
                //       ],
                //     ),
                //   ),
                // ),
                //Two button
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              cubit.loginByGoole();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Image.asset('image/appetit/google.png', width: 70, height: 70),
                          ),
                        ),
                      ),
                      // SizedBox(width: 16),
                      // Expanded(
                      //   child: Container(
                      //     height: 60,
                      //     child: ElevatedButton(
                      //       onPressed: () {},
                      //       style: ElevatedButton.styleFrom(
                      //           primary: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                      //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      //       child: Image.asset('image/appetit/Apple.png', width: 60, height: 60),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(bottom: 16.0),
                //   child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Text('Have an account ? ', style: TextStyle(fontWeight: FontWeight.w300)),
                //       InkWell(
                //         onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
                //         child: Text('Login', style: TextStyle(fontWeight: FontWeight.w700)),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ).paddingTop(40),
          ),
        );
      }),
    );
  }
}
