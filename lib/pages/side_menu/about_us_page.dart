import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);
  static const String routeName = '/about_us';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.about_us),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // OutlinedButton.icon(
            //   onPressed: () {},
            //   icon: Icon(Icons.play_arrow_outlined),
            //   label: Text('Play store'),
            // ),
            Text(
              AppLocalizations.of(context)!.company_domain,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8).copyWith(top: 20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Image.asset(
                  'assets/images/logo_SH.png',
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 0,
            color: Colors.transparent,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {},
                child: const Icon(Icons.facebook),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Icon(Icons.language),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Icon(Icons.email),
              ),
            ],
          ),
          const Divider(
            thickness: 0,
            color: Colors.transparent,
          ),
          Container(
            child: const Text(
              'This special hire App to be used by registered special hire operators in Tanzania.',
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
