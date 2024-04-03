// import 'dart:convert';
// import 'package:QBB/screens/pages/erorr_popup.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import '../screens/pages/loader.dart';
// import 'booking_get_slots.dart';

// Future<Map<String, dynamic>> callUpdatePasswordAPI(
//     String qid, BuildContext context) async {
//   final GlobalKey<State> _keyLoader = GlobalKey<State>();
//   LoaderWidget _loader = LoaderWidget();
//   try {
//     Dialogs.showLoadingDialog(context, _keyLoader, _loader);
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String lang = pref.getString("langEn").toString();
//     String setLang = 'langChange'.tr;

//     // Replace the following URL with your actual API endpoint
//     final apiUrl =
//         'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/UpdatePasswordAPI?QID=$qid&language=$setLang';

//     // Get the token from shared preferences
//     String token = pref.getString('token') ?? ''; // Replace with your token key

//     final response = await http.get(
//       Uri.parse(apiUrl),
//       headers: {
//         'Authorization': 'Bearer ${token.replaceAll('"', '')}',
//         'Content-Type': 'application/json',
//       },
//     );
//     print(token);
//     print(response.statusCode);
//     print(apiUrl);

//     if (response.statusCode == 200) {
//       Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//       // If the server returns a 200 OK response, parse and return the data
//       showDialog(
//           context: context, // Use the context of the current screen
//           builder: (BuildContext context) {
//             return ErrorPopup(
//                 errorMessage: json.decode(response.body)["Message"]);
//           });
//       return json.decode(response.body);
//     } else {
//       Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//       // If the server did not return a 200 OK response, handle errors
//       showDialog(
//           context: context, // Use the context of the current screen
//           builder: (BuildContext context) {
//             return ErrorPopup(
//                 errorMessage: json.decode(response.body)["Message"]);
//           });
//       throw Exception(
//           'Failed to call UpdatePasswordAPI: ${response.statusCode}');
//     }
//   } catch (e) {
//     Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//     // showDialog(
//     //     context: context, // Use the context of the current screen
//     //     builder: (BuildContext context) {
//     //       return ErrorPopup(errorMessage: '$e');
//     //     });
//     throw Exception('Exception during API request: $e');
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/pages/erorr_popup.dart';
import '../screens/pages/loader.dart';
import 'booking_get_slots.dart';

Future<Map<String, dynamic>> callUpdatePasswordAPI(
    String qid, BuildContext context) async {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  LoaderWidget _loader = LoaderWidget();

  try {
    Dialogs.showLoadingDialog(context, _keyLoader, _loader);
    //
    SharedPreferences pref = await SharedPreferences.getInstance();
    String lang = pref.getString("langEn").toString();
    String setLang = 'langChange'.tr;

    final apiUrl =
        'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/UpdatePasswordAPI?QID=$qid&language=$setLang';

    String token = pref.getString('token') ?? '';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer ${token.replaceAll('"', '')}',
        'Content-Type': 'application/json',
      },
    );

    print(token);
    print(response.statusCode);
    print(apiUrl);
    print(response.body);

    //

    if (response.statusCode == 200) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(
            errorMessage: json.decode(response.body)["Message"],
          );
        },
      );
      return json.decode(response.body);
    } else {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      print("error");
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(
            errorMessage: json.decode(response.body)["Message"],
          );
        },
      );

      throw Exception(
          'Failed to call UpdatePasswordAPI: ${response.statusCode}');
    }
  } catch (e) {
    Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    // Log the actual exception for debugging
    // print('Exception during API request: $e');
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(
            errorMessage:'$e'
          );
        });
    throw Exception('Exception during API request: $e');
  } finally {
    // Any cleanup code can go here
  }
}
