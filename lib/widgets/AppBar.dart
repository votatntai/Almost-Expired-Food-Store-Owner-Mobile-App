import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/Colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
    final String? title;
  final List<Widget>? actions;
  const MyAppBar({Key? key, this.title, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
         backgroundColor: appetitAppContainerColor,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: actions,
              title: title != null ? Text(
                title!,
                style: TextStyle(color: context.iconColor, fontSize: 20),
              ) : SizedBox.shrink(),
      );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}