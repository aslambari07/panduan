import 'dart:async';
import 'package:anekapanduan/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:anekapanduan/manager/theme_manager.dart';
import 'package:anekapanduan/screens/splash_screen.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/shared_prefs.dart';
import 'package:anekapanduan/utils/themes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'utils/firebase/firebase_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppSharedPrefs.initSharedPrefs();
  MobileAds.instance.initialize();
  await FirebaseApi().initNotification();

  FlutterBranchSdk.initSession().listen(
    (event) {
      debugPrint('Branch initiated successfully');
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseApi().initPushNotification(context);
    return ChangeNotifierProvider(
        create: (context) => AppSettingsManager(),
        child: Consumer(
          builder: (context, AppSettingsManager themeManager, child) =>
              MaterialApp(
            title: appName,
            debugShowCheckedModeBanner: false,
            locale: themeManager.appLocale,
            supportedLocales: appLocales,
            theme: lightTheme,
            home: const SplashScreen(),
            darkTheme: darkTheme,
            themeMode: themeManager.themeMode,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
          ),
        ));
  }
}
