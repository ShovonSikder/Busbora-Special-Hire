import 'dart:developer';

import 'package:appscwl_specialhire/customewidgets/printer/connect_bluetooth_devices.dart';
import 'package:flutter/material.dart';

import '../../db/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/bluetooth_printer.dart';
import '../../utils/helper_function.dart';
import '../../utils/printer_utils.dart';

class SelectPrinterWidget extends StatefulWidget {
  const SelectPrinterWidget({Key? key, required this.onSubmitted})
      : super(key: key);
  final void Function() onSubmitted;

  @override
  State<SelectPrinterWidget> createState() => _SelectPrinterWidgetState();
}

class _SelectPrinterWidgetState extends State<SelectPrinterWidget> {
  int printer_code = PrinterUtils.getPrinterTypeInt(PrinterType.NoPrinter);
  bool isDontShowAgain = false;
  bool _isConnected = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      var p_code = await AppSharedPref.getPrinterCode();
      isDontShowAgain = await AppSharedPref.getDontShowAgain();
      printer_code = PrinterUtils.getStringToIntOfPrinterType(p_code);

      _isConnected = await BluetoothPrinter.isConnected() == 'true';
      if (!_isConnected &&
          await AppSharedPref.getBTPrinterMac() != '' &&
          await AppSharedPref.getPrinterCode() == 'Bluetooth') {
        // log(await AppSharedPref.getPrinterCode());
        showMsgOnSnackBar(
            context, AppLocalizations.of(context)!.try_auto_connect);
        if (await BluetoothPrinter.connectByMacAddress(
                await AppSharedPref.getBTPrinterMac()) ==
            'true') {
          _isConnected = true;
          showMsgOnSnackBar(context, AppLocalizations.of(context)!.connected);
        } else {
          showMsgOnSnackBar(
              context, AppLocalizations.of(context)!.cant_connect);
          Navigator.pushNamed(context, ConnectBluetoothDevices.routeName)
              .then((value) async {
            if (await BluetoothPrinter.isConnected() == 'true') {
              _isConnected = true;
              setState(() {});
            }
          });
        }
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    AppSharedPref.getPrinterCode().then((value) {
      printer_code = PrinterUtils.getStringToIntOfPrinterType(value);
      AppSharedPref.getDontShowAgain().then((value) {
        isDontShowAgain = value;
        setState(() {});
      });
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant SelectPrinterWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    AppSharedPref.getPrinterCode().then((value) {
      printer_code = PrinterUtils.getStringToIntOfPrinterType(value);
      AppSharedPref.getDontShowAgain().then((value) {
        isDontShowAgain = value;
        setState(() {});
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //radio group of Q1,Sunmi,No Printer
          Text(AppLocalizations.of(context)!.select_printer),
          SizedBox(
            height: 10,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                value: 1,
                groupValue: printer_code,
                onChanged: (value) {
                  printer_code = value as int;
                  AppSharedPref.setPrinterCode(
                      PrinterUtils.getPrinterType(PrinterType.Sunmi));
                  setState(() {});
                },
                title: Text(AppLocalizations.of(context)!.sunmi),
              ),
              RadioListTile(
                value: 2,
                groupValue: printer_code,
                onChanged: (value) {
                  printer_code = value as int;
                  AppSharedPref.setPrinterCode(
                      PrinterUtils.getPrinterType(PrinterType.Q1Q2));
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
                            PrinterUtils.getPrinterType(PrinterType.BLUETOOTH));
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
                            showBluetoothConnectionDialog();
                          }
                        } else {
                          showBluetoothConnectionDialog();
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
                            showBluetoothConnectionDialog();
                          }
                        },
                        child: Text(_isConnected
                            ? AppLocalizations.of(context)!.disconnect
                            : AppLocalizations.of(context)!.connect)),
                  )
                ],
              ),
              RadioListTile(
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
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  OutlinedButton(
                      onPressed: () {
                        AppSharedPref.setPrinterCode(
                            PrinterUtils.getIntToStringOfPrinterType(
                                printer_code));
                        AppSharedPref.setDontShowAgain(isDontShowAgain);
                        widget.onSubmitted.call();
                      },
                      child: Text(AppLocalizations.of(context)!.continue_)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  void showBluetoothConnectionDialog() async {
    Navigator.pushNamed(context, ConnectBluetoothDevices.routeName)
        .then((value) async {
      if (await BluetoothPrinter.isConnected() == 'true') {
        _isConnected = true;
      }
      setState(() {});
    });
  }
}
