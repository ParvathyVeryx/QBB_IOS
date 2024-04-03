import 'dart:convert';
import 'package:QBB/bottom_nav.dart';
import 'package:QBB/constants.dart';
import 'package:QBB/customNavBar.dart';
import 'package:QBB/nirmal_api.dart/Booking_get_slots.dart';
import 'package:QBB/screens/api/userid.dart';
import 'package:QBB/screens/pages/appointments.dart';
import 'package:QBB/screens/pages/book_appointment_date_slot.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:QBB/screens/pages/homescreen_nk.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:QBB/screens/pages/notification.dart';
import 'package:QBB/screens/pages/profile.dart';
import 'package:QBB/screens/pages/results.dart';
import 'package:QBB/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookAppointments extends StatefulWidget {
  final String? studyName;
  final int? studyId;
  final bool? isPreg;
  final VoidCallback? refreshCallback;
  final bool? isLangChange;

  const BookAppointments(
      {Key? key,
      this.studyName,
      this.studyId,
      this.isPreg,
      this.isLangChange,
      this.refreshCallback})
      : super(key: key);

  @override
  BookAppointmentsState createState() => BookAppointmentsState();
}

class BookAppointmentsState extends State<BookAppointments> {
  String selectedValue = 'selectStudies'.tr;
  String secondSelectedValue = 'selectVisitType'.tr;
  bool showSecondDropdown = false;
  List<String> studyNames = [];
  List<int> studyIds = [];
  List<String> visitTypeNames = [];
  String responseFromApi = '';
  List<int> visitTypeIds = [];
  int? selectedVisitTypeIdForBooking;
  int? selectedStudyId;
  bool isLoading = false; // Added flag for loading indicator
  int currentIndex = 2;
  bool? showDot;
  bool isButtonEnabled = false;
  String preg = '';
  bool isPreg = false;
  final screens = [
    const HomeScreen(),
    const Appointments(),
    const BookAppointments(),
    const Results(),
    const Profile(),
  ];

  static final GlobalKey<BookAppointmentsState> yourPageKey =
      GlobalKey<BookAppointmentsState>();

  Future<void> refreshPage() async {
    print("refreshing");
    // setState(() {
    //   selectedValue = 'selectStudies'.tr;
    //   secondSelectedValue = 'selectVisitType'.tr;
    //   print(selectedValue);
    // });

    // setState(() {
    //   selectedValue = 'selectStudies'.tr;
    // });

    // // Fetch data or perform other actions as needed
    await fetchStudyMasterAPI();
  }

  @override
  void initState() {
    showDotNotification();
    super.initState();
    showDotNotification();
    fetchStudyMasterAPI();
    refreshPage();
    widget.isLangChange == true ? refreshPage() : Container();
    getGender();
  }

  Future<void> fetchStudyMasterAPI() async {
    selectedValue = 'selectStudies'.tr;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var setLang = 'langChange'.tr;

    final String apiUrl =
        'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/StudyMasterAPI';

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      String? qid = await getQIDFromSharedPreferences();

      final http.Response response = await http.get(
        Uri.parse('$apiUrl?QID=$qid&language=$setLang'),
        headers: {
          'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          studyNames =
              responseData.map((data) => data['Name'].toString()).toList();

          if (studyNames.isNotEmpty) {
            selectedValue = 'selectStudies'.tr; // Set the initial placeholder
          }

          print("Appointment data" + responseData.toString());

          studyIds = responseData.map((data) => data['Id'] as int).toList();
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchVisitTypes(int studyId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var lang = pref.getString("langEn").toString();
    var setLang = "langChange".tr;

    setState(() {
      isLoading = true;
    });
    setState(() {
      isLoading = true;
    });

    final String apiUrl =
        'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetVisitTypeForAppointment';

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      String? qid = await getQIDFromSharedPreferences();
      // bool? isPregg = isPreg;
      final http.Response response = await http.get(
        Uri.parse(
            '$apiUrl?QID=$qid&StudyId=$studyId&Preg=$isPreg&language=$setLang'),
        headers: {
          'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
        },
      );
      print("$apiUrl?QID=$qid&StudyId=$studyId&Preg=$isPreg&language=$setLang");
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        print("Visiti type codes"+responseData.toString());
        setState(() {
          visitTypeNames =
              responseData.map((data) => data['Name'].toString()).toList();

          visitTypeIds = responseData.map((data) => data['Id'] as int).toList();
        });
      } else {
        throw Exception('Failed to fetch visit types');
      }
    } catch (error) {
      isLoading = false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> showDotNotification() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String sD = pref.getString("showDot").toString();
    print("Notification DOt" + sD);
    setState(() {
      sD == "null" ? showDot = true : showDot = false;
    });
  }

  final GlobalKey<BookAppointmentsState> _bookAppointmentsKey =
      GlobalKey<BookAppointmentsState>();
  void refreshBookAppointments() {
    _bookAppointmentsKey.currentState?.refreshPage();
  }

  String gender = '';
  String maritalId = '';

  void getGender() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    gender = pref.getString("userGender").toString();
    maritalId = pref.getString("userMaritalStatus").toString();
    print(gender + maritalId);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: DefaultTabController(
        length: 1,
        child: PopScope(
          canPop: true,
          child: Scaffold(
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
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();

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
            bottomNavigationBar: CustomTab(tabId: 2),
            body: RefreshIndicator(
              onRefresh: refreshPage,
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
                child: TabBarView(
                  children: [
                    Column(
                      children: [
                        gender.contains("emale") && maritalId != "Single"
                            ? Column(
                                children: [
                                  // const SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "areYouPregnant".tr,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        //   ],
                                        // ),
                                        // const SizedBox(
                                        //   height: 10.0,
                                        // ),
                                        Expanded(
                                            child: _buildRadioListTile(
                                                'yes'.tr, 'Yes')),
                                        // const SizedBox(
                                        //   width: 20.0,
                                        // ),
                                        Expanded(
                                            child: _buildRadioListTileNo(
                                                'no'.tr, 'No')),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                height: 0,
                              ),
                        gender.contains("emale") &&
                                maritalId != "Single" &&
                                preg == ''
                            ? Container(
                                height: 0,
                              )
                            : Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(20.0),
                                      ),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: studyNames.isEmpty
                                          ? Center(child: LoaderWidget())
                                          : DropdownButton<String>(
                                              value: selectedValue,
                                              items: [
                                                DropdownMenuItem<String>(
                                                  value: 'selectStudies'.tr,
                                                  child: Text(
                                                    'selectStudies'.tr,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                ...studyNames.map(
                                                  (studyName) =>
                                                      DropdownMenuItem<String>(
                                                    value: studyName,
                                                    child: Text(studyName),
                                                  ),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value!;
                                                  showSecondDropdown = value !=
                                                      'selectStudies'.tr;
                                                  int selectedStudyIndex =
                                                      studyNames.indexOf(value);
                                                  selectedStudyId = studyIds[
                                                      selectedStudyIndex];
                                                  secondSelectedValue =
                                                      'selectVisitType'.tr;
                                                  fetchVisitTypes(
                                                      selectedStudyId!);
                                                });
                                              },
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.0,
                                              ),
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              isExpanded: true,
                                              underline: const SizedBox(),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                        gender.contains("emale") &&
                                maritalId != "Single" &&
                                preg == ''
                            ? Container(
                                height: 0,
                              )
                            : Visibility(
                                visible: showSecondDropdown,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(20.0),
                                      ),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: DropdownButton<String>(
                                        value: secondSelectedValue,
                                        items: [
                                          'selectVisitType'.tr,
                                          ...visitTypeNames
                                        ]
                                            .toSet()
                                            .toList() // Convert to set to remove duplicates
                                            .map((visitTypeName) =>
                                                DropdownMenuItem(
                                                  value: visitTypeName,
                                                  child: Text(
                                                    visitTypeName,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            secondSelectedValue = value!;

                                            if (value != 'selectVisitType'.tr) {
                                              int selectedVisitTypeIndex =
                                                  visitTypeNames
                                                      .indexOf(value!);
                                              int selectedVisitTypeId =
                                                  visitTypeIds[
                                                      selectedVisitTypeIndex];
                                              selectedVisitTypeIdForBooking =
                                                  selectedVisitTypeId;
                                            }
                                          });
                                        },
                                        style: const TextStyle(
                                          color: Colors.purple,
                                          fontSize: 16.0,
                                        ),
                                        icon: const Icon(Icons.arrow_drop_down),
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 30),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
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
                                  onPressed: () {
                                    // Handle button press
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'cancelButton'.tr,
                                    style: const TextStyle(color: appbar),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  style: selectedValue == 'selectStudies'.tr ||
                                          secondSelectedValue ==
                                              'selectVisitType'.tr ||
                                          selectedStudyId == null ||
                                          selectedVisitTypeIdForBooking == null
                                      ? ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all<Color>(primaryColor.withOpacity(
                                                  0.4)), // Set background color
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
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
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
                                  onPressed: (selectedValue ==
                                              'selectStudies'.tr ||
                                          secondSelectedValue ==
                                              'selectVisitType'.tr ||
                                          selectedStudyId == null ||
                                          selectedVisitTypeIdForBooking == null)
                                      ? null
                                      : () async {
                                          SharedPreferences pref =
                                              await SharedPreferences
                                                  .getInstance();
                                          pref.setString("selectedStudyId",
                                              selectedStudyId.toString());
                                          pref.setString(
                                              "selectedVisitTypeID",
                                              selectedVisitTypeIdForBooking
                                                  .toString());
                                          pref.setString("selectedvalue",
                                              secondSelectedValue.toString());
                                          if (selectedValue !=
                                                  'selectStudies'.tr &&
                                              secondSelectedValue !=
                                                  'selectVisitType'.tr) {
                                            await bookAppointmentApiCall(
                                              context,
                                              selectedStudyId.toString(),
                                              selectedVisitTypeIdForBooking
                                                  .toString(),
                                              secondSelectedValue,

                                              // "false"
                                            );
                                          }
                                        },
                                  child: Text(
                                    'tutorialContinueButton'.tr,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Loading indicator
                        if (isLoading)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: LoaderWidget(),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
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
