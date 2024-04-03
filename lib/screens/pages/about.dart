import 'package:QBB/constants.dart';
import 'package:QBB/screens/pages/notification.dart';
import 'package:QBB/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  AboutUsState createState() => AboutUsState();
}

class AboutUsState extends State<AboutUs> {
  bool? showDot;
  Future<void> showDotNotification() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String sD = pref.getString("showDot").toString();

    setState(() {
      sD == "null" ? showDot = true : showDot = false;
    });
  }

  @override
  void initState() {
    super.initState();
    showDotNotification();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: const SideMenu(),
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: appbar,
          ),
          iconTheme: const IconThemeData(color: textcolor),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Image.asset(
                  "assets/images/icon.png",
                  width: 40.0,
                  height: 40.0,
                  fit: BoxFit.cover,
                ),
              ),
              // SizedBox(
              //   width: 50.0,
              // ),
              Text(
                'aboutUs'.tr,
                style: const TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.w900 ,
                    fontFamily: 'Impact',
                    fontSize: 16),
              ),
              // SizedBox(
              //   width: 50.0,
              // ),
              IconButton(
                onPressed: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
    
                  setState(() {
                    showDot = false;
                    pref.setString("showDot", "false");
                  });
    
                  // Perform actions on the first click, such as navigating or showing a notification.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  );
                },
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_none_outlined),
                    if (showDot == true)
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 3,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                          ),
                          child: const Text(
                            '', // You can customize this text or use an empty container for just a dot.
                          ),
                        ),
                      ),
                  ],
                ),
                iconSize: 30.0,
                color: Colors.white,
              ),
            ],
          ),
          backgroundColor: appbar,
        ),
        // bottomNavigationBar: BottomMenu(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              // color: textcolor,
              // height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Colors.white, // Container background color
                borderRadius: BorderRadius.circular(0), // Border radius
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 188, 188, 188)
                        .withOpacity(0.5), // Shadow color
                    spreadRadius: 5, // Spread radius
                    blurRadius: 7, // Blur radius
                    offset: const Offset(0, 3), // Offset from top-left
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text('aboutUs'.tr,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 24.0)),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'aboutContent'.tr,
                      style: const TextStyle(
                          color: Colors.black, fontSize: 14.0),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'aboutContentt'.tr,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
