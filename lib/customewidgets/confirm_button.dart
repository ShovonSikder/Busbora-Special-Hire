import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/constants/text_field_constants.dart';

class ConfirmButton extends StatelessWidget {
  final Function() callBack;
  final String btnText;
  const ConfirmButton({Key? key, required this.btnText, required this.callBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: textFieldPadding,
      child: SizedBox(
        height: 45,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30)),
          onPressed: () {
            callBack();
          },
          child: Text(
            btnText,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
