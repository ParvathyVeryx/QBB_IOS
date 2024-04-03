import 'package:QBB/constants.dart';
import 'package:QBB/screens/api/access_setup_api.dart';
import 'package:QBB/screens/api/getacess_otp.dart';
import 'package:QBB/screens/api/setup_password_acess_complete_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../nirmal_api.dart/forget_password_getotp.dart';

class AccessUser extends StatefulWidget {
  const AccessUser({super.key});

  @override
  AccessUserState createState() => AccessUserState();
}

class AccessUserState extends State<AccessUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController qidController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String password = ''; // Store the entered password
  String confirmPassword = ''; // Store the entered confirm password
  bool isButtonEnabled = false;
  String otp = '';
  String QID = '';
  String errorPwd = '';
  String errorText = '';
  void _checkAndSubmitForm() async {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Process the form data
      // Check OTP match
      bool isOtpMatch = await getAccess(qidController.text, otp, context);

      // If OTP doesn't match, show error and return
      if (!isOtpMatch) {
        // Show error indicating OTP mismatch
        // You can use Flutter's showDialog or any other method to show the popup
        return;
      }

      // Proceed to accessSetupOTP if OTP matches
      await accessSetupOTP(
        otp: otp,
        userPassword: password,
        userId: '1',
        language: 'langChange'.tr,
        qid: QID,
        context: context,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    qidController.addListener(_validateInput);
    passwordController.addListener(_validatePwd);
  }

  void _validateInput() {
    print("validating");
    setState(() {
      if (qidController.text.isEmpty) {
        errorText = '';
      } else if (!RegExp(r'^[0-9]*$').hasMatch(qidController.text)) {
        errorText = 'pleaseEnterValidQatarID'.tr;
      } else {
        errorText = '';
      }
    });
  }

  void _validatePwd() {
    setState(() {
      if (passwordController.text.isEmpty) {
        errorPwd = '';
      } else if (!RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>])(?=.*\d)(?=.*[A-Z]).*$')
          .hasMatch(passwordController.text)) {
        errorPwd =
            'passwordsMustBeAtLeast8CharactersAndContainAt3Of4OfTheFollowingUpperCaseAZLowerCaseAAnumber09AndSpecialCharacterEG'
                .tr;
      } else {
        errorPwd = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: appbar,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 179, 179, 179),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 40.0),
            child: Text(
              'accessSetUp'.tr,
              style:
                  TextStyle(color: appbar, fontFamily: 'Impact', fontSize: 16),
            ),
          ),
        ),
        backgroundColor: textcolor,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              alignment: Alignment
                  .bottomCenter, // Align the image to the bottom center
              fit: BoxFit
                  .contain, // Adjust to your needs (e.g., BoxFit.fill, BoxFit.fitHeight)
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildRoundedBorderTextField(
                    labelText: 'qid'.tr,
                    labelTextColor: const Color.fromARGB(255, 173, 173, 173),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'pleaseEnterYourQID'.tr;
                      }
                      return null;
                    },
                    controller: qidController,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            try {
                              // Call the API function
                              await setPasswordAccessSetupNotCompleted(
                                  QID, 'langChange'.tr, context);
                            } catch (e) {
                              print("$e");
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryColor), // Set background color
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        12.0), // Rounded border at bottom-left
                                  ),
                                ),
                              )),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                            child: Text(
                              'getOTP'.tr,
                              style: TextStyle(color: textcolor, fontSize: 11),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  _buildRoundedBorderOTPField(
                    labelText: 'enterOTP'.tr,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'pleaseEnterOtp'.tr;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    labelTextColor: const Color.fromARGB(255, 173, 173, 173),
                    controller: otpController,
                  ),
                  const SizedBox(height: 20.0),
                  _buildPasswordField(controller: passwordController),
                  const SizedBox(height: 20.0),
                  _buildConfirmPasswordField(
                      controller: confirmPasswordController),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: isButtonEnabled ? _checkAndSubmitForm : null,
                    // onPressed: isButtonEnabled
                    //     ? () async {
                    //         if (_formKey.currentState!.validate()) {
                    //           // Process the form data
                    //           // Submit the form or perform necessary actions
                    //           print('QID: $qidController.text');
                    //           print('OTP: $otp');
                    //           print('Password: $password');
                    //           print('Confirm Password: $confirmPassword');
                    //           await accessSetupOTP(
                    //               otp: otp, // Replace with your OTP variable
                    //               userPassword:
                    //                   password, // Replace with your UserPassword variable
                    //               userId: '1',
                    //               // Replace with your Userid variable
                    //               language: 'en',
                    //               qid: QID,
                    //               context: context
                    //               // Replace with your language variable
                    //               );
                    //         }
                    //       }
                    //     : null,
                    style: isButtonEnabled
                        ? ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                primaryColor), // Set background color
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      12.0), // Rounded border at bottom-left
                                ),
                              ),
                            ))
                        : ButtonStyle(
                            // Set background color
                            backgroundColor: MaterialStateProperty.all<Color>(
                                primaryColor
                                    .withOpacity(0.6)), // Set background color
                            // Set overlay color when disabled
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      12.0), // Rounded border at bottom-left
                                ),
                              ),
                            ),
                          ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                      child: Text(
                        'submit'.tr,
                        style: TextStyle(
                          color: textcolor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedBorderTextField({
    required String labelText,
    required FormFieldValidator<String> validator,
    required TextEditingController controller,
    Color? labelTextColor,
    TextInputType? keyboardType, // Added labelTextColor parameter
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        errorText: errorText,
        errorStyle: TextStyle(
          // Add your style properties here
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 11.0,
        ),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: labelText,
        prefixIcon: Container(
          height: 5,
          width: 5,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              "assets/images/id-card.png",
              // width: 15.0,
              // height: 15.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        labelStyle: TextStyle(color: labelTextColor, fontSize: 12),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
      ),
      onChanged: (value) {
        setState(() {
          QID = value;
          // Enable or disable the button based on whether the OTP field is empty or not
          isButtonEnabled = QID.isNotEmpty &&
              otp.isNotEmpty &&
              password.isNotEmpty &&
              confirmPassword.isNotEmpty;
        });
      },
      validator: validator,
    );
  }

  Widget _buildRoundedBorderOTPField({
    required String labelText,
    required FormFieldValidator<String> validator,
    required TextEditingController controller,
    Color? labelTextColor,
    TextInputType? keyboardType, // Added labelTextColor parameter
  }) {
    return TextFormField(
      // keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          // Add your style properties here
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 11.0,
        ),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: labelText,
        prefixIcon: Container(
          height: 5,
          width: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              "assets/images/phone.png",
              // width: 15.0,
              // height: 15.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        labelStyle: TextStyle(color: labelTextColor, fontSize: 12),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
      ),
      onChanged: (value) {
        setState(() {
          otp = value;
          // Enable or disable the button based on whether the OTP field is empty or not
          isButtonEnabled = QID.isNotEmpty &&
              otp.isNotEmpty &&
              password.isNotEmpty &&
              confirmPassword.isNotEmpty;
        });
      },
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        errorMaxLines: 4,
        errorText: errorPwd,
        errorStyle: TextStyle(
          // Add your style properties here
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 11.0,
        ),
        contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: 'password'.tr + '*',
        prefixIcon: Container(
          height: 10.0,
          width: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              "assets/images/lock.png",
              width: 15.0,
              height: 15.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        labelStyle: TextStyle(
            color: Color.fromARGB(
              255,
              173,
              173,
              173,
            ),
            fontSize: 12 // Label text color
            ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
      ),
      obscureText: true, // Hide the entered text
      controller: controller, // Initialize the controller here
      onChanged: (value) {
        setState(() {
          password = value;
          isButtonEnabled = QID.isNotEmpty &&
              otp.isNotEmpty &&
              password.isNotEmpty &&
              confirmPassword.isNotEmpty;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password'; // Validation error message
        }
        return null; // No error
      },
    );
  }

  Widget _buildConfirmPasswordField({
    required TextEditingController controller,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        errorStyle: TextStyle(
          // Add your style properties here
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 11.0,
        ),
        contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: 'confirmPassword'.tr + '*',
        labelStyle: TextStyle(
            color: Color.fromARGB(255, 173, 173, 173),
            fontSize: 12 // Label text color
            ),
        prefixIcon: Container(
          height: 10.0,
          width: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              "assets/images/lock.png",
              width: 15.0,
              height: 15.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
      ),
      obscureText: true, // Hide the entered text
      controller: controller, // Initialize the controller here
      onChanged: (value) {
        setState(() {
          confirmPassword = value;
          isButtonEnabled = QID.isNotEmpty &&
              otp.isNotEmpty &&
              password.isNotEmpty &&
              confirmPassword.isNotEmpty;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password'; // Validation error message
        } else if (value != password) {
          return 'Passwords do not match'; // Validation error message for mismatch
        }
        return null; // No error
      },
    );
  }
}
