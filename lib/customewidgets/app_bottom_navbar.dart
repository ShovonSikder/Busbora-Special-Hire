//Not used till now

import 'package:appscwl_specialhire/pages/reservation/reservation_list_page.dart';
import 'package:appscwl_specialhire/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../pages/view_quotation/quotation_list_page.dart';

class AppBottomNavbar extends StatelessWidget {
  final int pageCode;
  const AppBottomNavbar({Key? key, required this.pageCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //home
          buildNavButton(
            context,
            isActive: pageCode == 1,
            icon: Icons.home,
            text: AppLocalizations.of(context)!.home,
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, ReservationListPage.routeName);
            },
          ),
          //quotation
          buildNavButton(
            context,
            isActive: pageCode == 2,
            icon: Icons.format_quote,
            text: AppLocalizations.of(context)!.quotation,
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, QuotationListPage.routeName);
            },
          ),
          //profile
          buildNavButton(
            context,
            isActive: pageCode == 3,
            icon: Icons.person,
            text: AppLocalizations.of(context)!.profile,
            onPressed: () {
              Navigator.pushReplacementNamed(context, ProfilePage.routeName);
            },
          ),
        ],
      ),
    );
  }

  Widget buildNavButton(BuildContext context,
      {required icon, required text, required isActive, required onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: 100,
        height: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              icon,
              size: 40,
              color: isActive ? Theme.of(context).primaryColor : null,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: isActive ? Theme.of(context).primaryColor : null),
            ),
          ],
        ),
      ),
    );
  }
}
