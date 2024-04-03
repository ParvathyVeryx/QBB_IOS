import 'dart:convert';
import 'package:QBB/constants.dart';
import 'package:QBB/nirmal/login_screen.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;
import 'package:shared_preferences/shared_preferences.dart';

import '../../nirmal_api.dart/profile_api.dart';
import '../pages/loader.dart';

Future<void> accessSetupOTP({
  required String qid,
  required String otp,
  required String userPassword,
  required String userId,
  required String language,
  required BuildContext context,
}) async {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  LoaderWidget _loader = LoaderWidget();
  try {
    Dialogs.showLoadingDialog(context, _keyLoader, _loader);
    // Retrieve token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Handle the case where the token is not available in shared preferences
      return;
    }

    String encryptedPassword = _sha512(userPassword);
    Map<String, dynamic> requestBody = {
      'QID': qid,
      'OTP': otp,
      'UserPassword': encryptedPassword,
      'Userid': userId,
      'language': language,
    };

    print(requestBody);

    final url = Uri.parse(
        '$base_url/AcessSetupOTP?QID=${requestBody['QID']}&OTP=${requestBody['OTP']}&UserPassword=${requestBody['UserPassword']}&Userid=${requestBody['Userid']}&language=${requestBody['language']}');
    print("Acccesstoken");
    print("Access Token" + url.toString());
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.replaceAll('"', '')}',
      },
      body: jsonEncode(requestBody),
    );
    print("Access Setup response code" + response.statusCode.toString());
    print(response.body);
    if (response.statusCode == 200) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
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
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginPage()),
      // );
      // Handle successful response
    } else {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(
              errorMessage: json.decode(response.body)["Message"]);
        },
      );

      // Handle error
    }
  } catch (e) {
    Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    // Handle network errors
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: 'Error: $e.');
      },
    );
  }
}

String _sha512(String input) {
  var bytes = utf8.encode(input);
  var digest = crypto.sha512.convert(bytes);
  return digest.toString();
}
