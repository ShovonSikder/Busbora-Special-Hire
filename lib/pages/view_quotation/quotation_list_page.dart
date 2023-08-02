import 'dart:developer';

import 'package:appscwl_specialhire/customewidgets/fab_button_hiddable.dart';
import 'package:appscwl_specialhire/customewidgets/reservation_or_quotation_tile.dart';
import 'package:appscwl_specialhire/customewidgets/reservation_or_quotation_search.dart';
import 'package:appscwl_specialhire/pages/add_quotation/quotation_add_page.dart';
import 'package:appscwl_specialhire/providers/fab_button_provider.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_queue_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../customewidgets/appbar_with_userinfo.dart';
import '../../customewidgets/icon_text_floating_button.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/user/user_provider.dart';
import '../../utils/constants/api_constants/http_code.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/helper_function.dart';

class QuotationListPage extends StatefulWidget {
  // final Function(bool) fabCallback;

  const QuotationListPage({
    Key? key,
  }) : super(key: key);

  static const String routeName = '/quotation_list';
  @override
  State<QuotationListPage> createState() => _QuotationListPageState();
}

class _QuotationListPageState extends State<QuotationListPage> {
  final ScrollController hideButtonController = ScrollController();

  @override
  void initState() {
    hideButtonController.addListener(
      () {
        if (hideButtonController.position.atEdge) {
          if (hideButtonController.position.pixels != 0) {
            Provider.of<FabButtonProvider>(context, listen: false)
                .visibilityOFF();
          }
        } else {
          Provider.of<FabButtonProvider>(context, listen: false).visibilityON();
        }
      },
    );

    super.initState();
  }

  @override
  void didChangeDependencies() {
    //fetch all quotationList first
    _getAllQuotation();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    hideButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          buildAppBarWithUserInfo(context),
          const ReservationOrQuotationSearch(),
          const SizedBox(
            height: 5.0,
          ),
          Expanded(child: buildQuotationList()),
        ],
      ),
    );
  }

  AppBarWithUserInfo buildAppBarWithUserInfo(BuildContext context) {
    return AppBarWithUserInfo(
      title: Text(
        AppLocalizations.of(context)!.quotation,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1,
            color: Colors.white),
      ),
      username: Text(
        Provider.of<UserProvider>(context, listen: false)
                .userModel!
                .post!
                .username ??
            'user',
        textAlign: TextAlign.right,
        style: TextStyle(color: Colors.white),
      ),
      identity: Text(
        Provider.of<UserProvider>(context, listen: false).userModel!.bTitle ??
            'brand',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Consumer<QuotationQueueProvider> buildQuotationList() {
    return Consumer<QuotationQueueProvider>(
      builder: (context, provider, child) {
        if (provider.quotationBriefModel != null &&
            provider.quotationBriefModel!.reservationQuotationList != null) {
          return provider
                  .quotationBriefModel!.reservationQuotationList!.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () async {
                    _getAllQuotation();
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: hideButtonController,
                    itemCount: provider
                        .quotationBriefModel!.reservationQuotationList!.length,
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, bottom: 5.0),
                    itemBuilder: (context, index) => ReservationOrQuotationTile(
                        reservationQuotation: provider.quotationBriefModel!
                            .reservationQuotationList![index],
                        isReservation: false),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    _getAllQuotation();
                  },
                  child: ListView(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 3),
                          child: Text(
                            AppLocalizations.of(context)!
                                .no_quotation_data_found,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                'assets/images/no_internet.svg',
                height: 200,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    _getAllQuotation();
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.quotation_list),
    );
  }

  void _getAllQuotation() {
    EasyLoading.show();
    Provider.of<QuotationQueueProvider>(context, listen: false)
        .getQuotationList()
        .then<void>((value) => EasyLoading.dismiss())
        .catchError((err) {
      EasyLoading.dismiss();

      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    });
  }
}

//ignore this comment
// final ScrollController _hideButtonController = ScrollController();
// bool _isFabVisible = true;
// @override
// void initState() {
//   _hideButtonController.addListener(() {
//     if (_hideButtonController.position.atEdge) {
//       if (_hideButtonController.position.pixels != 0) {
//         if (_isFabVisible) {
//           _isFabVisible = false;
//           setState(() {});
//         }
//       }
//     }
//     if (_hideButtonController.position.userScrollDirection ==
//         ScrollDirection.reverse) {
//       if (!_isFabVisible) {
//         _isFabVisible = true;
//         setState(() {});
//       }
//     }
//   });
//   super.initState();
// }
