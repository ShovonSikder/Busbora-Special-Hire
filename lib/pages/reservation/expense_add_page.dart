import 'package:appscwl_specialhire/customewidgets/reservation_expense_form.dart';
import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/models/reservation/expense/expense_init_model.dart';
import 'package:appscwl_specialhire/providers/resrvation/reservation_provider.dart';
import 'package:appscwl_specialhire/utils/constants/api_constants/http_code.dart';
import 'package:appscwl_specialhire/utils/constants/color_constants.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../customewidgets/confirm_button.dart';
import '../../customewidgets/loading/small_circular_loading.dart';
import '../../utils/constants/text_constants/text_style_constants.dart';

class ExpanseAddPage extends StatefulWidget {
  static const String routeName = '/expanse_add_page';
  const ExpanseAddPage({Key? key}) : super(key: key);

  @override
  State<ExpanseAddPage> createState() => _ExpanseAddPageState();
}

class _ExpanseAddPageState extends State<ExpanseAddPage> {
  late String reservationReId;
  late ExpenseInitModel expenseSubmitModel;

  @override
  void didChangeDependencies() {
    reservationReId = ModalRoute.of(context)!.settings.arguments as String;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.special_hire_expense),
      ),
      body: buildFutureBuilder(),
    );
  }

  FutureBuilder<Object?> buildFutureBuilder() {
    return FutureBuilder(
      future: _initExpense(reservationReId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final ExpenseInitModel model = snapshot.data as ExpenseInitModel;
            expenseSubmitModel = model;
            return buildExpenseForm(context, model);
          }
          if (snapshot.hasError) {
            return Text(AppLocalizations.of(context)!.something_went_wrong);
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/no_internet.svg',
                height: 200,
              ),
              const SizedBox(
                height: 80,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 10,
                      primary: specialHireThemePrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5)),
                  child: Text(
                    AppLocalizations.of(context)!.reload,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildExpenseForm(BuildContext context, ExpenseInitModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeaderSectionCard(context, model),
                buildSectionLabel(
                    context, AppLocalizations.of(context)!.add_expense),
                model.reservationFleets != null &&
                        model.reservationFleets!.isNotEmpty
                    ? Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(top: 8),
                          children: model.reservationFleets!
                              .map((fleet) => ReservationExpenseForm(
                                    reservationFleets: fleet,
                                    fleets: model.fleets,
                                    staffs: model.staff,
                                  ))
                              .toList(),
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: Text(
                              AppLocalizations.of(context)!.fleet_list_empty),
                        ),
                      ),
              ],
            ),
          ),
        ),
        buildBottomContainer(),
      ],
    );
  }

  Container buildBottomContainer() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: cardBackgroundColor, width: 2),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ConfirmButton(
            btnText: AppLocalizations.of(context)!.save,
            callBack: () {
              _saveExpense();
            }),
      ),
    );
  }

  Padding buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildHeaderSectionCard(BuildContext context, ExpenseInitModel model) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: ListTile(
        tileColor: Colors.white,
        title: Transform.translate(
          offset: const Offset(-15, 0),
          child: Text(
            '${model.id}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              // fontSize: 18,
            ),
          ),
        ),
        subtitle: Transform.translate(
          offset: const Offset(-15, 0),
          child: Text(
            '${AppLocalizations.of(context)!.route}: ${model.route}',
            style: const TextStyle(color: Colors.black),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        leading: Icon(
          Icons.money,
          color: Theme.of(context).primaryColor,
          size: 28,
        ),
      ),
    );
  }

  _initExpense(String reservationReId) async {
    EasyLoading.show();
    ExpenseInitModel? expanseInitModel;
    try {
      expanseInitModel =
          await Provider.of<ReservationProvider>(context, listen: false)
              .initExpense(reservationReId);
      EasyLoading.dismiss();
    } catch (err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    }
    return expanseInitModel;
  }

  void _saveExpense() {
    // FocusScope.of(context).unfocus();
    showConfirmationDialog(context,
        msg:
            '${AppLocalizations.of(context)!.save_expense_confirm}(${expenseSubmitModel.id})',
        onConfirmation: (status) {
      if (status) {
        _hitApi();
      }
    });
  }

  void _hitApi() {
    EasyLoading.show(status: AppLocalizations.of(context)!.please_wait);
    Provider.of<ReservationProvider>(context, listen: false)
        .addExpense(expenseSubmitModel, reservationReId)
        .then((value) {
      EasyLoading.dismiss();
      showMsgOnSnackBar(context, AppLocalizations.of(context)!.expense_added);
      Navigator.pop(context);
    }).catchError((err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    });
  }
}
