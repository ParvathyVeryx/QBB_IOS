import 'dart:convert';

import 'package:QBB/screens/api/userid.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> callUserProfileAPIGet() async {
  int? userId = await getUserIdFromSharedPreferences();
  if (userId != null) {
  } else {
    return "Failed to retrieve user ID"; // or handle it accordingly
  }

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');

  if (token == null) {
    return "Token is null. Unable to make API request."; // or handle it accordingly
  }

  const String apiUrl =
      "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/UserProfileAPI";
  String language = "langChange".tr;

  final Map<String, String> headers = {
    'Authorization': 'Bearer ${token.replaceAll('"', '')}',
  };

  final Uri uri = Uri.parse("$apiUrl?UserId=$userId&language=$language");

  try {
    final http.Response response = await http.get(
      uri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Successful response, return the body
      pref.setString("userMStatus", json.decode(response.body)["MaritalStatus"]).toString();
      return response.body;
    } else {
      // Error handling, log or display an error message
      return "Error: ${response.statusCode} - ${response.body}";
    }
  } catch (e) {
    // Exception handling, log or display an error message
    return "Exception during API request: $e";
  }
}

// Example of calling the function and handling the response
