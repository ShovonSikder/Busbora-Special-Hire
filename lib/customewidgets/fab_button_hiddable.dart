import 'package:appscwl_specialhire/providers/fab_button_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/add_quotation/quotation_add_page.dart';

class FabButtonHidable extends StatelessWidget {
  const FabButtonHidable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FabButtonProvider>(
        builder: (context, provider, child) => Visibility(
              visible: provider.visibility,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, QuotationAddPage.routeName,
                      arguments: [false, false]);
                },
                child: const Icon(Icons.add),
              ),
            ));
  }
}
