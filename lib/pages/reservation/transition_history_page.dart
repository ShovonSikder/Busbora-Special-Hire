import 'dart:convert';
import 'dart:developer';

import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/models/quotation/quotation_details_model.dart';
import 'package:appscwl_specialhire/models/reservation/transition_history_model.dart';
import 'package:appscwl_specialhire/providers/resrvation/reservation_provider.dart';
import 'package:appscwl_specialhire/providers/user/user_provider.dart';
import 'package:appscwl_specialhire/utils/constants/color_constants.dart';
import 'package:appscwl_specialhire/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../db/shared_preferences.dart';
import '../../models/reservation/reservation_details_model.dart';
import '../../utils/bluetooth_printer.dart';
import '../../utils/constants/api_constants/http_code.dart';
import '../../utils/helper_function.dart';

class TransitionHistoryPage extends StatefulWidget {
  static const String routeName = '/transition_history';

  const TransitionHistoryPage({Key? key}) : super(key: key);

  @override
  State<TransitionHistoryPage> createState() => _TransitionHistoryPageState();
}

class _TransitionHistoryPageState extends State<TransitionHistoryPage> {
  TransitionHistoryModel? model;
  QuotationDetails? reservationDetailsModel;

  late String reservationReId;
  static const platform = MethodChannel('com.busbora.specialhire/printer');

  @override
  void didChangeDependencies() {
    reservationReId = ModalRoute.of(context)!.settings.arguments as String;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: buildAppBar(context),
      body: FutureBuilder(
        future: _getTransitionHistory(reservationReId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              model = snapshot.data as TransitionHistoryModel;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeaderSectionCard(context, model!),
                    buildSectionLabel(
                        context, AppLocalizations.of(context)!.history),
                    (model!.history != null && model!.history!.isNotEmpty)
                        ? Expanded(
                            child: ListView(
                              padding: const EdgeInsets.only(top: 8),
                              children: model!.history!
                                  .map((history) =>
                                      buildHistoryListTile(history))
                                  .toList(),
                            ),
                          )
                        : Expanded(
                            child: Center(
                              child: Text(
                                  AppLocalizations.of(context)!.no_history),
                            ),
                          ),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                AppLocalizations.of(context)!.something_went_wrong,
                style: const TextStyle(fontSize: 18),
              ));
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/no_internet.svg',
                  height: 200,
                ),
                const SizedBox(
                  height: 80,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 10,
                        primary: specialHireThemePrimary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5)),
                    child: Text(
                      AppLocalizations.of(context)!.reload,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildHeaderSectionCard(
      BuildContext context, TransitionHistoryModel model) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: ListTile(
        tileColor: Colors.white,
        title: Transform.translate(
          offset: const Offset(-15, 0),
          child: Text(
            '${model.reReservationId}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              // fontSize: 18,
            ),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        subtitle: Transform.translate(
          offset: const Offset(-15, 0),
          child: Text(
            '${AppLocalizations.of(context)!.contact_person}: ${model.reContPerson}',
          ),
        ),
        leading: Icon(
          Icons.history,
          color: Theme.of(context).primaryColor,
          size: 28,
        ),
      ),
    );
  }

  Padding buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildHistoryListTile(History history) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      child: ListTile(
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.all(8).copyWith(
            left: 12,
            top: history.p != null && history.p!.isNotEmpty ? 8 : 0,
            bottom: history.p != null && history.p!.isNotEmpty ? 8 : 0),
        dense: true,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              history.date ?? 'xx-xx-xxxx',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              history.time ?? 'xx:xx:xx',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: history.amount != null
                  ? Text(
                      '${Provider.of<UserProvider>(context, listen: false).userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(history.amount!.toStringAsFixed(2))}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: history.amount! > 0
                              ? Colors.green[700]
                              : Colors.red[700]),
                    )
                  : const Text('xx'),
            ),
            OutlinedButton(
              onPressed: () async {
                var dontShowAgain = await AppSharedPref.getDontShowAgain();
                if (dontShowAgain) {
                  printIndividualPayment(history);
                } else {
                  showSelectPrinterDialog(context, callBack: () {
                    printIndividualPayment(history);
                  });
                }
              },
              child: Icon(Icons.print_sharp),
            )
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(history.user ?? ''),
            if (history.p != null && history.p!.isNotEmpty)
              Text(history.p ?? ''),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.transition_history),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () async {
            //export to excel
            //For experiment purpose only
            try {
              var _result = await platform.invokeMethod('initialize', {
                "printerType": "Bluetooth",
              });

              // batteryLevel = 'Battery level at $result % .';
            } on PlatformException catch (e) {
              //  batteryLevel = "Failed to get battery level: '${e.message}'.";
              print('platform error');
            }
          },
          icon: const Icon(Icons.my_library_books_sharp),
        ),
        IconButton(
          onPressed: () async {
            var dontShowAgain = await AppSharedPref.getDontShowAgain();
            if (dontShowAgain) {
              printTransactionHistory();
            } else {
              showSelectPrinterDialog(context, callBack: () {
                printTransactionHistory();
              });
            }
          },
          icon: const Icon(Icons.print),
        ),
      ],
    );
  }

  Future<void> printIndividualPayment(History history) async {
    String batteryLevel = "";
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    reservationDetailsModel ??=
        await _getReservationDetails(model!.reReservationId ?? '');
    var pCode = await AppSharedPref.getPrinterCode();

    Map<String, Object> jsonData = {
      "printerType": pCode,
      "jsonData": {
        "bTitle": '${userProvider.userModel!.bTitle}',
        "address": "${model!.pBox ?? ''}",
        "email": "${model!.email ?? ''}",
        "tel": "${model!.tel ?? ''}",
        "tin": "${model!.TIN ?? ''}",
        "vrn": "${model!.vrn ?? ''}",

        //contact info
        "spHireNo": '${reservationDetailsModel!.id ?? 'xxxx'}',
        "cusName": '${reservationDetailsModel!.contactPerson ?? ''}',
        "company": '${reservationDetailsModel!.company ?? ' '}',
        "cusPhone": '${reservationDetailsModel!.mobile ?? ''}',
        "cusAddress": '${reservationDetailsModel!.address ?? ''}',
        "route":
            '${reservationDetailsModel!.origin ?? ''} ${AppLocalizations.of(context)!.to} ${reservationDetailsModel!.destination ?? ''}',
        "pickUp": '${reservationDetailsModel!.pickUp ?? ''}',
        "dropOff": '${reservationDetailsModel!.dropping ?? ''}',
        "depDateTime": '${reservationDetailsModel!.journeyDate ?? ''}',
        "retDateTime":
            '${reservationDetailsModel!.type == '2' ? reservationDetailsModel!.returnDate : ''}',
        "remark": '${reservationDetailsModel!.remarks ?? ''}',

        //fleet info
        "fleetType":
            '${listToString(reservationDetailsModel!.fleetDetails!.map((fleet) => fleet.fleetType).toList())}',
        "ftMaker":
            '${listToString(reservationDetailsModel!.fleetDetails!.map((fleet) => fleet.fleetMakers).toList())}',
        "seatCapacity":
            '${listToString(reservationDetailsModel!.fleetDetails!.map((fleet) => fleet.seatTemplate).toList())}',
        "coachNo":
            '${listToString(reservationDetailsModel!.fleetDetails!.map((fleet) => fleet.coachTitle).toList())}',
        "rentPrice":
            '${userProvider.userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(reservationDetailsModel!.subtotal != null ? reservationDetailsModel!.subtotal!.toStringAsFixed(2) : '0.0')}',
        "paidAmmount":
            '${userProvider.userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(history.amount!.toStringAsFixed(2))} (${history.amount! > 0 ? AppLocalizations.of(context)!.received : AppLocalizations.of(context)!.returned_p})',
        "totalPaid":
            "${userProvider.userModel!.allCurrency![0].crSymbol} ${history.totalPay != null ? addPunctuationInMoney(history.totalPay!.toStringAsFixed(2)) : '0.0'}",
        "amountDue":
            "${userProvider.userModel!.allCurrency![0].crSymbol} ${history.due != null ? addPunctuationInMoney(history.due!.toStringAsFixed(2)) : '0.0'}",
        "note": '${history.p ?? ''}',
        "servedBy": '${history.user ?? ''}',
        "rePrintDate":
            '${getFormattedDate(DateTime.now(), 'dd-MM-yyyy HH:mm:ss a')}',
        "printDate": "",
        "vcode": "${model!.vfdCode ?? ''}",
        "qrData": "${model!.vfdLink ?? ''}",
        "findUs": "${model!.WEB ?? ''}",
        "downloadApp": "${model!.WEB ?? ''}",
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
        // batteryLevel = 'Battery level at $result % .';
      }
    } on PlatformException catch (e) {
      //  batteryLevel = "Failed to get battery level: '${e.message}'.";
      print('platform error');
    }

    log("batteryLevel: $batteryLevel");
  }

  Future<void> printTransactionHistory() async {
    if (model!.history == null || model!.history!.isEmpty) {
      showMsgOnSnackBar(
          context, AppLocalizations.of(context)!.no_history_to_print);
      return;
    }
    String batteryLevel = "";
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    reservationDetailsModel ??=
        await _getReservationDetails(model!.reReservationId ?? '');
    log(jsonEncode(reservationDetailsModel!.toJson()));

    var pCode = await AppSharedPref.getPrinterCode();

    Map<String, Object> jsonData = {
      "printerType": pCode,
      "jsonData": {
        "bTitle": '${userProvider.userModel!.bTitle}',
        "address": "${model!.pBox ?? ''}",
        "email": "${model!.email ?? ''}",
        "tel": "${model!.tel ?? ''}",
        "tin": "${model!.TIN ?? ''}",
        "vrn": "${model!.vrn ?? ''}",

        //contact info
        "spHireNo": '${reservationDetailsModel!.id ?? 'xxxx'}',
        "cusName": '${reservationDetailsModel!.contactPerson ?? ''}',
        "company": '${reservationDetailsModel!.company ?? ' '}',
        "cusPhone": '${reservationDetailsModel!.mobile ?? ''}',

        "route":
            '${reservationDetailsModel!.origin ?? ''} ${AppLocalizations.of(context)!.to} ${reservationDetailsModel!.destination ?? ''}',
        "depDateTime": '${reservationDetailsModel!.journeyDate ?? ''}',
        "retDateTime":
            '${reservationDetailsModel!.type == '2' ? reservationDetailsModel!.returnDate : ''}',
        "remark": '${reservationDetailsModel!.remarks ?? ''}',

        "payHistory":
            '${_transactionHistoryAsString(userProvider.userModel!.allCurrency![0].crSymbol ?? 'TZS')}',

        "rentPrice":
            '${userProvider.userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(reservationDetailsModel!.subtotal != null ? reservationDetailsModel!.subtotal!.toStringAsFixed(2) : '0.0')}',
        "amountPaid":
            '${userProvider.userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(reservationDetailsModel!.paid!.toStringAsFixed(2))}',
        "amountDue":
            '${userProvider.userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(reservationDetailsModel!.due!.toStringAsFixed(2))}',
        "printDate":
            "${getFormattedDate(DateTime.now(), 'dd-MM-yyyy hh:mm:ss a')}",

        "vcode": "${model!.vfdCode ?? ''}",
        "qrData": "${model!.vfdLink ?? ''}",
        "findUs": "${model!.WEB ?? ''}",
        "downloadApp": "${model!.WEB ?? ''}",
      }
    };
    log(jsonEncode(jsonData));

    try {
      if (pCode == 'Bluetooth') {
        if (await BluetoothPrinter.isConnected() == 'true') {
          BluetoothPrinter.printTransactionHistory(
              jsonData['jsonData'] as Map<String, Object>);
        } else {
          if (await BluetoothPrinter.connectByMacAddress(
                  await AppSharedPref.getBTPrinterMac()) ==
              'true') {
            BluetoothPrinter.printTransactionHistory(
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

        var result = platform.invokeMethod('printTransactionHistory', jsonData);
        batteryLevel = 'Battery level at $result % .';
      }
    } on PlatformException catch (e) {
      //  batteryLevel = "Failed to get battery level: '${e.message}'.";
      print('platform error');
    }

    log("batteryLevel: $batteryLevel");
  }

  _getTransitionHistory(String reservationReId) async {
    EasyLoading.show();
    TransitionHistoryModel? transitionHistoryModel;
    try {
      transitionHistoryModel =
          await Provider.of<ReservationProvider>(context, listen: false)
              .getTransitionHistory(reservationReId);
      EasyLoading.dismiss();
    } catch (err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    }
    return transitionHistoryModel;
  }

  _getReservationDetails(String id) async {
    EasyLoading.show();
    ReservationDetailsModel? _model;
    try {
      _model = await Provider.of<ReservationProvider>(context, listen: false)
          .getReservationDetails(id);
      EasyLoading.dismiss();
    } catch (err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    }
    return _model!.quotationDetails!;
  }

  String _transactionHistoryAsString(String crSmbl) {
    String result = '';

    result += '${AppLocalizations.of(context)!.history}:\n';
    for (var history in model!.history!) {
      result +=
          '${history.date ?? 'xx-xx-xxxx'} (${history.time ?? 'xx:xx'}) $crSmbl ${addPunctuationInMoney(history.amount!.toStringAsFixed(2))}\n'
          '${history.user ?? ''}: ${history.p ?? ''}\n\n';
    }

    return result.toString();
  }
}
