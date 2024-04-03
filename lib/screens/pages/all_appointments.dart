import 'dart:convert';

import 'package:QBB/constants.dart';
import 'package:QBB/nirmal_api.dart/appointments._api.dart';
import 'package:QBB/nirmal_api.dart/booking_get_slots.dart';
import 'package:QBB/screens/api/userid.dart';
import 'package:QBB/screens/pages/appointments.dart';
import 'package:QBB/screens/pages/appointments_data_extract.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:QBB/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AllAppointments extends StatefulWidget {
  final List<Map<String, dynamic>> allAppointments;

  const AllAppointments({Key? key, required this.allAppointments})
      : super(key: key);

  @override
  AllAppointmentsState createState() => AllAppointmentsState();
}

class AllAppointmentsState extends State<AllAppointments> {
  List<Map<String, dynamic>> allAppointments = [];
  String allCancelMsg = '';
  List<String> cancelMessages = [];
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
        allCancelMsg = allAppointments[0]["CancelExpiredMSG"];

        cancelMessages = allAppointments
            .map((appointment) => appointment["CancelExpiredMSG"])
            .cast<String>()
            .toList();
        print(allAppointments);
        List<Map<String, dynamic>> reversedAppointments =
            allAppointments.reversed.toList();
        allAppointments.sort((a, b) {
          DateTime dateA = DateTime.parse(a['AppoimentDate']);
          DateTime dateB = DateTime.parse(b['AppoimentDate']);
          return dateB.compareTo(dateA);
        });
        return allAppointments;
      } else {
        // Handle errors

        return []; // Return an empty list in case of an error
      }
    } catch (e, stackTrace) {
      return []; // Return an empty list in case of an exception
    }
  }

  bool? showDot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isMounted = true;
    fetchData();
    showDotNotification();
    // setState(() {
    getReasons();
    // });
  }

  List<Map<String, dynamic>> reasons = [];
  Future<List<Map<String, dynamic>>> getReasons() async {
    print("Reasons");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var lang = 'langChange'.tr;
    String token = pref.getString('token') ??
        ''; // Replace 'auth_token' with your actual key
    try {
      print("Reasons 2");
      var response = await http.get(
        Uri.parse(
            "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetReasonForCancelAppoinmentAPI?language=$lang"),
        headers: {
          'Authorization': 'Bearer ${token.replaceAll('"', '')}',
        },
      );
      print("Reasons 3");

      if (response.statusCode == 200) {
        print("Reasons 4");
        // Parse and handle the response body
        var responseBody = json.decode(response.body);

        reasons = List<Map<String, dynamic>>.from(responseBody);

        return reasons;
      } else {
        print("Reasons 5");
        return [];
      }
    } catch (e) {
      print("Reasons 6");
      return [];
    }
  }

  String selectedReason = '';

  List<Widget> buildReasonRadioButtons(StateSetter setState) {
    // Create a list of radio buttons based on the reasons
    return reasons.map((reason) {
      String reasonName = reason['Name'] ?? '';
      print(reason);
      return RadioListTile(
        title: Text(
          reasonName,
          style: TextStyle(fontSize: 10),
        ),
        value: reasonName,
        groupValue: selectedReason,
        activeColor: primaryColor,
        onChanged: (value) async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          // Handle radio button selection
          setState(() {
            selectedReason = value as String;
          });
          pref.setString("selectedReason", value as String);
        },
      );
    }).toList();
  }

// Widget buildReasonRadioButtons(
//   StateSetter setState,
//   List<Map<String, dynamic>> reasons,
// ) {
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     children: reasons.map((reason) {
//       String reasonName = reason['Name'] ?? '';
//       print(reason);
//       return RadioListTile(
//         title: Text(
//           reasonName,
//           style: TextStyle(fontSize: 10),
//         ),
//         value: reasonName,
//         groupValue: selectedReason,
//         activeColor: primaryColor,
//         onChanged: (value) async {
//           SharedPreferences pref = await SharedPreferences.getInstance();
//           setState(() {
//             selectedReason = value as String;
//           });
//           pref.setString("selectedReason", value as String);
//         },
//       );
//     }).toList(),
//   );
// }

  Future<void> cancelResultAppointment(String appointmentId) async {
    final GlobalKey<State> _keyLoader = GlobalKey<State>();
    LoaderWidget _loader = LoaderWidget();
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? qid = await getQIDFromSharedPreferences();
    var lang = 'langChange'.tr;
    // String selectedAppointmentId =
    //     pref.getString("selectedAppointmentId").toString();
    // String selectedReason = pref.getString("selectedReason").toString();

    try {
      Dialogs.showLoadingDialog(context, _keyLoader, _loader);
      // Retrieve the token from SharedPreferences
      String? token = pref.getString('token');
      if (token == null) {
        // Handle the case where the token is not available
        return;
      }

      // Construct headers with the retrieved token
      Map<String, String> headers = {
        'Authorization': 'Bearer ${token.replaceAll('"', '')}',
      };

      Map<String, dynamic> requestBody = {
        "QID": qid,
        "AppoinmentId": appointmentId,
        "Reason": selectedReason,
        "ReasonType": "4",
        "language": 'langChange'.tr
      };

      // Construct the API URL
      Uri apiUrl = Uri.parse(
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/CancelResultAppointmentAPI');

      // Make the HTTP POST request
      final response =
          await http.post(apiUrl, headers: headers, body: requestBody);
      print("Cancel Result Appointment");
      if (response.statusCode == 200) {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
       await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(50.0), // Adjust the radius as needed
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  json.decode(response.body)["Message"],
                  style:
                      const TextStyle(color: Color.fromARGB(255, 74, 74, 74)),
                ),
              ),
              actions: <Widget>[
                // Divider(),
                TextButton(
                  onPressed: () async {
                    Navigator.pushNamed(context, '/appointments');
                  },
                  child: Text(
                    'ok'.tr,
                    style: TextStyle(color: secondaryColor),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        await showDialog(
            context: context, // Use the context of the current screen
            builder: (BuildContext context) {
              return ErrorPopup(
                  errorMessage: json.decode(response.body)["Message"]);
            });
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      print("Exception caught: $e");
      await showDialog(
          context: context, // Use the context of the current screen
          builder: (BuildContext context) {
            return ErrorPopup(
              errorMessage: '$e',
            );
          });
    }
  }

  Future<void> cancelAnAppointment(String appointmentId) async {
    final GlobalKey<State> _keyLoader = GlobalKey<State>();
    LoaderWidget _loader = LoaderWidget();
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? qid = await getQIDFromSharedPreferences();
    var lang = 'langChange'.tr;
    // String selectedAppointmentId =
    //     pref.getString("selectedAppointmentId").toString();
    // String selectedReason = pref.getString("selectedReason").toString();

    try {
      Dialogs.showLoadingDialog(context, _keyLoader, _loader);
      // Retrieve the token from SharedPreferences
      String? token = pref.getString('token');
      if (token == null) {
        // Handle the case where the token is not available
        return;
      }

      // Construct headers with the retrieved token
      Map<String, String> headers = {
        'Authorization': 'Bearer ${token.replaceAll('"', '')}',
      };

      Map<String, dynamic> requestBody = {
        "QID": qid,
        "AppoinmentId": appointmentId,
        "Reason": selectedReason,
        "ReasonType": "4",
        "language": 'langChange'.tr
      };

      // Construct the API URL
      Uri apiUrl = Uri.parse(
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/CancelAppointmentAPI');

      // Make the HTTP POST request
      final response =
          await http.post(apiUrl, headers: headers, body: requestBody);

      if (response.statusCode == 200) {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(50.0), // Adjust the radius as needed
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  json.decode(response.body)["Message"],
                  style:
                      const TextStyle(color: Color.fromARGB(255, 74, 74, 74)),
                ),
              ),
              actions: <Widget>[
                // Divider(),
                TextButton(
                  onPressed: () async {
                    Navigator.pushNamed(context, '/appointments');
                  },
                  child: Text(
                    'ok'.tr,
                    style: TextStyle(color: secondaryColor),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        await showDialog(
            context: context, // Use the context of the current screen
            builder: (BuildContext context) {
              return ErrorPopup(
                  errorMessage: json.decode(response.body)["Message"]);
            });
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      print("Exception caught: $e");
      await showDialog(
          context: context, // Use the context of the current screen
          builder: (BuildContext context) {
            return ErrorPopup(
              errorMessage: '$e',
            );
          });
    }
  }

  Future<void> showDotNotification() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String sD = pref.getString("showDot").toString();

    sD == "null" ? showDot = true : showDot = false;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
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
            return LoaderWidget();
          } else {
            completedAppointments = snapshot.data!;
          }
          if (snapshot.data!.length == 0) {
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.95,
                child: Center(child: Text('thereAreNoAppointments'.tr)));
          }
          return Scaffold(
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
                                                fontSize: 11,
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
                                            padding: EdgeInsets.fromLTRB(
                                                18, 3.0, 18, 3),
                                            child: Text(
                                              appointment['AppoinmentStatus']
                                                          .toString() ==
                                                      "4"
                                                  ? "completed".tr
                                                  : appointment['AppoinmentStatus']
                                                              .toString() ==
                                                          "1"
                                                      ? 'upcoming'.tr
                                                      : appointment['AppoinmentStatus']
                                                                  .toString() ==
                                                              "10"
                                                          ? 'noShow'.tr
                                                          : appointment['AppoinmentStatus']
                                                                      .toString() ==
                                                                  "2"
                                                              ? 'rescheduled'.tr
                                                              : appointment['AppoinmentStatus']
                                                                          .toString() ==
                                                                      "3"
                                                                  ? 'toReschedule'
                                                                      .tr
                                                                  : appointment['AppoinmentStatus']
                                                                              .toString() ==
                                                                          "5"
                                                                      ? 'cancelled'
                                                                          .tr
                                                                      : appointment['AppoinmentStatus'].toString() ==
                                                                              "7"
                                                                          ? 'revisitRequired'
                                                                              .tr
                                                                          : appointment['AppoinmentStatus'].toString() == "8"
                                                                              ? 'arrived'.tr
                                                                              : appointment['AppoinmentStatus'].toString() == "9"
                                                                                  ? 'delayed'.tr
                                                                                  : appointment['AppoinmentStatus'].toString() == "11"
                                                                                      ? 'resultReady'.tr
                                                                                      : appointment['AppoinmentStatus'].toString() == "12"
                                                                                          ? 'revisitNotRequired'.tr
                                                                                          : appointment['AppoinmentStatus'].toString() == "13"
                                                                                              ? 'wishList'.tr
                                                                                              : appointment['AppoinmentStatus'].toString() == "14"
                                                                                                  ? 'confirmed'.tr
                                                                                                  : appointment['AppoinmentStatus'].toString() == "15"
                                                                                                      ? 'onTheWay'.tr
                                                                                                      : appointment['AppoinmentStatus'].toString() == "16"
                                                                                                          ? 'reminded'.tr
                                                                                                          : appointment['AppoinmentStatus'].toString() == "17"
                                                                                                              ? 'mayBe'.tr
                                                                                                              : '',
                                              style: TextStyle(
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
                                                        "assets/images/fast.png",
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
                                                        'timeSlot'.tr,
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              163,
                                                              163,
                                                              163),
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                      Text(
                                                        timeExtract(
                                                            appointment), // Use the extracted time here
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
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
                                                        style: TextStyle(
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
                                                        style: TextStyle(
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
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/appointment-list.png",
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
                                                        'appointmentType'.tr,
                                                        style: TextStyle(
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
                                                                'AppoinmenttypName']
                                                            .toString(),
                                                        style: TextStyle(
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
                                                        style: TextStyle(
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
                                                        style: TextStyle(
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
                                      appointment["AppoinmentStatus"] == 1 ||
                                              appointment["AppoinmentStatus"] ==
                                                  2
                                          ? Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 150,
                                                    child: ElevatedButton(
                                                      style: appointment[
                                                                  "showCancelBtn"] ==
                                                              false
                                                          ? ElevatedButton
                                                              .styleFrom(
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20.0),
                                                                ),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.white,
                                                              side: const BorderSide(
                                                                  color:
                                                                      appbar),
                                                              elevation: 0,
                                                            )
                                                          : ElevatedButton
                                                              .styleFrom(
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20.0),
                                                                ),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.white
                                                                      .withOpacity(
                                                                          0.5),
                                                              side: const BorderSide(
                                                                  color:
                                                                      appbar),
                                                              elevation: 0,
                                                            ),
                                                      onPressed: () async {
                                                        setState(() {
                                                          getReasons();
                                                        });

                                                        appointment["showCancelBtn"] ==
                                                                false
                                                            ? //   showDialog(
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return ErrorPopup(
                                                                      errorMessage:
                                                                          appointment[
                                                                              'CancelExpiredMSG']);
                                                                })
                                                            : appointment[
                                                                        "AppoinmenttypName"] ==
                                                                    "Result"
                                                                ? showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        shape: CustomAlertDialogShape(
                                                                            bottomLeftRadius:
                                                                                36.0),
                                                                        title:
                                                                            Column(
                                                                          children: [
                                                                            Center(child: Text("", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            // Divider(),
                                                                          ],
                                                                        ),
                                                                        content:
                                                                            StatefulBuilder(
                                                                          builder:
                                                                              (BuildContext context, StateSetter setState) {
                                                                            return Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                ...buildReasonRadioButtons(setState),

                                                                                // ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        ),
                                                                        actions: [
                                                                          Column(
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  TextButton(
                                                                                    onPressed: () async {
                                                                                      // SharedPreferences prefs =
                                                                                      //     await SharedPreferences.getInstance();
                                                                                      // var selectedLanguagePref =
                                                                                      //     prefs.getString('langEn').toString();
                                                                                      // if (selectedLanguagePref == "false") {
                                                                                      //   selectedLanguage = 'Arabic';
                                                                                      // } else {
                                                                                      //   selectedLanguage = 'English';
                                                                                      // }
                                                                                      Navigator.of(context).pop(); // Close the dialog
                                                                                    },
                                                                                    child: Text('cancelButton'.tr),
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed: () {
                                                                                      String appId = appointment["AppoinmentId"].toString();

                                                                                      cancelResultAppointment(appId);
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text('ok'.tr),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  )
                                                                : showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        shape: CustomAlertDialogShape(
                                                                            bottomLeftRadius:
                                                                                36.0),
                                                                        title:
                                                                            Column(
                                                                          children: [
                                                                            Center(child: Text("", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            // Divider(),
                                                                          ],
                                                                        ),
                                                                        content:
                                                                            StatefulBuilder(
                                                                          builder:
                                                                              (BuildContext context, StateSetter setState) {
                                                                            return Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                ...buildReasonRadioButtons(setState),

                                                                                // ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        ),
                                                                        actions: [
                                                                          Column(
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  TextButton(
                                                                                    onPressed: () async {
                                                                                      // SharedPreferences prefs =
                                                                                      //     await SharedPreferences.getInstance();
                                                                                      // var selectedLanguagePref =
                                                                                      //     prefs.getString('langEn').toString();
                                                                                      // if (selectedLanguagePref == "false") {
                                                                                      //   selectedLanguage = 'Arabic';
                                                                                      // } else {
                                                                                      //   selectedLanguage = 'English';
                                                                                      // }
                                                                                      Navigator.of(context).pop(); // Close the dialog
                                                                                    },
                                                                                    child: Text('cancelButton'.tr),
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed: () {
                                                                                      String appId = appointment["AppoinmentId"].toString();

                                                                                      cancelAnAppointment(appId);
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text('ok'.tr),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                        // }
                                                      },
                                                      child: Text(
                                                        'cancelButton'.tr,
                                                        style: TextStyle(
                                                            color: appbar,
                                                            fontSize: 11),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16.0),
                                                  SizedBox(
                                                    width: 150,
                                                    child: ElevatedButton(
                                                      style: appointment[
                                                                  "showRescheduleBtn"] ==
                                                              true
                                                          ? ElevatedButton
                                                              .styleFrom(
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20.0),
                                                                ),
                                                              ),
                                                              backgroundColor:
                                                                  primaryColor,
                                                              // side: const BorderSide(
                                                              //     color: Colors.black),
                                                              elevation: 0,
                                                            )
                                                          : ElevatedButton
                                                              .styleFrom(
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20.0),
                                                                ),
                                                              ),
                                                              backgroundColor:
                                                                  primaryColor
                                                                      .withOpacity(
                                                                          0.5),
                                                              // side: const BorderSide(
                                                              //     color: Colors.black),
                                                              elevation: 0,
                                                            ),
                                                      onPressed: () {
                                                        String appId = appointment[
                                                                "AppoinmentId"]
                                                            .toString();
                                                        String Vtype = appointment[
                                                                'VisittypeName']
                                                            .toString();
                                                        String vTypeId =
                                                            appointment[
                                                                    'VisitTypeId']
                                                                .toString();
                                                        String appstatus =
                                                            appointment[
                                                                    'AppoinmentStatus']
                                                                .toString();
                                                        String calendarId =
                                                            appointment[
                                                                    "AvailabilityCalenderId"]
                                                                .toString();
                                                        String appTypeId =
                                                            appointment[
                                                                    "AppointmentTypeId"]
                                                                .toString();
                                                        String studyId =
                                                            appointment[
                                                                    "StudyId"]
                                                                .toString();
                                                        String appDate =
                                                            appointment[
                                                                "AppoimentDate"];
                                                        // rescheduleAppointment(
                                                        //     appId,
                                                        //     appstatus,
                                                        //     Vtype,
                                                        //     calendarId,
                                                        //     appTypeId,
                                                        //     vTypeId,
                                                        //     studyId);
                                                        appointment["showRescheduleBtn"] ==
                                                                true
                                                            ? showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    shape:
                                                                        const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        bottomLeft:
                                                                            Radius.circular(50.0), // Adjust the radius as needed
                                                                      ),
                                                                    ),
                                                                    content:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              12.0),
                                                                      child:
                                                                          Text(
                                                                        'rescheduleAppoint'
                                                                            .tr,
                                                                        style: const TextStyle(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                74,
                                                                                74,
                                                                                74)),
                                                                      ),
                                                                    ),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          appointment["AppoinmenttypName"] == "Result"
                                                                              ? GetResultRescheduleAppointment(context, studyId, vTypeId, Vtype, appId, appDate, appTypeId)
                                                                              : GetRescheduleAppointment(context, studyId, vTypeId, Vtype, appId, appDate, appTypeId);

                                                                          // Navigator.pop(context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'ok'.tr,
                                                                          style:
                                                                              TextStyle(color: secondaryColor),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              )
                                                            : showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return ErrorPopup(
                                                                      errorMessage:
                                                                          appointment[
                                                                              "ResultExpiredMSG"]);
                                                                },
                                                              );
                                                        // appointment["AppoinmenttypName"] ==
                                                        //         "Result"
                                                        //     ? GetResultRescheduleAppointment(
                                                        //         context,
                                                        //         studyId,
                                                        //         vTypeId,
                                                        //         Vtype,
                                                        //         appId,
                                                        //         appDate)
                                                        //     : GetRescheduleAppointment(
                                                        //         context,
                                                        //         studyId,
                                                        //         vTypeId,
                                                        //         Vtype,
                                                        //         appId,
                                                        //         appDate);
                                                      },
                                                      child: Text(
                                                        'reschedule'.tr,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 11),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container()
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
