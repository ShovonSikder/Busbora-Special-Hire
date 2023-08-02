import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TermsAndConditionPage extends StatelessWidget {
  const TermsAndConditionPage({Key? key}) : super(key: key);
  static const String routeName = '/terms_and_conditions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.term_con),
      ),
      body: const Center(
        child: Text('Coming soon...'),
      ),
    );
  }
}
