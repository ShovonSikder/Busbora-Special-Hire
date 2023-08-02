import 'dart:convert';

import 'package:appscwl_specialhire/db/backend/server_helper.dart';
import 'package:appscwl_specialhire/db/local/local_db_helper.dart';
import 'package:appscwl_specialhire/db/shared_preferences.dart';
import 'package:appscwl_specialhire/models/all_districts_model.dart';
import 'package:appscwl_specialhire/utils/constants/constants.dart';
import 'package:flutter/material.dart';

import '../utils/helper_function.dart';

class DistrictsProvider extends ChangeNotifier {
  AllDistrictsModel? allDistrictsModel;

  Future<void> initDistricts({int from = fromApi}) async {
    if (from == fromApi) {
      final response = await ServerHelper.districtsInit(
          await AppSharedPref.getUserAuthCode());
      if (json.decode(response.body)['status'] == 1) {
        allDistrictsModel =
            AllDistrictsModel.fromJson(json.decode(response.body));
        saveToLocalDB();
        notifyListeners();
      } else if (json.decode(response.body)['status'] == 4) {
        return Future.error('4');
      } else {
        Future.error('Data fetch error from DistrictsProvider');
      }
    } else if (from == fromLocal) {
      fetchFromLocalDB();
    }
  }

  void saveToLocalDB() {
    if (allDistrictsModel != null) {
      LocalDBHelper.insertDistricts(allDistrictsModel!);
      AppSharedPref.setAppInstallStatus(false);
    }
  }

  void fetchFromLocalDB() async {
    allDistrictsModel =
        AllDistrictsModel(districts: await LocalDBHelper.fetchDistricts());
    notifyListeners();
  }
}
