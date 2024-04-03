import 'dart:convert';
import 'dart:io';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:QBB/screens/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../screens/pages/loader.dart';

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, Widget? child) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Material(
            type: MaterialType.transparency,
            key: key,
            child: Center(
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    if (child != null) child,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> uploadUserProfilePhoto(
    BuildContext context, String qid, File photo) async {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  LoaderWidget _loader = LoaderWidget();
  SharedPreferences pref = await SharedPreferences.getInstance();
  String qid = pref.getString("userQID").toString();
  try {
    Dialogs.showLoadingDialog(context, _keyLoader, _loader);

    // Read the file as bytes
    List<int> photoBytes = await photo.readAsBytes();

    // Encode the bytes to base64
    String base64Photo = base64Encode(photoBytes);
    String? token = pref.getString('token');

    // Append the 'data:image/png;base64,' prefix to the base64-encoded photo
    String prefixedBase64Photo = 'data:image/png;base64,' + base64Photo;

    // Prepare the request body as a Map
    Map<String, dynamic> requestBody = {
      'QID': qid,
      'Photo': prefixedBase64Photo,
    };

    // Convert the request body to JSON
    String requestBodyJson = jsonEncode(requestBody);
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
    };

    // Make the API call using http.post
    var response = await http.post(
      Uri.parse(
          'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/UserProfilePhotoAPI'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
      },
      body: requestBodyJson,
    );
    print(response.body);
    print(response.statusCode);
    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      // Check if the response is JSON
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        // Parse the response body as JSON
        var responseBody = json.decode(response.body);
      } else {
        // Handle non-JSON response (e.g., log or print the raw response)
      }

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(50.0), // Adjust the radius as needed
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                json.decode(response.body)["Message"],
                style: const TextStyle(color: Color.fromARGB(255, 74, 74, 74)),
              ),
            ),
            actions: <Widget>[
              Divider(),
              TextButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    ),
                  );
                },
                child: Text(
                  'ok'.tr,
                  style: TextStyle(color: secondaryColor),
                ),
              ),
            ],
          );
        },
      );
    }
  } catch (e, stackTrace) {
    Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    ErrorPopup(errorMessage: '$e');
  }
}
