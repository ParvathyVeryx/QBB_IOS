import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:QBB/constants.dart';
import 'package:QBB/customNavBar.dart';
import 'package:QBB/nirmal_api.dart/marital_status_api.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:QBB/screens/pages/results.dart';
import 'package:QBB/sidebar.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:QBB/nirmal_api.dart/user_profile_photo_api.dart';
import 'package:QBB/nirmal_api.dart/user_profileapi_get.dart';
import 'package:QBB/screens/pages/about.dart';
import 'package:QBB/screens/profile/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appointments.dart';
import 'book_appintment_nk.dart';
import 'homescreen_nk.dart';
import 'notification.dart';

class UserProfileData {
  String userName = '';
  String mobile = '';
  String email = '';
  String nationality = '';
  String hCNo = '';
  String dob = '';
  String qid = '';
  String gender = '';
  String maritalStatus = '';
  String dateOnly = '';
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  String _qid = '';
  // String profilePicture = '';
  late File? _selectedImage;
  bool _isLoading = true;
  int currentIndex = 4;
  late Future<UserProfileData> _userProfileFuture;
  String profilePicture = '';

  bool _isLoadingData = true;
  late ImagePicker imagePicker;
  XFile? pickedImage;

  bool? showDot;
  Future<void> showDotNotification() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String sD = pref.getString("showDot").toString();

    setState(() {
      sD == "null" ? showDot = true : showDot = false;
    });
  }

  @override
  void initState() {
    super.initState();
    showDotNotification();
    imagePicker = ImagePicker();

    // Assume you have a variable _isLoading to track whether data is still loading
    _isLoading = true;

    // Start loading user profile data
    _userProfileFuture = getUserProfileData();

    // After 2 seconds, set isLoading to false to stop showing the LoaderWidget
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });

    // Call the profilePic method to update profilePicture after loading data
    profilePic();
    UserProfileData();
  }

  Future<void> pickImage() async {
    try {
      XFile? pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        pickedImage = pickedImage;
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<UserProfileData> getUserProfileData() async {
    try {
      String responseBody = await callUserProfileAPIGet();
      return parseUserProfileData(responseBody);
    } catch (e) {
      throw e;
    }
  }

  UserProfileData parseUserProfileData(String responseBody) {
    Map<String, dynamic> jsonMap = json.decode(responseBody);
    return UserProfileData()
      ..userName = _buildFullName(jsonMap)
      ..mobile = jsonMap['RecoveryMobile'].toString()
      ..email = jsonMap['RecoverEmail'].toString()
      ..nationality = jsonMap["Nationality"].toString() ?? ''
      ..hCNo = jsonMap['HealthCardNo'].toString() == "null"
          ? ""
          : jsonMap['HealthCardNo'].toString()
      ..dob = jsonMap['Dob'].toString()
      ..qid = jsonMap['QID'].toString()
      ..gender = jsonMap['Gender'].toString()
      ..maritalStatus = jsonMap['MaritalStatus'].toString()
      ..dateOnly = _buildDateOnly(jsonMap);
  }

  String _buildFullName(Map<String, dynamic> jsonMap) {
    String middleName = jsonMap['MiddleName'].toString() == "null"
        ? ''
        : jsonMap['MiddleName'].toString() + '';
    return jsonMap['FirstName'].toString() +
        ' ' +
        middleName +
        jsonMap['LastName'].toString();
  }

  String _buildDateOnly(Map<String, dynamic> jsonMap) {
    DateTime dateTime = DateTime.parse(jsonMap['Dob'].toString());
    return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
  }

  void profilePic() async {
    try {
      String responseBody = await callUserProfileAPIGet();
      Map<String, dynamic> jsonMap = json.decode(responseBody);
      setState(() {
        profilePicture = jsonMap['Photo'] ?? '';
      });
      print("Profile Pic 1 " + profilePicture);
    } catch (e) {
      // Handle the error appropriately
    }
  }

  bool isImageSizeValid(Uint8List imageData, int maxSizeInBytes) {
    return imageData.length <= maxSizeInBytes;
  }

  // Future<void> pickImageFromGallery() async {
  //   final pickedImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     // print('Selected Image Path: ${pickedImage.path}');
  //     // setState(() {
  //     //   _selectedImage = File(pickedImage.path);
  //     // });

  //     // print('Uploading Image...');
  //     // await uploadUserProfilePhoto(
  //     //     context,
  //     //     _userProfileFuture
  //     //         .then((userProfileData) => userProfileData.qid)
  //     //         .toString(),
  //     //     _selectedImage!);
  //     // print('Image Upload Complete');

  //         if (isImageSizeValid(_selectedImage, 70 * 1024)) {
  //     await uploadUserProfilePhoto(
  //         context,
  //         _userProfileFuture
  //             .then((userProfileData) => userProfileData.qid)
  //             .toString(),
  //         _selectedImage!);

  //     print('Image Upload Complete');
  //   } else {
  //     // Show an error message or handle the case where the image size exceeds 70KB
  //     print('Image size exceeds 70KB. Please choose a smaller image.');
  //   }
  //   }
  // }

  Future<void> pickImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Read the file as bytes (Uint8List)
      Uint8List? imageBytes = await pickedImage.readAsBytes();

      // Check if the image size is less than 70KB (70 * 1024 bytes)
      if (isImageSizeValid(imageBytes, 70 * 1024)) {
        // Set the _selectedImage variable
        setState(() {
          _selectedImage = File(pickedImage.path);
        });

        // Continue with your image upload logic
        await uploadUserProfilePhoto(
          context,
          _userProfileFuture
              .then((userProfileData) => userProfileData.qid)
              .toString(),
          _selectedImage!,
        );

        print('Image Upload Complete');
      } else {
        // Show an error message or handle the case where the image size exceeds 70KB
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(50.0), // Adjust the radius as needed
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  "editImgError".tr,
                  style:
                      const TextStyle(color: Color.fromARGB(255, 74, 74, 74)),
                ),
              ),
              actions: <Widget>[
                // Divider(),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'ok'.tr,
                    style: TextStyle(color: secondaryColor),
                  ),
                ),
              ],
            );
          },
        );

        print('Image size exceeds 70KB. Please choose a smaller image.');
      }
    }
  }

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
            Text(
              'profile'.tr,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'Impact', fontSize: 16),
            ),
            IconButton(
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();

                setState(() {
                  showDot = false;
                  pref.setString("showDot", "false");
                });

                // Perform actions on the first click, such as navigating or showing a notification.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(),
                  ),
                );
              },
              icon: Stack(
                children: [
                  Icon(Icons.notifications_none_outlined),
                  if (showDot == true)
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 3,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                        ),
                        child: Text(
                          '', // You can customize this text or use an empty container for just a dot.
                        ),
                      ),
                    ),
                ],
              ),
              iconSize: 30.0,
              color: Colors.white,
            ),
          ],
        ),
        backgroundColor: appbar,
      ),
      drawer: const SideMenu(),
      bottomNavigationBar: CustomTab(
        tabId: 4,
      ),
      body: _isLoading
          ? Center(child: LoaderWidget())
          : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [appbar, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.100, 0.100],
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: primaryColor,
                          child: CircleAvatar(
                            radius: 47,
                            backgroundImage: profilePicture != "string"
                                ? _getImageProvider(profilePicture)
                                : const AssetImage('assets/images/user.png'),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryColor,
                                width: 1.0,
                              ),
                              color: primaryColor,
                            ),
                            child: Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                // onPressed: () async {
                                //   final pickedImage = await ImagePicker()
                                //       .pickImage(source: ImageSource.gallery);
                                //   if (pickedImage != null) {
                                //     setState(() {
                                //       _selectedImage = File(pickedImage.path);
                                //     });
                                //     await uploadUserProfilePhoto(
                                //         _qid, _selectedImage!);
                                //   }
                                // },
                                onPressed: pickImageFromGallery,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    ProfileInfoRow(
                      label: 'fullName'.tr,
                      value: _userProfileFuture
                          .then((userProfileData) => userProfileData.userName),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                      label: 'mobile'.tr,
                      value: _userProfileFuture
                          .then((userProfileData) => userProfileData.mobile),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                      label: 'qid'.tr,
                      value: _userProfileFuture
                          .then((userProfileData) => userProfileData.qid),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                      label: 'gender'.tr,
                      value: _userProfileFuture.then((userProfileData) =>
                          userProfileData.gender.toLowerCase()),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                      label: 'healthCardNo'.tr,
                      value: _userProfileFuture
                          .then((userProfileData) => userProfileData.hCNo),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                      label: 'dateOfBirth'.tr,
                      value: _userProfileFuture
                          .then((userProfileData) => userProfileData.dateOnly),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                      label: 'nationality'.tr,
                      value: _userProfileFuture.then(
                          (userProfileData) => userProfileData.nationality),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                      label: 'email'.tr,
                      value: _userProfileFuture
                          .then((userProfileData) => userProfileData.email),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    const SizedBox(height: 10),
                    ProfileInfoRow(
                      label: 'maritalStatus'.tr,
                      value: _userProfileFuture.then(
                          (userProfileData) => userProfileData.maritalStatus),
                    ),
                    const SizedBox(height: 10),
                    const PinkDivider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15, 5),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString(
                                "userGenderrr",
                                _userProfileFuture
                                    .then((userProfileData) =>
                                        userProfileData.maritalStatus)
                                    .toString());
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditUser(
                                  emailFuture: _userProfileFuture.then(
                                    (userProfileData) => userProfileData.email,
                                  ),
                                  maritalstatus: _userProfileFuture.then(
                                    (userProfileData) => userProfileData
                                        .maritalStatus
                                        .toString(),
                                  ),
                                ),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12.0),
                                ),
                                side: BorderSide(
                                  color: secondaryColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(3.0, 8.0, 3.0, 8.0),
                            child: Text(
                              'settingsPageProfile'.tr,
                              style: const TextStyle(
                                color: secondaryColor,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const PinkDivider(),
                  ],
                ),
              ),
            ),
    );
  }
}

class PinkDivider extends StatelessWidget {
  const PinkDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color.fromARGB(255, 228, 228, 228),
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final Future<String> value;

  const ProfileInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: value,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return LoaderWidget();
          } else {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            snapshot.data ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        } else {
          // Still loading
          // return LoaderWidget();
          return Container();
        }
      },
    );
  }
}

ImageProvider _getImageProvider(String profilePicture) {
  print("Profile Picture" + profilePicture);
  if (profilePicture.startsWith('data:image/png')) {
    List<String> parts = profilePicture.split(',');
    if (parts.length == 2) {
      String base64String = parts[1];
      Uint8List bytes = base64Decode(base64String);
      return MemoryImage(bytes);
    }
  }

  return NetworkImage(profilePicture);
}
