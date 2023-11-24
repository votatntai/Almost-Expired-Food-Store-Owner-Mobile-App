import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/gap.dart';

class CreateNew extends StatelessWidget {
  final String routeName;
  final String title;
  final String text;
  const CreateNew({Key? key, required this.routeName, required this.title, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title),
                  Gap.k16.height,
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, routeName);
                      },
                      style: ElevatedButton.styleFrom(primary: appStore.isDarkModeOn ? context.cardColor : Colors.orange.shade700),
                      child: Text(
                        text,
                        style: TextStyle(color: white),
                      ))
                ],
              ),
            );
  }
}