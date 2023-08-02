import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:appscwl_specialhire/db/shared_preferences.dart';
import 'package:appscwl_specialhire/l10n/app_localizations.dart';
import 'package:appscwl_specialhire/pages/home_page.dart';
import 'package:appscwl_specialhire/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/localization/local_provider.dart';
import '../providers/user/user_provider.dart';
import '../utils/constants/api_constants/http_code.dart';
import '../utils/helper_function.dart';

class LauncherPage extends StatefulWidget {
  static const String routeName = '/launcher_page';
  const LauncherPage({Key? key}) : super(key: key);

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  final checker = AppVersionChecker();
  bool allSet = true;
  bool? canUpdate;
  String? currentVersion;
  String? appURL;
  String? newVersion;
  String? minAppVersion = "1.0.0";
  bool haveToUpgrade = false;
  String errMsg = "";
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await checkUpdateAndRedirect();
    });
  }

  Future<void> checkUpdateAndRedirect() async {
    try {
      await checkUpdate();

      await initDefaultConfig(remoteConfig);
      haveToUpgrade = shouldUpdate(currentVersion!, minAppVersion!);
      if (canUpdate != null && canUpdate! && appURL != null) {
        showAppUpdateMsgDialog();
      } else if (allSet) {
        redirect();

        // showAppUpdateMsgDialog();
      }
      // await redirect();
    } on TimeoutException {
      allSet = false;
      errMsg = AppLocalizations.of(context)!.time_out;
      setState(() {});
    } on SocketException {
      allSet = false;
      errMsg = AppLocalizations.of(context)!.no_internet;
      setState(() {});
    } on FirebaseException catch (err) {
      allSet = false;

      errMsg = AppLocalizations.of(context)!.firebase_exception;
      setState(() {});
    } catch (err) {
      allSet = false;

      errMsg = AppLocalizations.of(context)!.something_went_wrong;
      setState(() {});
    }
  }

  checkUpdate() async {
    await checker.checkUpdate().then((value) {
      canUpdate = value.canUpdate;
      currentVersion = value.currentVersion;
      newVersion = value.newVersion;
      appURL = value.appURL;
    });
    // minAppVersion.$ = currentVersion!;
    print(
        "canUpdate: $canUpdate\n currentVersion: $currentVersion\n newVersion: $newVersion\n appUrl: $appURL");
  }

  Future<void> redirect() async {
    Provider.of<LocalProvider>(context, listen: false)
        .changeLocal(await AppSharedPref.getLanguageCode());
    if (await AppSharedPref.getLoginStatus() &&
        await AppSharedPref.getUserAuthCode() != '') {
      _initUserIfRequire(context);
      Navigator.pushNamedAndRemoveUntil(
          context, HomePage.routeName, (_) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, LoginPage.routeName, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: errMsg.isEmpty
          ? const Center(child: Text('Loading...'))
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    errMsg,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      errMsg = "";
                      allSet = true;
                      setState(() {});
                      await checkUpdateAndRedirect();
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  )
                ],
              ),
            ),
    );
  }

  void _initUserIfRequire(context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.userModel == null) {
      userProvider.initUser(await AppSharedPref.getUserInfo());
      // print(await AppSharedPref.getUserInfo());
      // print(AppSharedPref.getUserInfo().runtimeType);
    }
  }

  void showAppUpdateMsgDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
          onWillPop: () async {
            if (!haveToUpgrade) {
              Navigator.pop(context);
              redirect();
            }
            return false;
          },
          child: AlertDialog(
            // insetPadding: const EdgeInsets.symmetric(horizontal: 15),
            title: Text(
              AppLocalizations.of(context)!.update_app,
              // textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            contentPadding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    text: AppLocalizations.of(context)!.update_available_msg,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                          text: AppLocalizations.of(context)!
                              .your_current_version),
                      TextSpan(
                          text: ' $currentVersion ',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic)),
                      TextSpan(text: AppLocalizations.of(context)!.new_version),
                      TextSpan(
                          text: ' $newVersion ',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  haveToUpgrade
                      ? AppLocalizations.of(context)!.please_update
                      : AppLocalizations.of(context)!.would_you_update,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            actionsPadding:
                const EdgeInsets.only(bottom: 10, top: 5, right: 10),
            // actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              if (!haveToUpgrade)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    redirect();
                  },
                  child: Text(AppLocalizations.of(context)!.later),
                ),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                onPressed: () async {
                  await launchUrl(Uri.parse(appURL!),
                      mode: LaunchMode.externalNonBrowserApplication);
                  if (!haveToUpgrade) {
                    Navigator.pop(context);
                    redirect();
                  }
                },
                child: Text(AppLocalizations.of(context)!.update_now),
              ),
            ],
          )),
    );
  }

  Future<void> initDefaultConfig(FirebaseRemoteConfig remoteConfig) async {
    final Map<String, dynamic> defaults = <String, dynamic>{
      'min_version': currentVersion
    };
    await remoteConfig.setDefaults(defaults);
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 1),
        minimumFetchInterval: const Duration(seconds: 10),
      ),
    );
    await fetchConfig(remoteConfig);
  }

  fetchConfig(FirebaseRemoteConfig remoteConfig) async {
    await remoteConfig.fetchAndActivate();

    minAppVersion = remoteConfig.getString('min_version');
  }

  bool shouldUpdate(String versionA, String versionB) {
    final versionNumbersA =
        versionA.split(".").map((e) => int.tryParse(e) ?? 0).toList();
    final versionNumbersB =
        versionB.split(".").map((e) => int.tryParse(e) ?? 0).toList();

    final int versionASize = versionNumbersA.length;
    final int versionBSize = versionNumbersB.length;
    int maxSize = math.max(versionASize, versionBSize);

    for (int i = 0; i < maxSize; i++) {
      if ((i < versionASize ? versionNumbersA[i] : 0) >
          (i < versionBSize ? versionNumbersB[i] : 0)) {
        return false;
      } else if ((i < versionASize ? versionNumbersA[i] : 0) <
          (i < versionBSize ? versionNumbersB[i] : 0)) {
        return true;
      }
    }
    return false;
  }
}
