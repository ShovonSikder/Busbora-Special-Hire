import 'dart:developer';

import 'package:appscwl_specialhire/db/shared_preferences.dart';
import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/pages/login_page.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_queue_provider.dart';
import 'package:appscwl_specialhire/providers/resrvation/reservation_provider.dart';
import 'package:appscwl_specialhire/providers/user/user_provider.dart';
import 'package:appscwl_specialhire/utils/bluetooth_printer.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:appscwl_specialhire/utils/printer_utils.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../../customewidgets/printer/connect_bluetooth_devices.dart';
import '../../providers/localization/local_provider.dart';
import '../../utils/constants/api_constants/http_code.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile_page';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDontShowAgain = false;
  int printer_code = PrinterUtils.getPrinterTypeInt(PrinterType.NoPrinter);
  late String selectedLn;
  bool loading = false;
  bool _isConnected = false;

  @override
  void initState() {
    selectedLn =
        Provider.of<LocalProvider>(context, listen: false).local.languageCode;
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var p_code = await AppSharedPref.getPrinterCode();
      printer_code = PrinterUtils.getStringToIntOfPrinterType(p_code);
      isDontShowAgain = await AppSharedPref.getDontShowAgain();
      _isConnected = await BluetoothPrinter.isConnected() == 'true';
      if (!_isConnected &&
          await AppSharedPref.getBTPrinterMac() != '' &&
          await AppSharedPref.getPrinterCode() == 'Bluetooth') {
        // log(await AppSharedPref.getPrinterCode());
        if (await BluetoothPrinter.connectByMacAddress(
                await AppSharedPref.getBTPrinterMac()) ==
            'true') {
          _isConnected = true;
        }
      }

      setState(() {});
    });
    _initUserIfRequire(context);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _initUserIfRequire(context);
      },
      child: ListView(
        padding: const EdgeInsets.all(8).copyWith(bottom: 20),
        children: [
          //user info
          buildUserProfileSection(),

          buildSectionLabel(context, AppLocalizations.of(context)!.information),
          //history tile
          buildHistoryListTile(context),

          //select printer
          buildSelectPrinterContainer(context),

          buildSectionLabel(context, AppLocalizations.of(context)!.language),
          //language
          buildLanguageListTile(context),

          buildSectionLabel(context, AppLocalizations.of(context)!.accounts),
          //logout
          buildLogoutListTile(context),
        ],
      ),
    );
  }

  Container buildSelectPrinterContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.select_printer),
          const SizedBox(
            height: 10,
          ),
          //radio group of Q1,Sunmi,No Printer
          Card(
            margin: const EdgeInsets.all(0),
            child: Column(
              children: [
                RadioListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  value: 1,
                  groupValue: printer_code,
                  onChanged: (value) {
                    AppSharedPref.setPrinterCode(
                        PrinterUtils.getPrinterType(PrinterType.Sunmi));
                    printer_code = value as int;
                    setState(() {});
                  },
                  title: Text(AppLocalizations.of(context)!.sunmi),
                ),
                RadioListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  value: 2,
                  groupValue: printer_code,
                  onChanged: (value) {
                    AppSharedPref.setPrinterCode(
                        PrinterUtils.getPrinterType(PrinterType.Q1Q2));
                    printer_code = value as int;
                    setState(() {});
                  },
                  title: Text(AppLocalizations.of(context)!.q1),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        value: 3,
                        groupValue: printer_code,
                        onChanged: (value) async {
                          AppSharedPref.setPrinterCode(
                              PrinterUtils.getPrinterType(
                                  PrinterType.BLUETOOTH));
                          printer_code = value as int;
                          setState(() {});

                          if (await BluetoothPrinter.isConnected() != 'true' &&
                              await AppSharedPref.getBTPrinterMac() != '') {
                            showMsgOnSnackBar(context,
                                AppLocalizations.of(context)!.try_auto_connect);
                            if (await BluetoothPrinter.connectByMacAddress(
                                    await AppSharedPref.getBTPrinterMac()) ==
                                'true') {
                              _isConnected = true;
                              setState(() {});
                            } else {
                              showMsgOnSnackBar(
                                  context,
                                  AppLocalizations.of(context)!
                                      .cant_connect_to_previous_device);
                              showBluetoothConnectionPage();
                            }
                          } else {
                            showBluetoothConnectionPage();
                          }
                        },
                        subtitle: Text(
                          _isConnected
                              ? AppLocalizations.of(context)!.connected
                              : AppLocalizations.of(context)!.disconnected,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        title: Text(AppLocalizations.of(context)!.bluetooth),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextButton(
                          onPressed: () async {
                            if (_isConnected) {
                              await BluetoothPrinter.disconnect();
                              setState(() {
                                _isConnected = false;
                              });
                            } else {
                              showBluetoothConnectionPage();
                            }
                          },
                          child: Text(_isConnected
                              ? AppLocalizations.of(context)!.disconnect
                              : AppLocalizations.of(context)!.connect)),
                    )
                  ],
                ),
                RadioListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  value: 0,
                  groupValue: printer_code,
                  onChanged: (value) {
                    printer_code = value as int;

                    AppSharedPref.setPrinterCode(
                        PrinterUtils.getPrinterType(PrinterType.NoPrinter));
                    setState(() {});
                  },
                  title: Text(AppLocalizations.of(context)!.no_printer),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  thickness: 1,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isDontShowAgain,
                      onChanged: (value) {
                        setState(() {
                          isDontShowAgain = value!;
                          log("isDontShowAgain: $isDontShowAgain");
                          AppSharedPref.setDontShowAgain(isDontShowAgain);
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    Text(
                      AppLocalizations.of(context)!.remember,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLogoutListTile(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.sure_want_to_logout,
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () => loading ? () {} : Navigator.pop(context),
                    child: Text(
                      AppLocalizations.of(context)!.no,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                ElevatedButton(
                  onPressed: loading
                      ? () {}
                      : () async {
                          loading = true;
                          _initiateLogout(context);
                        },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.yes,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                )
              ],
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.logout,
                    size: 24,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    AppLocalizations.of(context)!.logout,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  )
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios_sharp,
                size: 15,
                color: Colors.red,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHistoryListTile(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.history,
                    size: 24,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    AppLocalizations.of(context)!.history,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios_sharp,
                size: 15,
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(label),
    );
  }

  Card buildUserProfileSection() {
    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        child: Row(
          children: [
            Image.asset(
              'assets/images/profile_placeholder.png',
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Consumer<UserProvider>(
                builder: (context, provider, child) {
                  return provider.userModel != null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.userModel!.post!.username ??
                                  AppLocalizations.of(context)!.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(provider.userModel!.bTitle ?? ''),
                            Text(provider.userModel!.counterName ?? ''),
                          ],
                        )
                      : const Text('Error Data Loading');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initiateLogout(context) {
    EasyLoading.show();
    Provider.of<UserProvider>(context, listen: false).logOut().then((value) {
      Provider.of<QuotationQueueProvider>(context, listen: false)
          .clearCurrentSearchQuery();
      Provider.of<ReservationProvider>(context, listen: false)
          .clearCurrentSearchQuery();

      EasyLoading.dismiss();
      Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName,
          ModalRoute.withName(LoginPage.routeName));
    }).catchError((err) {
      EasyLoading.dismiss();
      err.toString() == HttpCode.invalidLogin
          ? expiredLoginAction(context)
          : showMsgOnSnackBar(
              context, HttpCode.getFriendlyErrorMsg(context, err));
    });
  }

  void _initUserIfRequire(context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.userModel == null) {
      userProvider.initUser(await AppSharedPref.getUserInfo());
      // print(await AppSharedPref.getUserInfo());
      // print(AppSharedPref.getUserInfo().runtimeType);
    }
  }

  buildLanguageListTile(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.language,
                  size: 24,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  AppLocalizations.of(context)!.current_language,
                  style: const TextStyle(fontSize: 16),
                )
              ],
            ),
            DropdownButton<String>(
              isDense: true,
              underline: Text(''),
              value: selectedLn,
              icon: const Icon(
                Icons.arrow_drop_down,
              ),
              items: const [
                DropdownMenuItem<String>(
                  value: 'en',
                  child: Text(
                    'English',
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'sw',
                  child: Text(
                    'Swahili',
                  ),
                ),
              ],
              onChanged: (value) {
                Provider.of<LocalProvider>(context, listen: false)
                    .changeLocal(value!);
                setState(() {
                  selectedLn = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  void showBluetoothConnectionPage() async {
    Navigator.pushNamed(context, ConnectBluetoothDevices.routeName)
        .then((value) async {
      if (await BluetoothPrinter.isConnected() == 'true') {
        _isConnected = true;
      }
      setState(() {});
    });
  }
}
