import 'package:flutter/material.dart';

import '../../db/shared_preferences.dart';

class LocalProvider extends ChangeNotifier {
  Locale local = const Locale('en');
  void changeLocal(String lanCode, [bool init = false]) async {
    local = Locale(lanCode);
    await AppSharedPref.setLanguageCode(lanCode);
    if (!init) {
      notifyListeners();
    }
  }
}
