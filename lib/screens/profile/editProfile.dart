import 'package:QBB/constants.dart';
import 'package:QBB/nirmal_api.dart/marital_status_api.dart';
import 'package:QBB/nirmal_api.dart/profile_api.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:QBB/screens/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUser extends StatefulWidget {
  final Future<String> emailFuture;
  final Future<String> maritalstatus;

  const EditUser(
      {required this.emailFuture, required this.maritalstatus, Key? key})
      : super(key: key);

  @override
  EditUserState createState() => EditUserState();
}

class EditUserState extends State<EditUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _emailValidationMessage;

  String password = '';
  String confirmPassword = '';
  bool isButtonEnabled = false;
  String otp = '';
  String QID = '';
  String? maritalStatus = "";
  String? maritalStatusId;
  bool isLoading = false;
  int? maritalId;
  int? newMaritalid;

  final TextEditingController _emailController = TextEditingController();
  String? _genderController;
  late Future<String> maritalStatusFuture;
  String? originalEmail;
  String? originalMaritalStatus;
  @override
  void initState() {
    super.initState();
    // _emailController.text = widget.email; // Removed this line
    widget.emailFuture.then((email) {
      setState(() {
        _emailController.text = email;
        originalEmail = email;
      });
    });

    widget.maritalstatus.then((gender) {
      setState(() {
        _genderController = gender.toString();
        originalMaritalStatus = gender.toString();
      });

      print(maritalStatus);
    });
    maritalStatusFuture = getUserGenderr();
    getUserGender();
  }

  void getUserGender() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    maritalStatus = pref.getString("userMStatus").toString();
    print(maritalStatus.toString() + "Marital Status");
    if (_genderController == "Single") {
      setState(() {
        newMaritalid = 2;
      });
    } else if (_genderController == "Married") {
      setState(() {
        newMaritalid = 1;
      });
    } else if (_genderController == "Divorced") {
      setState(() {
        newMaritalid = 3;
      });
    } else if (_genderController == "Widowed") {
      setState(() {
        newMaritalid = 4;
      });
    }
    maritalId = newMaritalid;
  }

  Future<String> getUserGenderr() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("userMaritalStatus").toString();
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          },
        ),
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 40.0),
            child: Text(
              'settingsPageProfile'.tr,
              style:
                  TextStyle(color: appbar, fontFamily: 'Impact', fontSize: 16),
            ),
          ),
        ),
        backgroundColor: textcolor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            alignment:
                Alignment.bottomCenter, // Align the image to the bottom center
            fit: BoxFit
                .contain, // Adjust to your needs (e.g., BoxFit.fill, BoxFit.fitHeight)
          ),
        ),
        child: FutureBuilder<String>(
          future: maritalStatusFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              maritalStatus = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildRoundedBorderTextField(
                            labelText: '${'emailAddress'.tr}*',
                            labelTextColor:
                                const Color.fromARGB(255, 173, 173, 173),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'pleaseEnterAValidEmailId'.tr;
                              } // Email validation regular expression
                              RegExp emailRegex = RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

                              if (!emailRegex.hasMatch(value)) {
                                return 'pleaseEnterAValidEmailId'.tr;
                              }
                              return null;
                            },
                            controller: _emailController),
                        const SizedBox(
                          height: 20.0,
                        ),
                        _buildDropdownFormField(
                          value: _genderController,
                          onChanged: (value) async{
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString("userMaritalStatus",
                                value.toString());
                            print("kkkkkkkk");
                            print(value.toString());
                            setState(() {
                              maritalStatus = value!;
                              
                              switch (maritalStatus) {
                                case 'Single':
                                  maritalId = 2;
                                  break;
                                case 'Married':
                                  maritalId = 1;
                                  break;
                                case 'Divorced':
                                  maritalId = 3;
                                  break;
                                case 'Widowed':
                                  maritalId = 4;
                                  break;
                                case 'الأرامل':
                                  maritalId = 4;
                                  break;
                                case 'اعزب':
                                  maritalId = 2;
                                  break;
                                case 'متزوج':
                                  maritalId = 1;
                                  break;
                                case 'مطلقة':
                                  maritalId = 3;
                                  break;
                                default:
                                  maritalId = newMaritalid;
                                  break;
                              }
                            });
                          },
                          items: [
                            'Single'.tr,
                            'married'.tr,
                            'divorced'.tr,
                            'widowed'.tr
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value.tr,
                              child: Text(
                                value.tr,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            );
                          }).toList(),
                          labelText: '${'maritalStatus'.tr}*',
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            // SharedPreferences pref =
                            //     await SharedPreferences.getInstance();
                            // pref.setString("userMaritalStatus",
                            //     _genderController.toString());
                            // print("kkkkkkkk");
                            // print(_genderController.toString());
                            // if (isButtonEnabled) {
                            // if (_genderController == "Single".tr) {
                            //   newMaritalid = 2;
                            // } else if (_genderController == "married".tr) {
                            //   newMaritalid = 1;
                            // } else if (_genderController == "divorced".tr) {
                            //   newMaritalid = 3;
                            // } else if (_genderController == "widowed".tr) {
                            //   newMaritalid = 4;
                            // }
                            print(newMaritalid);
                            print(maritalId);
                            print(_emailController.text);
                            print(originalEmail);
                            if (_emailController.text != originalEmail ||
                                newMaritalid != maritalId) {
                              setState(() {
                                isLoading = true;
                              });
                              print("if is working");
                              String userEmail = _emailController.text;
                              // int userMaritalId =
                              //     int.parse(maritalId);
                              callUserProfileAPI(
                                  context, userEmail, maritalId!);
                              // } else {}
                            } else if (_emailController.text == originalEmail &&
                                newMaritalid == maritalId) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ErrorPopup(
                                      errorMessage: "No changes to update");
                                },
                              ); // Show popup when no changes made
                            }

                            // }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20.0),
                                  ),
                                ),
                              )),
                          child: Padding(
                            padding:
                                EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                            child: Text(
                              'save'.tr,
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
              );
              // Your main widget tree
            }
          },
        ),
      ),
    );
  }

  void _setEmailValidationMessage(String? message) {
    setState(() {
      _emailValidationMessage = message;
    });
  }

  bool isValidEmail(String value) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$',
    );
    return emailRegex.hasMatch(value);
  }

  Widget _buildDropdownFormField(
      {required String? value,
      required void Function(String?)? onChanged,
      required List<DropdownMenuItem<String>> items,
      required String labelText,
      String? defaultValue}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(
              255, 173, 173, 173), // Set the border color to grey
          width: 1.0, // Set the border width
        ),

        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0), // Rounded border at bottom-left
        ), // Rounded border corners
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: DropdownButtonFormField<String>(
          value: value ?? defaultValue,
          onChanged: onChanged,
          items: items,
          decoration: InputDecoration(
            errorStyle: const TextStyle(
              // Add your style properties here
              color: primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),
            labelText: labelText,
            labelStyle: const TextStyle(
                color: Color.fromARGB(255, 173, 173, 173), fontSize: 12),
            // Set the label text color

            // Label text color
            border: InputBorder.none, // Remove the default border
          ),
          validator: (value) {
            return null; // No error
          },
        ),
      ),
    );
  }
}

Widget _buildRoundedBorderTextField({
  required String labelText,
  required FormFieldValidator<String> validator,
  Color? labelTextColor,
  TextInputType? keyboardType, // Added labelTextColor parameter
  TextEditingController? controller,
}) {
  return TextFormField(
    controller: controller, // Set the controller
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      labelText: labelText,

      errorStyle: const TextStyle(
        // Add your style properties here
        color: primaryColor,
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
      ),
      labelStyle: TextStyle(
          color: labelTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w400), // Set the label text color
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

    validator: validator,
  );
}
