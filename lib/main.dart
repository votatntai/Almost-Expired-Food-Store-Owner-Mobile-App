import 'package:appetit/screens/DashboardScreen.dart';
import 'package:appetit/store/AppStore.dart';
import 'package:appetit/utils/Constants.dart';
import 'package:appetit/utils/ADataProvider.dart';
import 'package:appetit/utils/AppTheme.dart';
import 'package:appetit/utils/bloc_provider.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:appetit/utils/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/SplashScreen.dart';

AppStore appStore = AppStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize(aLocaleLanguageList: languageList());
  await initialGetIt();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));
  defaultToastGravityGlobal = ToastGravity.BOTTOM;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: multiBlocProvider(),
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        onGenerateRoute: generateRoute,
        debugShowCheckedModeBanner: false,
        title: 'Appetit${!isMobile ? ' ${platformName()}' : ''}',
        home: _fetchAuthAndInitialRoute(),
        theme: !appStore.isDarkModeOn ? AppThemeData.lightTheme : AppThemeData.darkTheme,
        navigatorKey: navigatorKey,
        scrollBehavior: SBehavior(),
        supportedLocales: LanguageDataModel.languageLocales(),
        localeResolutionCallback: (locale, supportedLocales) => locale,
      ),
    );
  }
}

Widget _fetchAuthAndInitialRoute() {
  // final UserRepo _userRepo = getIt.get<UserRepo>();
  try {
    String accessToken = getStringAsync(TOKEN_KEY);
    if (accessToken.isNotEmpty) {
      return DashboardScreen();
    }
  } catch (e) {
   debugPrint("ex ${e.toString()}"); 
  }
    return SplashScreen();
}