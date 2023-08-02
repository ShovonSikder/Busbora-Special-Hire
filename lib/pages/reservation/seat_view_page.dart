import 'dart:developer';

import 'package:appscwl_specialhire/customewidgets/reservation_fleet_seat_form.dart';
import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/models/reservation/passenger_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../customewidgets/confirm_button.dart';
import '../../providers/resrvation/reservation_provider.dart';
import '../../utils/constants/api_constants/http_code.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/helper_function.dart';

class SeatViewPage extends StatelessWidget {
  static const String routeName = '/seat_view_page';
  SeatViewPage({Key? key}) : super(key: key);
  PassengerInfoModel? passengerInfoModel;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> reservationInfo =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.seat_view),
      ),
      body: FutureBuilder(
        future: _passengerInfoInit(context, reservationInfo['rfID']),
        builder: (context, _snapshot) {
          if (_snapshot.hasData) {
            final PassengerInfoModel model =
                _snapshot.data as PassengerInfoModel;
            passengerInfoModel = model;
            return buildSeatUI(context, model, reservationInfo);
          }
          if (_snapshot.hasError) {
            return Text(AppLocalizations.of(context)!.something_went_wrong);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget buildHeaderSectionCard(
      BuildContext context, Map<String, dynamic> reservationInfo) {
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
        contentPadding: const EdgeInsets.all(8).copyWith(left: 15, right: 8),
        leading: Icon(
          Icons.event_seat,
          color: Theme.of(context).primaryColor,
          size: 50,
        ),
        title: Text(
          reservationInfo['reservationId'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            // fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (reservationInfo['route'] != null &&
                reservationInfo['route'].isNotEmpty)
              Text(
                reservationInfo['route'],
                style: const TextStyle(color: Colors.black),
              ),
            if (reservationInfo['seat_temp'] != null &&
                reservationInfo['seat_temp'].isNotEmpty)
              Text(
                reservationInfo['seat_temp'],
                style: const TextStyle(color: Colors.black),
              ),
            if (reservationInfo['fleet_type'] != null &&
                reservationInfo['fleet_type'].isNotEmpty)
              Text(
                reservationInfo['fleet_type'],
                style: const TextStyle(color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }

  Container buildBottomContainer(context, reservationInfo) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: cardBackgroundColor, width: 2),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ConfirmButton(
            btnText: AppLocalizations.of(context)!.save,
            callBack: () {
              _savePassengerInfo(context, reservationInfo['rfID']);
            }),
      ),
    );
  }

  _passengerInfoInit(context, rfID) async {
    EasyLoading.show();
    PassengerInfoModel? _passengerInfoModel;
    try {
      _passengerInfoModel =
          await Provider.of<ReservationProvider>(context, listen: false)
              .passengerInfoInit(rfID);
      EasyLoading.dismiss();
    } catch (err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    }
    return _passengerInfoModel;
  }

  Widget buildSeatUI(
      BuildContext context, PassengerInfoModel model, reservationInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeaderSectionCard(context, reservationInfo),
                  const Divider(
                    height: 3,
                    // thickness: 1.5,
                  ),
                  buildSectionLabel(
                      context, AppLocalizations.of(context)!.seat_view),
                  model.passengerInfo != null && model.passengerInfo!.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: model.passengerInfo!
                              .map(
                                (passenger) => ReservationFleetSeatForm(
                                  passengerInfo: passenger,
                                  ticketFaireType: model.ticketFairType,
                                ),
                              )
                              .toList(),
                        )
                      : Expanded(
                          child: Center(
                          child: Text(
                              AppLocalizations.of(context)!.no_fleet_found),
                        ))
                ],
              ),
            ),
          ),
        ),
        buildBottomContainer(context, reservationInfo),
      ],
    );
  }

  Padding buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(label),
    );
  }

  void _savePassengerInfo(context, String rfID) {
    FocusScope.of(context).unfocus();
    // final validationMsg =
    //     validatePassengerInfo(passengerInfoModel!.passengerInfo!);
    // validationMsg['status']
    if (true) {
      showConfirmationDialog(context,
          msg: AppLocalizations.of(context)!.save_passenger_info_confirm,
          onConfirmation: (status) {
        if (status) {
          _hitApi(context, rfID);
        }
      });
    }
    // else {
    //   showMsgOnDialog(context,
    //       msg:
    //           '${AppLocalizations.of(context)!.name_number_validation_msg} ${validationMsg['msg']} ');
    // }
  }

  void _hitApi(context, String rfID) {
    EasyLoading.show(status: AppLocalizations.of(context)!.please_wait);
    Provider.of<ReservationProvider>(context, listen: false)
        .updatePassengerInfo(passengerInfoModel!, rfID)
        .then((value) {
      EasyLoading.dismiss();
      showMsgOnSnackBar(context, AppLocalizations.of(context)!.saved);
      Navigator.pop(context);
    }).catchError((err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    });
  }

  Map<String, dynamic> validatePassengerInfo(
      List<PassengerInfo> passengerInfo) {
    for (var passenger in passengerInfo) {
      if ((passenger.name!.isEmpty && passenger.number!.isEmpty) ||
          (passenger.name!.isNotEmpty && passenger.number!.isNotEmpty)) {
        // continue;
      } else {
        return {'status': false, 'msg': passenger.seatName};
      }
    }
    return {'status': true, 'msg': ''};
  }
}
