import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/models/quotation/fleet_model.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_add_provider.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../utils/helper_class.dart';

class FleetMemoTile extends StatefulWidget {
  final FleetModel fleet;
  final isEnable;
  const FleetMemoTile({Key? key, required this.fleet, required this.isEnable})
      : super(key: key);

  @override
  State<FleetMemoTile> createState() => _FleetMemoTileState();
}

class _FleetMemoTileState extends State<FleetMemoTile> {
  final _fieldController = TextEditingController();

  late QuotationAddProvider quotationAddProvider;
  @override
  void initState() {
    quotationAddProvider =
        Provider.of<QuotationAddProvider>(context, listen: false);
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (widget.fleet.rent != null) {
        _fieldController.text = widget.fleet.rent! > 0
            ? addPunctuationInMoney(widget.fleet.rent!.toStringAsFixed(2))
            : '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fleet.rent == null || widget.fleet.rent! == 0) {
      _fieldController.clear();
    }
    return ListTile(
      contentPadding: EdgeInsets.all(0).copyWith(left: 15),
      title: Text(
        widget.fleet.coach!.coachTitle!,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      dense: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.fleet.fleetType!.ftTitle!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            widget.fleet.makers!.fmTitle!,
            style: TextStyle(color: Colors.black),
          ),
          Text(
            widget.fleet.seatTemp!.stTitle!,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      trailing: SizedBox(
        width: 150,
        height: 40,
        child: TextField(
          controller: _fieldController,
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.end,
          keyboardType: TextInputType.number,
          enabled: widget.isEnable,
          // textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8),
            hintText: AppLocalizations.of(context)!.rent_price,
            border: const OutlineInputBorder(),
          ),
          inputFormatters: [
            CurrencyInputFormatter(),
          ],
          onChanged: (value) {
            try {
              widget.fleet.rent = value.isNotEmpty
                  ? double.parse(value.replaceAll(',', ''))
                  : 0;
              quotationAddProvider.calculateBill();
              print('calculating...');
            } catch (err) {}
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fieldController.dispose();
    super.dispose();
  }
}
