import 'package:appetit/screens/LoginScreen.dart';
import 'package:flutter/material.dart';

PageRoute? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (_) => LoginScreen());
    default:
  }
  return null;
}
