import 'dart:developer';

import 'package:appscwl_specialhire/models/reservation/expense/expense_init_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropdownWithSearchField<T> extends StatelessWidget {
  final List<T>? dropDownValueList;
  final void Function(T) callBack;
  final String label;
  final bool showSearch;
  final Mode mode;
  final T? selectedValue;

  const DropdownWithSearchField({
    Key? key,
    required this.dropDownValueList,
    required this.label,
    required this.callBack,
    required this.selectedValue,
    this.showSearch = true,
    this.mode = Mode.DIALOG,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      maxHeight: _getDynamicHeight(),
      // popupBackgroundColor: Colors.red,
      popupSafeArea: PopupSafeAreaProps(top: mode != Mode.MENU ? true : false),
      // dialogMaxWidth: 20,
      filterFn: filterSearchList,

      mode: mode,
      showSearchBox: showSearch,
      showSelectedItems: true,
      compareFn: compareFunction,
      searchFieldProps: buildTextFieldProps(),
      popupTitle: _buildPopupTitle(context),
      dropdownSearchDecoration: buildInputDecoration(context),
      items: dropDownValueList,
      itemAsString: (object) => object.toString(),
      popupItemDisabled: shouldDisabled,
      selectedItem: selectedValue,
      onChanged: (T? value) {
        callBack(value!);
      },
      validator: (value) {
        return null;
      },
    );
  }

  bool shouldDisabled(item) {
    if (item.runtimeType == Staff) {
      final staff = item as Staff;

      return !staff.isAvailable;
    }
    if (item.runtimeType == Fleets) {
      final fleet = item as Fleets;

      return !fleet.isAvailable;
    }
    return false;
  }

  bool compareFunction(found, expected) =>
      found.toString() == expected.toString();

  bool filterSearchList(object, filter) => object
      .toString()
      .toLowerCase()
      .contains(filter!.toString().toLowerCase());

  InputDecoration buildInputDecoration(BuildContext context) {
    return InputDecoration(
      label: Text(
        label,
      ),
      floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
      border: OutlineInputBorder(),
    );
  }

  TextFieldProps buildTextFieldProps() {
    return const TextFieldProps(
      autofocus: true,
      textInputAction: TextInputAction.search,
    );
  }

  double _getDynamicHeight() => dropDownValueList != null
      ? (dropDownValueList!.length > 6
          ? 600
          : dropDownValueList!.length > 2
              ? dropDownValueList!.length * 82
              : mode == Mode.DIALOG
                  ? 170
                  : dropDownValueList!.length == 1
                      ? 50
                      : 120)
      : 170;

  Widget? _buildPopupTitle(context) => mode != Mode.MENU
      ? Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              Expanded(child: Text(label)),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close))
            ],
          ),
        )
      : null;
}
