import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/helper_class.dart';

class MemoTile extends StatefulWidget {
  final String label;
  final double? value;
  final bool isEnable;
  final Function(double)? callBack;
  const MemoTile(
      {Key? key,
      required this.label,
      this.value,
      required this.isEnable,
      required this.callBack})
      : super(key: key);

  @override
  State<MemoTile> createState() => _MemoTileState();
}

class _MemoTileState extends State<MemoTile> {
  final _fieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (widget.value != null && widget.value! > 0) {
        _fieldController.text =
            addPunctuationInMoney(widget.value!.toStringAsFixed(2));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnable && widget.value != null) {
      _fieldController.text =
          addPunctuationInMoney(widget.value!.toStringAsFixed(2));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(right: 0, left: 15),
      child: Row(
        children: [
          Expanded(
            child: Text(widget.label),
          ),
          SizedBox(
            // padding: EdgeInsets.only(right: 10),
            width: 150,
            height: 40,
            child: TextField(
              controller: _fieldController,
              enabled: widget.isEnable,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                hintText: widget.label,
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                if (widget.isEnable) CurrencyInputFormatter(),
              ],
              onChanged: (value) {
                if (widget.callBack != null) {
                  try {
                    widget.callBack!(value.isNotEmpty
                        ? double.parse(value.replaceAll(',', ''))
                        : 0);
                  } catch (err) {}
                }
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fieldController.dispose();
    super.dispose();
  }
}
