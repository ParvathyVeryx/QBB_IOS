// import 'dart:convert';
// import 'package:QBB/constants.dart';
// import 'package:QBB/nirmal_api.dart/Booking_get_slots.dart';
// import 'package:QBB/screens/api/userid.dart';
// import 'package:QBB/screens/pages/appointments.dart';
// import 'package:QBB/screens/pages/book_appintment_nk.dart';
// import 'package:QBB/screens/pages/book_appointment_date_slot.dart';
// import 'package:QBB/screens/pages/homescreen_nk.dart';
// import 'package:QBB/screens/pages/loader.dart';
// import 'package:QBB/screens/pages/notification.dart';
// import 'package:QBB/screens/pages/profile.dart';
// import 'package:QBB/screens/pages/results.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class BN extends StatefulWidget {
//   const BN({Key? key}) : super(key: key);

//   @override
//   BNState createState() => BNState();
// }

// class BNState extends State<BN> {
//   String selectedValue = 'selectStudies'.tr;
//   String secondSelectedValue = 'Select visit type';
//   bool showSecondDropdown = false;
//   List<String> studyNames = [];
//   List<int> studyIds = [];
//   List<String> visitTypeNames = [];
//   String responseFromApi = '';
//   List<int> visitTypeIds = [];
//   int? selectedVisitTypeIdForBooking;
//   int? selectedStudyId;
//   bool isLoading = false; // Added flag for loading indicator
//   int currentIndex = 0;
//   final screens = [
//     HomeScreen(),
//     Appointments(),
//     BookAppointments(),
//     Results(),
//     Profile(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: true,
//       child: DefaultTabController(
//         length: 3,
//         child: PopScope(
//           canPop: true,
//           child: Scaffold(
//               bottomNavigationBar: BottomNavigationBar(
//                   selectedItemColor: secondaryColor,
//                   unselectedItemColor: textcolor,
//                   backgroundColor: primaryColor,
//                   currentIndex: currentIndex,
//                   unselectedFontSize: 7,
//                   selectedFontSize: 7,
//                   type: BottomNavigationBarType.fixed,
//                   onTap: (index) => setState(() {
//                         currentIndex = index;
//                       }),
//                   items: const [
//                     BottomNavigationBarItem(
//                       icon: Icon(
//                         Icons.home,
//                         color: textcolor,
//                       ),
//                       label: 'HOME',
//                     ),
//                     BottomNavigationBarItem(
//                         icon: Icon(
//                           Icons.home,
//                           color: textcolor,
//                         ),
//                         label: 'APPOINTMENT'),
//                     BottomNavigationBarItem(
//                         icon: Icon(
//                           Icons.home,
//                           color: textcolor,
//                         ),
//                         label: 'BOOK AN APPOINTMENT'),
//                     BottomNavigationBarItem(
//                         icon: Icon(
//                           Icons.home,
//                           color: textcolor,
//                         ),
//                         label: 'RESULTS/STATUS'),
//                     BottomNavigationBarItem(
//                         icon: Icon(
//                           Icons.home,
//                           color: textcolor,
//                         ),
//                         label: 'MY PROFILE'),
//                   ]),
//               body: screens[currentIndex]),
//         ),
//       ),
//     );
//   }
// }
