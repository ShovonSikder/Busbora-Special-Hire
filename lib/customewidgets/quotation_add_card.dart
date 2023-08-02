import 'package:appscwl_specialhire/customewidgets/quotation_add_card_header.dart';
import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/models/quotation/contact_information_model.dart';
import 'package:appscwl_specialhire/models/quotation/journey_information_model.dart';
import 'package:appscwl_specialhire/pages/add_quotation/add_contact_information_page.dart';
import 'package:appscwl_specialhire/pages/add_quotation/add_journey_information_page.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_add_provider.dart';
import 'package:appscwl_specialhire/utils/constants/constants.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuotationAddCard extends StatelessWidget {
  final String serial, title;

  const QuotationAddCard({Key? key, required this.serial, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuotationAddCardHeader(
              serial: serial,
              title: title,
            ),

            //info to display
            Consumer<QuotationAddProvider>(
              builder: (context, provider, child) {
                if (serial == localization.num_1) {
                  //display contact details
                  if (provider.quotationModel.contactInformationModel != null) {
                    final model =
                        provider.quotationModel.contactInformationModel;
                    return buildContactInfoSection(model);
                  } else {
                    return buildMissingInfoButtonRow(localization, context);
                  }
                }

                //display journey details
                if (serial == localization.num_2) {
                  if (provider.quotationModel.journeyInformationModel != null) {
                    final model =
                        provider.quotationModel.journeyInformationModel;
                    return buildJourneyInfoSection(context, model);
                  } else {
                    return buildMissingInfoButtonRow(localization, context);
                  }
                }
                return const Text('');
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding buildJourneyInfoSection(context, JourneyInformationModel? model) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
              '${model!.origin!.distTitle!} - ${model.destination!.distTitle!}'),
          Text('${model.pickup}'),
          Text('${model.dropping}'),
          Text('${model.type!.title}'),
          Text(
              '${getFormattedDate(model.journeyDate!, datePattern)}  ${model.journeyTimeString}'),
          if (model.type!.id == 2)
            Text(
                '${getFormattedDate(model.returnDate!, datePattern)}  ${model.returnTimeString} (${AppLocalizations.of(context)!.r})'),
        ],
      ),
    );
  }

  Padding buildContactInfoSection(ContactInformationModel? model) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (model!.companyName != null && model.companyName!.isNotEmpty)
            Text(model.companyName!),
          if (model.name != null && model.name!.isNotEmpty) Text(model.name!),
          if (model.mobile != null && model.mobile!.isNotEmpty)
            Text(model.mobile!),
          if (model.email != null && model.email!.isNotEmpty)
            Text(model.email!),
          if (model.address != null && model.address!.isNotEmpty)
            Text(model.address!),
          if (model.remarks != null && model.remarks!.isNotEmpty)
            Text(model.remarks!),
        ],
      ),
    );
  }

  Row buildMissingInfoButtonRow(
      AppLocalizations localization, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            if (serial == localization.num_1) {
              Navigator.pushNamed(context, AddContactInformationPage.routeName);
            } else if (serial == localization.num_2) {
              //goto journey info page
              Navigator.pushNamed(context, AddJourneyInformationPage.routeName);
            }
          },
          child: Text(
            AppLocalizations.of(context)!.add_missing_information,
          ),
        ),
      ],
    );
  }
}
