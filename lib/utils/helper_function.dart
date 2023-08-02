import 'package:appscwl_specialhire/db/local/local_db_helper.dart';
import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/utils/constants/api_constants/json_keys.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../customewidgets/printer/select_printer.dart';
import '../db/shared_preferences.dart';
import '../pages/launcher_page.dart';

String getFormattedDate(DateTime date, String pattern) =>
    DateFormat(pattern).format(date);

showMsgOnDialog(BuildContext context, {required String msg}) => showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
            ),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.ok,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

showMsgOnSnackBar(BuildContext context, String msg) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(msg: msg);
}

showConfirmationDialog(
  BuildContext context, {
  required String msg,
  String leftBtnTxt = 'Cancel',
  String rightBtnTxt = 'Ok',
  required Function(bool) onConfirmation,
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.special_hire),
        content: Text(msg),
        actions: [
          //left button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirmation(false);
            },
            child: Text(
              leftBtnTxt,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          //right button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirmation(true);
            },
            child: Text(
              rightBtnTxt,
            ),
          ),
        ],
      ),
    );
//show select printer dialog
void showSelectPrinterDialog(BuildContext context,
    {required Function callBack}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(5),
          content: SelectPrinterWidget(
            onSubmitted: () {
              Navigator.pop(context);
              callBack();
            },
          ),
        );
      });
}

MaterialColor buildMaterialColorFromColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

void expiredLoginAction(BuildContext context) async {
  showMsgOnSnackBar(context, AppLocalizations.of(context)!.login_expired);
  await AppSharedPref.removeEntry(jsonKeyAuthCode);
  await AppSharedPref.removeEntry(loginStatus);
  await AppSharedPref.removeEntry(installStatus);
  await LocalDBHelper.deleteDistricts();
  Navigator.pushNamedAndRemoveUntil(
      context, LauncherPage.routeName, (_) => false);
}

void openDrawer(context) {
  Scaffold.of(context).openDrawer();
}

String listToString(List<String?> list) {
  String result = '';
  for (var item in list) {
    result.isNotEmpty ? result += ', ${item ?? ''}' : result += item ?? '';
  }
  return result;
}

String getFileNameFromUrl(String url) {
  final splitArray = url.split('/');
  return splitArray.isNotEmpty
      ? splitArray[splitArray.length - 1]
      : DateTime.now().toString();
}

String addPunctuationInMoney(String moneyAmount) {
  String result = '';

  final moneyParts = moneyAmount.split('.');
  result = moneyParts[0];

  final numOfDigit = result.length;

  if (numOfDigit > 3) {
    final charArray = result.split('');
    if (charArray[numOfDigit - 4] != '-') {
      charArray.insert(numOfDigit - 3, ',');
    }

    for (var i = numOfDigit - 3; i > 3;) {
      if (charArray[i - 4] != '-') {
        charArray.insert(i -= 3, ',');
      } else {
        i -= 3;
      }
    }

    result = charArray.join();
  }
  if (moneyParts.length == 2) {
    result = '$result.${moneyParts[1]}';
  }

  return result;
}
