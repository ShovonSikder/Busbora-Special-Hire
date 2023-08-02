import 'dart:convert';
import 'dart:developer';

import 'package:appscwl_specialhire/db/backend/server_helper.dart';
import 'package:appscwl_specialhire/models/reservation/expense/expense_init_model.dart';
import 'package:appscwl_specialhire/models/reservation/passenger_info_model.dart';
import 'package:appscwl_specialhire/models/reservation/r_sheet_model.dart';
import 'package:appscwl_specialhire/models/reservation/reservation_brief_model.dart';
import 'package:appscwl_specialhire/models/reservation/reservation_details_model.dart';
import 'package:appscwl_specialhire/models/reservation/transition_history_model.dart';
import 'package:appscwl_specialhire/utils/constants/constants.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:flutter/material.dart';

import '../../db/shared_preferences.dart';

class ReservationProvider extends ChangeNotifier {
  ReservationBriefModel? reservationBriefModel;
  Map<String, String?> currentSearchQuery = {
    'id': '',
    'from': '',
    'to': '',
    'formDate': getFormattedDate(DateTime.now(), datePattern),
    'toDate': getFormattedDate(DateTime.now(), datePattern),
  };
  void clearCurrentSearchQuery() {
    currentSearchQuery = {
      'id': '',
      'from': '',
      'to': '',
      'formDate': getFormattedDate(DateTime.now(), datePattern),
      'toDate': getFormattedDate(DateTime.now(), datePattern),
    };
  }

  Future<void> getReservationList() async {
    final response = await ServerHelper.getReservationList(
        await AppSharedPref.getUserAuthCode(),
        searchQuery: currentSearchQuery);
    if (json.decode(response.body)['status'] == 1) {
      reservationBriefModel =
          ReservationBriefModel.fromJson(json.decode(response.body));
      notifyListeners();
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from ReservationProvider');
    }
  }

  Future<void> searchReservation(Map<String, String?> searchQuery) async {
    currentSearchQuery = searchQuery;
    final response = await ServerHelper.getReservationList(
        await AppSharedPref.getUserAuthCode(),
        searchQuery: searchQuery);
    if (json.decode(response.body)['status'] == 1) {
      reservationBriefModel =
          ReservationBriefModel.fromJson(json.decode(response.body));

      notifyListeners();
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from ReservationProvider Search');
    }
  }

  Future<String> createReservationFromQuotation(String id) async {
    log('call here with id: $id');
    final response = await ServerHelper.createReservationFromQuotation(
        await AppSharedPref.getUserAuthCode(), id);
    if (json.decode(response.body)['status'] == 1) {
      getReservationList();
      return json.decode(response.body)['reservationDetails']['id'] as String;
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      Future.error('Data fetch error from ReservationProvider add');
    }
    return '';
  }

  Future<ReservationDetailsModel> getReservationDetails(String id) async {
    final response = await ServerHelper.getReservationDetails(
        await AppSharedPref.getUserAuthCode(), id);

    if (json.decode(response.body)['status'] == 1) {
      return ReservationDetailsModel.fromJson(json.decode(response.body));
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from ReservationProvider');
    }
  }

  Future<RSheetModel> getReservationRSheetDetails(String id) async {
    final response = await ServerHelper.getReservationDetails(
        await AppSharedPref.getUserAuthCode(), id);
    log(response.body);
    if (json.decode(response.body)['status'] == 1) {
      return RSheetModel.fromJson(json.decode(response.body));
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from ReservationProvider');
    }
  }

  Future<void> deleteReservation(String reID) async {
    final response = await ServerHelper.deleteReservation(
        await AppSharedPref.getUserAuthCode(), reID);
    if (json.decode(response.body)['status'] == 1) {
      getReservationList();
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from ReservationProvider');
    }
  }

  Future<Map<String, dynamic>> makeReservationTransition(String reservationId,
      int transitionType, double amount, String note) async {
    final response = await ServerHelper.reservationTransition(
        await AppSharedPref.getUserAuthCode(),
        reservationId,
        transitionType,
        amount,
        note);

    if (json.decode(response.body)['status'] == 1) {
      getReservationList();
      return json.decode(response.body);
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from ReservationProvider');
    }
  }

  Future<TransitionHistoryModel> getTransitionHistory(
      String reservationReId) async {
    final response = await ServerHelper.getTransitionHistory(
        await AppSharedPref.getUserAuthCode(), reservationReId);
    if (json.decode(response.body)['status'] == 1) {
      return TransitionHistoryModel.fromJson(json.decode(response.body));
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from ReservationProvider');
    }
  }

  Future<ExpenseInitModel> initExpense(String reservationReId) async {
    final response = await ServerHelper.initExpense(
        await AppSharedPref.getUserAuthCode(), reservationReId);
    if (json.decode(response.body)['status'] == 1) {
      return ExpenseInitModel.fromJson(json.decode(response.body));
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from ReservationProvider');
    }
  }

  addExpense(ExpenseInitModel expenseSubmitModel, String reID) async {
    final response = await ServerHelper.addExpense(
        await AppSharedPref.getUserAuthCode(), expenseSubmitModel, reID);
    print(json.decode(response.body));
    if (json.decode(response.body)['status'] == 1) {
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from ReservationProvider');
    }
  }

  passengerInfoInit(rfID) async {
    final response = await ServerHelper.passengerInfoInit(
        await AppSharedPref.getUserAuthCode(), rfID);
    if (json.decode(response.body)['status'] == 1) {
      return PassengerInfoModel.fromJson(json.decode(response.body));
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from ReservationProvider');
    }
  }

  updatePassengerInfo(
      PassengerInfoModel passengerInfoModel, String rfID) async {
    final response = await ServerHelper.updatePassengerInfo(
        await AppSharedPref.getUserAuthCode(), passengerInfoModel, rfID);
    if (json.decode(response.body)['status'] == 1) {
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from ReservationProvider');
    }
  }
}
