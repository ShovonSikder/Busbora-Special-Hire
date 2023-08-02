import 'dart:developer';

import 'package:appscwl_specialhire/customewidgets/confirm_button.dart';
import 'package:appscwl_specialhire/customewidgets/dropdown_with_search_field.dart';
import 'package:appscwl_specialhire/customewidgets/pick_and_show_date_time.dart';
import 'package:appscwl_specialhire/models/quotation/journey_information_model.dart';
import 'package:appscwl_specialhire/models/quotation/quotation_init_model.dart';
import 'package:appscwl_specialhire/providers/districts_provider.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_init_provider.dart';
import 'package:appscwl_specialhire/utils/constants/constants.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../customewidgets/search/dropdown_search_field.dart';
import '../../l10n/app_localizations.dart';
import '../../models/all_districts_model.dart';
import '../../providers/quotation/quotation_add_provider.dart';
import '../../utils/constants/text_field_constants.dart';

class AddJourneyInformationPage extends StatefulWidget {
  static const String routeName = '/add_journey_information';
  const AddJourneyInformationPage({Key? key}) : super(key: key);

  @override
  State<AddJourneyInformationPage> createState() =>
      _AddJourneyInformationPageState();
}

class _AddJourneyInformationPageState extends State<AddJourneyInformationPage> {
  final _formKey = GlobalKey<FormState>();

  final _pickUpAddressController = TextEditingController();
  final _droppingAddressController = TextEditingController();
  final _journeyDate = TextEditingController();
  final _returnDate = TextEditingController();
  final _journeyTime = TextEditingController();
  final _returnTime = TextEditingController();
  bool pickupFocusedBefore = false;
  bool droppingFocusedBefore = false;
  Districts? origin;
  Districts? destination;
  Type? type;

  DateTime jDate = DateTime.now();
  DateTime rDate = DateTime.now();
  TimeOfDay jTime = TimeOfDay.now();
  TimeOfDay rTime = TimeOfDay.now();

  late QuotationAddProvider quotationAddProvider;
  late QuotationInitProvider quotationInitProvider;
  late DistrictsProvider districtsProvider;
  @override
  void didChangeDependencies() {
    quotationInitProvider =
        Provider.of<QuotationInitProvider>(context, listen: false);
    quotationAddProvider =
        Provider.of<QuotationAddProvider>(context, listen: false);
    districtsProvider = Provider.of<DistrictsProvider>(context, listen: false);
    if (quotationAddProvider.quotationModel.journeyInformationModel != null) {
      _fillTextField();
      return;
    }
    _journeyDate.text =
        _returnDate.text = getFormattedDate(DateTime.now(), 'dd-MM-yyyy');

    _journeyTime.text = jTime.format(context);
    _returnTime.text = rTime.format(context);

    if (quotationInitProvider.quotationInitModel != null) {
      type = quotationInitProvider.quotationInitModel!.type![0];
    } else {
      Navigator.pop(context);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 25).copyWith(top: 8),
          children: [
            //origin
            buildOriginField(context),
            //pickup
            buildPickupField(context),
            //destination
            buildDestinationField(context),
            //dropping
            buildDroppingField(context),
            //type
            buildTypeField(context),
            //journey date
            buildJourneyDateField(context),
            //return date
            if (type!.id == 2) buildReturnDateField(context),
            //confirm button
            ConfirmButton(
              callBack: _insertJourneyInfo,
              btnText:
                  quotationAddProvider.quotationModel.journeyInformationModel !=
                          null
                      ? AppLocalizations.of(context)!.update
                      : AppLocalizations.of(context)!.confirm,
            ),
          ],
        ),
      ),
    );
  }

  Row buildReturnDateField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: textFieldPadding.copyWith(right: 0),
            child: PickAndShowDateTime(
              controller: _returnDate,
              suffixIcon: Icon(Icons.calendar_month),
              label: AppLocalizations.of(context)!.return_date,
              callBack: () {
                pickDate(true);
                // FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: textFieldPadding,
            child: PickAndShowDateTime(
              controller: _returnTime,
              suffixIcon: Icon(Icons.access_time),
              label: AppLocalizations.of(context)!.return_time,
              callBack: () {
                pickTime(true);
              },
            ),
          ),
        ),
      ],
    );
  }

  Row buildJourneyDateField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: textFieldPadding.copyWith(right: 0),
            child: PickAndShowDateTime(
              controller: _journeyDate,
              label: AppLocalizations.of(context)!.journey_date,
              suffixIcon: Icon(Icons.calendar_month),
              callBack: () {
                pickDate(false);
                // FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: textFieldPadding,
            child: PickAndShowDateTime(
                controller: _journeyTime,
                label: AppLocalizations.of(context)!.journey_time,
                suffixIcon: Icon(Icons.access_time),
                callBack: () {
                  pickTime(false);
                }),
          ),
        ),
      ],
    );
  }

  Padding buildDroppingField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _droppingAddressController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.dropping_address),
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          droppingFocusedBefore = true;
          _formKey.currentState!.validate();
        },
        validator: (value) {
          //requires validation
          if (droppingFocusedBefore && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.dropping_required;
          }
          return null;
        },
      ),
    );
  }

  Padding buildPickupField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: TextFormField(
        controller: _pickUpAddressController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          label: Text(AppLocalizations.of(context)!.pick_up_address),
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          pickupFocusedBefore = true;
          _formKey.currentState!.validate();
        },
        validator: (value) {
          //requires validation
          if (pickupFocusedBefore && (value == null || value.isEmpty)) {
            return AppLocalizations.of(context)!.pickup_required;
          }
          return null;
        },
      ),
    );
  }

  Padding buildTypeField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: DropdownWithSearchField<Type>(
        selectedValue: type,
        dropDownValueList: quotationInitProvider.quotationInitModel!.type,
        label: AppLocalizations.of(context)!.type,
        showSearch: false,
        mode: Mode.MENU,
        callBack: (value) {
          type = value;
          setState(() {});
        },
      ),
    );
  }

  Padding buildDestinationField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: DropdownSearchField<Districts>(
        selectedValue: destination,
        onSelection: <Districts>(value) {
          destination = value;
        },
        label: AppLocalizations.of(context)!.destination,
      ),
    );
  }

  Padding buildOriginField(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: DropdownSearchField<Districts>(
        selectedValue: origin,
        onSelection: <Districts>(value) {
          origin = value;
        },
        label: AppLocalizations.of(context)!.origin,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.add_journey_information),
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

  void _insertJourneyInfo() {
    pickupFocusedBefore = true;
    droppingFocusedBefore = true;
    if (_formKey.currentState!.validate()) {
      if (origin == null) {
        showMsgOnDialog(context,
            msg: AppLocalizations.of(context)!.origin_require);
        return;
      }
      if (destination == null) {
        showMsgOnDialog(context,
            msg: AppLocalizations.of(context)!.destination_require);
        return;
      }
      if (_journeyTime.text.isEmpty) {
        return;
      }
      if (_returnTime.text.isEmpty) {
        return;
      }
      final pickUp = _pickUpAddressController.text;
      final dropping = _droppingAddressController.text;

      final journeyInfoModel = JourneyInformationModel(
        destination: destination,
        origin: origin,
        type: type,
        dropping: dropping,
        journeyDate: jDate,
        journeyTimeString: _journeyTime.text,
        pickup: pickUp,
        returnDate: type!.id == 2 ? rDate : null,
        returnTimeString: _returnTime.text,
      );

      quotationAddProvider.insertJourneyInfo(journeyInfoModel);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _pickUpAddressController.dispose();
    _droppingAddressController.dispose();
    _journeyDate.dispose();
    _returnDate.dispose();
    _journeyTime.dispose();
    _returnTime.dispose();
    super.dispose();
  }

  void _fillTextField() {
    final journeyInfoModel =
        quotationAddProvider.quotationModel.journeyInformationModel;

    origin = journeyInfoModel!.origin;
    destination = journeyInfoModel.destination;
    type = journeyInfoModel.type;
    _pickUpAddressController.text = journeyInfoModel.pickup!;
    _droppingAddressController.text = journeyInfoModel.dropping!;
    jDate = journeyInfoModel.journeyDate!;
    _journeyDate.text =
        getFormattedDate(journeyInfoModel.journeyDate!, datePattern);
    rDate = journeyInfoModel.returnDate ?? jDate;
    _returnDate.text =
        getFormattedDate(journeyInfoModel.returnDate ?? jDate, datePattern);
    _journeyTime.text = journeyInfoModel.journeyTimeString ?? '';
    _returnTime.text = journeyInfoModel.returnTimeString ?? '';
    if (_journeyTime.text.isNotEmpty) {
      jTime = TimeOfDay(
        hour: int.parse(_journeyTime.text.split(':')[0]),
        minute: int.parse(_journeyTime.text.split(':')[1].split(' ')[0]),
      );
    }
    if (_returnTime.text.isNotEmpty) {
      rTime = TimeOfDay(
          hour: int.parse(_returnTime.text.split(':')[0]),
          minute: int.parse(_returnTime.text.split(':')[1].split(' ')[0]));
    }
  }

  pickDate(bool isPickingReturnDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isPickingReturnDate ? rDate : jDate,
      firstDate: jDate,
      lastDate: DateTime(99999),
    );
    if (pickedDate != null) {
      final dateAsString = getFormattedDate(pickedDate, 'dd-MM-yyyy');
      if (isPickingReturnDate) {
        _returnDate.text = dateAsString;
        rDate = DateTime.parse(pickedDate.toString());
      } else {
        _journeyDate.text = dateAsString;
        jDate = DateTime.parse(pickedDate.toString());

        if (rDate.compareTo(jDate) == -1) {
          rDate = DateTime.parse(jDate.toString());
          _returnDate.text = dateAsString;
        }
      }
      setState(() {});
      pickTime(isPickingReturnDate);
    }
  }

  pickTime(bool isPickingReturnTime) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: isPickingReturnTime ? rTime : jTime,
      builder: (ctx, w) {
        log(w.toString());
        return w!;
      },
    );
    if (pickedTime != null) {
      // final dateAsString = getFormattedDate(pickedDate, 'dd-MM-yyyy');
      if (isPickingReturnTime) {
        _returnTime.text = pickedTime.format(context);
        rTime = pickedTime;
      } else {
        _journeyTime.text = pickedTime.format(context);
        jTime = pickedTime;

        // if (rTime.(rTime) == -1) {
        //   rDate = DateTime.parse(jDate.toString());
        //   _returnDate.text = dateAsString;
        // }
      }
      setState(() {});
    }
  }
}
