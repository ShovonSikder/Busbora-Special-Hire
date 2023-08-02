import 'package:appscwl_specialhire/db/shared_preferences.dart';
import 'package:appscwl_specialhire/utils/bluetooth_printer.dart';
import 'package:appscwl_specialhire/utils/constants/color_constants.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:appscwl_specialhire/utils/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../l10n/app_localizations.dart';

class ConnectBluetoothDevices extends StatefulWidget {
  static const String routeName = '/btd_search';
  const ConnectBluetoothDevices({Key? key}) : super(key: key);

  @override
  State<ConnectBluetoothDevices> createState() =>
      _ConnectBluetoothDevicesState();
}

class _ConnectBluetoothDevicesState extends State<ConnectBluetoothDevices> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> _devices = [];
  bool _isScanning = true;
  var lisener;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      scan();
    });
  }

  scan() async {
    if (!await PermissionManager.locationAccessDiba()) {
      showMsgOnSnackBar(context,
          AppLocalizations.of(context)!.location_permission_required_blue);
      return;
    }
    if (!await PermissionManager.bluetoothAccessDiba()) {
      //happy rose day 2023. the issue solved today was with android version 12 which requires some extra permission
      showMsgOnSnackBar(
          context, AppLocalizations.of(context)!.bluetooth_permission_required);
      return;
    }

    if (!await flutterBlue.isOn) {
      await flutterBlue.turnOn();
    }
    // Start scanning
    await flutterBlue.startScan(timeout: const Duration(seconds: 4));

// Listen to scan results
    lisener = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      _devices = results;
      if (mounted) setState(() {});
    });

// Stop scanning
    await flutterBlue.stopScan();
    _isScanning = false;
    setState(() {});
  }

  @override
  void dispose() {
    if (lisener != null) {
      lisener.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.avl_bluetooth_devices,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (!_isScanning) {
                _isScanning = true;
                scan();
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.radar_sharp,
                  size: 18,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  AppLocalizations.of(context)!.scan,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _devices.isNotEmpty
          ? ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              children: _devices
                  .map(
                    (e) => Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[200]!,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.bluetooth_sharp,
                          color: specialHireThemePrimary,
                          size: 30,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 8,
                        ),
                        minVerticalPadding: 0,
                        minLeadingWidth: 0,
                        isThreeLine: true,

                        // dense: true,
                        title: Text(
                          e.device.name.isNotEmpty
                              ? e.device.name
                              : "Unknown device",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'MAC: ' + e.device.id.id,
                              style: const TextStyle(fontSize: 10),
                            ),
                            Text(
                              'Type: ' + e.device.type.name,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        trailing: OutlinedButton(
                          onPressed: () {
                            _connectADevice(e.device);
                          },
                          child: Text(AppLocalizations.of(context)!.connect),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            )
          : Center(
              child: _isScanning
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(AppLocalizations.of(context)!
                                .searching_for_devices +
                            '...'),
                      ],
                    )
                  : Text(AppLocalizations.of(context)!.no_device_found),
            ),
    );
  }

  void _connectADevice(BluetoothDevice device) async {
    try {
      EasyLoading.show();
      if (await BluetoothPrinter.connectByMacAddress(device.id.id) == 'true') {
        await AppSharedPref.setBTPrinterMac(device.id.id);
        Navigator.pop(context, true);
        showMsgOnSnackBar(context, AppLocalizations.of(context)!.connected);
      } else {
        showMsgOnSnackBar(context, AppLocalizations.of(context)!.cant_connect);
      }
      EasyLoading.dismiss();
    } catch (err) {
      EasyLoading.dismiss();
      showMsgOnSnackBar(context, err.toString());
    }
  }
}
