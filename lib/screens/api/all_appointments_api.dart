// import 'package:QBB/constants.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class AllAppAPI {
//   static void fetchtoken(context) async {
//     var baseURL =
//         "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/QBBMobAPI";
//     Map<String, String> headers = {
//       // 'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };
//     Map<String, String> body = {
//       "Password": "QBBMobadmin",
//       "Username": "MOBadmin@gmail.com",
//       "SubscriptionID": "88664328891221"
//     };
//     var url = Uri.parse(baseURL);
//     final response = await http.post(
//       url,
//       headers: headers,
//       body: body,
//     );
//     var token = response.body.toString();
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     pref.setString("token", token);
//     print('ppppppppppppppppppppppppppppppppppppppppppppppppppppp' +
//         response.body.toString());
//   }

//   Future<List<AllApp>> fetchAllAppAPI(context) async {
//     String authToken = "";
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var baseURL = base_url;
//     var token = prefs.getString("token");
//     var QID = prefs.getString("QID");
//     var url = Uri.parse(
//         '$baseURL/ViewAllResultAppointmentsAPI?language=en&QID=28900498437&page=1');

//     Map<String, String> headers = {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };

//     final response = await http.get(
//       url,
//       headers: headers,
//     );

//     if (response.statusCode == 200) {
//       int i;
//       var thr;
//       var jsonResponse = json.decode(response.body);

//       List viewedby = jsonResponse["VisittypeName"];
//       print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk' + viewedby.toString());

//       // List jsonResponse = json.decode(response.body);
//       return viewedby.map((data) => AllApp.fromJson(data)).toList();
//     } else
//       return [];
//   }
// }

// class AllApp {
//   // final int studyId;
//   final String visitType;
//   late final String studyName;
//   late final String appType;

//   AllApp(
//       {
//       // required this.studyId,
//       required this.visitType,
//       required this.studyName,
//       required this.appType});

//   factory AllApp.fromJson(Map<dynamic, dynamic> json) {
//     return AllApp(
//       // studyId: json['StudyId'],
//       visitType: json['VisittypeName'],
//       studyName: json['StudyName'],
//       appType: json['AppoinmenttypName'],
//     );
//   }
// }
