// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<void> callUserProfileAPILocal() async {
//   final String apiUrl =
//       "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/UserProfileAPI";
//   final String userId = "21418";
//   final String language = "en";

//   final Map<String, dynamic> requestBody = {
//     "id": userId,
//     "language": language,
//   };

//   final Map<String, String> headers = {
//     "Authorization": "Bearer your_token", // Replace with your actual token
//     "Content-Type": "application/json",
//   };

//   final http.Response response = await http.post(
//     Uri.parse(apiUrl),
//     headers: headers,
//     body: jsonEncode(requestBody),
//   );

//   if (response.statusCode == 200) {
//     // Successful response, you can handle the data here
//     print("API Response: ${response.body}");
//   } else {
//     // Error handling, you can log or display an error message
//     print("Error: ${response.statusCode} - ${response.body}");
//   }
// }
