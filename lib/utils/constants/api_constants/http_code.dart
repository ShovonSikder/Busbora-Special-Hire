import 'dart:async';
import 'dart:io';

import '../../../l10n/app_localizations.dart';

abstract class HttpCode {
  static const int success = 200;
  static const String invalidLogin = '4';
  static String getFriendlyErrorMsg(context, err) {
    String errMsg;
    //filter appropriate error message
    if (err is SocketException) {
      errMsg = AppLocalizations.of(context)!.no_internet;
    } else if (err is TimeoutException) {
      errMsg = AppLocalizations.of(context)!.time_out;
    } else {
      errMsg = AppLocalizations.of(context)!.something_went_wrong;
    }
    return errMsg;
  }
}
