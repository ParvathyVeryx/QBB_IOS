import 'dart:convert';

import 'package:QBB/constants.dart';
import 'package:QBB/nirmal_api.dart/appointments._api.dart';
import 'package:QBB/nirmal_api.dart/booking_get_slots.dart';
import 'package:QBB/screens/pages/all_appointments.dart';
import 'package:QBB/screens/pages/appointments.dart';
import 'package:QBB/screens/pages/appointments_data_extract.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../customNavBar.dart';
import '../../sidebar.dart';
import '../api/results_api.dart';
import 'book_appintment_nk.dart';
import 'homescreen_nk.dart';
import 'notification.dart';
import 'profile.dart';

class Results extends StatefulWidget {
  const Results({
    Key? key,
  }) : super(key: key);

  @override
  ResultsState createState() => ResultsState();
}

class ResultsState extends State<Results> {
  List<Map<String, dynamic>> allreslt = [];

  bool _isMounted = false;
  Future<List<Map<String, dynamic>>> fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var lang = 'langChange'.tr;
    String qid = pref.getString("userQID").toString();

    try {
      // Get the token from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ??
          ''; // Replace 'auth_token' with your actual key

      // Check if the token is available
      if (token.isEmpty) {
        return [];
      }

      // Construct the request URL
      String apiUrl =
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/ViewAllResultAppointmentsAPI';
      String requestUrl = '$apiUrl?qid=$qid&page=1&language=$lang';

      // Make the GET request with the token in the headers
      var response = await http.get(
        Uri.parse(requestUrl),
        headers: {
          'Authorization': 'Bearer ${token.replaceAll('"', '')}',
        },
      );
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String qid = prefs.getString("userQID").toString();
      // var lang = 'langChange'.tr;

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse and handle the response body
        var responseBody = json.decode(response.body);
        allreslt = List<Map<String, dynamic>>.from(responseBody);
        return allreslt;
      } else {
        // Handle errors

        return []; // Return an empty list in case of an error
      }
    } catch (e, stackTrace) {
      return []; // Return an empty list in case of an exception
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchAppointmentsData();
    super.initState();
    showDotNotification();
    _isMounted = true;
    fetchData();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  int currentIndex = 3;

  bool isDateGreaterThanOrEqualToToday(DateTime dateToCheck) {
    DateTime today = DateTime.now();
    return dateToCheck.isAfter(today) || dateToCheck.isAtSameMomentAs(today);
  }

  bool? showDot;
  Future<void> showDotNotification() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String sD = pref.getString("showDot").toString();

    setState(() {
      sD == "null" ? showDot = true : showDot = false;
    });
  }

  List<Map<String, dynamic>> allAppointments = [];
  String allCancelMsg = '';
  List<String> cancelMessages = [];

  List<Map<String, dynamic>> allCompletedAppointments = [];

  Future<List<Map<String, dynamic>>> fetchAppointmentsData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var lang = 'langChange'.tr;
    String qid = pref.getString("userQID").toString();

    // try {

    //   var appointments = await viewAppointments('$qid', 1, '$lang');
    //   // setState(() {
    //   //   // Set all appointments
    //   //   allAppointments = appointments;
    //   // });
    //   allAppointments = appointments;
    //   return appointments;
    // } catch (error) {
    //   // Handle errors, e.g., show an error message.
    //   print('Error fetching appointments: $error');
    //   throw error; // Make sure to rethrow the error
    // }

    try {
      // Get the token from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ??
          ''; // Replace 'auth_token' with your actual key

      // Check if the token is available
      if (token.isEmpty) {
        return [];
      }

      // Construct the request URL
      String apiUrl =
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/ViewAppointmentsAPI';
      String requestUrl = '$apiUrl?qid=$qid&page=1&language=$lang';

      // Make the GET request with the token in the headers
      var response = await http.get(
        Uri.parse(requestUrl),
        headers: {
          'Authorization': 'Bearer ${token.replaceAll('"', '')}',
        },
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse and handle the response body
        var responseBody = json.decode(response.body);
        allAppointments = List<Map<String, dynamic>>.from(responseBody);
        allCompletedAppointments = allAppointments
            .where((appointment) =>
                appointment['AppoinmentStatus'] is int &&
                appointment['AppoinmentStatus'] == 4)
            .toList();
        print("All app length" + allCompletedAppointments.length.toString());
        allCompletedAppointments.sort((a, b) {
          DateTime dateA = DateTime.parse(a['AppoimentDate']);
          DateTime dateB = DateTime.parse(b['AppoimentDate']);
          return dateB.compareTo(dateA);
        });
        return allCompletedAppointments;
      } else {
        // Handle errors

        return []; // Return an empty list in case of an error
      }
    } catch (e, stackTrace) {
      return []; // Return an empty list in case of an exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   // Display a loading indicator while waiting for the data
        //   return CircularProgressIndicator();
        // } else
        if (snapshot.hasError) {
          // Display an error message if an error occurs
          return Text('Error: ${snapshot.error}');
        } else {
          // Display the data when it's available
          List<Map<String, dynamic>> completedAppointments = [];
          if (!snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: appbar,
                  ),
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
                        'results'.tr,
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
                            Icon(Icons.notifications_none_outlined),
                            if (showDot == true)
                              Positioned(
                                top: 0,
                                right: 0,
                                bottom: 3,
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                  ),
                                  child: Text(
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
                  iconTheme: const IconThemeData(color: textcolor),

                  // actions: [
                  //   IconButton(
                  //     onPressed: () {},
                  //     icon: Icon(Icons.notifications_none_outlined),
                  //     iconSize: 30.0,
                  //   ),
                  // ],
                ),
                drawer: const SideMenu(),
                bottomNavigationBar: CustomTab(
                  tabId: 3,
                ),
                body: Center(child: LoaderWidget()));
          } else {
            completedAppointments = snapshot.data!;
          }

          if (snapshot.data!.length == 0) {
            // return Container(
            //     height: MediaQuery.of(context).size.height * 0.95,
            //     child: const Center(child: Text("No new notifications")));
            return Scaffold(
                appBar: AppBar(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: appbar,
                  ),
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
                        'results'.tr,
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
                            Icon(Icons.notifications_none_outlined),
                            if (showDot == true)
                              Positioned(
                                top: 0,
                                right: 0,
                                bottom: 3,
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                  ),
                                  child: Text(
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
                  iconTheme: const IconThemeData(color: textcolor),

                  // actions: [
                  //   IconButton(
                  //     onPressed: () {},
                  //     icon: Icon(Icons.notifications_none_outlined),
                  //     iconSize: 30.0,
                  //   ),
                  // ],
                ),
                drawer: const SideMenu(),
                bottomNavigationBar: CustomTab(
                  tabId: 3,
                ),
                body: SingleChildScrollView(
                    child: Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'resultsAreStillUnderReviewYouWillReceiveAnSMSOnceTheResultsAreReady'
                          .tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  )),
                )));
          }

          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: appbar,
              ),
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
                    'results'.tr,
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
                        Icon(Icons.notifications_none_outlined),
                        if (showDot == true)
                          Positioned(
                            top: 0,
                            right: 0,
                            bottom: 3,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                              child: Text(
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
              iconTheme: const IconThemeData(color: textcolor),

              // actions: [
              //   IconButton(
              //     onPressed: () {},
              //     icon: Icon(Icons.notifications_none_outlined),
              //     iconSize: 30.0,
              //   ),
              // ],
            ),
            drawer: const SideMenu(),
            bottomNavigationBar: CustomTab(
              tabId: 3,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    for (final appointment in completedAppointments)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 188, 188, 188)
                                    .withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, top: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          color: appbar,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 3.0, 12, 3),
                                            child: Text(
                                              DateFormat('dd')
                                                  .format(
                                                      dateExtract(appointment))
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 12,
                                                backgroundColor: appbar,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              2, 3.0, 12, 3),
                                          child: Text(
                                            DateFormat('MM-yyyy')
                                                .format(
                                                    dateExtract(appointment))
                                                .toString(),
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          color: Colors.blue,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                18, 3.0, 18, 3),
                                            child: Text(
                                              // appointment['AppoinmentStatus']
                                              //             .toString() ==
                                              //         "4"
                                              //     ? "results".tr
                                              //     : "cancelled".tr,
                                              "results".tr,
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 10, 20, 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/user-time.png",
                                                        width: 25.0,
                                                        height: 25.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'visitType'.tr,
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              163,
                                                              163,
                                                              163),
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                      Text(
                                                        appointment[
                                                                'VisittypeName']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 40,
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/users.png",
                                                        width: 30.0,
                                                        height: 30.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'studyName'.tr,
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              163,
                                                              163,
                                                              163),
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                      Text(
                                                        appointment['StudyName']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: Text(
                                          "yourResultIsReadyForCollection".tr,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  255, 171, 171, 171)),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          appointment["showResultBookingBtn"] ==
                                                  true
                                              ? ElevatedButton(
                                                  onPressed: () async {
                                                    SharedPreferences pref =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    pref.setString(
                                                        "resultsStudyID",
                                                        appointment["StudyId"]
                                                            .toString());
                                                    pref.setString(
                                                        "resultsVisitTypeID",
                                                        appointment[
                                                                'VisitTypeId']
                                                            .toString());
                                                    pref.setString(
                                                        "resultsAppID",
                                                        appointment[
                                                                'AppoinmentId']
                                                            .toString());
                                                    pref.setString(
                                                        "resultsAppointmentTypeID",
                                                        appointment[
                                                                "AppointmentTypeId"]
                                                            .toString());
                                                    //   await bookAppointmentToGetResults(
                                                    //     context,
                                                    //     appointment["QID"]
                                                    //         .toString(),
                                                    //     appointment[
                                                    //             "AppointmentTypeId"]
                                                    //         .toString(),
                                                    //     appointment[
                                                    //             'AppoinmentId']
                                                    //         .toString(),
                                                    //     appointment["StudyId"]
                                                    //         .toString(),
                                                    //     appointment["VisitTypeId"]
                                                    //         .toString(),
                                                    //     appointment[
                                                    //             'AvailabilityCalenderId']
                                                    //         .toString(),
                                                    //   );
                                                    getResultsSlot(
                                                        context,
                                                        appointment["StudyId"]
                                                            .toString(),
                                                        appointment[
                                                                'VisitTypeId']
                                                            .toString(),
                                                        appointment[
                                                                'VisittypeName']
                                                            .toString(),
                                                        appointment[
                                                                'AppoinmentId']
                                                            .toString(),
                                                        appointment[
                                                                "AppointmentTypeId"]
                                                            .toString());
                                                    // await getResultAppointmentApiCall(
                                                    //     context,
                                                    //     appointment["StudyId"]
                                                    //         .toString(),
                                                    //     appointment["VisitTypeId"]
                                                    //         .toString(),
                                                    //     appointment["AppoinmentId"]
                                                    //         .toString());
                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<
                                                                  Color>(
                                                              primaryColor), // Set background color
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    12.0), // Rounded border at bottom-left
                                                          ),
                                                        ),
                                                      )),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        015, 0, 015, 0),
                                                    child: Text(
                                                      'collectResult'.tr,
                                                      style: const TextStyle(
                                                          color: textcolor,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await getresults(
                                                  context,
                                                  appointment["QID"],
                                                  appointment["AppoinmentId"]
                                                      .toString(),
                                                  'en');

                                              // String dateString = appointment[
                                              //     "ResultExpiredDate"];
                                              // DateTime resultExpiredDate =
                                              //     DateTime.parse(dateString);
                                              // showDialog(
                                              //   context: context,
                                              //   builder:
                                              //       (BuildContext context) {
                                              //     return AlertDialog(
                                              //       title: Text(''),
                                              //       content:
                                              //           isDateGreaterThanOrEqualToToday(
                                              //                   resultExpiredDate)
                                              //               ? null
                                              //               : Text(appointment[
                                              //                   "ExpiredMsg"]),
                                              //       actions: [
                                              //         ElevatedButton(
                                              //           onPressed: () {
                                              //             Navigator.pop(
                                              //                 context); // Close the dialog
                                              //           },
                                              //           child: Text('OK'),
                                              //         ),
                                              //       ],
                                              //     );
                                              //   },
                                              // );
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        textcolor.withOpacity(
                                                            0.6)), // Set background color
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  const RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      color:
                                                          secondaryColor, // Specify the border color here
                                                      width:
                                                          1.0, // Specify the border width here
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft: Radius.circular(
                                                          12.0), // Rounded border at bottom-left
                                                    ),
                                                  ),
                                                )),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      015, 0, 015, 0),
                                              child: Text(
                                                'download'.tr,
                                                style: const TextStyle(
                                                    color: secondaryColor,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // ElevatedButton(
                                      //   onPressed: () async {
                                      //     await downloadNewTest(context, "", "");
                                      //   },
                                      //   style: ButtonStyle(
                                      //       backgroundColor: MaterialStateProperty
                                      //           .all<Color>(textcolor.withOpacity(
                                      //               0.6)), // Set background color
                                      //       shape: MaterialStateProperty.all<
                                      //           RoundedRectangleBorder>(
                                      //         const RoundedRectangleBorder(
                                      //           side: BorderSide(
                                      //             color:
                                      //                 secondaryColor, // Specify the border color here
                                      //             width:
                                      //                 1.0, // Specify the border width here
                                      //           ),
                                      //           borderRadius: BorderRadius.only(
                                      //             bottomLeft: Radius.circular(
                                      //                 12.0), // Rounded border at bottom-left
                                      //           ),
                                      //         ),
                                      //       )),
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.fromLTRB(
                                      //         015, 0, 015, 0),
                                      //     child: Text(
                                      //       'download'.tr,
                                      //       style: const TextStyle(
                                      //           color: secondaryColor,
                                      //           fontSize: 12),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
