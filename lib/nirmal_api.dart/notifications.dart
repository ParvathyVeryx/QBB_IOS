import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<void> getNotificationsApiCall() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String qid = prefs.getString("userQID").toString();
  var lang = 'langChange'.tr;
  final String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetNotificationsAPI';

  final String? token = await getAuthToken();

  if (token == null) {
    // Handle the case where the token is not available
    return;
  }

  final Map<String, String> queryParams = {
    "QID": "$qid",
    "language": "$lang",
  };

  final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${token.replaceAll('"', '')}',
  };

  try {
    final response = await http.get(
      uri,
      headers: headers,
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
