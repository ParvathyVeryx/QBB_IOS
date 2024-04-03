import 'package:flutter/material.dart';

import 'package:QBB/constants.dart';
import 'package:flutter/services.dart';

import '../../sidebar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String password = ''; // Store the entered password
  String confirmPassword = ''; // Store the entered confirm password
  bool isButtonEnabled = false;
  String otp = '';
  String QID = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 40.0),
              child: Text(
                'Access Set UP',
                style: TextStyle(
                  color: appbar,
                  fontFamily: 'Impact',
                  fontSize: 16
                ),
              ),
            ),
          ),
          backgroundColor: textcolor,
        ),
        drawer: const SideMenu(), // Global drawer
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildRoundedBorderTextField(
                    labelText: 'QID',
                    labelTextColor: const Color.fromARGB(255, 173, 173, 173),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your QID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryColor), // Set background color
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        20.0), // Rounded border at bottom-left
                                  ),
                                ),
                              )),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                            child: Text(
                              'Get OTP',
                              style: TextStyle(
                                color: textcolor,
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  _buildRoundedBorderOTPField(
                    labelText: 'Enter OTP',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter OTP';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    labelTextColor: const Color.fromARGB(255, 173, 173, 173),
                  ),
                  const SizedBox(height: 20.0),
                  _buildPasswordField(),
                  const SizedBox(height: 20.0),
                  _buildConfirmPasswordField(),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              // Process the form data
                              // Submit the form or perform necessary actions
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
                                      20.0), // Rounded border at bottom-left
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
                                      20.0), // Rounded border at bottom-left
                                ),
                              ),
                            ),
                          ),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                      child: Text(
                        'Submit',
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
    Color? labelTextColor,
    TextInputType? keyboardType, // Added labelTextColor parameter
  }) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: labelText,
        prefixIcon: const Icon(
          Icons.card_membership_outlined,
          color: Color.fromARGB(255, 173, 173, 173),
        ),
        labelStyle:
            TextStyle(color: labelTextColor), // Set the label text color
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
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: labelText,
        prefixIcon: const Icon(
          Icons.phone_android,
          color: Color.fromARGB(255, 173, 173, 173),
        ),
        labelStyle:
            TextStyle(color: labelTextColor), // Set the label text color
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
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: 'Password*',
        prefixIcon: Icon(
          Icons.lock,
          color: Color.fromARGB(255, 173, 173, 173),
        ),
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 173, 173, 173), // Label text color
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
      ),
      obscureText: true, // Hide the entered text
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

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelText: 'Confirm Password*',
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 173, 173, 173), // Label text color
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: Color.fromARGB(255, 173, 173, 173),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
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
