// import 'package:QBB/constants.dart';
// import 'package:flutter/material.dart';

// class EditProfilePage extends StatelessWidget {
//   const EditProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: appbar,
//         title: const Text(
//           'Profile',
//           style: TextStyle(color: Colors.white),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_none),
//             onPressed: () {
//               // Handle notifications button press
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               alignment: Alignment.bottomRight,
//               children: [
//                 Center(
//                   child: Stack(
//                     alignment: Alignment.bottomRight,
//                     children: [
//                       Container(
//                         width: 100,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(width: 2, color: Colors.pink),
//                           image: const DecorationImage(
//                             fit: BoxFit.fill,
//                             image: AssetImage('assets/images/user.png'),
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           // Handle profile image edit
//                         },
//                         child: Container(
//                           width: 30,
//                           height: 30,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.pink,
//                           ),
//                           child: const Icon(
//                             Icons.camera,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: ListView(
//                 children: [
//                   buildProfileRow('Full Name', 'John Doe'),
//                   buildProfileRow('Mobile', '1234567890'),
//                   buildProfileRow('QID', '123456789'),
//                   buildProfileRow('Gender', 'Male'),
//                   buildProfileRow('Health Card No.', 'H123456789'),
//                   buildProfileRow('Date of Birth', '01-01-1990'),
//                   buildProfileRow('Nationality', 'Country'),
//                   buildProfileRow('Email', 'john.doe@example.com'),
//                   buildProfileRow('Marital Status', 'Single'),
//                   const SizedBox(height: 16),
//                   OutlinedButton(
//                     onPressed: () {
//                       // Handle Edit Profile button press
//                     },
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(
//                           color: Colors.pink), // Set the border color
//                     ),
//                     child: const Text(
//                       'Edit Profile',
//                       style:
//                           TextStyle(color: Colors.pink), // Set the text color
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ], // Add a closing bracket here
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 3,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.event),
//             label: 'Appointments',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.date_range),
//             label: 'Book an Appointment',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//         selectedItemColor: const Color(0xFFBC1E87),
//         unselectedItemColor: Colors.grey,
//         backgroundColor: const Color(0xFF0F75CE),
//       ),
//     );
//   }

//   Widget buildProfileRow(String label, String value) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(label),
//             Text(value),
//           ],
//         ),
//         const Divider(), // Add a divider line
//       ],
//     );
//   }
// }
