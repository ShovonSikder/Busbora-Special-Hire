import 'dart:developer';

import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/models/quotation/quotation_details_model.dart';
import 'package:appscwl_specialhire/models/user/user_model.dart';
import 'package:appscwl_specialhire/providers/resrvation/reservation_provider.dart';
import 'package:appscwl_specialhire/providers/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../db/shared_preferences.dart';
import '../../models/quotation/quotation_brief_model.dart';
import '../../models/reservation/reservation_details_model.dart';
import '../../utils/bluetooth_printer.dart';
import '../../utils/constants/api_constants/http_code.dart';
import '../../utils/constants/text_field_constants.dart';
import '../../utils/helper_class.dart';
import '../../utils/helper_function.dart';

class TransitionForm extends StatefulWidget {
  final String reservationReId;
  final double returnLimit;
  final double subTotal;
  final double receiveLimit;
  final String reservationId;
  final ReservationQuotation printInfo;
  // final String name;
  const TransitionForm({
    Key? key,
    required this.reservationReId,
    required this.returnLimit,
    required this.subTotal,
    required this.receiveLimit,
    required this.reservationId,
    required this.printInfo,
    // required this.name,
  }) : super(key: key);

  @override
  State<TransitionForm> createState() => _TransitionFormState();
}

class _TransitionFormState extends State<TransitionForm> {
  int transitionType = 1;

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  static const platform = MethodChannel('com.busbora.specialhire/printer');

  late QuotationDetails reservationDetailsModel;
  late UserModel userInfo;
  @override
  void initState() {
    userInfo = Provider.of<UserProvider>(context, listen: false).userModel!;
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.total + ": ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '${userInfo.allCurrency![0].crSymbol} ${addPunctuationInMoney(widget.subTotal.toStringAsFixed(2))}',
                          style: TextStyle(
                            color: Colors.green[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.due + ': ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '${userInfo.allCurrency![0].crSymbol} ${addPunctuationInMoney(widget.receiveLimit.toStringAsFixed(2))}',
                          style: TextStyle(
                            color: Colors.amber[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          buildRadioButtonRow(context),
          buildForm(context),
          const SizedBox(
            height: 10,
          ),
          buildButtonRow(context),
        ],
      ),
    );
  }

  Widget buildButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 38,
          width: 80,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ),
        SizedBox(
          height: 38,
          child: ElevatedButton(
            onPressed: () {
              _makeTransition();
            },
            child: Text(AppLocalizations.of(context)!.submit),
          ),
        )
      ],
    );
  }

  Form buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: textFieldPadding.copyWith(left: 0, right: 0),
            child: TextFormField(
              controller: _amountController,
              autofocus: true,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyInputFormatter()],
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    top: 15, bottom: 15, right: 10, left: 12),
                label: Text(transitionType == 1
                    ? AppLocalizations.of(context)!.receive_amount
                    : AppLocalizations.of(context)!.return_amount),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                _formKey.currentState!.validate();
              },
              validator: (value) {
                //requires validation
                return amountValidation(value?.replaceAll(',', ''), context);
              },
            ),
          ),
          Padding(
            padding: textFieldPadding.copyWith(left: 0, right: 0),
            child: TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    top: 15, bottom: 15, right: 10, left: 12),
                label: Text(AppLocalizations.of(context)!.note),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                //requires validation
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  String? amountValidation(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.amount_required;
    }
    try {
      final paying = double.parse(value);
      if (paying == 0.0) return AppLocalizations.of(context)!.no_need_to_pay;
      if (paying < 0.0) {
        return AppLocalizations.of(context)!.amount_cant_negative;
      }

      if (transitionType == 1 && paying > widget.receiveLimit) {
        return '${AppLocalizations.of(context)!.cant_receive} ${addPunctuationInMoney(widget.receiveLimit.toStringAsFixed(2))}';
      } else if (transitionType == 2 && paying > widget.returnLimit) {
        return '${AppLocalizations.of(context)!.cant_return} ${addPunctuationInMoney(widget.returnLimit.toStringAsFixed(2))}';
      }
    } catch (err) {
      return AppLocalizations.of(context)!.enter_valid_digit;
    }
    return null;
  }

  Row buildRadioButtonRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile(
              title: Text(AppLocalizations.of(context)!.receive),
              value: 1,
              dense: true,
              contentPadding: EdgeInsets.all(0),
              groupValue: transitionType,
              onChanged: (value) {
                transitionType = 1;
                setState(() {
                  _formKey.currentState!.validate();
                });
              }),
        ),
        Expanded(
          child: RadioListTile(
              title: Text(AppLocalizations.of(context)!.return_p),
              value: 2,
              dense: true,
              contentPadding: EdgeInsets.all(0),
              groupValue: transitionType,
              onChanged: (value) {
                transitionType = 2;
                setState(() {
                  _formKey.currentState!.validate();
                });
              }),
        ),
      ],
    );
  }

  void _makeTransition() {
    if (_formKey.currentState!.validate()) {
      showConfirmationDialog(context,
          msg: AppLocalizations.of(context)!.confirm_transition,
          onConfirmation: (status) {
        if (status) {
          hitApiForTransition();
        }
      });
    }
  }

  void hitApiForTransition() {
    FocusScope.of(context).requestFocus(FocusNode());
    EasyLoading.show();
    final amount = double.parse(_amountController.text.replaceAll(',', ''));
    final note = _noteController.text;
    Provider.of<ReservationProvider>(context, listen: false)
        .makeReservationTransition(
            widget.reservationReId, transitionType, amount, note)
        .then((value) async {
      EasyLoading.dismiss();

      //printing
      // var dontShowAgain = await AppSharedPref.getDontShowAgain();
      // if (dontShowAgain) {
      //   log('$dontShowAgain');
      //   await printPayment();
      // } else {
      //   log('$dontShowAgain');
      //   showSelectPrinterDialog(context, callBack: () async {
      //     await printPayment();
      //   });
      // }
      await printPayment(value);
      Navigator.pop(context);

      showMsgOnSnackBar(
          context, AppLocalizations.of(context)!.transition_success);
    }).catchError((err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    });
  }

  Future<void> printPayment(Map<String, dynamic> printInfo) async {
    String batteryLevel = "";
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _getReservationDetails(widget.reservationId);
    var pCode = await AppSharedPref.getPrinterCode();

    Map<String, Object> jsonData = {
      "printerType": pCode,
      "jsonData": {
        "bTitle": '${userProvider.userModel!.bTitle}',
        "address": "${printInfo['pBox'] ?? ''}",
        "email": "${printInfo['bEmail'] ?? ''}",
        "tel": "${printInfo['tel'] ?? ''}",
        "tin": "${printInfo['TIN'] ?? ''}",
        "vrn": "${printInfo['vrn'] ?? ''}",

        //contact info
        "spHireNo": '${widget.printInfo.id ?? 'xxxx'}',
        "cusName": '${widget.printInfo.contPerson ?? ''}',
        "company": '${widget.printInfo.company ?? ' '}',
        "cusPhone": '${widget.printInfo.mobile ?? ''}',
        "cusAddress": '${reservationDetailsModel.address ?? ''}',
        "route": '${widget.printInfo.route ?? ''}',
        "pickUp": '${reservationDetailsModel.pickUp ?? ''}',
        "dropOff": '${reservationDetailsModel.dropping ?? ''}',
        "depDateTime": '${reservationDetailsModel.journeyDate ?? ''}',
        "retDateTime":
            '${widget.printInfo.type == 'With return' ? reservationDetailsModel.returnDate : ''}',
        "remark": '${reservationDetailsModel.remarks ?? ''}',

        //fleet info
        "fleetType":
            '${listToString(reservationDetailsModel.fleetDetails!.map((fleet) => fleet.fleetType).toList())}',
        "ftMaker":
            '${listToString(reservationDetailsModel.fleetDetails!.map((fleet) => fleet.fleetMakers).toList())}',
        "seatCapacity":
            '${listToString(reservationDetailsModel.fleetDetails!.map((fleet) => fleet.seatTemplate).toList())}',
        "coachNo":
            '${listToString(reservationDetailsModel.fleetDetails!.map((fleet) => fleet.coachTitle).toList())}',
        "rentPrice":
            '${userProvider.userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(widget.printInfo.totalAmount != null ? widget.printInfo.totalAmount!.toStringAsFixed(2) : '')}',
        "paidAmmount":
            '${userProvider.userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(_amountController.text.replaceAll(',', ''))} (${transitionType == 1 ? AppLocalizations.of(context)!.received : AppLocalizations.of(context)!.returned_p})',
        "totalPaid":
            "${userProvider.userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(printInfo['rePay'] ?? '0')}",
        "amountDue":
            '${userProvider.userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(((widget.receiveLimit - double.parse(_amountController.text.replaceAll(',', ''))).toStringAsFixed(2)))}',
        "note": '${_noteController.text}',
        "servedBy": '${userProvider.userModel!.post!.username ?? ''}',
        "printDate":
            "${getFormattedDate(DateTime.now(), 'dd-MM-yyyy hh:mm:ss a')}",
        "rePrintDate": "",
        "vcode": "${printInfo['vfdCode'] ?? ''}",
        "qrData": "${printInfo['vfdLink'] ?? ''}",
        "findUs": "${printInfo['WEB'] ?? ''}",
        "downloadApp": "${printInfo['WEB'] ?? ''}",
      }
    };

    try {
      if (pCode == 'Bluetooth') {
        if (await BluetoothPrinter.isConnected() == 'true') {
          BluetoothPrinter.printPayment(
              jsonData['jsonData'] as Map<String, Object>);
        } else {
          if (await BluetoothPrinter.connectByMacAddress(
                  await AppSharedPref.getBTPrinterMac()) ==
              'true') {
            BluetoothPrinter.printPayment(
                jsonData['jsonData'] as Map<String, Object>);
          } else {
            showMsgOnSnackBar(context,
                AppLocalizations.of(context)!.check_printer_connection);
          }
        }
      } else {
        var _result = await platform.invokeMethod('initialize', {
          "printerType": pCode,
        });
        var result = platform.invokeMethod('printPayment', jsonData);
        batteryLevel = 'Battery level at $result % .';
      }
    } on PlatformException catch (e) {
      //  batteryLevel = "Failed to get battery level: '${e.message}'.";
      print('platform error');
    }

    log("batteryLevel: $batteryLevel");
  }

  _getReservationDetails(String id) async {
    EasyLoading.show();
    ReservationDetailsModel? model;
    try {
      model = await Provider.of<ReservationProvider>(context, listen: false)
          .getReservationDetails(id);
      EasyLoading.dismiss();
    } catch (err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    }
    reservationDetailsModel = model!.quotationDetails!;
  }
}
