// import 'dart:convert';
// import 'package:QBB/providers/token_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';

// Future<String?> getToken() async {
//   final url = Uri.parse(
//       "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/QBBMobAPI");

//   final Map<String, String> headers = {
//     'Content-Type': 'application/json',
//   };

//   final Map<String, String> body = {
//     'Password': 'QBBMobadmin',
//     'Username': 'MOBadmin@gmail.com',
//     'SubscriptionID': '88664328891221',
//   };

//   final response = await http.post(
//     url,
//     headers: headers,
//     body: jsonEncode(body),
//   );

//   if (response.statusCode == 200) {
//     // Successful request
//     final Map<String, dynamic> responseData = jsonDecode(response.body);
//     final String? token = responseData[
//         'token']; // Replace 'token' with the actual key for the token in the response
//     // Use the provider to set the token
//     Provider.of<TokenProvider>(context, listen: false).setToken(token);
//     return token;
//   } else {
//     // Handle error response
//     print('Token request failed with status code: ${response.statusCode}');
//     print('Response body: ${response.body}');
//     return null;
//   }
// }

// void main() async {
//   // Call the function to get the token
//   String? token = await getToken();
//   if (token != null) {
//     print('Token: $token');
//     // Now you can use this token for further API requests.
//   } else {
//     print('Token request failed.');
//   }
// }
