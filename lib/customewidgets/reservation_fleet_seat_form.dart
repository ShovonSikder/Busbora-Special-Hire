import 'package:appscwl_specialhire/customewidgets/dropdown_with_search_field.dart';
import 'package:appscwl_specialhire/models/reservation/passenger_info_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class ReservationFleetSeatForm extends StatefulWidget {
  final PassengerInfo passengerInfo;
  final List<TicketFairType>? ticketFaireType;
  TicketFairType? selectedType;
  String? name;
  String? number;
  ReservationFleetSeatForm(
      {Key? key, required this.passengerInfo, required this.ticketFaireType})
      : super(key: key);

  @override
  State<ReservationFleetSeatForm> createState() =>
      _ReservationFleetSeatFormState();
}

class _ReservationFleetSeatFormState extends State<ReservationFleetSeatForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  @override
  void didChangeDependencies() {
    _initForm();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildFormHeader(context),
            buildPassengerNameField(context),
            buildPassengerPhoneNumberField(context),
            buildTicketFairTypeDropdown(context),
          ],
        ),
      ),
    );
  }

  buildFormHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const Icon(Icons.airline_seat_recline_extra_sharp),
          Text(
            widget.passengerInfo.seatName ?? '--',
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPassengerNameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _nameController,
        textInputAction: TextInputAction.next,
        onChanged: (value) {
          widget.name = value;
          widget.passengerInfo.name = value;
          _formKey.currentState!.validate();
        },
        decoration:
            buildInputFormFieldDecoration(AppLocalizations.of(context)!.name),
        validator: (value) => fieldValidator(context, value, true),
      ),
    );
  }

  Padding buildPassengerPhoneNumberField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _phoneNumberController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.phone,
        onChanged: (value) {
          widget.number = value;
          widget.passengerInfo.number = value;
          // _formKey.currentState!.validate();
        },
        decoration:
            buildInputFormFieldDecoration(AppLocalizations.of(context)!.mobile),
        validator: (value) => null,
        // fieldValidator(context, value, false),
      ),
    );
  }

  Padding buildTicketFairTypeDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownWithSearchField<TicketFairType>(
          dropDownValueList: widget.ticketFaireType,
          label: AppLocalizations.of(context)!.type,
          mode: Mode.MENU,
          showSearch: false,
          callBack: (value) {
            widget.selectedType = value;
            widget.passengerInfo.tftID = value.tftID;
          },
          selectedValue: widget.selectedType),
    );
  }

  InputDecoration buildInputFormFieldDecoration(String label) {
    return InputDecoration(
      label: Text(label),
      border: const OutlineInputBorder(),
    );
  }

  void _initForm() {
    if (widget.passengerInfo.tftID != null &&
        widget.passengerInfo.tftID!.isNotEmpty) {
      widget.selectedType = widget.ticketFaireType != null
          ? widget.ticketFaireType!
              .firstWhere((type) => type.tftID == widget.passengerInfo.tftID)
          : null;
    }
    _nameController.text = widget.passengerInfo.name ?? '';
    _phoneNumberController.text = widget.passengerInfo.number ?? '';
  }

  fieldValidator(BuildContext context, String? value, bool callFromName) {
    if (_nameController.text.isEmpty &&
        _phoneNumberController.text.isNotEmpty) {
      return callFromName ? AppLocalizations.of(context)!.name_required : null;
    }
    if (_nameController.text.isNotEmpty &&
        _phoneNumberController.text.isEmpty) {
      return callFromName
          ? null
          : AppLocalizations.of(context)!.mobile_required;
    }
  }
}
