import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/pages/add_quotation/add_contact_information_page.dart';
import 'package:appscwl_specialhire/pages/add_quotation/add_fleet_details_page.dart';
import 'package:appscwl_specialhire/pages/add_quotation/add_journey_information_page.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_add_provider.dart';
import 'package:appscwl_specialhire/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants/text_constants/text_style_constants.dart';

class QuotationAddCardHeader extends StatelessWidget {
  final String serial, title;
  const QuotationAddCardHeader(
      {Key? key, required this.serial, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 30,
          width: 30,
          margin: EdgeInsets.only(right: 10, left: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: specialHireThemePrimary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            serial,
            style: quotationCardTitle.copyWith(color: Colors.white),
          ),
        ),
        Expanded(
          child: Text(
            title,
            style: quotationCardTitle,
          ),
        ),
        Consumer<QuotationAddProvider>(
          builder: (context, provider, child) {
            dynamic model;
            final localization = AppLocalizations.of(context)!;
            if (serial == localization.num_1) {
              model = provider.quotationModel.contactInformationModel;
            } else if (serial == localization.num_2) {
              model = provider.quotationModel.journeyInformationModel;
            } else if (serial == localization.num_3) {
              model = provider.quotationModel.listOfFleets;
            }

            return TextButton(
              onPressed: () {
                if (serial == localization.num_1) {
                  //goto contact info page
                  Navigator.pushNamed(
                      context, AddContactInformationPage.routeName);
                } else if (serial == localization.num_2) {
                  //goto journey info page
                  Navigator.pushNamed(
                      context, AddJourneyInformationPage.routeName);
                } else if (serial == localization.num_3) {
                  //goto fleet details info page
                  Navigator.pushNamed(context, AddFleetDetailsPage.routeName);
                }
              },
              child: Text(showBtnText(model, context)), // or Edit
            );
          },
        )
      ],
    );
  }

  String showBtnText(var model, context) {
    String btnText = AppLocalizations.of(context)!.add;
    if (serial == AppLocalizations.of(context)!.num_3) {
      model.isEmpty
          ? btnText = AppLocalizations.of(context)!.add
          : btnText = AppLocalizations.of(context)!.edit;
    } else {
      model == null
          ? btnText = AppLocalizations.of(context)!.add
          : btnText = AppLocalizations.of(context)!.edit;
    }
    return btnText;
  }
}
