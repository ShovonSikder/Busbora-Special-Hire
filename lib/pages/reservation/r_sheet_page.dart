import 'dart:convert';
import 'dart:developer';

import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/models/reservation/r_sheet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../db/shared_preferences.dart';
import '../../providers/resrvation/reservation_provider.dart';
import '../../providers/user/user_provider.dart';
import '../../utils/bluetooth_printer.dart';
import '../../utils/constants/api_constants/http_code.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/helper_function.dart';

class RSheet extends StatefulWidget {
  static const String routeName = '/r_sheet_page';
  const RSheet({Key? key}) : super(key: key);

  @override
  State<RSheet> createState() => _RSheetState();
}

class _RSheetState extends State<RSheet> {
  late String reservationId;
  late RSheetModel rSheetmodel;
  static const platform = MethodChannel('com.busbora.specialhire/printer');
  @override
  void didChangeDependencies() {
    reservationId = ModalRoute.of(context)!.settings.arguments as String;
    super.didChangeDependencies();
  }

  Future<void> printManifest() async {
    String batteryLevel = "";
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    // reservationDetailsModel ??=
    // await _getReservationDetails(model!.reReservationId ?? '');
    var pCode = await AppSharedPref.getPrinterCode();

    Map<String, Object> jsonData = {
      "printerType": pCode,
      "jsonData": {
        "bTitle": '${userProvider.userModel!.bTitle}',
        "address": "${rSheetmodel.reservationDetails!.pBox ?? ''}",
        "email": "${rSheetmodel.reservationDetails!.bEmail ?? ''}",
        "tel": "${rSheetmodel.reservationDetails!.tel ?? ''}",
        "tin": "${rSheetmodel.reservationDetails!.TIN ?? ''}",
        "vrn": "${rSheetmodel.reservationDetails!.vrn ?? ''}",

        //contact info
        "spHireNo": '${rSheetmodel.reservationDetails!.id ?? 'xxxx'}',

        //j info
        "route":
            '${rSheetmodel.reservationDetails!.origin ?? ''} ${AppLocalizations.of(context)!.to} ${rSheetmodel.reservationDetails!.destination ?? ''}',

        "depDateTime": '${rSheetmodel.reservationDetails!.journeyDate ?? ''}',
        "retDateTime":
            '${rSheetmodel.reservationDetails!.type == 'With return' ? rSheetmodel.reservationDetails!.returnDate : ''}',
        "remark": '${rSheetmodel.reservationDetails!.remarks ?? ''}',

        //rSheet
        "rSheet": "${_getRSheetAsString()}",
        "printDate":
            "${getFormattedDate(DateTime.now(), 'dd-MM-yyyy hh:mm:ss a')}",
        "findUs": "${rSheetmodel.reservationDetails!.WEB ?? ''}",
        "downloadApp": "${rSheetmodel.reservationDetails!.WEB ?? ''}",
      }
    };
    log(jsonEncode(jsonData));

    try {
      if (pCode == 'Bluetooth') {
        if (await BluetoothPrinter.isConnected() == 'true') {
          BluetoothPrinter.printManifest(
              jsonData['jsonData'] as Map<String, Object>);
        } else {
          if (await BluetoothPrinter.connectByMacAddress(
                  await AppSharedPref.getBTPrinterMac()) ==
              'true') {
            BluetoothPrinter.printManifest(
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

        var result = platform.invokeMethod('printManifest', jsonData);
        // batteryLevel = 'Battery level at $result % .';
      }
    } on PlatformException catch (e) {
      //  batteryLevel = "Failed to get battery level: '${e.message}'.";
      print('platform error');
    }

    log("batteryLevel: $batteryLevel");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: buildAppBar(context),
      body: FutureBuilder(
        future: _getReservationRSheetDetails(reservationId),
        builder: (context, _snapshot) {
          if (_snapshot.connectionState == ConnectionState.done) {
            if (_snapshot.hasData) {
              rSheetmodel = _snapshot.data as RSheetModel;

              return buildRSheetUI(context, rSheetmodel);
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
      ),
    );
  }

  Future<RSheetModel?>? _getReservationRSheetDetails(String id) async {
    EasyLoading.show();
    RSheetModel? rSheetModel;
    try {
      rSheetModel =
          await Provider.of<ReservationProvider>(context, listen: false)
              .getReservationRSheetDetails(id);

      EasyLoading.dismiss();
    } catch (err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    }
    return rSheetModel;
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.reservation_sheet),
      actions: [
        IconButton(
          onPressed: () async {
            var dontShowAgain = await AppSharedPref.getDontShowAgain();
            if (dontShowAgain) {
              printManifest();
            } else {
              showSelectPrinterDialog(context, callBack: () {
                printManifest();
              });
            }
          },
          icon: const Icon(Icons.print),
        ),
      ],
    );
  }

  Widget buildRSheetUI(BuildContext context, RSheetModel rSheetmodel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildJourneyInfoSectionCard(context, rSheetmodel),
          buildSectionLabel(context, AppLocalizations.of(context)!.sheet),
          rSheetmodel.reservationDetails!.fleetDetails != null &&
                  rSheetmodel.reservationDetails!.fleetDetails!.isNotEmpty
              ? Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: ListView(
                      // shrinkWrap: true,
                      children: rSheetmodel.reservationDetails!.fleetDetails!
                          .map(
                            (fleet) => buildFleetContainer(fleet),
                          )
                          .toList(),
                    ),
                  ),
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

  Widget buildJourneyInfoSectionCard(BuildContext context, RSheetModel? model) {
    return Card(
      margin: const EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
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
            '${model!.reservationDetails!.id}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              // fontSize: 18,
            ),
          ),
          // Text(
          //   '${model!.origin} - ${model.destination}',
          //   style: const TextStyle(
          //     fontWeight: FontWeight.bold,
          //     // fontSize: 18,
          //   ),
          // ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((model.reservationDetails!.origin != null &&
                      model.reservationDetails!.origin!.isNotEmpty) ||
                  (model.reservationDetails!.destination != null &&
                      model.reservationDetails!.destination!.isNotEmpty))
                Text(
                  '${model.reservationDetails!.origin} - ${model.reservationDetails!.destination}',
                  style: const TextStyle(color: Colors.black),
                ),
              if ((model.reservationDetails!.pickUp != null &&
                      model.reservationDetails!.pickUp!.isNotEmpty) ||
                  (model.reservationDetails!.dropping != null &&
                      model.reservationDetails!.dropping!.isNotEmpty))
                Text(
                  '${model.reservationDetails!.pickUp} - ${model.reservationDetails!.dropping}',
                  style: const TextStyle(color: Colors.black),
                ),
              if (model.reservationDetails!.journeyDate != null &&
                  model.reservationDetails!.journeyDate!.isNotEmpty)
                Text(
                  model.reservationDetails!.journeyDate ?? '',
                  style: const TextStyle(color: Colors.black),
                ),
              if (model.reservationDetails!.type == '2')
                Text(
                  '${model.reservationDetails!.returnDate} (${AppLocalizations.of(context)!.r})',
                  style: const TextStyle(color: Colors.black),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFleetContainer(FleetDetails fleet) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: ExpansionTile(
        leading: Icon(
          Icons.directions_car,
          color: Theme.of(context).primaryColor,
          size: 30,
        ),
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        trailing: const Icon(
          Icons.arrow_drop_down,
          size: 30,
        ),
        tilePadding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
        title: Text(
          '${AppLocalizations.of(context)!.fleet}: ${fleet.fleet ?? ' '}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppLocalizations.of(context)!.driver}: ${fleet.driver ?? ''}',
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              '${AppLocalizations.of(context)!.helper}: ${fleet.helper ?? ' '}',
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              '${AppLocalizations.of(context)!.guide}: ${fleet.guide ?? ' '}',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        children: fleet.passengers != null && fleet.passengers!.isNotEmpty
            ? fleet.passengers!
                .map((passenger) => buildSeatContainer(passenger))
                .toList()
            : [Text(AppLocalizations.of(context)!.no_data_found)],
      ),
    );
  }

  Container buildSeatContainer(Passengers passenger) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: cardBackgroundColor))),
      child: ListTile(
        tileColor: Colors.white,
        leading: Text(passenger.seatName ?? 'xx'),
        title: Text(passenger.name ?? ''),
        subtitle: Text(passenger.number ?? ''),
        trailing: Text(passenger.passengerType ?? ''),
      ),
    );
  }

  _getRSheetAsString() {
    String result = '';
    for (var fleet in rSheetmodel.reservationDetails!.fleetDetails!) {
      result += '${AppLocalizations.of(context)!.fleet}: ${fleet.fleet}\n'
          '${AppLocalizations.of(context)!.driver}: ${fleet.driver}\n'
          '${AppLocalizations.of(context)!.guide}: ${fleet.guide}\n'
          '${AppLocalizations.of(context)!.helper}: ${fleet.helper}\n\n'
          '${AppLocalizations.of(context)!.passenger_list}:\n';
      int numOfPassenger = 0;
      for (var passenger in fleet.passengers!) {
        if ((passenger.name != null && passenger.name!.isNotEmpty) ||
            (passenger.number != null && passenger.number!.isNotEmpty)) {
          numOfPassenger++;
          result +=
              '#${passenger.seatName} ${passenger.name ?? ''} ${passenger.number ?? ''}\n';
        }
      }
      result +=
          '${AppLocalizations.of(context)!.passenger_total}: $numOfPassenger\n\n';
    }
    return result;
  }
}
