import 'dart:convert';
import 'dart:developer';

import 'package:appscwl_specialhire/db/backend/server_helper.dart';
import 'package:appscwl_specialhire/models/quotation/quotation_brief_model.dart';
import 'package:appscwl_specialhire/models/quotation/quotation_details_model.dart';
import 'package:flutter/cupertino.dart';

import '../../db/shared_preferences.dart';
import '../../utils/constants/constants.dart';
import '../../utils/helper_function.dart';

class QuotationQueueProvider extends ChangeNotifier {
  QuotationBriefModel? quotationBriefModel;
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

  Future<void> getQuotationList() async {
    final response = await ServerHelper.getQuotationList(
        await AppSharedPref.getUserAuthCode(),
        searchQuery: currentSearchQuery);
    if (json.decode(response.body)['status'] == 1) {
      quotationBriefModel =
          QuotationBriefModel.fromJson(json.decode(response.body));
      notifyListeners();
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from QuotationQueueProvider');
    }
  }

  Future<void> searchQuotation(Map<String, String?> searchQuery) async {
    currentSearchQuery = searchQuery;

    final response = await ServerHelper.getQuotationList(
        await AppSharedPref.getUserAuthCode(),
        searchQuery: searchQuery);
    if (json.decode(response.body)['status'] == 1) {
      quotationBriefModel =
          QuotationBriefModel.fromJson(json.decode(response.body));
      notifyListeners();
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from QuotationQueueProvider');
    }
  }

  Future<QuotationDetailsModel?> getQuotationDetails(String id) async {
    final response = await ServerHelper.getQuotationDetails(
        await AppSharedPref.getUserAuthCode(), id);
    if (json.decode(response.body)['status'] == 1) {
      return QuotationDetailsModel.fromJson(json.decode(response.body));
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from QuotationQueueProvider');
    }
  }

  Future<void> deleteQuotation(String qreID) async {
    final response = await ServerHelper.deleteQuotation(
        await AppSharedPref.getUserAuthCode(), qreID);
    if (json.decode(response.body)['status'] == 1) {
      getQuotationList();
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from QuotationQueueProvider');
    }
  }
}
