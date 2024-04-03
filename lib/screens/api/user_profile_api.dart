import 'package:QBB/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> getUserProfile(int id) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String lang = 'langChange'.tr;
 
  // Replace the following URL with your actual API endpoint
  final apiUrl = '$base_url/UserProfileAPI';

  // Replace the following token with your actual bearer token
  const token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Im1vYmFkbWluQGdtYWlsLmNvbSIsIm5iZiI6MTcwMzE3ODA1MywiZXhwIjoxNzAzNzgyODUzLCJpYXQiOjE3MDMxNzgwNTMsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAxOTEiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUwMTkxIn0.WYN0dROXwe3ys9yA2Ngd62p7Fr2h6JV4nSyHPcnF4tk';


  final response = await http.post(
    Uri.parse('$apiUrl?id=$id&language=$lang'), // Include id in the URL
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse and return the data
    return json.decode(response.body);
  } else {
    // If the server did not return a 200 OK response, handle errors
    throw Exception('Failed to load user profile: ${response.statusCode}');
  }
}
