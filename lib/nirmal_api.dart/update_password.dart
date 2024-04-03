import 'dart:convert';
import 'package:QBB/constants.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../nirmal/login_screen.dart';
import '../screens/pages/loader.dart';
import 'profile_api.dart';

Future<Map<String, dynamic>> UpdatePasswordAPI(
  String qid,
  String otp,
  String password,
  BuildContext context, // Added password parameter
) async {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  LoaderWidget _loader = LoaderWidget();
  final String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/UpdatePasswordAPI';

  // Get the token from shared preferences
  SharedPreferences pref = await SharedPreferences.getInstance();
  String token = pref.getString('token') ?? ''; // Replace with your token key
  try {
    Dialogs.showLoadingDialog(context, _keyLoader, _loader);
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${token.replaceAll('"', '')}',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'QID': qid,
      'OtpToken': otp,
      'UserPassword': password, // Pass the password parameter
      'language': 'langChange'.tr,
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(requestBody),
    );
    print(response.body);
    print(requestBody);
    if (response.statusCode == 200) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      // If the server returns a 200 OK response, parse the JSON response
      Map<String, dynamic> data = jsonDecode(response.body);
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
                style: const TextStyle(color: Color.fromARGB(255, 74, 74, 74)),
              ),
            ),
            actions: <Widget>[
              Divider(),
              TextButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
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
      print(data);
      return data;
    } else {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      await showDialog(
          context: context, // Use the context of the current screen
          builder: (BuildContext context) {
            return ErrorPopup(
                errorMessage: json.decode(response.body)["Message"]);
          });
      return {'success': false, 'error': response.body};

      // If the server did not return a 200 OK response, throw an exception.
    }
  } catch (e) {
    Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    await showDialog(
        context: context, // Use the context of the current screen
        builder: (BuildContext context) {
          return ErrorPopup(errorMessage: '$e');
        });
    return {'success': false, 'error': '$e'};
  }
}
