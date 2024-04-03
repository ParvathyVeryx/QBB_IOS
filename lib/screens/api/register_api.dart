import 'dart:convert';
import 'package:QBB/constants.dart';
import 'package:QBB/screens/authentication/accessSetUp.dart';
import 'package:QBB/screens/authentication/loginorReg.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterApi {
  static Future<void> signup(
      Register register, BuildContext context, String? token,
      {required Null Function() onApiComplete}) async {
    // print('Api token :$token');
    // String? token = pref.getString("token").toString();
    // Retrieve the token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    // String tokenString = token.toString();

    // print('token in api: $token');
    // String? token =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Im1vYmFkbWluQGdtYWlsLmNvbSIsIm5iZiI6MTcwMzE3ODA1MywiZXhwIjoxNzAzNzgyODUzLCJpYXQiOjE3MDMxNzgwNTMsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTAxOTEiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUwMTkxIn0.WYN0dROXwe3ys9yA2Ngd62p7Fr2h6JV4nSyHPcnF4tk";
    SharedPreferences pref = await SharedPreferences.getInstance();
    // var lang = pref.getString("langEn").toString();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer $token',
      // 'Authorization': token.toString(),
      'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
    };
    // Register register = Register();

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    String lang = "langChange".tr;

    var url = Uri.parse('$base_url/QuickRegistrationAPI?language=$lang');
    print(url);
    print(register.toJson());

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(register.toJson()),
    );

    print(jsonEncode(register.toJson()));

    // return response;
    if (response.statusCode == 200) {
      onApiComplete(); // Call the callback function to notify that the API is complete
      showDialog(
          context: context, // Use the context of the current screen
          builder: (BuildContext context) {
            return ErrorPopup(
                errorMessage: json.decode(response.body)["Message"]);
          }).then((_) {
        // This code will run after the dialog is dismissed
        // Navigate to another widget here
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AccessUser()),
        );
      });

      ;
      // Successful response, you might want to handle this case
    } else {
      onApiComplete(); // Call the callback function to notify that the API is complete
      showDialog(
          context: context, // Use the context of the current screen
          builder: (BuildContext context) {
            return ErrorPopup(
                errorMessage: json.decode(response.body)["Message"]);
          });
      // Handle error response

      // You can throw an exception or handle the error in another way
    }
  }
}

// Make sure to replace 'your_api_url' with the actual API URL.
// Also, define the properties and methods of the Register class as per your requirements.

class Register {
  int? id;
  String? isQuickRegistration;
  int? qid;
  int? userId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? gender;
  String? dob;
  String? livingPeriodId;
  String? registrationSourceID;
  String? isSelfRegistred;
  int? maritalId;
  String? healthCardNo;
  String? remark;
  int? nationalityId;
  String? photo;
  String? isItVIP;
  int? personGradeId;
  String? referralPersonFirstName;
  String? referralPersonLastName;
  String? captcha;
  int? languageID;
  int? applicationTypeId;
  int? userTypeId;
  String? recoverEmail;
  String? recoveryMobile;
  String? token;
  String? source;
  String? regError;
  String? campain;
  int? createdBY;
  String? createdOn;
  int? updatedBY;
  String? updatedOn;
  int? statusId;

  Register({
    this.id,
    this.isQuickRegistration,
    this.qid,
    this.userId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.dob,
    this.livingPeriodId,
    this.registrationSourceID,
    this.isSelfRegistred,
    this.maritalId,
    this.healthCardNo,
    this.remark,
    this.nationalityId,
    this.photo,
    this.isItVIP,
    this.personGradeId,
    this.referralPersonFirstName,
    this.referralPersonLastName,
    this.captcha,
    this.languageID,
    this.applicationTypeId,
    this.userTypeId,
    this.recoverEmail,
    this.recoveryMobile,
    this.token,
    this.source,
    this.regError,
    this.campain,
    this.createdBY,
    this.createdOn,
    this.updatedBY,
    this.updatedOn,
    this.statusId,
  });

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      id: json['Id'],
      // isQuickRegistration: json['isQuickRegistration'],
      qid: json['QID'],
      userId: json['UserId'],
      firstName: json['FirstName'],
      middleName: json['MiddleName'],
      lastName: json['LastName'],
      gender: json['Gender'],
      dob: json['Dob'],
      livingPeriodId: json['LivingPeriodId'],
      registrationSourceID: json['RegistrationSourceID'],
      isSelfRegistred: json['isSelfRegistred'],
      maritalId: json['MaritalId'],
      healthCardNo: json['HealthCardNo'],
      remark: json['Remark'],
      // nationalityId: json['NationalityId'],
      nationalityId: 1,
      photo: json['Photo'],
      isItVIP: json['IsItVIP'],
      personGradeId: json['PersonGradeId'],
      referralPersonFirstName: json['ReferralPersonFirstName'],
      referralPersonLastName: json['ReferralPersonLastName'],
      captcha: json['Captcha'],
      languageID: json['LanguageID'],
      applicationTypeId: json['ApplicationTypeId'],
      userTypeId: json['UserTypeId'],
      recoverEmail: json['RecoverEmail'],
      recoveryMobile: json['RecoveryMobile'],
      token: json['Token'],
      source: json['Source'],
      regError: json['RegError'],
      campain: json['Campain'],
      createdBY: json['CreatedBY'],
      createdOn: json['CreatedOn'],
      updatedBY: json['UpdatedBY'],
      updatedOn: json['UpdatedOn'],
      statusId: json['StatusId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': 0,
      'isQuickRegistration': 'false',
      'QID': qid,
      'UserId': 0,
      'FirstName': firstName,
      'MiddleName': middleName,
      'LastName': lastName,
      'Gender': gender,
      'Dob': dob,
      'LivingPeriodId': livingPeriodId,
      'RegistrationSourceID': registrationSourceID,
      'isSelfRegistred': isSelfRegistred,
      'MaritalId': maritalId,
      'HealthCardNo': healthCardNo,
      'Remark': 'some',
      'NationalityId': nationalityId,
      // 'NationalityId': 1,
      'Photo': 'string',
      'IsItVIP': 'false',
      // 'PersonGradeId': personGradeId,
      'PersonGradeId': 2,
      'ReferralPersonFirstName': referralPersonFirstName,
      'ReferralPersonLastName': referralPersonLastName,
      'Captcha': '',
      // 'LanguageID': languageID,
      // 'ApplicationTypeId': applicationTypeId,
      'LanguageID': 1,
      'ApplicationTypeId': 1,
      // 'UserTypeId': userTypeId,
      'UserTypeId': 1,
      'RecoverEmail': recoverEmail,
      'RecoveryMobile': recoveryMobile,
      // 'Token': token,
      'Token': "",
      'Source': source,
      // 'RegError': regError,
      'RegError': "",
      'Campain': campain,
      // 'CreatedBY': createdBY,
      // 'CreatedOn': createdOn,
      // 'UpdatedBY': updatedBY,
      // 'UpdatedOn': updatedOn,
      // 'StatusId': statusId,
      'CreatedBY': 1,
      'CreatedOn': "",
      'UpdatedBY': "",
      'UpdatedOn': "",
      'StatusId': "",
    };
  }
}
