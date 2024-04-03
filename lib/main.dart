import 'dart:convert';
import 'package:QBB/constants.dart';
import 'package:QBB/localestring.dart';
import 'package:QBB/localization/localization.dart';
import 'package:QBB/nirmal/login_screen.dart';
import 'package:QBB/providers/studymodel.dart';
import 'package:QBB/providers/token_provider.dart';
import 'package:QBB/screens/pages/appointments.dart';
import 'package:QBB/screens/pages/book_appintment_nk.dart';
import 'package:QBB/screens/pages/bookappointment_screen.dart';
import 'package:QBB/screens/splash.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:QBB/l10n/l10n.dart';
import 'package:QBB/providers/navigation_provider.dart';
// import 'package:flutter_gen/gen_I10n/app-localizations.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: appbar,
  ));
  // await GetStorage.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StudyProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => TokenProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class RefreshNotifier extends ChangeNotifier {
  // This class will notify listeners about changes

  void triggerRefresh() {
    // Trigger a refresh
    notifyListeners();
  }
}

class _MyAppState extends State<MyApp> {
  // Locale _locale = const Locale('en', 'US'); // Default locale

  void _changeLanguage(Locale locale) {
    setState(() {
      // _locale = locale;
    });
  }

  @override
  void initState() {
    _initApp();
    super.initState();
    _clearSharedPreferences();
  }

  @override
  void dispose() {
    _clearSharedPreferences(); // Clear shared preferences when the widget is disposed
    super.dispose();
  }

  _clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("langSelected");
    await prefs.remove("showDot");
  }

  Future<void> _initApp() async {
    // Fetch the token using the getToken function
    String? token = await getToken(context);

    if (token != null) {
      // Store the token in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RefreshNotifier(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // title: 'QBB', supportedLocales: AppLocalizations.supported,
        translations: LocaleString(),
        supportedLocales: L10n.all,
        locale: const Locale('ar'),
        // locale: Locale(LanguageController().selectedLanguageCode.value),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          AppLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          // AppLocalizationsDelegateEn(), // Default (English)
          // AppLocalizationsDelegateAr(), // Arabic
        ],

        theme: ThemeData(
          scaffoldBackgroundColor: bgColor,
          // colorScheme: ColorScheme.fromSeed(seedColor: appbar),
          useMaterial3: true,
          fontFamily: 'Arial',
        ),
        routes: {
          '/login': (BuildContext context) => const LoginPage(),
          '/bookanAppointment': (BuildContext context) => const BookAppointments(),
          '/appointments': (BuildContext context) => const Appointments(),
        },
        home: const SplashScreen(),
      ),
    );
  }
}

Future<String?> getToken(context) async {
  final url = Uri.parse(
      "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/QBBMobAPI");

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  final Map<String, String> body = {
    'Password': 'QBBMobadmin',
    'Username': 'MOBadmin@gmail.com',
    'SubscriptionID': '88664328891221',
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final String token = response.body;
    // Use the provider to set the token
    Provider.of<TokenProvider>(context, listen: false).setToken(token);
    // Now you can use storedToken for further API requests.
    String? storedToken =
        Provider.of<TokenProvider>(context, listen: false).token;
    return token;
  } else {
    // Handle error response
    return null;
  }
}
