// import 'dart:html';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/services.dart';
// import 'package:async/async.dart';

// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   String dir = 'ltr';
//   dynamic userdata;
//   dynamic profile;
//   List<dynamic> goodResponse = [];
//   late String name;
//   late String mobile;
//   late String qid;
//   late String gender;
//   late String healthcard;
//   late String dob;
//   late String nationality;
//   late String email;
//   late String marital;
//   late String userid;
//   late String nationn;
//   late String userPic;
//   late String token;
//   late String genderr;
//   late String nationalityy;
//   dynamic image;
//   late String ok;
//   late String edit_img_error;
//   late String file_upload_JPG_error;
//   late String base64textString;
//   late String success_file_upload;
//   late String crntlang;
//   late String base_url;
//   late String api_url;

//   @override
//   void initState() {
//     super.initState();
//     api_url = base_url;
//     dir = TextDirection.ltr.toString();
//     getCountyList();
//     getDetails();
//     var translate;
//     translate.get([
//       "Ok",
//       "edit_img_error",
//       "file_uploaded_successfully",
//       "file_upload_JPG_error"
//     ]).then((values) {
//       setState(() {
//         ok = values["Ok"];
//         edit_img_error = values["edit_img_error"];
//         success_file_upload = values["file_uploaded_successfully"];
//         file_upload_JPG_error = values["file_upload_JPG_error"];
//       });
//     });
//   }

//   Future<void> onUploadChange() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//     );

//     if (pickedFile != null) {
//       File file = File(pickedFile.path);

//       if (file.lengthSync() > 70000) {
//         final alert = AlertDialog(
//           content: Text(edit_img_error),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text(ok),
//             ),
//           ],
//         );
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return alert;
//           },
//         );
//       } else {
//         final reader = FileReader();
//         reader.readAsBinarylate String(file);
//         reader.onLoad.listen((data) {
//           handleReaderLoaded(data);
//         });
//       }
//     }
//   }

//   void handleReaderLoaded(dynamic e) async {
//     final loader = CircularProgressIndicator();
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: loader,
//         );
//       },
//     );

//     base64textlate String = 'data:image/png;base64,' + base64Encode(e.target.result);

//     late String? QID = localStorage["QID"];
//     late String? Photo = base64textlate String;
//     user.profilePhoto(QID, Photo).then((res) {
//       getDetails();
//       Navigator.of(context).pop(); // Dismiss the loading dialog
//       final alert = AlertDialog(
//         content: Text(success_file_upload),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text(ok),
//           ),
//         ],
//       );
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return alert;
//         },
//       );
//     }).catchError((err) {
//       Navigator.of(context).pop(); // Dismiss the loading dialog
//     });
//   }

//   bool formale = false;
//   bool forfemale = false;
//   bool forsmale = false;
//   bool forsfemale = false;
//   dynamic checkmarital;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     getCountyList();
//     getDetails();
//   }

//   Future<void> getDetails() async {
//     final loader = CircularProgressIndicator();
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: loader,
//         );
//       },
//     );

//     token = localStorage["maintoken"];
//     late String? userids = localStorage["userid"];

//     final headers = {
//       HttpHeaders.contentTypeHeader: 'application/json',
//       HttpHeaders.acceptHeader: 'application/json',
//       HttpHeaders.authorizationHeader: 'Bearer $token',
//     };

//     http.get(Uri.parse('$api_url/UserProfileAPI?UserId=$userids&language=${translate.currentLang}'), headers: headers)
//         .then((res) {
//       Navigator.of(context).pop(); // Dismiss the loading dialog
//       var result = json.decode(res.body);

//       setState(() {
//         name = result["FirstName"] + " " + result["MiddleName"] + " " + result["LastName"];
//         mobile = result["RecoveryMobile"];
//         qid = result["QID"];
//         gender = result["Gender"];
//         genderr = gender.trim();
//         healthcard = result["HealthCardNo"];
//         dob = result["Dob"];
//         nationality = result["Nationality"];
//         email = result["RecoverEmail"];
//         marital = result["MaritalStatus"];
//         base64textlate String = result["Photo"];

//         localStorage["GenderId"] = result["GenderId"];

//         if (nationn == null || nationn.length == 0) {
//           getCountyList();
//         } else {
//           nationn.forEach((item) {
//             if (item["Id"] == nationality) {
//               nationalityy = item["Name"];
//             }
//           });
//         }

//         checkmarital = localStorage["Gender"].trim().toLowerCase();
//       });
//     }).catchError((err) {
//       Navigator.of(context).pop(); // Dismiss the loading dialog
//     });
//   }

//   Future<void> getCountyList() async {
//     user.countryApi().then((nation) {
//       setState(() {
//         nationn = nation;
//         nationn.forEach((item) {
//           if (item["Id"] == nationality) {
//             nationalityy = item["Name"];
//           }
//         });
//       });
//     });
//   }

//   void goToAppointments() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => AppointmentListPage()),
//     );
//   }

//   void bookAnAppointment() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => BookAppointmentVisitorPage()),
//     );
//   }

//   void results() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ResultsPage()),
//     );
//   }

//   void goToAppointmentList() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ProfilePage()),
//     );
//   }

//   void home() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => home()),
//     );
//   }

//   void notificationPage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => NotificationPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Build your UI here
//   }
// }

// class BookAppointmentVisitorPage {
// }
