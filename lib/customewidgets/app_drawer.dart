import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/pages/side_menu/about_us_page.dart';
import 'package:appscwl_specialhire/pages/side_menu/contact_us_page.dart';
import 'package:appscwl_specialhire/pages/side_menu/terms_and_conditions_page.dart';
import 'package:appscwl_specialhire/pages/side_menu/vehicle_register_page.dart';
import 'package:appscwl_specialhire/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            buildHeaderContainer(context),
            Expanded(
              child: ListView(
                children: [
                  const Divider(
                    thickness: 0,
                    color: Colors.transparent,
                    // height: 0,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.popAndPushNamed(
                          context, VehicleRegisterPage.routeName);
                    },
                    minLeadingWidth: 1,
                    title: Text(
                      AppLocalizations.of(context)!.register_here,
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: buildTrailingIcon(),
                  ),
                  // Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.popAndPushNamed(
                          context, ContactUsPage.routeName);
                    },
                    title: Text(
                      AppLocalizations.of(context)!.contact_us,
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: buildTrailingIcon(),
                  ),
                  // Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.popAndPushNamed(context, AboutUsPage.routeName);
                    },
                    title: Text(
                      AppLocalizations.of(context)!.about_us,
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: buildTrailingIcon(),
                  ),
                  // Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.popAndPushNamed(
                          context, TermsAndConditionPage.routeName);
                    },
                    title: Text(
                      AppLocalizations.of(context)!.term_con,
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: buildTrailingIcon(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.company_domain,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildHeaderContainer(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: specialHireThemePrimary,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 2,
            right: 2,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_sharp,
                color: Colors.white,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/logo_SH.png',
              width: 210,
            ),
          ),
        ],
      ),
    );
  }

  Icon buildTrailingIcon() {
    return const Icon(
      Icons.arrow_forward_ios_sharp,
      size: 20,
    );
  }
}
