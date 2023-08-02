import 'dart:convert';

import 'package:appscwl_specialhire/db/backend/server_helper.dart';
import 'package:appscwl_specialhire/db/local/local_db_helper.dart';
import 'package:appscwl_specialhire/db/shared_preferences.dart';
import 'package:appscwl_specialhire/models/user/user_model.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/api_constants/json_keys.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;

  void initUser(dynamic jsonData) async {
    userModel = UserModel.fromJson(json.decode(jsonData));
    await AppSharedPref.setUserInfo(jsonEncode(userModel!.toJson()));
    notifyListeners();
  }

  Future<void> logOut() async {
    final response =
        await ServerHelper.logOut(await AppSharedPref.getUserAuthCode());
    if (json.decode(response.body)['status'] == 1) {
      userModel = null;
      await AppSharedPref.removeEntry(jsonKeyAuthCode);
      await AppSharedPref.removeEntry(loginStatus);
      await AppSharedPref.removeEntry(installStatus);
      await AppSharedPref.removeEntry(userInfo);
      await LocalDBHelper.deleteDistricts();
      notifyListeners();
    } else if (json.decode(response.body)['status'] == 4) {
      return Future.error('4');
    } else {
      Future.error('Can\'t logout something went wrong');
    }
  }
}
