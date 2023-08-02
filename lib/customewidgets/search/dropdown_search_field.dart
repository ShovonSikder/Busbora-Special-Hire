import 'package:appscwl_specialhire/customewidgets/search/choose_districts.dart';
import 'package:flutter/material.dart';

class DropdownSearchField<T> extends StatefulWidget {
  final String label;
  final void Function(T?) onSelection;
  T? selectedValue;
  bool showClearButton;
  DropdownSearchField({
    Key? key,
    this.label = '',
    required this.onSelection,
    this.selectedValue,
    this.showClearButton = false,
  }) : super(key: key);

  @override
  State<DropdownSearchField> createState() => _DropdownSearchFieldState();
}

class _DropdownSearchFieldState<T> extends State<DropdownSearchField> {
  final _selectedValueController = TextEditingController();
  @override
  void initState() {
    _selectedValueController.text =
        widget.selectedValue != null ? widget.selectedValue.toString() : '';
    super.initState();
  }

  @override
  void dispose() {
    _selectedValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _selectedValueController,
      readOnly: true,
      onTap: () {
        openListAndSetValue(context);
      },
      decoration: InputDecoration(
        suffixIcon: buildSuffixRow(),
        contentPadding:
            const EdgeInsets.only(top: 15, bottom: 15, right: 10, left: 12),
        label: Text(
          widget.label,
        ),
        floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
        border: const OutlineInputBorder(),
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
        Icon(Icons.arrow_drop_down),
      ],
    );
  }

  void openListAndSetValue(BuildContext context) {
    Navigator.pushNamed(context, ChooseDistricts.routeName,
            arguments: widget.label)
        .then<T?>((value) {
      if (value != null) {
        widget.selectedValue = value;
        _selectedValueController.text = value.toString();
        widget.onSelection(value);
      }
      FocusScope.of(context).requestFocus(FocusNode());

      return null;
    });
  }

  void _clearField() {
    widget.selectedValue = null;
    _selectedValueController.clear();
    widget.onSelection(null);
  }
}
