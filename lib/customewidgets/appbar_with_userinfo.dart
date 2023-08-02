import 'package:appscwl_specialhire/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';

import '../utils/helper_function.dart';

class AppBarWithUserInfo extends StatelessWidget {
  final Widget title;
  final Widget? username;
  final Widget? identity;
  const AppBarWithUserInfo(
      {Key? key, required this.title, this.username, this.identity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: specialHireThemePrimary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  alignment: AlignmentDirectional.center,
                  onPressed: () {
                    openDrawer(context);
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 25,
                  )),
              Expanded(
                flex: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                      child: title,
                    ),
                  ],
                ),
              ),
              if (username != null)
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: username!,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (identity != null)
            Container(
                alignment: Alignment.centerRight,
                padding:
                    EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 5),
                child: identity!),
        ],
      ),
    );
  }
}
