import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants/api_constants/json_keys.dart';

class AppSharedPref {
  static Future<bool> setUserAuthCode(String value) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString(jsonKeyAuthCode, value);
  }

  static Future<bool> setLoginStatus(bool value) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool(loginStatus, value);
  }

  static Future<bool> getLoginStatus() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(loginStatus) ?? false;
  }

  static Future<bool> setAppInstallStatus(bool status) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool(installStatus, status);
  }

  static Future<String> getUserAuthCode() async {
    final pref = await SharedPreferences.getInstance();
    // print(pref.getString(authCode) ?? '');
    return pref.getString(jsonKeyAuthCode) ?? '';
  }

  static Future<bool> isAppFirstInstalled() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(installStatus) ?? true;
  }

  static Future<bool> setUserInfo(String value) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString(userInfo, value);
  }

  static Future<String> getUserInfo() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userInfo) ?? '';
  }

  static Future<bool> removeEntry(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }

  static Future<bool> setPrinterCode(String value) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString(printerCode, value);
  }

  static Future<bool> setBTPrinterMac(String value) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString(btMac, value);
  }

  static Future<String> getBTPrinterMac() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(btMac) ?? '';
  }

  static Future<String> getPrinterCode() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(printerCode) ?? 'no_printer';
  }

  static Future<bool> setDontShowAgain(bool value) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool(dontShowAgain, value);
  }

  static Future<bool> getDontShowAgain() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(dontShowAgain) ?? false;
  }

  static Future<bool> setLanguageCode(String value) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString(lnCode, value);
  }

  static Future<String> getLanguageCode() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(lnCode) ?? 'en';
  }
}
