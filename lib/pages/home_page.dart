import 'package:appscwl_specialhire/customewidgets/app_drawer.dart';
import 'package:appscwl_specialhire/customewidgets/fab_button_hiddable.dart';
import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/pages/profile/profile_page.dart';
import 'package:appscwl_specialhire/pages/reservation/reservation_list_page.dart';
import 'package:appscwl_specialhire/pages/view_quotation/quotation_list_page.dart';
import 'package:appscwl_specialhire/providers/localization/local_provider.dart';
import 'package:appscwl_specialhire/utils/constants/color_constants.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/shared_preferences.dart';
import '../providers/fab_button_provider.dart';
import '../providers/user/user_provider.dart';
import '../utils/helper_function.dart';
import 'add_quotation/quotation_add_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = <Widget>[
    const ReservationListPage(),
    const QuotationListPage(),
    const ProfilePage(),
  ];
  late final List<String> _titles = <String>[
    AppLocalizations.of(context)!.special_hire,
    AppLocalizations.of(context)!.quotation_list,
    AppLocalizations.of(context)!.profile
  ];
  DateTime preBackPress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!ModalRoute.of(context)!.isFirst) return true;
        final timeGap = DateTime.now().difference(preBackPress);
        final cantExit = timeGap >= const Duration(seconds: 2);
        preBackPress = DateTime.now();
        if (cantExit) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              AppLocalizations.of(context)!.exit_app,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            backgroundColor: Colors.red.withOpacity(.9),
            duration: const Duration(seconds: 2),
          ));
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          backgroundColor: cardBackgroundColor,
          appBar: _selectedIndex == 2
              ? buildAppBar(context, _titles[_selectedIndex])
              : null,
          drawer: const AppDrawer(),
          bottomNavigationBar: buildConvexAppBar(context),
          floatingActionButton: _selectedIndex == 1
              ? FabButtonHidable()
              : const SizedBox.shrink()),
    );
  }

  ConvexAppBar buildConvexAppBar(BuildContext context) {
    return ConvexAppBar(
      color: Colors.white,
      backgroundColor: specialHireThemePrimary,
      top: -15,
      items: [
        TabItem(icon: Icons.home, title: AppLocalizations.of(context)!.home),
        TabItem(
            icon: Icons.my_library_books_rounded,
            title: AppLocalizations.of(context)!.quotation_1),
        TabItem(
            icon: Icons.person, title: AppLocalizations.of(context)!.profile),
      ],
      onTap: (int pageIndex) {
        _selectedIndex = pageIndex;
        Provider.of<FabButtonProvider>(context, listen: false).visibilityON();
        setState(() {});
      },
    );
  }

  AppBar buildAppBar(BuildContext context, String title) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 1),
      ),
      actions: [],
    );
  }
}
