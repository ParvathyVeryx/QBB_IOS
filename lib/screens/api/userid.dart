import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<int?> getUserIdFromSharedPreferences() async {
  try {
    // Retrieve the stored user details from SharedPreferences
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userDetailsString = pref.getString('userDetails');

    if (userDetailsString != null) {
      // Parse the JSON-encoded string to a Map
      Map<String, dynamic> userDetails = json.decode(userDetailsString);

      // Extract the user ID from the Map
      dynamic userIdDynamic = userDetails['UserId'];

      // Convert the user ID to an integer (or handle other types accordingly)
      if (userIdDynamic is int) {
        int userId = userIdDynamic;
        return userId;
      } else {
        return null;
      }
    } else {
      // Handle the case where user details are not found
      return null;
    }
  } catch (e) {
    // Handle any exceptions that occurred during the process
    return null;
  }
}

Future<String?> getQIDFromSharedPreferences() async {
  try {
    // Retrieve the stored user details from SharedPreferences
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userDetailsString = pref.getString('userDetails');

    if (userDetailsString != null) {
      // Parse the JSON-encoded string to a Map
      Map<String, dynamic> userDetails = json.decode(userDetailsString);

      // Extract the QID from the Map
      dynamic qidDynamic = userDetails['QID'];

      // Convert the QID to a string (or handle other types accordingly)
      if (qidDynamic is String) {
        String qid = qidDynamic;
        return qid;
      } else {
        return null;
      }
    } else {
      // Handle the case where user details are not found
      return null;
    }
  } catch (e) {
    // Handle any exceptions that occurred during the process
    return null;
  }
}

Future<int?> getPersonGradeIdFromSharedPreferences() async {
  try {
    // Retrieve the stored user details from SharedPreferences
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userDetailsString = pref.getString('userDetails');

    if (userDetailsString != null) {
      // Parse the JSON-encoded string to a Map
      Map<String, dynamic> userDetails = json.decode(userDetailsString);

      // Extract the PersonGradeId from the Map
      dynamic personGradeIdDynamic = userDetails['PersonGradeId'];

      // Convert the PersonGradeId to an integer (or handle other types accordingly)
      if (personGradeIdDynamic is int) {
        int personGradeId = personGradeIdDynamic;
        return personGradeId;
      } else {
        return null;
      }
    } else {
      // Handle the case where user details are not found
      return null;
    }
  } catch (e) {
    // Handle any exceptions that occurred during the process
    return null;
  }
}
