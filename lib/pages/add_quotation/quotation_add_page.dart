import 'package:appscwl_specialhire/customewidgets/confirm_button.dart';
import 'package:appscwl_specialhire/customewidgets/fleet_memo_tile.dart';
import 'package:appscwl_specialhire/customewidgets/memo_tile.dart';
import 'package:appscwl_specialhire/db/backend/server_helper.dart';
import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/models/quotation/quotation_model.dart';
import 'package:appscwl_specialhire/pages/add_quotation/add_fleet_details_page.dart';
import 'package:appscwl_specialhire/pages/view_quotation/quotation_details_page.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_add_provider.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_init_provider.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_queue_provider.dart';
import 'package:appscwl_specialhire/providers/resrvation/reservation_provider.dart';
import 'package:appscwl_specialhire/providers/user/user_provider.dart';
import 'package:appscwl_specialhire/utils/constants/color_constants.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../customewidgets/quotation_add_card.dart';
import '../../customewidgets/quotation_add_card_header.dart';
import '../../utils/constants/api_constants/http_code.dart';
import '../../utils/constants/api_constants/json_keys.dart';
import '../../utils/constants/text_constants/text_style_constants.dart';

class QuotationAddPage extends StatefulWidget {
  const QuotationAddPage({Key? key}) : super(key: key);
  static const String routeName = '/add_quotation';
  @override
  State<QuotationAddPage> createState() => _QuotationAddPageState();
}

class _QuotationAddPageState extends State<QuotationAddPage> {
  bool isDirectReservation = false;
  bool isEditingMode = false;
  bool isReservation = false;
  String? currencySymbol;

  @override
  void initState() {
    _initializeQuotationFields(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)!.settings.arguments as List<bool>;
    isEditingMode = args[0];
    isReservation = args[1];

    if (!isEditingMode) {
      Provider.of<QuotationAddProvider>(context, listen: false).clearProvider();
    }
    try {
      currencySymbol = Provider.of<UserProvider>(context, listen: false)
          .userModel!
          .allCurrency![0]
          .crSymbol;
    } on Exception catch (e) {
      currencySymbol = 'TZS';
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //card to open contact info input page
                  QuotationAddCard(
                    serial: AppLocalizations.of(context)!.num_1,
                    title: AppLocalizations.of(context)!.contact_information,
                  ),

                  //card to open journey info input page
                  QuotationAddCard(
                    serial: AppLocalizations.of(context)!.num_2,
                    title: AppLocalizations.of(context)!.journey_information,
                  ),

                  //fleet details card
                  buildFleetDetailsSection(context),

                  //reservation checkbox
                  if (!isEditingMode) buildCheckboxField(context),
                ],
              ),
            ),
          ),
          buildBottomContainer(),
        ],
      ),
    );
  }

  Card buildFleetDetailsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QuotationAddCardHeader(
              serial: AppLocalizations.of(context)!.num_3,
              title: AppLocalizations.of(context)!.fleet_details,
            ),

            //list of all selected fleet
            buildFleetListConsumer(),
          ],
        ),
      ),
    );
  }

  Card buildCheckboxField(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Checkbox(
            value: isDirectReservation,
            onChanged: (value) {
              setState(() {
                isDirectReservation = value!;
              });
            },
          ),
          Text(AppLocalizations.of(context)!.direct_reservation),
        ],
      ),
    );
  }

  Consumer<QuotationAddProvider> buildFleetListConsumer() {
    return Consumer<QuotationAddProvider>(
      builder: (context, provider, child) {
        final list = provider.quotationModel.listOfFleets;
        return list.isNotEmpty
            ? Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: list
                        .map(
                          (fleet) => FleetMemoTile(
                            fleet: fleet,
                            isEnable:
                                provider.quotationModel.advanced == null ||
                                    provider.quotationModel.advanced! <= 0,
                          ),
                        )
                        .toList(),
                  ),

                  //subtotal
                  MemoTile(
                      label: AppLocalizations.of(context)!.sub_total,
                      value: provider.quotationModel.subTotal,
                      callBack: null,
                      isEnable: false),
                  MemoTile(
                    label: AppLocalizations.of(context)!.discount,
                    isEnable: true,
                    value: provider.quotationModel.discount,
                    callBack: (value) {
                      provider.quotationModel.discount = value;
                      provider.calculateBill();
                    },
                  ),
                  MemoTile(
                    label: AppLocalizations.of(context)!.total_payable,
                    value: provider.quotationModel.totalPayable,
                    isEnable: false,
                    callBack: null,
                  ),
                  MemoTile(
                    label: AppLocalizations.of(context)!.advance_payment,
                    value: provider.quotationModel.advanced,
                    isEnable: true,
                    callBack: (value) {
                      provider.quotationModel.advanced = value;
                      provider.calculateBill();
                    },
                  ),
                  MemoTile(
                    label: AppLocalizations.of(context)!.due,
                    isEnable: false,
                    value: provider.quotationModel.due,
                    callBack: null,
                  ),
                ],
              )
            : TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddFleetDetailsPage.routeName);
                },
                child: Text(AppLocalizations.of(context)!.no_fleet_selected));
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(isEditingMode
          ? isReservation
              ? AppLocalizations.of(context)!.update_reservation
              : AppLocalizations.of(context)!.update_quotation
          : AppLocalizations.of(context)!.reservation_quotation_add),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context, false);
        },
        icon: const Icon(
          Icons.arrow_back,
        ),
      ),
    );
  }

  Container buildBottomContainer() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: cardBackgroundColor, width: 2)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0).copyWith(top: 0, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.total,
                    style: bottomSheetHeaderStyle,
                  ),
                  Consumer<QuotationAddProvider>(
                    builder: (context, provider, child) => Flexible(
                      child: Text(
                        provider.quotationModel.totalPayable != null
                            ? '$currencySymbol ${addPunctuationInMoney(provider.quotationModel.due!.toStringAsFixed(2))}'
                            : '$currencySymbol 00.00',
                        textAlign: TextAlign.left,
                        style: bottomSheetHeaderStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ConfirmButton(
                btnText: isEditingMode
                    ? AppLocalizations.of(context)!.update
                    : AppLocalizations.of(context)!.save,
                callBack: () {
                  isEditingMode ? _updateQuotation() : _addQuotation();
                }),
          ],
        ),
      ),
    );
  }

  void _addQuotation() async {
    QuotationModel model =
        Provider.of<QuotationAddProvider>(context, listen: false)
            .quotationModel;

    if (model.contactInformationModel == null) {
      showMsgOnDialog(context,
          msg: AppLocalizations.of(context)!.contact_require);
      return; //validation msg
    }
    if (model.journeyInformationModel == null) {
      showMsgOnDialog(context,
          msg: AppLocalizations.of(context)!.journey_require);
      return; //validation msg
    }
    if (model.listOfFleets.isEmpty) {
      showMsgOnDialog(context,
          msg: AppLocalizations.of(context)!.fleet_require);
      return; //validation msg
    }

    final validationMsg = model.validateFleetRents();
    if (!validationMsg['status']) {
      showMsgOnDialog(
        context,
        msg:
            '${AppLocalizations.of(context)!.enter_valid_rent} ${AppLocalizations.of(context)!.fo_r} ${validationMsg['msg']}',
      );
      return;
    }
    if (model.discount! < 0 || model.discount! > model.subTotal!.toDouble()) {
      showMsgOnSnackBar(
          context, AppLocalizations.of(context)!.discount_validation_msg);
      return;
    }
    if (model.advanced! < 0 ||
        model.advanced! > model.totalPayable!.toDouble()) {
      showMsgOnSnackBar(
          context, AppLocalizations.of(context)!.advance_validation_msg);
      return;
    }
    await showConfirmationDialog(context,
        msg: isDirectReservation
            ? AppLocalizations.of(context)!.confirm_reservation_msg
            : AppLocalizations.of(context)!.confirm_quotation_msg,
        rightBtnTxt: AppLocalizations.of(context)!.yes,
        leftBtnTxt: AppLocalizations.of(context)!.no, onConfirmation: (status) {
      if (status) {
        hitApi();
      }
    });
  }

  void hitApi() {
    // FocusScope.of(context).requestFocus(FocusNode());
    String? id;
    EasyLoading.show();
    //hit api
    Provider.of<QuotationAddProvider>(context, listen: false)
        .addReservationQuotation()
        .then((value) async {
      id = value['id'];
      if (isDirectReservation) {
        try {
          id = await Provider.of<ReservationProvider>(context, listen: false)
              .createReservationFromQuotation(value[jsonKeyQreID]!);

          showMsgOnSnackBar(context,
              AppLocalizations.of(context)!.reservation_creation_success);
        } catch (err) {
          showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
        }
      } else {
        showMsgOnSnackBar(
            context, AppLocalizations.of(context)!.quotation_creation_success);
        Provider.of<QuotationQueueProvider>(context, listen: false)
            .getQuotationList();
      }

      EasyLoading.dismiss();
      Provider.of<QuotationAddProvider>(context, listen: false).clearProvider();
      Navigator.pop(context, false);
      Navigator.pushNamed(context, QuotationOrReservationDetails.routeName,
          arguments: [id, isDirectReservation]);
    }).catchError((err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    });
  }

  _updateQuotation() async {
    QuotationModel model =
        Provider.of<QuotationAddProvider>(context, listen: false)
            .quotationModel;

    if (model.contactInformationModel == null) {
      showMsgOnDialog(context,
          msg: AppLocalizations.of(context)!.contact_require);
      return; //validation msg
    }
    if (model.journeyInformationModel == null) {
      showMsgOnDialog(context,
          msg: AppLocalizations.of(context)!.journey_require);
      return; //validation msg
    }
    if (model.listOfFleets.isEmpty) {
      showMsgOnDialog(context,
          msg: AppLocalizations.of(context)!.fleet_require);
      return; //validation msg
    }

    final validationMsg = model.validateFleetRents();
    if (!validationMsg['status']) {
      showMsgOnDialog(
        context,
        msg:
            '${AppLocalizations.of(context)!.enter_valid_rent} ${AppLocalizations.of(context)!.fo_r} ${validationMsg['msg']}',
      );
      return;
    }
    //validate amount
    if (model.discount! < 0 || model.discount! > model.subTotal!.toDouble()) {
      showMsgOnSnackBar(
          context, AppLocalizations.of(context)!.discount_validation_msg);
      return;
    }
    if (model.advanced! < 0 ||
        model.advanced! > model.totalPayable!.toDouble()) {
      showMsgOnSnackBar(
          context, AppLocalizations.of(context)!.advance_validation_msg);
      return;
    }
    await showConfirmationDialog(context,
        msg: AppLocalizations.of(context)!.confirm_quotation_update_msg,
        rightBtnTxt: AppLocalizations.of(context)!.yes,
        leftBtnTxt: AppLocalizations.of(context)!.no, onConfirmation: (status) {
      if (status) {
        hitUpdateApi();
      }
    });
  }

  void _initializeQuotationFields(BuildContext context) async {
    try {
      EasyLoading.show();
      await Provider.of<QuotationInitProvider>(context, listen: false)
          .initQuotationFields();
      EasyLoading.dismiss();
    } catch (err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    }
  }

  void hitUpdateApi() {
    EasyLoading.show();
    //hit api
    Provider.of<QuotationAddProvider>(context, listen: false)
        .updateReservationQuotation(isReservation: isReservation)
        .then((value) async {
      showMsgOnSnackBar(
          context, AppLocalizations.of(context)!.quotation_update_success);
      Provider.of<QuotationAddProvider>(context, listen: false).clearProvider();
      EasyLoading.dismiss();
      Navigator.pop(context, true);
    }).catchError((err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    });
  }
}
