import 'package:QBB/constants.dart';
import 'package:QBB/screens/pages/appointments.dart';
import 'package:QBB/screens/pages/book_appintment_nk.dart';
import 'package:QBB/screens/pages/homescreen_nk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/pages/profile.dart';
import 'screens/pages/results.dart';

class CustomTab extends StatefulWidget {
  int? tabId;
  CustomTab({this.tabId});

  @override
  State<CustomTab> createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> {
  List<String> tabImages = [
    'assets/images/home.png',
    'assets/images/event.png',
    'assets/images/date.png',
    'assets/images/experiment-results.png',
    'assets/images/user.png',
  ];

  @override
  void initState() {
    setState(() {
      print("tabid : ${widget.tabId}");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double width = MediaQuery.of(context).size.width / baseWidth;
    double height = width * 0.97;
//     double width = MediaQuery.of(context).size.width; // Get the screen width

// double twentyPercentWidth = 0.2 * width; // Calculate 20% of the width

    return Container(
      // padding:
      //     EdgeInsets.fromLTRB(50 * width, 14 * width, 50 * width, 13 * width),
      width: MediaQuery.of(context).size.width,
      height: 70,
      decoration: BoxDecoration(
        color: appbar,
        boxShadow: [
          BoxShadow(
            color: Color(0x19006ea3),
            offset: Offset(0 * width, 0 * width),
            blurRadius: 10 * width,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: Container(
              // margin: EdgeInsets.fromLTRB(
              //     0 * width, 3 * width, 42 * width, 4 * width),
              height: 70,
              width: MediaQuery.of(context).size.width * 0.2,
              color: widget.tabId == 0 ? primaryColor : appbar,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Image.asset(
                            "assets/images/home.png",
                            width: 20.0,
                            height: 20.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text('home'.tr + '\n',
                            style: TextStyle(color: textcolor, fontSize: 7)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/appointments');
            },
            child: Container(
              // margin: EdgeInsets.fromLTRB(
              //     0 * width, 3 * width, 42 * width, 4 * width),
              height: 70,
              width: MediaQuery.of(context).size.width * 0.2,
              color: widget.tabId == 1 ? primaryColor : appbar,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Image.asset(
                            "assets/images/event.png",
                            width: 20.0,
                            height: 20.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          'appointments'.tr.toUpperCase() + '\n',
                          style: TextStyle(color: textcolor, fontSize: 7),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/bookanAppointment');
            },
            child: Container(
              // margin: EdgeInsets.fromLTRB(
              //     0 * width, 3 * width, 42 * width, 4 * width),
              height: 70,
              width: MediaQuery.of(context).size.width * 0.2,
              color: widget.tabId == 2 ? primaryColor : appbar,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Image.asset(
                            "assets/images/date.png",
                            width: 20.0,
                            height: 20.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Center(
                          child: Text(
                            'bookAn'.tr + '\n' + 'appointment'.tr,
                            style: TextStyle(color: textcolor, fontSize: 7),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Results()),
              );
            },
            child: Container(
              // margin: EdgeInsets.fromLTRB(
              //     0 * width, 3 * width, 42 * width, 4 * width),
              height: 70,
              width: MediaQuery.of(context).size.width * 0.2,
              color: widget.tabId == 3 ? primaryColor : appbar,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Image.asset(
                            "assets/images/experiment-results.png",
                            width: 20.0,
                            height: 20.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Center(
                          child: Text(
                            'results'.tr + '/' + '\n' + 'status'.tr,
                            style: TextStyle(color: textcolor, fontSize: 7),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
            child: Container(
              // margin: EdgeInsets.fromLTRB(
              //     0 * width, 3 * width, 42 * width, 4 * width),
              height: 70,
              width: MediaQuery.of(context).size.width * 0.2,
              color: widget.tabId == 4 ? primaryColor : appbar,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Image.asset(
                            "assets/images/user.png",
                            width: 20.0,
                            height: 20.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Center(
                          child: Text(
                            'profile'.tr.toUpperCase() + '\n',
                            style: TextStyle(color: textcolor, fontSize: 7),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTabDefault extends StatefulWidget {
  CustomTabDefault({super.key});

  @override
  State<CustomTabDefault> createState() => CustomTabDefaultState();
}

class CustomTabDefaultState extends State<CustomTabDefault> {
  List<String> tabImages = [
    'assets/images/home.png',
    'assets/images/event.png',
    'assets/images/date.png',
    'assets/images/experiment-results.png',
    'assets/images/user.png',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double width = MediaQuery.of(context).size.width / baseWidth;
    double height = width * 0.97;
//     double width = MediaQuery.of(context).size.width; // Get the screen width

// double twentyPercentWidth = 0.2 * width; // Calculate 20% of the width

    return Container(
      // padding:
      //     EdgeInsets.fromLTRB(50 * width, 14 * width, 50 * width, 13 * width),
      width: MediaQuery.of(context).size.width,
      height: 70,
      decoration: BoxDecoration(
        color: appbar,
        boxShadow: [
          BoxShadow(
            color: Color(0x19006ea3),
            offset: Offset(0 * width, 0 * width),
            blurRadius: 10 * width,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: Container(
              // margin: EdgeInsets.fromLTRB(
              //     0 * width, 3 * width, 42 * width, 4 * width),
              height: 70,
              width: MediaQuery.of(context).size.width * 0.2,
              color: appbar,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Image.asset(
                            "assets/images/home.png",
                            width: 20.0,
                            height: 20.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text('home'.tr + '\n',
                            style: TextStyle(color: textcolor, fontSize: 7)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/appointments');
            },
            child: Container(
              // margin: EdgeInsets.fromLTRB(
              //     0 * width, 3 * width, 42 * width, 4 * width),
              height: 70,
              width: MediaQuery.of(context).size.width * 0.2,
              color: appbar,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Image.asset(
                            "assets/images/event.png",
                            width: 20.0,
                            height: 20.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          'appointments'.tr.toUpperCase() + '\n',
                          style: TextStyle(color: textcolor, fontSize: 7),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/bookanAppointment');
            },
            child: Container(
              // margin: EdgeInsets.fromLTRB(
              //     0 * width, 3 * width, 42 * width, 4 * width),
              height: 70,
              width: MediaQuery.of(context).size.width * 0.2,
              color: appbar,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Image.asset(
                            "assets/images/date.png",
                            width: 20.0,
                            height: 20.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Center(
                          child: Text(
                            'bookAn'.tr + '\n' + 'appointment'.tr,
                            style: TextStyle(color: textcolor, fontSize: 7),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Results()),
              );
            },
            child: Container(
              // margin: EdgeInsets.fromLTRB(
              //     0 * width, 3 * width, 42 * width, 4 * width),
              height: 70,
              width: MediaQuery.of(context).size.width * 0.2,
              color: appbar,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Image.asset(
                            "assets/images/experiment-results.png",
                            width: 20.0,
                            height: 20.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Center(
                          child: Text(
                            'results'.tr + '/' + '\n' + 'status'.tr,
                            style: TextStyle(color: textcolor, fontSize: 7),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
            child: Container(
              // margin: EdgeInsets.fromLTRB(
              //     0 * width, 3 * width, 42 * width, 4 * width),
              height: 70,
              width: MediaQuery.of(context).size.width * 0.2,
              color: appbar,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Image.asset(
                            "assets/images/user.png",
                            width: 20.0,
                            height: 20.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Center(
                          child: Text(
                            'profile'.tr.toUpperCase() + '\n',
                            style: TextStyle(color: textcolor, fontSize: 7),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
