// // -------------
// import 'package:QBB/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:QBB/screens/pages/appointments_data_extract.dart';

// class Completed extends StatefulWidget {
//   final List<Map<String, dynamic>> completedAppointments;

//   const Completed({required this.completedAppointments, Key? key})
//       : super(key: key);

//   @override
//   CompletedState createState() => CompletedState();
// }

// class CompletedState extends State<Completed> {
//   @override
//   Widget build(BuildContext context) {
//     print('Completed Appointments: ${widget.completedAppointments}');
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pop(context);
//         return false;
//       },
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               children: [
//                 for (final appointment in widget.completedAppointments)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: const BorderRadius.only(
//                           bottomLeft: Radius.circular(20.0),
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color.fromARGB(255, 188, 188, 188)
//                                 .withOpacity(0.5),
//                             spreadRadius: 5,
//                             blurRadius: 7,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             const SizedBox(
//                               height: 20.0,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       color: appbar,
//                                       child: Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             12, 3.0, 12, 3),
//                                         child: Text(
//                                           DateFormat('dd')
//                                               .format(dateExtract(appointment))
//                                               .toString(),
//                                           style: const TextStyle(
//                                             color: Color.fromARGB(
//                                                 255, 255, 255, 255),
//                                             fontSize: 16,
//                                             backgroundColor: appbar,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.fromLTRB(
//                                           2, 3.0, 12, 3),
//                                       child: Text(
//                                         DateFormat('MM-yyyy')
//                                             .format(dateExtract(appointment))
//                                             .toString(),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       color: Colors.blue,
//                                       child: Padding(
//                                         padding:
//                                             EdgeInsets.fromLTRB(18, 3.0, 18, 3),
//                                         child: Text(
//                                           'completed'.tr,
//                                           style: TextStyle(
//                                             color: Color.fromARGB(
//                                                 255, 255, 255, 255),
//                                             fontSize: 16,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Column(
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Column(
//                                                 children: [
//                                                   Image.asset(
//                                                     "assets/images/fast.png",
//                                                     width: 30.0,
//                                                     height: 30.0,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ],
//                                               ),
//                                               const SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     'timeSlot'.tr,
//                                                     style: TextStyle(
//                                                       color: Color.fromARGB(
//                                                           255, 163, 163, 163),
//                                                       fontSize: 13,
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     timeExtract(
//                                                         appointment), // Use the extracted time here
//                                                     style: const TextStyle(
//                                                         fontSize: 10),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(
//                                         width: 20,
//                                       ),
//                                       Column(
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Column(
//                                                 children: [
//                                                   Image.asset(
//                                                     "assets/images/user-time.png",
//                                                     width: 25.0,
//                                                     height: 25.0,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ],
//                                               ),
//                                               const SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     'visitType'.tr,
//                                                     style: TextStyle(
//                                                       color: Color.fromARGB(
//                                                           255, 163, 163, 163),
//                                                       fontSize: 13,
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     appointment['VisittypeName']
//                                                         .toString(),
//                                                     style: const TextStyle(
//                                                         fontSize: 10),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(
//                                     height: 20,
//                                   ),
//                                   Row(
//                                     children: [
//                                       Column(
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Column(
//                                                 children: [
//                                                   Image.asset(
//                                                     "assets/images/appointment-list.png",
//                                                     width: 25.0,
//                                                     height: 25.0,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ],
//                                               ),
//                                               const SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     'appointmentType'.tr,
//                                                     style: TextStyle(
//                                                       color: Color.fromARGB(
//                                                           255, 163, 163, 163),
//                                                       fontSize: 13,
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     appointment[
//                                                             'AppoinmenttypName']
//                                                         .toString(),
//                                                     style: const TextStyle(
//                                                         fontSize: 10),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(
//                                         width: 40,
//                                       ),
//                                       Column(
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Column(
//                                                 children: [
//                                                   Image.asset(
//                                                     "assets/images/users.png",
//                                                     width: 30.0,
//                                                     height: 30.0,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ],
//                                               ),
//                                               const SizedBox(
//                                                 width: 10,
//                                               ),
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     'studyName'.tr,
//                                                     style: TextStyle(
//                                                       color: Color.fromARGB(
//                                                           255, 163, 163, 163),
//                                                       fontSize: 13,
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     appointment['StudyName']
//                                                         .toString(),
//                                                     style: const TextStyle(
//                                                         fontSize: 10),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:QBB/constants.dart';
import 'package:QBB/nirmal_api.dart/appointments._api.dart';
import 'package:QBB/screens/pages/appointments_data_extract.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Completed extends StatefulWidget {
  final List<Map<String, dynamic>> completedAppointments;

  const Completed({Key? key, required this.completedAppointments})
      : super(key: key);

  @override
  CompletedState createState() => CompletedState();
}

class CompletedState extends State<Completed> {
  List<Map<String, dynamic>> allAppointments = [];
  List<Map<String, dynamic>> allCompletedAppointments = [];

  Future<List<Map<String, dynamic>>> fetchData() async {
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
                                                  : "cancelled".tr,
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
