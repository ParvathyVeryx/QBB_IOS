import 'package:QBB/constants.dart';
// import 'package:QBB/l10n/applocalization_ar.dart';
// import 'package:QBB/localization/localization.dart';
import 'package:QBB/nirmal/login_screen.dart';
import 'package:QBB/screens/authentication/forgotPwd.dart';
import 'package:QBB/screens/authentication/loginorReg.dart';
import 'package:QBB/screens/pages/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  WelcomeState createState() => WelcomeState();
}

class WelcomeState extends State<Welcome> {
  final List locale = [
    {'name': 'ENGLISH', 'locale': const Locale('en', 'US')},
    {'name': 'عربي', 'locale': const Locale('ar')},
  ];

  // final List<Map<String, dynamic>> locale = [
  //   {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
  //   {'name': 'عربي', 'locale': Locale('ar')},
  // ];

  updateLanguage(Locale locale) {
    // Get.back();
    Get.updateLocale(locale);
  }

  _clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("langSelected");
  }

  String password = ''; // Store the entered password
  String confirmPassword = ''; // Store the entered confirm password
  bool isButtonEnabled = false;
  String otp = '';
  String QID = '';
  bool isButtonClickedW = false;
  bool isButtonClickedWArabic = true;
  String selectedLang = '';

  Future<String> getLang() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    selectedLang = pref.getString("langSelected").toString();
    if (selectedLang == "English") {
      setState(() {
        isButtonClickedW = true;
        isButtonClickedWArabic = false;
      });
    } else {
      setState(() {
        isButtonClickedW = false;
        isButtonClickedWArabic = true;
      });
    }

    return selectedLang;
  }

  @override
  void initState() {
    // TODO: implement initState
    // _clearSharedPreferences();
    super.initState();
    getLang();
    //   Future.delayed(Duration(seconds: 2), () {
    //     _clearSharedPreferences();
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: appbar,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Text(
                  'tutorialSkipButton'.tr.toUpperCase(),
                  // appLocalizations?.hello ?? 'default',

                  style: const TextStyle(
                    color: appbar,
                    fontSize: 13.0,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 16.0),
            //   child: LanguageToggleSwitch(onLanguageChanged: onLanguageChanged),
            // ),
          ],
        ),
        backgroundColor: textcolor,
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.95,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              alignment: Alignment
                  .bottomCenter, // Align the image to the bottom center // Replace with your image path
              fit: BoxFit
                  .contain, // Adjust to your needs (e.g., BoxFit.fill, BoxFit.fitHeight)
            ),
            // color: Colors.blue, // Container background color

            borderRadius: BorderRadius.circular(0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 45.0, right: 45, top: 20),
            // padding: const EdgeInsets.all(45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: isButtonClickedW
                            ? ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(appbar),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                              )
                            : ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    side: BorderSide(color: appbar),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(0.0),
                                    ),
                                  ),
                                ),
                              ),
                        onPressed: () async {
                          // setState(() {
                          // Toggle the state to change the button style
                          isButtonClickedW = true;
                          isButtonClickedWArabic = false;
                          // });
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setString("langSelected", "English");
                          var lan = pref.getString("langSelected").toString();
                          updateLanguage(locale[0]['locale']);
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(6.0, 1.0, 6.0, 1.0),
                          child: isButtonClickedW
                              ? const Text(
                                  'English',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textcolor,
                                  ),
                                )
                              : const Text(
                                  'English',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: appbar,
                                  ),
                                ),
                        ),
                      ),
                      ElevatedButton(
                        style: isButtonClickedWArabic
                            ? ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(appbar),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                              )
                            : ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    // borderRadius: BorderRadius.only(
                                    //   bottomLeft: Radius.circular(20.0),
                                    // ),
                                    side: BorderSide(color: appbar),
                                  ),
                                ),
                              ),
                        onPressed: () async {
                          setState(() {
                            // Toggle the state to change the button style
                            isButtonClickedW = false;
                            isButtonClickedWArabic = true;
                          });
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setString("langSelected", "Arabic");

                          updateLanguage(locale[1]['locale']);
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(6.0, 1.0, 6.0, 1.0),
                          child: isButtonClickedWArabic
                              ? const Text(
                                  'عربي',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textcolor,
                                  ),
                                )
                              : const Text(
                                  'عربي',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: appbar,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  "assets/images/logo-welcome-screen.png",
                  width: 160.0,
                  height: 160.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  'welcomeToQbb'.tr,
                  style: const TextStyle(
                      color: appbar, fontFamily: 'Impact', fontSize: 28.0),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  'tutorialSlide1Description'.tr,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 107, 107, 107), fontSize: 12),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFffffff)), // Set background color

                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    12.0), // Rounded border at bottom-left
                              ),
                              side: BorderSide(
                                color:
                                    primaryColor, // Specify the border color here
                                width: 1.0, // Specify the border width here
                              ),
                            ),
                          )),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                        child: Text(
                          'login'.tr,
                          style: const TextStyle(
                              color: primaryColor, fontSize: 13),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()),
                        );
                      },
                      child: Text(
                        'forgotPassword'.tr,
                        style:
                            const TextStyle(color: primaryColor, fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              // builder: (context) => EditProfilePage())
                              builder: (context) => const loginOrReg()),
                        );
                      },
                      child: Text(
                        'create/activateAcc'.tr,
                        style:
                            const TextStyle(color: primaryColor, fontSize: 12),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
