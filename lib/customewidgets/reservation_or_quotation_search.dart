import 'package:appscwl_specialhire/customewidgets/confirm_button.dart';
import 'package:appscwl_specialhire/customewidgets/pick_and_show_date_time.dart';
import 'package:appscwl_specialhire/customewidgets/search/dropdown_search_field.dart';
import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/providers/districts_provider.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_queue_provider.dart';
import 'package:appscwl_specialhire/providers/resrvation/reservation_provider.dart';
import 'package:appscwl_specialhire/utils/constants/constants.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../models/all_districts_model.dart';

class ReservationOrQuotationSearch extends StatefulWidget {
  final bool isForReservation;
  const ReservationOrQuotationSearch({Key? key, this.isForReservation = false})
      : super(key: key);

  @override
  State<ReservationOrQuotationSearch> createState() =>
      _ReservationOrQuotationSearchState();
}

class _ReservationOrQuotationSearchState
    extends State<ReservationOrQuotationSearch> {
  final _searchController = TextEditingController();
  final _dateController = TextEditingController();
  final _quotationNoController = TextEditingController();
  Districts? from;
  Districts? to;
  DateTimeRange? dateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  late DistrictsProvider districtsProvider;

  bool showClear = false;
  @override
  void didChangeDependencies() {
    districtsProvider = Provider.of<DistrictsProvider>(context);
    _searchController.text = _dateController.text =
        '${getFormattedDate(dateTimeRange!.start, datePattern)} ${AppLocalizations.of(context)!.to} ${getFormattedDate(dateTimeRange!.end, datePattern)}';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
      child: InkWell(
        onTap: () {
          buildShowModalBottomSheet(context);
        },
        child: Stack(
          children: [
            TextField(
              controller: _searchController,
              maxLines: 4,
              minLines: 1,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.search,
                contentPadding: const EdgeInsets.only(
                    top: 18, bottom: 18, right: 10, left: 15),
                enabled: false,
                filled: true,
                fillColor: Colors.white,
                suffixIcon: !showClear ? const Icon(Icons.search) : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            if (showClear)
              Positioned(
                top: 0,
                bottom: 0,
                right: 5,
                child: TextButton(
                  onPressed: () {
                    _clearField(true);
                    _searchDB(false);
                  },
                  child: Text(AppLocalizations.of(context)!.clear),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showGeneralDialog(
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) => const SizedBox.shrink(),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();
              },
              child: SafeArea(
                child: Dialog(
                  insetPadding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: topSheetUI(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Padding topSheetUI(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 5.0, right: 5.0, top: 15, bottom: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            //from
            Padding(
              padding: bottomSheetSearchPadding,
              child: DropdownSearchField<Districts>(
                showClearButton: true,
                selectedValue: from,
                onSelection: <Districts>(value) {
                  from = value;
                },
                label: AppLocalizations.of(context)!.from,
              ),
            ),
            //to
            Padding(
              padding: bottomSheetSearchPadding,
              child: DropdownSearchField<Districts>(
                showClearButton: true,
                selectedValue: to,
                onSelection: <Districts>(value) {
                  to = value;
                },
                label: AppLocalizations.of(context)!.to,
              ),
            ),
            //date
            Padding(
              padding: bottomSheetSearchPadding,
              child: PickAndShowDateTime(
                showClearButton: true,
                onClear: () {
                  dateTimeRange = null;
                  _dateController.clear();
                },
                controller: _dateController,
                callBack: () {
                  _pickDate();
                },
                label: AppLocalizations.of(context)!.date,
              ),
            ),
            //or
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
              child: Row(
                children: [
                  const Expanded(child: Divider(color: Colors.black54)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      AppLocalizations.of(context)!.or,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ),
                  const Expanded(child: Divider(color: Colors.black54)),
                ],
              ),
            ),
            //quotation no
            Padding(
              padding: bottomSheetSearchPadding,
              child: TextField(
                controller: _quotationNoController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.only(
                      top: 15, bottom: 15, right: 10, left: 12),
                  label: Text(widget.isForReservation
                      ? AppLocalizations.of(context)!.special_hire_no
                      : AppLocalizations.of(context)!.quotation_no),
                ),
              ),
            ),
            ConfirmButton(
              btnText: AppLocalizations.of(context)!.search,
              callBack: _searchDB,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _dateController.dispose();
    _quotationNoController.dispose();

    super.dispose();
  }

  _pickDate() async {
    final pickedDate = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1800),
      lastDate: DateTime(9999),
    );
    if (pickedDate != null) {
      dateTimeRange = pickedDate;
      _dateController.text =
          '${getFormattedDate(pickedDate.start, datePattern)} ${AppLocalizations.of(context)!.to} ${getFormattedDate(pickedDate.end, datePattern)}';
    }
  }

  _searchDB([bool isCallFromTopSheet = true]) {
    String searchString = '';
    showClear = false;
    if (_quotationNoController.text.isNotEmpty) {
      searchString += _quotationNoController.text;
      showClear = true;
      _clearField();
    } else {
      if (from != null) {
        showClear = true;
        if (searchString.isNotEmpty) {
          searchString += '\n';
        }
        searchString += from!.distTitle!;
      }
      if (to != null) {
        showClear = true;
        searchString += ' - ' + to!.distTitle!;
      }
      if (dateTimeRange != null && _dateController.text.isNotEmpty) {
        showClear = true;
        if (searchString.isNotEmpty) {
          searchString += '\n';
        }
        searchString += _dateController.text;
      }
    }
    setState(() {});
    _searchController.text = searchString;
    if (widget.isForReservation) {
      //search for reservation
      _searchReservation(searchString);
    } else {
      //search for quotations
      _searchQuotation(searchString);
    }

    if (isCallFromTopSheet) {
      Navigator.pop(context);
    }
    // setState(() {});
  }

  void _searchReservation(String searchString) {
    EasyLoading.show();
    //search for reservation
    Provider.of<ReservationProvider>(context, listen: false)
        .searchReservation(_generateSearchQuery(searchString))
        .then((value) {
      EasyLoading.dismiss();
    }).catchError((err) {
      EasyLoading.dismiss();
      showMsgOnSnackBar(context, err.toString());
    });
  }

  void _clearField([clearAll = false]) {
    from = null;
    to = null;
    if (clearAll) {
      _quotationNoController.text = '';
    }
    dateTimeRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
    _dateController.text = '';
  }

  void _searchQuotation(String searchString) {
    EasyLoading.show();
    //search for reservation
    Provider.of<QuotationQueueProvider>(context, listen: false)
        .searchQuotation(_generateSearchQuery(searchString))
        .then((value) {
      EasyLoading.dismiss();
    }).catchError((err) {
      EasyLoading.dismiss();
      showMsgOnSnackBar(context, err.toString());
    });
  }

  Map<String, String?> _generateSearchQuery(String searchString) {
    if (_quotationNoController.text.isNotEmpty) {
      return {
        'id': _quotationNoController.text,
        'from': '',
        'to': '',
        'formDate': '',
        'toDate': '',
      };
    }
    if (searchString.isEmpty) {
      dateTimeRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
      _searchController.text = _dateController.text =
          '${getFormattedDate(dateTimeRange!.start, datePattern)} ${AppLocalizations.of(context)!.to} ${getFormattedDate(dateTimeRange!.end, datePattern)}';
      showClear = false;

      return {
        'id': '',
        'from': '',
        'to': '',
        'formDate': dateTimeRange != null
            ? getFormattedDate(dateTimeRange!.start, datePattern)
            : '',
        'toDate': dateTimeRange != null
            ? getFormattedDate(dateTimeRange!.end, datePattern)
            : '',
      };
    }
    return {
      'id': '',
      'from': from != null ? from!.distID : '',
      'to': to != null ? to!.distID : '',
      'formDate': dateTimeRange != null
          ? getFormattedDate(dateTimeRange!.start, datePattern)
          : '',
      'toDate': dateTimeRange != null
          ? getFormattedDate(dateTimeRange!.end, datePattern)
          : '',
    };
  }
}

//ignore this comments
//
// DropdownWithSearchField<Districts>(
// dropDownValueList: districtsProvider.allDistrictsModel!.districts,
// label: AppLocalizations.of(context)!.from,
// callBack: (value) {
// from = value;
// },
// selectedValue: from,
// )

// Positioned(
// right: 30,
// top: 0,
// bottom: 0,
// child: TextButton(
// onPressed: () {
// _clearField();
// _searchDB(false);
// },
// child: Text(
// AppLocalizations.of(context)!.all,
// style: const TextStyle(fontSize: 16),
// ),
// ),
// ),

// else {
// dateTimeRange =
// DateTimeRange(start: DateTime.now(), end: DateTime.now());
// _dateController.text =
// '${getFormattedDate(dateTimeRange!.start, datePattern)} ${AppLocalizations.of(context)!.to} ${getFormattedDate(dateTimeRange!.end, datePattern)}';
// if (searchString.isNotEmpty) {
// searchString += '\n';
// }
// searchString += _dateController.text;
// }
