import 'dart:convert';
import 'dart:developer';

import 'package:appscwl_specialhire/db/backend/server_helper.dart';
import 'package:appscwl_specialhire/models/quotation/contact_information_model.dart';
import 'package:appscwl_specialhire/models/quotation/fleet_model.dart';
import 'package:appscwl_specialhire/models/quotation/journey_information_model.dart';
import 'package:appscwl_specialhire/models/quotation/quotation_model.dart';
import 'package:flutter/material.dart';

import '../../db/shared_preferences.dart';
import '../../utils/constants/api_constants/json_keys.dart';
import '../../utils/helper_function.dart';

class QuotationAddProvider extends ChangeNotifier {
  QuotationModel quotationModel = QuotationModel();

  void insertContactInfo(ContactInformationModel contactModel) {
    quotationModel.contactInformationModel = contactModel;
    notifyListeners();
  }

  void insertJourneyInfo(JourneyInformationModel journeyModel) {
    quotationModel.journeyInformationModel = journeyModel;
    notifyListeners();
  }

  ///no use right now
  void addFleet(FleetModel fleetModel) {
    quotationModel.listOfFleets.add(fleetModel);
    notifyListeners();
  }

  ///no use right now
  void removeFleet(int index) {
    quotationModel.listOfFleets.removeAt(index);
    calculateBill();
    notifyListeners();
  }

  void calculateBill() {
    _calculateSubtotal();
    _calculatePayable();
    _calculateDue();
    notifyListeners();
  }

  void _calculateSubtotal() {
    double sum = 0.0;
    for (var fleet in quotationModel.listOfFleets) {
      if (fleet.rent != null) {
        sum += fleet.rent!;
      }
    }
    quotationModel.subTotal = sum;
  }

  void _calculatePayable() {
    if (quotationModel.discount != null) {
      quotationModel.totalPayable =
          quotationModel.subTotal! - quotationModel.discount!;
    }
  }

  void _calculateDue() {
    if (quotationModel.advanced != null) {
      quotationModel.due =
          quotationModel.totalPayable! - quotationModel.advanced!;
    } else {
      quotationModel.due = quotationModel.totalPayable!;
    }
  }

  void clearProvider() {
    quotationModel = QuotationModel();
  }

  void initiateQuotation(QuotationModel quotation) {
    quotationModel = quotation;
    calculateBill();
    // notifyListeners();
  }

  Future<Map<String, dynamic>> addReservationQuotation() async {
    final response = await ServerHelper.addReservationQuotation(
        await AppSharedPref.getUserAuthCode(), quotationModel);
    log('create: ${response.body}');
    if (json.decode(response.body)['status'] == 1) {
      return {
        'qreID': json.decode(response.body)[jsonKeyQuotationDetails]
            [jsonKeyQreID],
        'id': json.decode(response.body)[jsonKeyQuotationDetails]['id'],
      };
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      // print('Err res ${response.body}');
      return Future.error('Data insert error from QuotationAddProvider');
    }
  }

  void addFleetList(List<FleetModel> tempSelectedFleets) {
    quotationModel.listOfFleets = [];
    quotationModel.listOfFleets = [...tempSelectedFleets];
    calculateBill();
    // notifyListeners();
  }

  updateReservationQuotation({isReservation}) async {
    final response = await ServerHelper.updateReservationQuotation(
        await AppSharedPref.getUserAuthCode(), quotationModel,
        isReservation: isReservation);
    log(response.body);
    if (json.decode(response.body)['status'] == 1) {
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      // print('Err res ${response.body}');
      return Future.error('Data insert error from QuotationAddProvider');
    }
  }
}
