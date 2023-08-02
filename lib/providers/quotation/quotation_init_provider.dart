import 'dart:convert';
import 'dart:developer';

import 'package:appscwl_specialhire/db/backend/server_helper.dart';
import 'package:appscwl_specialhire/models/quotation/quotation_init_model.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:flutter/cupertino.dart';

import '../../db/shared_preferences.dart';

class QuotationInitProvider extends ChangeNotifier {
  QuotationInitModel? quotationInitModel;
  Future<void> initQuotationFields() async {
    final response =
        await ServerHelper.quotationInit(await AppSharedPref.getUserAuthCode());
    log(response.body);
    if (json.decode(response.body)['status'] == 1) {
      quotationInitModel =
          QuotationInitModel.fromJson(json.decode(response.body));
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      return Future.error('Data fetch error from QuotationInitProvider');
    }
  }
}
