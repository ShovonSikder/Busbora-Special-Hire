import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/models/all_districts_model.dart';
import 'package:appscwl_specialhire/models/quotation/contact_information_model.dart';
import 'package:appscwl_specialhire/models/quotation/fleet_model.dart';
import 'package:appscwl_specialhire/models/quotation/journey_information_model.dart';
import 'package:appscwl_specialhire/models/quotation/quotation_details_model.dart';
import 'package:appscwl_specialhire/models/quotation/quotation_init_model.dart';
import 'package:appscwl_specialhire/models/quotation/quotation_model.dart';
import 'package:appscwl_specialhire/models/reservation/reservation_details_model.dart';
import 'package:appscwl_specialhire/pages/reservation/seat_view_page.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_queue_provider.dart';
import 'package:appscwl_specialhire/providers/resrvation/reservation_provider.dart';
import 'package:appscwl_specialhire/providers/user/user_provider.dart';
import 'package:appscwl_specialhire/utils/constants/color_constants.dart';
import 'package:appscwl_specialhire/utils/constants/constants.dart';
import 'package:appscwl_specialhire/utils/file_downloader.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:appscwl_specialhire/utils/printer_utils.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import '../../customewidgets/confirm_button.dart';
import '../../customewidgets/printer/select_printer.dart';
import '../../db/shared_preferences.dart';
import '../../providers/quotation/quotation_add_provider.dart';
import '../../utils/bluetooth_printer.dart';
import '../../utils/constants/api_constants/http_code.dart';
import '../../utils/details_flow_delegate.dart';
import '../add_quotation/quotation_add_page.dart';

class QuotationOrReservationDetails extends StatefulWidget {
  static const String routeName = '/quotation_details';
  const QuotationOrReservationDetails({Key? key}) : super(key: key);

  @override
  State<QuotationOrReservationDetails> createState() =>
      _QuotationOrReservationDetailsState();
}

class _QuotationOrReservationDetailsState
    extends State<QuotationOrReservationDetails> {
  late QuotationModel quotationModel;
  late String id;
  late QuotationDetails quotationDetailsModel;
  late bool isReservation;
  late UserProvider userInfo;
  File? pdfFile;
  //reservation or quotation id
  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)!.settings.arguments as List;
    id = args[0];
    isReservation = args[1];
    userInfo = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  String _batteryLevel = 'Unknown battery level.';
  static const platform = MethodChannel('com.busbora.specialhire/printer');

  Future<void> printQuotation() async {
    String batteryLevel = "";

    var pCode = await AppSharedPref.getPrinterCode();
    Map<String, Object> jsonData = {
      "printerType": pCode,
      "jsonData": {
        //company details
        "bTitle": '${userInfo.userModel!.bTitle}',
        "address": "${quotationDetailsModel.pBox ?? ''}",
        "email": "${quotationDetailsModel.bEmail ?? ''}",
        "tel": "${quotationDetailsModel.tel ?? ''}",
        "tin": "${quotationDetailsModel.TIN ?? ''}",
        "vrn": "${quotationDetailsModel.vrn ?? ''}",

        //customer info
        "spHireNo": '${quotationDetailsModel.id ?? 'xxxx'}',
        "cusName": '${quotationDetailsModel.contactPerson ?? ' '}',
        "company": '${quotationDetailsModel.company ?? ' '}',
        "cusPhone": '${quotationDetailsModel.mobile ?? ' '}',
        "cusAddress": '${quotationDetailsModel.address ?? ''}',

        //journey info
        "route":
            '${quotationDetailsModel.origin} to ${quotationDetailsModel.destination}',
        "pickUp": '${quotationDetailsModel.pickUp ?? ' '}',
        "dropOff": '${quotationDetailsModel.dropping ?? ''}',
        "depDateTime": '${quotationDetailsModel.journeyDate}',
        "retDateTime":
            '${quotationDetailsModel.type == '2' ? quotationDetailsModel.returnDate : ''}',
        "remark": '${quotationDetailsModel.remarks ?? ' '}',

        //fleet info
        "fleetType":
            '${listToString(quotationDetailsModel.fleetDetails!.map((fleet) => fleet.fleetType).toList())}',
        "ftMaker":
            '${listToString(quotationDetailsModel.fleetDetails!.map((fleet) => fleet.fleetMakers).toList())}',
        "seatCapacity":
            '${listToString(quotationDetailsModel.fleetDetails!.map((fleet) => fleet.seatTemplate).toList())}',
        "coachNo":
            '${listToString(quotationDetailsModel.fleetDetails!.map((fleet) => fleet.coachTitle).toList())}',

        //pyment info
        "rentPrice":
            '${userInfo.userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(quotationDetailsModel.subtotal!.toStringAsFixed(2))}',
        "amountPaid": (quotationDetailsModel.advance != null &&
                quotationDetailsModel.advance! > 0)
            ? '${userInfo.userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(quotationDetailsModel.advance!.toStringAsFixed(2))}'
            : "",
        "amountDue": (quotationDetailsModel.advance != null &&
                quotationDetailsModel.advance! > 0)
            ? '${userInfo.userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney((quotationDetailsModel.subtotal! - quotationDetailsModel.advance! - (quotationDetailsModel.discount ?? 0)).toStringAsFixed(2))}'
            : "",
        "servedBy": '${userInfo.userModel!.post!.username ?? ''}',
        "printDate":
            "${getFormattedDate(DateTime.now(), 'dd-MM-yyyy hh:mm:ss a')}",
        "findUs": "${quotationDetailsModel.WEB ?? ''}",
        "downloadApp": "${quotationDetailsModel.WEB ?? ''}",
      },
    };

    try {
      if (pCode == 'Bluetooth') {
        if (await BluetoothPrinter.isConnected() == 'true') {
          BluetoothPrinter.printQuotation(
              jsonData['jsonData'] as Map<String, Object>);
        } else {
          if (await BluetoothPrinter.connectByMacAddress(
                  await AppSharedPref.getBTPrinterMac()) ==
              'true') {
            BluetoothPrinter.printQuotation(
                jsonData['jsonData'] as Map<String, Object>);
          } else {
            showMsgOnSnackBar(context,
                AppLocalizations.of(context)!.check_printer_connection);
          }
        }
      } else {
        var result = await platform.invokeMethod('printQuotation', jsonData);
        batteryLevel = 'Battery level at $result % .';
      }
    } on PlatformException catch (e) {
      //  batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    log("batteryLevel: $batteryLevel");
  }

  Future<void> printInvoice() async {
    String batteryLevel = "";

    var pCode = await AppSharedPref.getPrinterCode();
    Map<String, Object> jsonData = {
      "printerType": pCode,
      "jsonData": {
        "bTitle": '${userInfo.userModel!.bTitle}',
        "address": "${quotationDetailsModel.pBox ?? ''}",
        "email": "${quotationDetailsModel.bEmail ?? ''}",
        "tel": "${quotationDetailsModel.tel ?? ''}",
        "tin": "${quotationDetailsModel.TIN ?? ''}",
        "vrn": "${quotationDetailsModel.vrn ?? ''}",

        //customer info
        "spHireNo": '${quotationDetailsModel.id ?? 'xxxx'}',
        "cusName": '${quotationDetailsModel.contactPerson ?? ' '}',
        "company": '${quotationDetailsModel.company ?? ' '}',
        "cusPhone": '${quotationDetailsModel.mobile ?? ' '}',
        "cusAddress": '${quotationDetailsModel.address ?? ''}',

        //journey info
        "route":
            '${quotationDetailsModel.origin} to ${quotationDetailsModel.destination}',
        "pickUp": '${quotationDetailsModel.pickUp ?? ' '}',
        "dropOff": '${quotationDetailsModel.dropping ?? ''}',
        "depDateTime": '${quotationDetailsModel.journeyDate}',
        "retDateTime":
            '${quotationDetailsModel.type == '2' ? quotationDetailsModel.returnDate : ''}',
        "remark": '${quotationDetailsModel.remarks ?? ' '}',

        //fleet info
        "fleetType":
            '${listToString(quotationDetailsModel.fleetDetails!.map((fleet) => fleet.fleetType).toList())}',
        "ftMaker":
            '${listToString(quotationDetailsModel.fleetDetails!.map((fleet) => fleet.fleetMakers).toList())}',
        "seatCapacity":
            '${listToString(quotationDetailsModel.fleetDetails!.map((fleet) => fleet.seatTemplate).toList())}',
        "coachNo":
            '${listToString(quotationDetailsModel.fleetDetails!.map((fleet) => fleet.coachTitle).toList())}',

        //pyment info
        "rentPrice":
            '${userInfo.userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(quotationDetailsModel.subtotal!.toStringAsFixed(2))}',
        "amountPaid": quotationDetailsModel.paid != null &&
                quotationDetailsModel.paid! > 0
            ? '${userInfo.userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(quotationDetailsModel.paid!.toStringAsFixed(2))}'
            : "",
        "amountDue": quotationDetailsModel.due != null &&
                quotationDetailsModel.due! > 0
            ? '${userInfo.userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney((quotationDetailsModel.due ?? 0).toStringAsFixed(2))}'
            : "",
        "servedBy": '${userInfo.userModel!.post!.username ?? ''}',
        "vcode": quotationDetailsModel.vfdCode != null
            ? "${quotationDetailsModel.vfdCode}"
            : "",
        "qrData": quotationDetailsModel.vfdLink != null
            ? "${quotationDetailsModel.vfdLink}"
            : "",
        "printDate":
            "${getFormattedDate(DateTime.now(), 'dd-MM-yyyy hh:mm:ss a')}",
        "findUs": "${quotationDetailsModel.WEB ?? ''}",
        "downloadApp": "${quotationDetailsModel.WEB ?? ''}",
      }
    };
    try {
      if (pCode == 'Bluetooth') {
        if (await BluetoothPrinter.isConnected() == 'true') {
          BluetoothPrinter.printInvoice(
              jsonData['jsonData'] as Map<String, Object>);
        } else {
          if (await BluetoothPrinter.connectByMacAddress(
                  await AppSharedPref.getBTPrinterMac()) ==
              'true') {
            BluetoothPrinter.printInvoice(
                jsonData['jsonData'] as Map<String, Object>);
          } else {
            showMsgOnSnackBar(context,
                AppLocalizations.of(context)!.check_printer_connection);
          }
        }
      } else {
        var result = await platform.invokeMethod('printInvoice', jsonData);
        batteryLevel = 'Battery level at $result % .';
      }
    } on PlatformException catch (e) {
      //  batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    log("batteryLevel: $batteryLevel");
  }

  Future<void> print() async {
    var pCode = await AppSharedPref.getPrinterCode();
    if (pCode == PrinterUtils.NO_PRINTER) {
    } else {
      try {
        if (pCode != 'Bluetooth') {
          var result = await platform.invokeMethod('initialize', {
            "printerType": pCode,
          });
        }

        isReservation ? printInvoice() : printQuotation();
      } catch (err) {}
      //   printInvoice();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          isReservation ? _getReservationDetails(id) : _getQuotationDetails(id),
      builder: (context, _snapshot) {
        if (_snapshot.connectionState == ConnectionState.done) {
          if (_snapshot.hasData) {
            final QuotationDetails model = _snapshot.data as QuotationDetails;
            quotationDetailsModel = model;
            return buildDetailsUI(context, model);
          }
          if (_snapshot.hasError) {
            return Center(
                child: Text(
              AppLocalizations.of(context)!.something_went_wrong,
              style: const TextStyle(fontSize: 18),
            ));
          }
        } else if (_snapshot.connectionState == ConnectionState.waiting) {
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
    );
  }

  Widget buildDetailsUI(BuildContext context, QuotationDetails model) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: buildAppBar(context),
      bottomNavigationBar: buildBottomContainer(context),
      // floatingActionButton: Flow(
      //   delegate: FlowMenuDelegate(),
      //   children: [
      //     FloatingActionButton(
      //       onPressed: () {},
      //       child: Icon(Icons.more_horiz_sharp),
      //     ),
      //     FloatingActionButton(
      //       onPressed: () {},
      //       child: Icon(Icons.file_download),
      //     ),
      //     FloatingActionButton(
      //       onPressed: () {},
      //       child: Icon(Icons.share),
      //     ),
      //     FloatingActionButton(
      //       onPressed: () {},
      //       child: Icon(Icons.add),
      //     ),
      //   ],
      // ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          buildContactInfoSectionCard(context, model),
          const Divider(
            height: 3,
            // thickness: 1.5,
          ),
          buildJourneyInfoSectionCard(context, model),
          const Divider(
            height: 3,
            // thickness: 1.5,
          ),
          buildCostDetailsSection(context, model),
          buildSectionLabel(
              context, AppLocalizations.of(context)!.fleet_details),
          model.fleetDetails != null && model.fleetDetails!.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: model.fleetDetails!
                      .map(
                        (fleet) => buildFleetContainer(fleet),
                      )
                      .toList(),
                )
              : Expanded(
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.no_fleet_found),
                  ),
                )
        ],
      ),
    );
  }

  Container buildBottomContainer(context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: cardBackgroundColor, width: 2),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0)
            .copyWith(top: 0, bottom: 3, left: 0, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isReservation)
              Expanded(
                flex: 2,
                child: ConfirmButton(
                    btnText: AppLocalizations.of(context)!.create_special_hire,
                    callBack: () {
                      _createReservation(context);
                    }),
              ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      _downloadFile(open: true);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 50,
                          child: Icon(
                            Icons.file_download,
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          left: 0,
                          right: 0,
                          child: Text(
                            AppLocalizations.of(context)!.download,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _downloadFile();
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 50,
                          child: Icon(
                            Icons.share,
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          left: 0,
                          right: 0,
                          child: Text(
                            AppLocalizations.of(context)!.share,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildFleetContainer(FleetDetails fleet) {
    return Container(
      decoration: listViewContainerBottomBorder,
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
        title: Text(
          fleet.coachTitle ?? '--',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fleet.fleetType ?? '--',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              fleet.fleetMakers ?? '--',
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              fleet.seatTemplate ?? '--',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                '${Provider.of<UserProvider>(context, listen: false).userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(fleet.rent!.toStringAsFixed(2))}'),
            if (isReservation)
              const SizedBox(
                width: 20,
              ),
            if (isReservation)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: specialHireThemePrimary)),
                onPressed: () {
                  Navigator.pushNamed(context, SeatViewPage.routeName,
                      arguments: {
                        'reservationId': quotationDetailsModel.id,
                        'route':
                            '${quotationDetailsModel.origin} - ${quotationDetailsModel.destination}',
                        'rfID': fleet.rfID,
                        'seat_temp': fleet.seatTemplate,
                        'fleet_type': fleet.fleetType,
                      });
                },
                child: Text(AppLocalizations.of(context)!.seat_view),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildContactInfoSectionCard(
      BuildContext context, QuotationDetails? model) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        left: BorderSide(
          width: 2,
          color: Theme.of(context).primaryColor,
        ),
      )),
      child: ListTile(
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.all(8).copyWith(left: 12, right: 8),
        leading: Icon(
          Icons.person,
          color: Theme.of(context).primaryColor,
          size: 40,
        ),
        title: Text(
          '${model!.id}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            // fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (model.company != null && model.company!.isNotEmpty)
              Text(
                model.company ?? '',
                style: const TextStyle(color: Colors.black),
              ),
            if (model.contactPerson != null && model.contactPerson!.isNotEmpty)
              Text(
                model.contactPerson ?? '',
                style: const TextStyle(color: Colors.black),
              ),
            if (model.email != null && model.email!.isNotEmpty)
              Text(
                model.email ?? '',
                style: const TextStyle(color: Colors.black),
              ),
            if (model.mobile != null && model.mobile!.isNotEmpty)
              Text(
                model.mobile ?? '',
                style: const TextStyle(color: Colors.black),
              ),
            if (model.address != null && model.address!.isNotEmpty)
              Text(
                model.address ?? '',
                style: const TextStyle(color: Colors.black),
              ),
            if (model.remarks != null && model.remarks!.isNotEmpty)
              Text(
                model.remarks ?? '',
                style: const TextStyle(color: Colors.black),
              ),
          ],
        ),
        trailing: isReservation
            ? model.paidStatus == 1
                ? Text(
                    AppLocalizations.of(context)!.full_paid,
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  )
                : model.paidStatus == 2
                    ? Text(
                        AppLocalizations.of(context)!.unpaid,
                        style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        AppLocalizations.of(context)!.due,
                        style: TextStyle(
                            color: Colors.amber[900],
                            fontWeight: FontWeight.bold),
                      )
            : null,
      ),
    );
  }

  Widget buildJourneyInfoSectionCard(
      BuildContext context, QuotationDetails? model) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        left: BorderSide(
          width: 2,
          color: Theme.of(context).primaryColor,
        ),
      )),
      child: ListTile(
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.all(8).copyWith(left: 12, right: 8),
        leading: Icon(
          Icons.tour_sharp,
          color: Theme.of(context).primaryColor,
          size: 40,
        ),
        title: Text(
          '${model!.origin} - ${model.destination}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            // fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((model.pickUp != null && model.pickUp!.isNotEmpty) ||
                (model.dropping != null && model.dropping!.isNotEmpty))
              Text(
                '${model.pickUp} - ${model.dropping}',
                style: const TextStyle(color: Colors.black),
              ),
            if (model.journeyDate != null && model.journeyDate!.isNotEmpty)
              Text(
                model.journeyDate ?? '',
                style: const TextStyle(color: Colors.black),
              ),
            if (model.type == '2')
              Text(
                '${model.returnDate} (${AppLocalizations.of(context)!.r})',
                style: const TextStyle(color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildCostDetailsSection(
      BuildContext context, QuotationDetails? model) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        left: BorderSide(
          width: 2,
          color: Theme.of(context).primaryColor,
        ),
      )),
      child: ListTile(
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.all(8).copyWith(left: 12, right: 8),
        leading: Icon(
          Icons.money,
          color: Theme.of(context).primaryColor,
          size: 40,
        ),
        title: Text(
          '${Provider.of<UserProvider>(context, listen: false).userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(model!.subtotal != null ? model.subtotal!.toStringAsFixed(2) : '0.0')}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,

            // fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${Provider.of<UserProvider>(context, listen: false).userModel!.allCurrency![0].crSymbol} -${addPunctuationInMoney(model.discount != null ? model.discount!.toStringAsFixed(2) : '0.0')}',
              style: TextStyle(color: Colors.red[900]),
            ),
            Text(
              '${Provider.of<UserProvider>(context, listen: false).userModel!.allCurrency![0].crSymbol}  ${addPunctuationInMoney(model.paid != null ? model.paid!.toStringAsFixed(2) : '0.0')}  ${model.advance != null && model.advance! > 0 ? '\n(${AppLocalizations.of(context)!.advance}: ${addPunctuationInMoney(model.advance!.toStringAsFixed(2))})' : ''}',
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ),
        trailing: Text(
          '${Provider.of<UserProvider>(context, listen: false).userModel!.allCurrency![0].crSymbol} ${addPunctuationInMoney(((model.subtotal ?? 0) - (model.discount ?? 0) - (model.paid ?? 0)).toStringAsFixed(2))}',
          style:
              TextStyle(color: Colors.amber[900], fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Padding buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)!.details,
      ),
      actions: [
        //delete
        if (quotationDetailsModel.paidStatus == 2 || !isReservation)
          IconButton(
            onPressed: () {
              _delete(context);
            },
            icon: const Icon(Icons.delete),
          ),

        //edit
        if (quotationDetailsModel.paidStatus == 2 || !isReservation)
          IconButton(
            onPressed: () {
              Provider.of<QuotationAddProvider>(context, listen: false)
                  .initiateQuotation(_detailsToEditModelConversion());
              Navigator.pushNamed(context, QuotationAddPage.routeName,
                  arguments: [true, isReservation]).then(<bool>(value) {
                if (value) {
                  setState(
                    () {},
                  );
                }
              });
            },
            icon: const Icon(Icons.edit),
          ),
        // print
        IconButton(
          onPressed: () async {
            var dontShowAgain = await AppSharedPref.getDontShowAgain();
            if (dontShowAgain) {
              print();
            } else {
              showSelectPrinterDialog(context, callBack: () {
                print();
              });
            }
          },
          icon: const Icon(Icons.print),
        ),
      ],
    );
  }

  Future<QuotationDetails?>? _getQuotationDetails(String id) async {
    EasyLoading.show();
    QuotationDetailsModel? quotationDetailsModel;
    try {
      quotationDetailsModel =
          await Provider.of<QuotationQueueProvider>(context, listen: false)
              .getQuotationDetails(id);
      EasyLoading.dismiss();
    } catch (err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    }
    return quotationDetailsModel?.quotationDetails;
  }

  Future<QuotationDetails?>? _getReservationDetails(String id) async {
    EasyLoading.show();
    ReservationDetailsModel? reservationDetailsModel;
    try {
      reservationDetailsModel =
          await Provider.of<ReservationProvider>(context, listen: false)
              .getReservationDetails(id);

      EasyLoading.dismiss();
    } catch (err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    }
    return reservationDetailsModel?.quotationDetails;
  }

  void _createReservation(BuildContext context) {
    showConfirmationDialog(
      context,
      msg: AppLocalizations.of(context)!.confirm_reservation_msg,
      onConfirmation: (status) {
        if (status) {
          _hitApi(context);
        }
      },
    );
  }

  void _hitApi(BuildContext context) {
    String id;
    EasyLoading.show();
    Provider.of<ReservationProvider>(context, listen: false)
        .createReservationFromQuotation(quotationDetailsModel.qreID ?? '')
        .then((value) {
      id = value;
      showMsgOnSnackBar(
          context, AppLocalizations.of(context)!.reservation_creation_success);
      Provider.of<QuotationQueueProvider>(context, listen: false)
          .getQuotationList();
      EasyLoading.dismiss();

      Navigator.popAndPushNamed(
          context, QuotationOrReservationDetails.routeName,
          arguments: [id, true]);
    }).catchError((err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    });
  }

  void _delete(context) {
    showConfirmationDialog(
      context,
      msg: AppLocalizations.of(context)!.delete_confirm_msg,
      rightBtnTxt: AppLocalizations.of(context)!.delete,
      onConfirmation: (status) {
        if (status) {
          hitDelete(context);
        }
      },
    );
  }

  void hitDelete(context) {
    EasyLoading.show(status: AppLocalizations.of(context)!.deleting);
    if (isReservation) {
      //delete reservation
      _reservationDelete(context);
    } else {
      //delete quotation
      _quotationDelete(context);
    }
  }

  void _quotationDelete(context) {
    Provider.of<QuotationQueueProvider>(context, listen: false)
        .deleteQuotation(quotationDetailsModel.qreID ?? '')
        .then((value) {
      EasyLoading.dismiss();
      showMsgOnSnackBar(context, AppLocalizations.of(context)!.deleted_success);
      Navigator.pop(context);
    }).catchError((err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    });
  }

  void _reservationDelete(context) {
    Provider.of<ReservationProvider>(context, listen: false)
        .deleteReservation(quotationDetailsModel.reID ?? '')
        .then((value) {
      EasyLoading.dismiss();
      showMsgOnSnackBar(context, AppLocalizations.of(context)!.deleted_success);
      Navigator.pop(context);
    }).catchError((err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    });
  }

  QuotationModel _detailsToEditModelConversion() {
    final model = QuotationModel(
      journeyInformationModel: JourneyInformationModel(
        origin: Districts(
            distID: quotationDetailsModel.from,
            distTitle: quotationDetailsModel.origin),
        pickup: quotationDetailsModel.pickUp,
        destination: Districts(
            distID: quotationDetailsModel.to,
            distTitle: quotationDetailsModel.destination),
        dropping: quotationDetailsModel.dropping,
        type: Type(
          id: num.parse(quotationDetailsModel.type!),
          title: quotationDetailsModel.type == '1'
              ? AppLocalizations.of(context)!.one_way
              : AppLocalizations.of(context)!.with_return,
        ),
        journeyDate: DateFormat(datePattern)
            .parse(quotationDetailsModel.journeyDate!.split(' ')[0]),
        journeyDateString: quotationDetailsModel.journeyDate!.split(' ')[0],
        journeyTimeString: quotationDetailsModel.journeyDate!.split(' ')[1] +
            ' ' +
            quotationDetailsModel.journeyDate!.split(' ')[2],
        returnDate: DateFormat(datePattern).parse(
            quotationDetailsModel.type == '1'
                ? quotationDetailsModel.journeyDate!.split(' ')[0]
                : quotationDetailsModel.returnDate!.split(' ')[0]),
        returnDateString: quotationDetailsModel.type == '1'
            ? quotationDetailsModel.journeyDate!.split(' ')[0]
            : quotationDetailsModel.returnDate!.split(' ')[0],
        returnTimeString: quotationDetailsModel.type == '1'
            ? quotationDetailsModel.journeyDate!.split(' ')[1] +
                ' ' +
                quotationDetailsModel.journeyDate!.split(' ')[2]
            : quotationDetailsModel.returnDate!.split(' ')[1] +
                ' ' +
                quotationDetailsModel.returnDate!.split(' ')[2],
      ),
      contactInformationModel: ContactInformationModel(
        companyName: quotationDetailsModel.company,
        name: quotationDetailsModel.contactPerson,
        mobile: quotationDetailsModel.mobile,
        email: quotationDetailsModel.email,
        address: quotationDetailsModel.address,
        remarks: quotationDetailsModel.remarks,
      ),
      quotationNo: quotationDetailsModel.id,
      qreID: quotationDetailsModel.qreID,
      reID: quotationDetailsModel.reID,
      subTotal: quotationDetailsModel.subtotal,
      discount: quotationDetailsModel.discount,
      advanced: quotationDetailsModel.advance!.toDouble(),
    );
    if (quotationDetailsModel.fleetDetails != null) {
      for (var fleet in quotationDetailsModel.fleetDetails!) {
        model.listOfFleets.add(FleetModel(
          seatTemp: Seats(stID: fleet.stID, stTitle: fleet.seatTemplate),
          makers: FleetMakers(
            fmID: fleet.fmID,
            fmTitle: fleet.fleetMakers,
          ),
          fleetType: FleetType(ftID: fleet.ftID, ftTitle: fleet.fleetType),
          coach: Coach(
              coachID: fleet.coachID ?? '',
              coachTitle: fleet.coachTitle ?? '--'),
          rent: fleet.rent,
        ));
      }
    }
    return model;
  }

  _downloadFile({open = false}) async {
    EasyLoading.show(status: AppLocalizations.of(context)!.downloading);
    pdfFile = await downloadFile(
        getFileNameFromUrl(quotationDetailsModel.pdfLink ?? ''),
        quotationDetailsModel.pdfLink);
    EasyLoading.dismiss();
    if (open) {
      if (pdfFile != null) {
        OpenFilex.open(pdfFile!.path).then((value) {
          showMsgOnSnackBar(context, value.message);
        }).catchError((err) {
          showMsgOnSnackBar(
              context, AppLocalizations.of(context)!.something_went_wrong);
        });
      } else {
        showMsgOnSnackBar(
            context, AppLocalizations.of(context)!.something_went_wrong);
      }
    } else {
      if (pdfFile != null) {
        Share.shareXFiles([XFile(pdfFile!.path)]);
      } else {
        showMsgOnSnackBar(
            context, AppLocalizations.of(context)!.something_went_wrong);
      }
    }
  }
}
