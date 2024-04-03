import 'dart:convert';
import 'dart:io';
// import 'dart:js';
import 'package:QBB/screens/api/userid.dart';
import 'package:QBB/screens/pages/book_appointment_date_slot.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../nirmal/login_screen.dart';

Future<void> signOut(BuildContext context) async {
  // String qid = '';

  String? qid = await getQIDFromSharedPreferences();

  const String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/LogoutAPI';

  final Map<String, dynamic> queryParams = {
    'QID': qid,
  };

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');

  final Uri uri = Uri.parse('$apiUrl?QID=${queryParams['QID']}');

  try {
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      pref.setString("showDot", "null");
      // Successful API call

      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // Save the API response in shared preferences

      // Now, navigate to the AppointmentBookingPage

      print("Success");
    } else {
      // Handle errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(
              errorMessage: json.decode(response.body)["Message"]);
        },
      );
    }
  } catch (error) {
    // Handle network errors
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: 'Network Error');
      },
    );
  }
}
