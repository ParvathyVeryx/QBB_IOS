// import 'package:QBB/constants.dart';
// import 'package:QBB/screens/authentication/register.dart';
// import 'package:flutter/material.dart';

// class RegistrationMode extends StatefulWidget {
//   const RegistrationMode({super.key});

//   @override
//   State<RegistrationMode> createState() => _RegistrationModeState();
// }

// class _RegistrationModeState extends State<RegistrationMode> {
//   String registrationMode = 'Self'; // Default value for Registration Mode
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Color.fromARGB(255, 179, 179, 179),
//           ),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: const Center(
//           child: Padding(
//             padding: EdgeInsets.only(right: 40.0),
//             child: Text(
//               'Register',
//               style: TextStyle(
//                 color: appbar,
//                 fontFamily: 'Impact',
//               ),
//             ),
//           ),
//         ),
//         backgroundColor: textcolor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 10.0),
//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Registration Mode",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//             ),
//             const SizedBox(
//               height: 10.0,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(child: _buildRadioListTile('Self', 'Self')),
//                 const SizedBox(
//                   width: 20.0,
//                 ),
//                 Expanded(child: _buildRadioListTile('On Behalf', 'On Behalf')),
//               ],
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         RegisterUser(registrationMode: registrationMode),
//                   ),
//                 );
//               }, // Link to the function
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
//                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                   const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(20.0),
//                     ),
//                   ),
//                 ),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
//                 child: Text(
//                   'Continue',
//                   style: TextStyle(
//                     color: textcolor,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRadioListTile(String title, String value) {
//     return RadioListTile<String>(
//       title: Text(title),
//       value: value,
//       groupValue: registrationMode,
//       onChanged: (newValue) {
//         setState(() {
//           registrationMode = newValue!;
//         });
//       },
//       activeColor: primaryColor,
//     );
//   }
// }
import 'package:QBB/constants.dart';
import 'package:QBB/screens/authentication/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegistrationMode extends StatefulWidget {
  const RegistrationMode({Key? key}) : super(key: key);

  @override
  State<RegistrationMode> createState() => _RegistrationModeState();
}

class _RegistrationModeState extends State<RegistrationMode> {
  String registrationMode = 'Self'; // Default value for Registration Mode
  TextEditingController behalfNameController = TextEditingController();
  TextEditingController behalfEmailController = TextEditingController();
  bool isButtonEnabled = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSelf = true;
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
              'register'.tr,
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
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "registrationMode".tr,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: _buildRadioListTile('self'.tr, 'Self')),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                        child: _buildRadioListTileBehalf(
                            'onBehalf'.tr, 'On Behalf')),
                  ],
                ),
                Visibility(
                  visible: registrationMode == 'On Behalf',
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: behalfNameController,
                        labelText: 'nameOnBehalf'.tr,
                      ),
                      _buildTextField(
                        controller: behalfEmailController,
                        labelText: 'lastnameOnBehalf'.tr,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "nameOfThePersonWhoIsActingOnBehalfOfParticipant".tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterUser(
                            isSelf: isSelf,
                            registrationMode: registrationMode,
                            behalfFname: behalfNameController.text,
                            behalfLname: behalfEmailController.text,
                          ),
                        ),
                      );
                    }
                  }, // Link to the function
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                    child: Text(
                      'tutorialContinueButton'.tr,
                      style: TextStyle(
                        color: textcolor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioListTile(String title, String value) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: registrationMode,
      onChanged: (newValue) {
        setState(() {
          registrationMode = newValue!;
        });
      },
      activeColor: primaryColor,
    );
  }

  Widget _buildRadioListTileBehalf(String title, String value) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: registrationMode,
      onChanged: (newValue) {
        setState(() {
          registrationMode = newValue!;
          isSelf = false;
        });
      },
      activeColor: primaryColor,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    Color? labelTextColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          errorStyle: TextStyle(
            // Add your style properties here
            color: primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 14.0,
          ),
          contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          labelText: labelText,

          labelStyle: TextStyle(
              color: Color.fromARGB(255, 173, 173, 173),
              fontSize: 12), // Set the label text color
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 173, 173, 173),
            ),
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
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'enterValidName'.tr; // Validation error message
          }
          return null; // No error
        },
      ),
    );
  }
}
