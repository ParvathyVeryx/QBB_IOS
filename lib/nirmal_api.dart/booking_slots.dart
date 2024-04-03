import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/api/userid.dart';

Future<String?> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<void> bookAppointmentApiCallPost(String studyId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? qid = await getQIDFromSharedPreferences();
    int? personGradeId = await getPersonGradeIdFromSharedPreferences();


  var lang = 'langChange'.tr;
  final String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/BookAppointmentAPI';

  final String? token = await getAuthToken();

  if (token == null) {
    // Handle the case where the token is not available
    return;
  }

  final Map<String, dynamic> requestBody = {
    "qatarid": "$qid",
    "StudyId": studyId,
    "ShiftCode": null,
    "VisitTypeId": "72",
    "PersonGradeId": personGradeId,
    "AvailabilityCalenderId": null,
    "AppoinmentId": "",
    "language": "$lang",
    "AppointmentTypeId": null,
  };

  final Map<String, String> queryParams = {
    "qatarid": "$qid",
    "StudyId": studyId,
    "ShiftCode": "",
    "VisitTypeId": "72",
    "PersonGradeId": "$personGradeId",
    "AvailabilityCalenderId": "",
    "AppoinmentId": "",
    "language": "$lang",
    "AppointmentTypeId": "",
  };

  final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
  Uri url = Uri.parse(
      "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/BookAppointmentAPI?qatarid=${queryParams['qatarid']}&StudyId=${queryParams['qatarid']}&ShiftCode=${queryParams['qatarid']}&VisitTypeId=${queryParams['qatarid']}&PersonGradeId=${queryParams['PersonGradeId']}&AvailabilityCalenderId=${queryParams['qatarid']}&language=${queryParams['qatarid']}&AppointmentTypeId=${queryParams['qatarid']}");

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // Request was successful, you can handle the response here
    } else {
      // Request failed, handle the error
    }
  } catch (e) {
    // Handle any exceptions that occur during the API call
  }
}
