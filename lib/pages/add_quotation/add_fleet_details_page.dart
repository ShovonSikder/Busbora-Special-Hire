import 'dart:developer';

import 'package:appscwl_specialhire/customewidgets/confirm_button.dart';
import 'package:appscwl_specialhire/customewidgets/search/ss_dropdown_search_on_dialog.dart';
import 'package:appscwl_specialhire/models/quotation/fleet_model.dart';
import 'package:appscwl_specialhire/models/quotation/quotation_init_model.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_add_provider.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_init_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../customewidgets/dropdown_with_search_field.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/text_field_constants.dart';
import '../../utils/helper_function.dart';

class AddFleetDetailsPage extends StatefulWidget {
  static const String routeName = '/add_fleet_information';
  const AddFleetDetailsPage({Key? key}) : super(key: key);

  @override
  State<AddFleetDetailsPage> createState() => _AddFleetDetailsPageState();
}

class _AddFleetDetailsPageState extends State<AddFleetDetailsPage> {
  FleetType? fleetType;
  FleetMakers? makers;
  Coach? coach;
  Seats? seatTemp;
  late QuotationAddProvider quotationAddProvider;
  late QuotationInitProvider quotationInitProvider;
  List<FleetModel> tempSelectedFleets = [];
  @override
  void initState() {
    quotationAddProvider =
        Provider.of<QuotationAddProvider>(context, listen: false);
    quotationInitProvider =
        Provider.of<QuotationInitProvider>(context, listen: false);
    tempSelectedFleets = [...quotationAddProvider.quotationModel.listOfFleets];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 25),
        children: [
          //fleet type dropdown
          buildFleetTypeField(context),
          //fleet makers dropdown
          buildFleetMakerField(context),
          //seat temp
          buildSeatTempField(context),
          //coach no
          buildCoachField(context),

          buildAddButton(context),
          //fleet list added
          buildFleetListConsumer(),
        ],
      ),
      bottomNavigationBar: buildBottomContainer(),
    );
  }

  Row buildAddButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConfirmButton(
          btnText: AppLocalizations.of(context)!.add,
          callBack: () {
            _addFleet();
          },
        ),
      ],
    );
  }

  Padding buildSeatTempField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: SSDropdownSearchOnDialog<Seats>(
        selectedValue: seatTemp,
        dropdownValueList:
            quotationInitProvider.quotationInitModel!.seats ?? [],
        label: AppLocalizations.of(context)!.seat_temp,
        onSelection: <Seats>(value) {
          seatTemp = value;
        },
      ),
    );
  }

  Padding buildFleetMakerField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: SSDropdownSearchOnDialog<FleetMakers>(
        selectedValue: makers,
        dropdownValueList:
            quotationInitProvider.quotationInitModel!.fleetMakers ?? [],
        label: AppLocalizations.of(context)!.makers,
        onSelection: <FleetMakers>(value) {
          makers = value;
        },
      ),
    );
  }

  Padding buildFleetTypeField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: SSDropdownSearchOnDialog<FleetType>(
        selectedValue: fleetType,
        dropdownValueList:
            quotationInitProvider.quotationInitModel!.fleetType ?? [],
        label: AppLocalizations.of(context)!.fleet_type,
        onSelection: <FleetType>(value) {
          fleetType = value;
        },
      ),
    );
  }

  Container buildBottomContainer() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ConfirmButton(
              btnText: AppLocalizations.of(context)!.confirm,
              callBack: () {
                _confirmFleetList();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFleetListConsumer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tempSelectedFleets.isNotEmpty) buildTableHeader(context),
          for (var i = 0; i < tempSelectedFleets.length; i++)
            Container(
              decoration: tableStyleDeco,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(tempSelectedFleets[i].coach!.coachTitle!),
                          Text(tempSelectedFleets[i].fleetType!.ftTitle!),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(tempSelectedFleets[i].makers!.fmTitle!),
                    ),
                    Expanded(
                      child: Text(tempSelectedFleets[i].seatTemp!.stTitle!),
                    ),
                    IconButton(
                      onPressed: () {
                        tempSelectedFleets.removeAt(i);
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.highlight_remove,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Container buildTableHeader(BuildContext context) {
    return Container(
      decoration:
          tableStyleDeco.copyWith(color: Theme.of(context).primaryColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.fleet_type,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.fleet_makers,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.num_of_seat,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.action,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.add_fleet_details),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back,
        ),
      ),
    );
  }

  void _addFleet() {
    if (fleetType == null) {
      showMsgOnDialog(context,
          msg: AppLocalizations.of(context)!.fleet_type_require);
      return; //msg:select fleet type
    } else if (makers == null) {
      showMsgOnDialog(context,
          msg: AppLocalizations.of(context)!.makers_require);
      return; //msg:select makers
    } else if (seatTemp == null) {
      showMsgOnDialog(context, msg: AppLocalizations.of(context)!.seat_require);
      return; //msg:select seat temp
    } else if (coach == null) {
      showMsgOnDialog(context,
          msg: AppLocalizations.of(context)!.coach_required);
      return; //msg:select seat temp
    }
    tempSelectedFleets.add(FleetModel(
      fleetType: fleetType,
      makers: makers,
      seatTemp: seatTemp,
      coach: coach,
      rent: 0,
    ));
    _clearField();
    setState(() {});
  }

  void _clearField() {
    fleetType = null;
    makers = null;
    seatTemp = null;
    coach = null;
  }

  void _confirmFleetList() {
    quotationAddProvider.addFleetList(tempSelectedFleets);
  }

  Padding buildCoachField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: SSDropdownSearchOnDialog<Coach>(
        selectedValue: coach,
        dropdownValueList:
            quotationInitProvider.quotationInitModel!.coach ?? [],
        label: AppLocalizations.of(context)!.coach_no,
        onSelection: <Coach>(value) {
          coach = value;
        },
      ),
    );
  }
}
