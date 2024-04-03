import 'package:QBB/constants.dart';
import 'package:QBB/nirmal/login_screen.dart';
import 'package:QBB/screens/authentication/accessSetUp.dart';
import 'package:QBB/screens/authentication/registration_mode.dart';
import 'package:QBB/screens/pages/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class loginOrReg extends StatefulWidget {
  const loginOrReg({super.key});

  @override
  loginOrRegState createState() => loginOrRegState();
}

class loginOrRegState extends State<loginOrReg> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // ignore: deprecated_member_use
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: appbar,
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: textcolor,
            ),
            onPressed: () {
              // Define the action you want to perform when the back button is pressed.
              // Typically, this would be Navigator.of(context).pop() to navigate back.
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'create/activateAcc'.tr,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Impact',
                fontSize: 16 // Set the text color to white
                ),
          ),
          backgroundColor: appbar,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClickableContainer(
                    onTap: () {
                      // Define the action you want to perform when the container is clicked.
                      const RegistrationMode();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AccessUser()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  30.0, 10.0, 10.0, 10.0),
                              child: Image.asset(
                                "assets/images/active-acc.png",
                                width: 40.0,
                                height: 40.0,
                                fit: BoxFit
                                    .cover, // Adjust to your needs (e.g., BoxFit.contain, BoxFit.fill)
                              ),
                            ),
                          ],
                        ),
    
                        // Add some spacing between the image and text
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'activateAccount'.tr,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'activateAccMsg'.tr,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  ClickableContainer(
                    onTap: () {
                      // Define the action you want to perform when the container is clicked.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationMode()),
                      );
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    30.0, 10.0, 10.0, 10.0),
                                child: Image.asset(
                                  "assets/images/add.png",
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit
                                      .cover, // Adjust to your needs (e.g., BoxFit.contain, BoxFit.fill)
                                ),
                              ),
                            ],
                          ),
    
                          // Add some spacing between the image and text
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'register'.tr,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'ifYouWantToParticipate'.tr,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  // Text(
                  //   'byRegisteringOrActivatingAccountYouAgreeToOurTermsAndConditions'.tr,
                  //   style: const TextStyle(
                  //       color: Color.fromARGB(255, 107, 107, 107)),
                  // ),
                  // TextButton(
                  //   onPressed: () {
                  //     // const RegistrationMode();  showDialog(
                  //     showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return TermsAndConditionsDialog();
                  //       },
                  //     );
                  //   },
                  //   child: Text(
                  //     'termsConditions'.tr,
                  //     style: const TextStyle(
                  //         color: primaryColor,
                  //         decoration: TextDecoration.underline),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ));
  }
}

class ClickableContainer extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  ClickableContainer({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          alignment: Alignment.center,
          // width: 150,
          height: 120,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(
                  'assets/images/bg.png'), // Replace with your image path
              fit: BoxFit
                  .cover, // Adjust to your needs (e.g., BoxFit.fill, BoxFit.fitHeight)
            ),
            // color: Colors.blue, // Container background color
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4), // Color of the shadow
                blurRadius: 10.0, // Spread of the shadow
                offset: const Offset(0, 4), // Offset from the top-left corner
              ),
            ],

            borderRadius: BorderRadius.circular(0),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
