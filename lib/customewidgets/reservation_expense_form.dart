import 'package:appscwl_specialhire/customewidgets/dropdown_with_search_field.dart';
import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/models/reservation/expense/expense_init_model.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:flutter/material.dart';

import '../utils/helper_class.dart';

// ignore: must_be_immutable
class ReservationExpenseForm extends StatefulWidget {
  final ReservationFleets reservationFleets;
  final List<Staff>? staffs;
  final List<Fleets>? fleets;
  Fleets? _fleet;
  Staff? _driver;
  Staff? _helper;
  Staff? _guide;
  String? total;

  ReservationExpenseForm(
      {Key? key, required this.reservationFleets, this.fleets, this.staffs})
      : super(key: key);

  @override
  State<ReservationExpenseForm> createState() => _ReservationExpenseFormState();
}

class _ReservationExpenseFormState extends State<ReservationExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _driverAmountController = TextEditingController();
  final _helperAmountController = TextEditingController();
  final _guideAmountController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _remarksController = TextEditingController();

  @override
  void initState() {
    //TODO: test may require
    _initFields();
    super.initState();
  }

  @override
  void dispose() {
    _remarksController.dispose();
    _driverAmountController.dispose();
    _guideAmountController.dispose();
    _helperAmountController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildFormHeader(context),
            buildFleetDropdown(context),
            buildDriverDropdown(context),
            //driver amount
            buildDriverAmountField(context),
            buildHelperDropdown(context),
            //helper amount
            buildHelperAmountField(context),
            buildGuideDropdown(context),
            //guide amount
            buildGuideAmountField(context),
            //total
            buildTotalField(context),
            //remarks
            buildRemarksField(context),
          ],
        ),
      ),
    );
  }

  //textForm fields

  Padding buildRemarksField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _remarksController,
        // keyboardType: TextInputType.number,
        onChanged: (value) {
          widget.reservationFleets.remarks = value;
        },
        decoration: buildInputFormFieldDecoration(
            AppLocalizations.of(context)!.remarks),
      ),
    );
  }

  Padding buildTotalField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: false,
        controller: _totalAmountController,
        decoration:
            buildInputFormFieldDecoration(AppLocalizations.of(context)!.total),
      ),
    );
  }

  //amount input
  Padding buildGuideAmountField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _guideAmountController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: [CurrencyInputFormatter()],
        onChanged: (value) {
          widget.reservationFleets.guideAmount =
              parseStringToDouble(value.replaceAll(',', ''));
          _calculateTotal();
          _formKey.currentState!.validate();
        },
        decoration: buildInputFormFieldDecoration(
            AppLocalizations.of(context)!.guide_amount),
        validator: (value) =>
            amountValidator(context, value?.replaceAll(',', '')),
      ),
    );
  }

  Padding buildHelperAmountField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _helperAmountController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: [CurrencyInputFormatter()],
        onChanged: (value) {
          widget.reservationFleets.helperAmount =
              parseStringToDouble(value.replaceAll(',', ''));
          _calculateTotal();
          _formKey.currentState!.validate();
        },
        decoration: buildInputFormFieldDecoration(
            AppLocalizations.of(context)!.helper_amount),
        validator: (value) =>
            amountValidator(context, value?.replaceAll(',', '')),
      ),
    );
  }

  Padding buildDriverAmountField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _driverAmountController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: [CurrencyInputFormatter()],
        onChanged: (value) {
          widget.reservationFleets.driverAmount =
              parseStringToDouble(value.replaceAll(',', ''));
          _calculateTotal();
          _formKey.currentState!.validate();
        },
        decoration: buildInputFormFieldDecoration(
            AppLocalizations.of(context)!.driver_amount),
        validator: (value) =>
            amountValidator(context, value?.replaceAll(',', '')),
      ),
    );
  }

  //dropdowns
  Padding buildFleetDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownWithSearchField<Fleets>(
          dropDownValueList: widget.fleets,
          label: AppLocalizations.of(context)!.fleet,
          callBack: (value) {
            if (widget._fleet != null) widget._fleet!.isAvailable = true;
            widget._fleet = value;
            widget._fleet!.isAvailable = false;
            if (widget._fleet != null) {
              widget.reservationFleets.fleet = widget._fleet!.fID;
            }
          },
          selectedValue: widget._fleet),
    );
  }

  Padding buildDriverDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownWithSearchField<Staff>(
          dropDownValueList: widget.staffs!
              .where((staff) => staff.sType == Staff.typeDriver)
              .toList(),
          label: AppLocalizations.of(context)!.driver,
          callBack: (value) {
            if (widget._driver != null) widget._driver!.isAvailable = true;
            widget._driver = value;
            widget._driver!.isAvailable = false;
            if (widget._driver != null) {
              widget.reservationFleets.driver = widget._driver!.sID;
            }
          },
          selectedValue: widget._driver),
    );
  }

  Padding buildHelperDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownWithSearchField<Staff>(
          dropDownValueList: widget.staffs!
              .where((staff) => staff.sType == Staff.typeHelper)
              .toList(),
          label: AppLocalizations.of(context)!.helper,
          callBack: (value) {
            if (widget._helper != null) widget._helper!.isAvailable = true;
            widget._helper = value;
            widget._helper!.isAvailable = false;
            if (widget._helper != null) {
              widget.reservationFleets.helper = widget._helper!.sID;
            }
          },
          selectedValue: widget._helper),
    );
  }

  Padding buildGuideDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownWithSearchField<Staff>(
          dropDownValueList: widget.staffs!
              .where((staff) => staff.sType == Staff.typeGuide)
              .toList(),
          label: AppLocalizations.of(context)!.guide,
          callBack: (value) {
            if (widget._guide != null) widget._guide!.isAvailable = true;
            widget._guide = value;
            widget._guide!.isAvailable = false;
            if (widget._guide != null) {
              widget.reservationFleets.guide = widget._guide!.sID;
            }
          },
          selectedValue: widget._guide),
    );
  }

  InputDecoration buildInputFormFieldDecoration(String label) {
    return InputDecoration(
      label: Text(label),
      border: OutlineInputBorder(),
      // contentPadding:
      //     const EdgeInsets.only(top: 15, bottom: 15, right: 10, left: 12),
      floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
    );
  }

  buildFormHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(
            '${AppLocalizations.of(context)!.fleet}: ${widget.reservationFleets.fleet ?? '--'}',
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String? amountValidator(BuildContext context, String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      final paying = double.parse(value);
      if (paying == 0.0) return AppLocalizations.of(context)!.no_need_to_pay;
      if (paying < 0.0) {
        return AppLocalizations.of(context)!.amount_cant_negative;
      }
    } catch (err) {
      return AppLocalizations.of(context)!.enter_valid_digit;
    }
    return null;
  }

  void _calculateTotal() {
    _totalAmountController.text = widget.total = addPunctuationInMoney(
        ((widget.reservationFleets.driverAmount ?? 0) +
                (widget.reservationFleets.helperAmount ?? 0) +
                (widget.reservationFleets.guideAmount ?? 0))
            .toStringAsFixed(2));
  }

  parseStringToDouble(String s) {
    try {
      double amount = double.parse(s);
      return amount > 0 ? amount : 0;
    } catch (err) {
      return 0.00;
    }
  }

  void _initFields() {
    if (widget.reservationFleets.fleet != null &&
        widget.reservationFleets.fleet!.isNotEmpty &&
        widget.reservationFleets.fleet != '0') {
      widget._fleet = widget.fleets != null
          ? widget.fleets!.firstWhere(
              (fleet) => fleet.fID == widget.reservationFleets.fleet)
          : null;
    }

    if (widget.reservationFleets.driver != null &&
        widget.reservationFleets.driver!.isNotEmpty &&
        widget.reservationFleets.driver != '0') {
      widget._driver = widget.staffs != null
          ? widget.staffs!.firstWhere(
              (staff) => staff.sID == widget.reservationFleets.driver)
          : null;
    }

    if (widget.reservationFleets.helper != null &&
        widget.reservationFleets.helper!.isNotEmpty &&
        widget.reservationFleets.helper != '0') {
      widget._helper = widget.staffs != null
          ? widget.staffs!.firstWhere(
              (staff) => staff.sID == widget.reservationFleets.helper)
          : null;
    }
    if (widget.reservationFleets.guide != null &&
        widget.reservationFleets.guide!.isNotEmpty &&
        widget.reservationFleets.guide != '0') {
      widget._guide = widget.staffs != null
          ? widget.staffs!.firstWhere(
              (staff) => staff.sID == widget.reservationFleets.guide)
          : null;
    }

    //init text fields
    _driverAmountController.text = widget.reservationFleets.driverAmount! > 0
        ? addPunctuationInMoney(
            widget.reservationFleets.driverAmount!.toStringAsFixed(2))
        : '';
    _helperAmountController.text = widget.reservationFleets.helperAmount! > 0
        ? addPunctuationInMoney(
            widget.reservationFleets.helperAmount!.toStringAsFixed(2))
        : '';
    _guideAmountController.text = widget.reservationFleets.guideAmount! > 0
        ? addPunctuationInMoney(
            widget.reservationFleets.guideAmount!.toStringAsFixed(2))
        : '';
    _remarksController.text = widget.reservationFleets.remarks ?? '';
    _calculateTotal();
  }
}
