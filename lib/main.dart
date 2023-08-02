import 'dart:ui';

import 'package:appscwl_specialhire/page_routes.dart';
import 'package:appscwl_specialhire/pages/launcher_page.dart';
import 'package:appscwl_specialhire/providers/districts_provider.dart';
import 'package:appscwl_specialhire/providers/fab_button_provider.dart';
import 'package:appscwl_specialhire/providers/localization/local_provider.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_add_provider.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_init_provider.dart';
import 'package:appscwl_specialhire/providers/quotation/quotation_queue_provider.dart';
import 'package:appscwl_specialhire/providers/resrvation/reservation_provider.dart';
import 'package:appscwl_specialhire/providers/user/user_provider.dart';
import 'package:appscwl_specialhire/utils/constants/color_constants.dart';
import 'package:appscwl_specialhire/utils/helper_function.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //firebase init
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xff51216c),
      systemNavigationBarColor: backgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
// // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
//   PlatformDispatcher.instance.onError = (error, stack) {
//     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
//     return true;
//   };
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => QuotationAddProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => QuotationQueueProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => QuotationInitProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReservationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DistrictsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FabButtonProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 30.0
      ..radius = 5.0
      ..progressColor = Colors.white
      ..backgroundColor = specialHireThemePrimary
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..maskType = EasyLoadingMaskType.black
      ..userInteractions = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalProvider>(
      builder: (_, provider, __) => MaterialApp(
        title: 'Special Hire',
        theme: ThemeData(
          primarySwatch: buildMaterialColorFromColor(specialHireThemePrimary),
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'OpenSans'),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData(
          primarySwatch: buildMaterialColorFromColor(specialHireThemePrimary),
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'OpenSans'),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: provider.local,
        builder: EasyLoading.init(),
        initialRoute: LauncherPage.routeName,
        routes: routes,
      ),
    );
  }
}
