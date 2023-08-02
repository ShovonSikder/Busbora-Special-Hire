import 'package:appscwl_specialhire/pages/reservation/expense_add_page.dart';
import 'package:appscwl_specialhire/pages/reservation/r_sheet_page.dart';
import 'package:appscwl_specialhire/pages/reservation/transition_form.dart';
import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/models/quotation/quotation_brief_model.dart';
import 'package:appscwl_specialhire/pages/reservation/transition_history_page.dart';
import 'package:appscwl_specialhire/pages/view_quotation/quotation_details_page.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_queue_provider.dart';
import 'package:appscwl_specialhire/providers/resrvation/reservation_provider.dart';
import 'package:appscwl_specialhire/utils/constants/color_constants.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../providers/user/user_provider.dart';
import '../utils/constants/api_constants/http_code.dart';

class ReservationOrQuotationTile extends StatelessWidget {
  final ReservationQuotation reservationQuotation;
  final bool isReservation;
  const ReservationOrQuotationTile(
      {Key? key, required this.reservationQuotation, this.isReservation = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //actions for quotation
    final quotationActionList = [
      //create reservation
      PopupMenuItem(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _createReservation(context);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.add,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.create_special_hire,
                    // style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              height: 0,
            ),
          ],
        ),
      ),
      //print
      // PopupMenuItem(
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       TextButton(
      //         onPressed: () {
      //           Navigator.pop(context);
      //         },
      //         child: Row(
      //           children: [
      //             const Icon(
      //               Icons.print,
      //             ),
      //             const SizedBox(
      //               width: 5,
      //             ),
      //             Text(
      //               AppLocalizations.of(context)!.print,
      //               // style: TextStyle(color: Colors.green),
      //             ),
      //           ],
      //         ),
      //       ),
      //       const Divider(
      //         thickness: 1,
      //         height: 0,
      //       ),
      //     ],
      //   ),
      // ),
      //details
      PopupMenuItem(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context, QuotationOrReservationDetails.routeName,
                    arguments: [reservationQuotation.id, isReservation]);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.edit,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.details,
                    // style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              height: 0,
            ),
          ],
        ),
      ),
      //delete
      PopupMenuItem(
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
            _delete(context);
          },
          child: Row(
            children: [
              const Icon(
                Icons.delete,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                AppLocalizations.of(context)!.delete,
                // style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    ];
    final reservationActionList = [
      //expense
      PopupMenuItem(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, ExpanseAddPage.routeName,
                    arguments: reservationQuotation.reID);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.money,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.expense,
                    // style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              height: 0,
            ),
          ],
        ),
      ),
      //pay
      PopupMenuItem(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showTransitionForm(context);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.payment,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.pay,
                    // style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              height: 0,
            ),
          ],
        ),
      ),
      //history
      PopupMenuItem(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showTransitionHistory(context);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.history,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.history,
                    // style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              height: 0,
            ),
          ],
        ),
      ),
      //r sheet
      PopupMenuItem(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RSheet.routeName,
                    arguments: reservationQuotation.id);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.library_books,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.r_sheet,
                    // style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              height: 0,
            ),
          ],
        ),
      ),
      //details
      PopupMenuItem(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context, QuotationOrReservationDetails.routeName,
                    arguments: [reservationQuotation.id, isReservation]);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.edit,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.details,
                    // style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
            if (reservationQuotation.paidStatus == 2)
              const Divider(
                thickness: 1,
                height: 0,
              ),
          ],
        ),
      ),
      //delete
      if (reservationQuotation.paidStatus == 2)
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
              _delete(context);
            },
            child: Row(
              children: [
                const Icon(
                  Icons.delete,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  AppLocalizations.of(context)!.delete,
                  // style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
    ];

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, QuotationOrReservationDetails.routeName,
            arguments: [reservationQuotation.id, isReservation]);
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12).copyWith(top: 8, right: 6),
          child: Row(
            crossAxisAlignment: isReservation
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reservationQuotation.id ?? 'Q.xx',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    //origin to dest
                    Text(
                      '${reservationQuotation.route}',
                    ),
                    //jdate
                    Text('${reservationQuotation.jDate}'),
                    if (reservationQuotation.type ==
                        AppLocalizations.of(context)!.with_return)
                      //rdate
                      Text(
                        '${reservationQuotation.rDate ?? 'null excp'} (${AppLocalizations.of(context)!.r})',
                      ),

                    //company name
                    if (reservationQuotation.company != null &&
                        reservationQuotation.company!.isNotEmpty)
                      Text(reservationQuotation.company!),
                    //name
                    Text(reservationQuotation.contPerson!),
                    //phone
                    Text(reservationQuotation.mobile!),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isReservation)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            '${Provider.of<UserProvider>(context, listen: false).userModel!.allCurrency![0].crSymbol}'
                            ' ${addPunctuationInMoney(reservationQuotation.totalAmount!.toStringAsFixed(2))}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: reservationQuotation.paidStatus == 1
                              ? Text(
                                  AppLocalizations.of(context)!.full_paid,
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                )
                              : reservationQuotation.paidStatus == 2
                                  ? Text(
                                      AppLocalizations.of(context)!.unpaid,
                                      style: TextStyle(
                                          color: Colors.red[900],
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      AppLocalizations.of(context)!.due,
                                      style: TextStyle(
                                          color: Colors.amber[900],
                                          fontWeight: FontWeight.bold),
                                    ),
                        ),
                      ],
                    ),
                  PopupMenuButton(
                    // elevation: 5,
                    itemBuilder: (context) {
                      return isReservation
                          ? reservationActionList
                          : quotationActionList;
                    },
                    tooltip: "",
                    child: const Padding(
                      padding: EdgeInsets.only(
                          left: 12.0, right: 6, top: 10, bottom: 10),
                      child: Icon(
                        Icons.more_vert,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showTransitionForm(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              // insetPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.all(0),
              titlePadding: const EdgeInsets.all(0),
              contentPadding: EdgeInsets.all(15),
              title: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: specialHireThemePrimary,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(0))),
                child: Text(
                  '${AppLocalizations.of(context)!.transition} (${reservationQuotation.id ?? 'xxx'})',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              content: TransitionForm(
                // name: reservationQuotation.contPerson ?? '',
                reservationId: reservationQuotation.id ?? 'xxx',
                reservationReId: reservationQuotation.reID ?? '',
                returnLimit: reservationQuotation.payAmount ?? 0,
                receiveLimit: reservationQuotation.dueAmount ?? 0,
                subTotal: reservationQuotation.totalAmount ?? 0,
                printInfo: reservationQuotation,
              ),
            ));
  }

  void _createReservation(BuildContext context) {
    showConfirmationDialog(
      context,
      msg: AppLocalizations.of(context)!.confirm_reservation_msg +
          ' (${reservationQuotation.id})',
      onConfirmation: (status) {
        if (status) {
          _hitApi(context);
        }
      },
    );
  }

  void _hitApi(BuildContext context) {
    EasyLoading.show();
    Provider.of<ReservationProvider>(context, listen: false)
        .createReservationFromQuotation(reservationQuotation.qreID!)
        .then((value) {
      showMsgOnSnackBar(
          context, AppLocalizations.of(context)!.reservation_creation_success);
      Provider.of<QuotationQueueProvider>(context, listen: false)
          .getQuotationList();
      EasyLoading.dismiss();
      Navigator.pushNamed(context, QuotationOrReservationDetails.routeName,
          arguments: [value, true]);
    }).catchError((err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    });
  }

  void _delete(context) {
    showConfirmationDialog(
      context,
      msg: AppLocalizations.of(context)!.delete_confirm_msg +
          ' (${reservationQuotation.id})',
      rightBtnTxt: AppLocalizations.of(context)!.delete,
      onConfirmation: (status) {
        if (status) {
          hitDelete(context);
        }
      },
    );
  }

  void hitDelete(context) {
    EasyLoading.show();
    if (isReservation) {
      //delete reservation
      _reservationDelete(context);
    } else {
      //delete quotation
      _quotationDelete(context);
    }
  }

  void _quotationDelete(context) {
    Provider.of<QuotationQueueProvider>(context, listen: false)
        .deleteQuotation(reservationQuotation.qreID ?? '')
        .then((value) {
      EasyLoading.dismiss();
      showMsgOnSnackBar(context, AppLocalizations.of(context)!.deleted_success);
    }).catchError((err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    });
  }

  void _reservationDelete(context) {
    Provider.of<ReservationProvider>(context, listen: false)
        .deleteReservation(reservationQuotation.reID ?? '')
        .then((value) {
      EasyLoading.dismiss();
      showMsgOnSnackBar(context, AppLocalizations.of(context)!.deleted_success);
    }).catchError((err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    });
  }

  void _showTransitionHistory(BuildContext context) {
    Navigator.pushNamed(context, TransitionHistoryPage.routeName,
        arguments: reservationQuotation.reID);
  }
}
