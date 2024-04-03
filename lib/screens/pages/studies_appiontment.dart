import 'package:QBB/constants.dart';
import 'package:QBB/customNavBar.dart';
import 'package:QBB/screens/authentication/register.dart';
import 'package:QBB/screens/pages/boo_appointment_studies.dart';
import 'package:QBB/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'book_appintment_nk.dart';
import 'notification.dart';

class StuidesAppointment extends StatefulWidget {
  final String? studyName;
  final int? studyId;
  const StuidesAppointment({Key? key, this.studyName, this.studyId})
      : super(key: key);

  @override
  State<StuidesAppointment> createState() => StuidesAppointmentState();
}

class StuidesAppointmentState extends State<StuidesAppointment> {
  String preg = ''; // Default value for Registration Mode
  TextEditingController behalfNameController = TextEditingController();
  TextEditingController behalfEmailController = TextEditingController();
  bool isButtonEnabled = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPreg = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: appbar,
              ),
              iconTheme: const IconThemeData(color: textcolor),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Image.asset(
                      "assets/images/icon.png",
                      width: 40.0,
                      height: 40.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Text(
                          'pageATitle'.tr,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Impact',
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_none_outlined),
                    iconSize: 30.0,
                    color: Colors.white,
                  )
                ],
              ),
              backgroundColor: appbar,
            ),
            drawer: SideMenu(),
            bottomNavigationBar: CustomTab(tabId: 2),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
                // const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "areYouPregnant".tr,
                        style:
                            TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 10.0,
                      // ),
                      Expanded(child: _buildRadioListTile('yes'.tr, 'Yes')),
                      // const SizedBox(
                      //   width: 20.0,
                      // ),
                      Expanded(child: _buildRadioListTileNo('no'.tr, 'No')),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      }, // Link to the function
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: appbar),
                        elevation: 0,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                        child: Text(
                          'cancelButton'.tr,
                          style: TextStyle(
                            color: appbar,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookAppointmentStudies(
                                          studyName: widget.studyName,
                                          studyId: widget.studyId,
                                          isPreg: isPreg)),
                                );
                                // Navigator.pushNamed(context, '/bookanAppointment');
                              }
                            }
                          : null, // Link to the function
                      style: isButtonEnabled
                          ? ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20.0),
                                  ),
                                ),
                              ),
                            )
                          : ButtonStyle(
                              // Set background color
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryColor.withOpacity(
                                      0.6)), // Set background color
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
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: Text(
                          'tutorialContinueButton'.tr,
                          style: TextStyle(
                            color: textcolor,
                          ),
                        ),
                      ),
                    ),
                  ],
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
      title: Text(
        title,
        style: TextStyle(fontSize: 12),
      ),
      value: value,
      groupValue: preg,
      onChanged: (newValue) {
        setState(() {
          preg = newValue!;
          isPreg = true;
          isButtonEnabled = true;
        });
      },
      activeColor: primaryColor,
    );
  }

  Widget _buildRadioListTileNo(String title, String value) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: TextStyle(fontSize: 12),
      ),
      value: value,
      groupValue: preg,
      onChanged: (newValue) {
        setState(() {
          preg = newValue!;
          isPreg = false;
          isButtonEnabled = true;
        });
      },
      activeColor: primaryColor,
    );
  }
}
