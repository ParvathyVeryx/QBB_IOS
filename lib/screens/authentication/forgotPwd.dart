import 'dart:convert';

import 'package:QBB/constants.dart';
import 'package:QBB/nirmal_api.dart/forget_password_getotp.dart';
import 'package:QBB/nirmal_api.dart/update_password.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String password = ''; // Store the entered password
  String confirmPassword = ''; // Store the entered confirm password
  bool isButtonEnabled = false;
  String otp = '';
  String QID = '';
  bool isPasswordValid = false;
  String errorText = '';
  String errorPwd = '';
  final TextEditingController _controller = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isbuttonCLicked = false;
  TextEditingController qidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validateInput);
    passwordController.addListener(_validatePwd);
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
            padding: const EdgeInsets.only(right: 40.0),
            child: Text(
              'forgotPasswordTitle'.tr,
              style: const TextStyle(
                color: appbar,
                fontFamily: 'Impact',
              ),
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
                        return 'Please enter your QID';
                      }
                      return null;
                    },
                    controller:
                        _controller, // Assign the controller to the text field
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            // print('button pressed');
                            // print("qid: ${_controller.text}");
                            // // Validate the form before making the API call

                            // // Access the QID from the form field
                            // String qid = _controller.text;
                            // print('QID: $qid');
                            // // Call the update password API
                            // await callUpdatePasswordAPI(qid, context);
                            // print('button pressed');
                            try {
                              print('Button pressed');
                              print("QID: ${_controller.text}");

                              // Validate the form before making the API call

                              // Access the QID from the form field
                              String qid = _controller.text;
                              print('QID: $qid');

                              // Call the update password API
                              await callUpdatePasswordAPI(qid, context);

                              // Additional code to execute after a successful API call
                              print('Button pressed');
                            } catch (e) {
                              // Handle errors
                              print('Error during button press: $e');
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
                                        10.0), // Rounded border at bottom-left
                                  ),
                                ),
                              )),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                            child: Text(
                              'getOTP'.tr,
                              style: const TextStyle(
                                  color: textcolor, fontSize: 11),
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
                  ),
                  const SizedBox(height: 20.0),
                  _buildPasswordField(),
                  const SizedBox(height: 05.0),
                  _buildConfirmPasswordField(),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              // Process the form data
                              print('Submitting Form Data:');
                              print('QID: $QID');
                              print('OTP: $otp');
                              print('Password: $password');
                              var bytes = utf8.encode(password);
                              var sha512Digest = sha512.convert(bytes);

                              // Call the API function with the required parameters
                              UpdatePasswordAPI(
                                QID,
                                otp,
                                sha512Digest.toString(),
                                context,
                              );
                            }
                          }
                        : null,
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
                      padding:
                          const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                      child: Text(
                        'submit'.tr,
                        style: const TextStyle(
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

  void _validateInput() {
    setState(() {
      if (_controller.text.isEmpty) {
        errorText = '';
      } else if (!RegExp(r'^[0-9]*$').hasMatch(_controller.text)) {
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

  Widget _buildRoundedBorderTextField({
    required String labelText,
    required FormFieldValidator<String> validator,
    Color? labelTextColor,
    TextInputType? keyboardType, // Added labelTextColor parameter
    required TextEditingController controller, // Add this line
  }) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      // inputFormatters: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      // ],
      decoration: InputDecoration(
        errorText: errorText,
        errorStyle: const TextStyle(
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
        labelStyle: TextStyle(
            color: labelTextColor, fontSize: 12), // Set the label text color
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
    Color? labelTextColor,
    TextInputType? keyboardType, // Added labelTextColor parameter
  }) {
    return TextFormField(
      // keyboardType: TextInputType.number,
      decoration: InputDecoration(
        errorStyle: const TextStyle(
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
        labelStyle: TextStyle(
            color: labelTextColor, fontSize: 12), // Set the label text color
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

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      decoration: InputDecoration(
        errorMaxLines: 3,
        errorText: errorPwd,
        errorStyle: const TextStyle(
          // Add your style properties here
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 11.0,
          overflow: TextOverflow.visible,
        ),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: 'newPassword'.tr + '*',
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
        labelStyle: const TextStyle(
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
      obscureText: true,
      // Hide the entered text
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
          return 'pleaseEnterYourPwd'.tr; // Validation error message
        }
        return null; // No error
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        errorStyle: const TextStyle(
          // Add your style properties here
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 11.0,
        ),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: 'confirmPassword'.tr + '*',
        labelStyle: const TextStyle(
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
