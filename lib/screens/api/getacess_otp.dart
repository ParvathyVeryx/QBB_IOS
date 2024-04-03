import 'dart:convert';
// import 'dart:html';
import 'package:QBB/constants.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../nirmal_api.dart/profile_api.dart';
import '../pages/loader.dart';

Future<bool> getAccess(String qid, String otp, BuildContext context) async {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  LoaderWidget _loader = LoaderWidget();
  // Retrieve token from shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    // Handle the case where the token is not available in shared preferences
    return false;
  }

  final Map<String, dynamic> verify = {
    'QID': qid,
    'OTP': otp,
  };

  final String verifyOtp =
      '$base_url/AcessSetupOTP?QID=${verify['QID']}&OtpToken=${verify['OTP']}';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${token.replaceAll('"', '')}',
  };

  try {
    Dialogs.showLoadingDialog(context, _keyLoader, _loader);
    final response = await http.get(Uri.parse(verifyOtp), headers: headers);
    print(verifyOtp);
    if (response.statusCode == 200) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      var userId = json.decode(response.body);
      // showDialog(
      //   context: context, // Use the context of the current screen
      //   builder: (BuildContext context) {
      //     return ErrorPopup(
      //         errorMessage: json.decode(response.body)["Message"]);
      //   },
      // );
      print(response.body);
      return true; // Return true if OTP verification is successful
    } else {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      // Handle error
      print('Error: ${response.statusCode}');
      await showDialog(
        context: context, // Use the context of the current screen
        builder: (BuildContext context) {
          return ErrorPopup(
              errorMessage: json.decode(response.body)["Message"]);
        },
      );
      print(response.body);
      return false; // Return false to indicate OTP verification failure
    }
  } catch (err) {
    Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    // Handle network errors
    await showDialog(
        context: context, // Use the context of the current screen
        builder: (BuildContext context) {
          return ErrorPopup(
              errorMessage: '$err');
        },
      );
    return false; // Return false to indicate OTP verification failure
  }
}
