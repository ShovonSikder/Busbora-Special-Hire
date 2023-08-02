import 'package:appscwl_specialhire/customewidgets/appbar_with_userinfo.dart';
import 'package:appscwl_specialhire/customewidgets/reservation_or_quotation_search.dart';
import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/providers/districts_provider.dart';
import 'package:appscwl_specialhire/providers/resrvation/reservation_provider.dart';
import 'package:appscwl_specialhire/utils/constants/color_constants.dart';
import 'package:appscwl_specialhire/utils/constants/constants.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../customewidgets/reservation_or_quotation_tile.dart';
import '../../db/shared_preferences.dart';
import '../../providers/user/user_provider.dart';
import '../../utils/constants/api_constants/http_code.dart';

class ReservationListPage extends StatefulWidget {
  const ReservationListPage({Key? key}) : super(key: key);
  static const String routeName = '/reservation_list_page';

  @override
  State<ReservationListPage> createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  @override
  void initState() {
    super.initState();
    _initDistricts(context);
    // _initUserIfRequire(context);
    _getAllReservations(context);
  }

  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          buildAppBarWithUserInfo(context),
          const ReservationOrQuotationSearch(
            isForReservation: true,
          ),
          const SizedBox(
            height: 5.0,
          ),
          Expanded(child: buildReservationList()),
        ],
      ),
    );
  }

  AppBarWithUserInfo buildAppBarWithUserInfo(BuildContext context) {
    return AppBarWithUserInfo(
      title: Text(
        AppLocalizations.of(context)!.special_hire_list,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          overflow: TextOverflow.ellipsis,
          letterSpacing: 1,
          color: Colors.white,
        ),
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
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Consumer<ReservationProvider> buildReservationList() {
    return Consumer<ReservationProvider>(
      builder: (context, provider, child) {
        if (provider.reservationBriefModel != null &&
            provider.reservationBriefModel!.reservationList != null) {
          return provider.reservationBriefModel!.reservationList!.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () async {
                    _initDistricts(context);
                    _getAllReservations(context);
                  },
                  child: ListView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, bottom: 5.0),
                    itemCount:
                        provider.reservationBriefModel!.reservationList!.length,
                    itemBuilder: (context, index) => ReservationOrQuotationTile(
                        reservationQuotation: provider
                            .reservationBriefModel!.reservationList![index]),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    _initDistricts(context);
                    _getAllReservations(context);
                  },
                  child: ListView(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 3),
                          child: Text(
                            AppLocalizations.of(context)!
                                .no_reservation_data_found,
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
        if (hasError) {
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
                      _initDistricts(context);
                      _getAllReservations(context);
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
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.special_hire),
    );
  }

  void _getAllReservations(BuildContext context) {
    EasyLoading.show();
    Provider.of<ReservationProvider>(context, listen: false)
        .getReservationList()
        .then<void>((value) => EasyLoading.dismiss())
        .catchError((err) {
      EasyLoading.dismiss();
      if (err.toString() == HttpCode.invalidLogin) {
        expiredLoginAction(context);
      } else {
        setState(() {
          hasError = true;
        });
        showMsgOnSnackBar(context, HttpCode.getFriendlyErrorMsg(context, err));
      }
    });
  }

  void _initDistricts(BuildContext context) async {
    final bool isFirstInstall = await AppSharedPref.isAppFirstInstalled();
    Provider.of<DistrictsProvider>(context, listen: false)
        .initDistricts(
          from: isFirstInstall ? fromApi : fromLocal,
        )
        .then((value) => 0)
        .catchError((err) {
      if (err.toString() == HttpCode.invalidLogin) {
        expiredLoginAction(context);
      } else {
        setState(() {
          hasError = true;
        });
        showMsgOnSnackBar(context, HttpCode.getFriendlyErrorMsg(context, err));
      }
    });
  }
}
