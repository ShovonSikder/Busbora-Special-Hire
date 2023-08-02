import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

///The class T should override toString() method

class SSDropdownSearchOnDialog<T> extends StatefulWidget {
  final String label;
  final Function(T?) onSelection;
  final List<T> dropdownValueList;
  T? selectedValue;
  final bool showClearButton;
  SSDropdownSearchOnDialog({
    Key? key,
    this.label = '',
    required this.dropdownValueList,
    required this.onSelection,
    this.selectedValue,
    this.showClearButton = false,
  }) : super(key: key);

  @override
  State<SSDropdownSearchOnDialog> createState() =>
      _SSDropdownSearchOnDialogState();
}

class _SSDropdownSearchOnDialogState<T>
    extends State<SSDropdownSearchOnDialog> {
  final _selectedValueController = TextEditingController();
  List<T> tempList = [];
  final _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _selectedValueController.text =
          widget.selectedValue != null ? widget.selectedValue.toString() : '';
    });
  }

  @override
  void dispose() {
    _selectedValueController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedValue == null) {
      _clearField();
    }
    return InkWell(
      onTap: () {
        tempList = [...widget.dropdownValueList];
        openDialogAndSetValue(context);
      },
      child: TextField(
        controller: _selectedValueController,
        focusNode: _focusNode,
        readOnly: true,
        enabled: false,
        decoration: InputDecoration(
          disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          suffixIcon: buildSuffixRow(),
          label: Text(
            widget.label,
          ),
          floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Row buildSuffixRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showClearButton)
          SizedBox(
            width: 45,
            child: Center(
              child: ElevatedButton(
                  onPressed: () {
                    _clearField();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      onPrimary: Colors.grey,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero)),
                  child: const Icon(
                    Icons.clear,
                    size: 22,
                  )),
            ),
          ),
        const Icon(Icons.arrow_drop_down),
      ],
    );
  }

  void _clearField() {
    widget.selectedValue = null;
    _selectedValueController.clear();
    widget.onSelection(null);
  }

  openDialogAndSetValue(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                titlePadding: EdgeInsets.all(12),
                contentPadding: EdgeInsets.all(8),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.label),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      popupSearchTextField(setState),
                      tempList.isNotEmpty
                          ? Flexible(
                              child: ListView(
                                shrinkWrap: true,
                                children: tempList
                                    .map(
                                      (item) => ListTile(
                                        onTap: () {
                                          _selectedValueController.text =
                                              item.toString();
                                          widget.onSelection(item);
                                          Navigator.pop(
                                              context, item.toString());
                                        },
                                        title: Text(
                                          item.toString(),
                                          style: selectedItemTextStyle(
                                              item, context),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Text(
                                  AppLocalizations.of(context)!.no_data_found)),
                    ],
                  ),
                ),
              ),
            ));
  }

  TextField popupSearchTextField(StateSetter setState) {
    return TextField(
      autofocus: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(8),
      ),
      onChanged: (value) {
        _filterList(value);
        setState(() {});
      },
    );
  }

  TextStyle selectedItemTextStyle(item, BuildContext context) {
    return TextStyle(
        color: item.toString() == _selectedValueController.text
            ? Theme.of(context).primaryColor
            : null);
  }

  void _filterList(String value) {
    if (value.isNotEmpty) {
      tempList = [];
      for (var item in widget.dropdownValueList) {
        if (item.toString().toLowerCase().contains(value.toLowerCase())) {
          tempList.add(item);
        }
      }
    } else {
      tempList = [...widget.dropdownValueList];
    }
  }
}
