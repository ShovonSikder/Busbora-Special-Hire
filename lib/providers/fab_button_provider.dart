import 'package:flutter/material.dart';

class FabButtonProvider extends ChangeNotifier {
  bool visibility = true;
  void visibilityON() {
    if (!visibility) {
      visibility = true;
      notifyListeners();
    }
  }

  void visibilityOFF() {
    if (visibility) {
      visibility = false;
      notifyListeners();
    }
  }
}
