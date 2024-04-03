import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:QBB/providers/studymodel.dart';
import 'package:flutter/material.dart';
import 'package:QBB/constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../nirmal_api.dart/profile_api.dart';
import '../api/userid.dart';
import 'appointments.dart';
import 'erorr_popup.dart';
import 'loader.dart';

class BookResults extends StatefulWidget {
  final List<dynamic> dateList;
  final List<dynamic> nextAvailableDates;
  final List<dynamic> ACI;
  final String studyId;
  final String appTypeID;
  final String visitTypeId;
  const BookResults(
      {required this.dateList,
      required this.nextAvailableDates,
      required this.ACI,
      required this.studyId,
      required this.appTypeID,
      required this.visitTypeId,
      Key? key})
      : super(key: key);

  @override
  BookResultsState createState() => BookResultsState();
}

class BookResultsState extends State<BookResults> {
  late List<Study> bookAppScreen;
  List<DateTime> upcomingDates = [];
  TextEditingController _dateController = TextEditingController();
  bool isLoading = true; // Add a loading state
  late PageController _pageController;
  DateTime selectedDate = DateTime.now();
  List<String> selectedDates = [];
  List<String> datesOnly = [];
  List<String> dayNames = [];
  List<String> availCId = [];
  List<String> daysAndDates = [];
  late List<String> timeList;
  bool isButtonClicked = false;
  List<int> selectedIndices = [];
  int lastSelectedIndex = -1; // Initialize to an invalid index
  List<DateTime> selectedSlot = [];
  String availabilityCalendarid = '';
  String appointmentDate = '';
  String tList = '';

  String checkAvailabilityCalendar = '';
  Future<void> fetchApiResponseFromSharedPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? apiResponseJson = pref.getString('apiResponseResults');

    if (apiResponseJson != null) {
      Map<String, dynamic> jsonResponse = json.decode(apiResponseJson);
      print("Availability Calendar");
      print(jsonResponse);

      setState(() {
        tList = jsonResponse['timelist'][0];
        print(tList.toLowerCase());
        if (tList.toLowerCase().contains("pm")) {
          print("Yes PM");
          tList = tList.toLowerCase().replaceAll("pm", 'pm'.tr);
        } else if (tList.toLowerCase().contains("am")) {
          tList = tList.toLowerCase().replaceAll("am", 'am'.tr);
        }
      });
    }
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: upcomingDates.isNotEmpty ? upcomingDates[0] : DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );

  //   if (picked == null) {
  //     picked = DateTime.now();
  //     setState(() {
  //       generateUpcomingDates(picked!);
  //       generateUpcomingDatesandDays(picked!);
  //       // timeList.removeWhere((time) {
  //       //   DateTime parsedDate = DateTime.parse(time);
  //       //   return parsedDate.isBefore(picked);
  //       // });
  //     });
  //   }

  //   if (picked != null &&
  //       (upcomingDates.isEmpty || picked != upcomingDates[0])) {
  //     setState(() {
  //       generateUpcomingDates(picked!);
  //       generateUpcomingDatesandDays(picked!);
  //       // timeList.removeWhere((time) {
  //       //   DateTime parsedDate = DateTime.parse(time);
  //       //   return parsedDate.isBefore(picked);
  //       // });
  //     });

  //     // Fetch data after selecting a date
  //   }
  // }
  bool ispicked = false;
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: upcomingDates.isNotEmpty ? upcomingDates[0] : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked == null) {
      picked = DateTime.now();
    }

    setState(() {
      selectedIndices = [];
      ispicked = true;
      isNextWeekArrow = false;
      isNextWeek = false;

      generateUpcomingDates(picked!);
      fetchDateList(picked);
    });

    // Fetch data after selecting a date
  }

  List<DateTime> upcomingDateList = [];
  List<DateTime> originalDateList = [];
  List<DateTime> nextAvailableDate = [];
  List<DateTime> allDates = [];
  List<dynamic> availabiltyCandarId = [];

  Future<void> fetchAvailabilityCalendar() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? apiResponseJson = pref.getString('apiResponseResults');

    if (apiResponseJson != null) {
      Map<String, dynamic> jsonResponse = json.decode(apiResponseJson);
      print("Availability Calendar");
      print(jsonResponse);

      if (jsonResponse['BookAppoinmentModelList'] != null &&
          jsonResponse['BookAppoinmentModelList'].isNotEmpty) {
        availabiltyCandarId = jsonResponse['BookAppoinmentModelList']
            .map((item) => item['AvailabilityCalenderId'].toString())
            .toList();
        print("AAAAAACI" + availabiltyCandarId.toString());
      } else {
        print("BookAppoinmentModelList is null or empty");
      }

      // Set state if needed (depends on where this function is called)
      // setState(() {
      //   // Do something with availabiltyCandarId
      // });
    }
  }

  bool isNextWeek = false;

  // Future<void> fetchDateList(DateTime selectedDate) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String? apiResponseJson = pref.getString('apiResponseResults');

  //   if (apiResponseJson != null) {
  //     Map<String, dynamic> jsonResponse = json.decode(apiResponseJson);
  //     print("Availability Calendar");
  //     DateTime tempDate = selectedDate;
  //     print(jsonResponse);
  //     List<dynamic> dynamicList = jsonResponse['datelist'];
  //     print("Dates" + dynamicList.toString());
  //     List<String> dateStrings = List<String>.from(dynamicList);
  //     List<DateTime> dateTimes = dateStrings.map((dateString) {
  //       return DateTime.parse(dateString);
  //     }).toList();
  //     DateTime appointmentDateParse = DateTime.parse(appointmentDate);

  //     print(ispicked);

  //     print(ispicked);
  //     if (ispicked == true) {
  //       upcomingDateList = [];

  //       for (int i = 0; i < 5; i++) {
  //         // Check if the current date is within the same month as the selected date
  //         if (tempDate.month == selectedDate.month) {
  //           if (appointmentDateParse != tempDate) {
  //             setState(() {
  //               upcomingDateList.add(tempDate);
  //             });
  //             print(upcomingDateList);
  //           }
  //         }
  //         tempDate = tempDate.add(const Duration(days: 1));
  //       }
  //     } else if (isNextWeek == true) {
  //       upcomingDateList = [];
  //       for (int i = 0; i < 5; i++) {
  //         if (appointmentDateParse != tempDate) {
  //           // Check if the current date is within the same month as the selected date
  //           if (tempDate.month == selectedDate.month) {
  //             setState(() {
  //               upcomingDateList.add(tempDate);
  //             });
  //             print(upcomingDateList);
  //           }
  //         }
  //         tempDate = tempDate.add(const Duration(days: 1));
  //       }
  //     } else {
  //       setState(() {
  //         upcomingDateList = dateStrings
  //             .map((tempDate) => DateTime.parse(tempDate))
  //             .where((date) => date != appointmentDateParse)
  //             .toList();
  //       });
  //     }
  //   }
  // }
  List<String> displayedACI = [];
  bool isNextWeekArrow = false;
  bool isACI = true;
  bool onclickAgain = true;
  bool isNextWeekArrowRight = false;
  int i = 0;
  Future<void> fetchDateList(DateTime selectedDate) async {
    List<DateTime> dateTimeList = widget.dateList
        .map((dateString) => DateTime.parse(dateString))
        .toList();
    List<DateTime> nextdateTimeList = widget.nextAvailableDates
        .map((dateString) => DateTime.parse(dateString))
        .toList();
    upcomingDates = nextdateTimeList;
    originalDateList = dateTimeList;
    List<String> listACI = widget.ACI.map((item) => item.toString()).toList();
    // int i = listACI.length;
    // displayedACI.add(listACI[i - 1]);

    print("No loop 1");

    upcomingDateList = dateTimeList;
    List<DateTime> mergedList = [...dateTimeList, ...nextdateTimeList];
    availabiltyCandarId = listACI;
    if (mergedList.length > availabiltyCandarId.length) {
      isACI = false;
    }

    print(displayedACI);
    print(availabiltyCandarId);
    print(listACI);
    print(isACI);
    if (ispicked) {
      upcomingDateList = [];
      availabiltyCandarId = [];
      displayedACI = [];

      int selectedIndex = mergedList.indexOf(selectedDate);
      int endIndex = selectedIndex + 5;
      setState(() {
        if (endIndex > mergedList.length || endIndex > mergedList.length) {
          endIndex = mergedList.length;
        }
        upcomingDateList = mergedList.sublist(selectedIndex, endIndex);
        for (int i = selectedIndex; i < endIndex; i++) {
          isACI == false && selectedIndex != 0
              ? displayedACI.add(listACI[i - 1])
              : displayedACI.add(listACI[i]);
        }
        availabiltyCandarId = displayedACI;
        print(mergedList.length);
        print(availabiltyCandarId.length);
      });

      print("Merged Date List: $upcomingDateList");
      print("Availability Calendar IDs: $availabiltyCandarId");
    } else if (isNextWeek) {
      print('Nextweekslot');
      upcomingDateList = [];
      availabiltyCandarId = [];
      displayedACI = [];
      List<DateTime> mergedList = [...dateTimeList, ...nextdateTimeList];
      int selectedIndex = mergedList.indexOf(selectedDate);
      int endIndex = selectedIndex + 5;
      setState(() {
        if (endIndex > mergedList.length) {
          endIndex = mergedList.length;
        }
        upcomingDateList = mergedList.sublist(selectedIndex, endIndex);
        print(upcomingDateList);
        print(selectedDate);
        // selectedIndex = upcomingDateList.indexOf(selectedDate);
        print(selectedIndex);
        for (int i = selectedIndex; i < endIndex; i++) {
          isACI == false
              ? displayedACI.add(listACI[i - 1])
              : displayedACI.add(listACI[i]);
        }
        availabiltyCandarId = displayedACI;
        print(availabilityCalendarid);
      });

      print("Merged next Date List: $upcomingDateList");
      print("Availability Calendar IDs next: $availabiltyCandarId");
    } else if (isNextWeekArrow) {
      print('NextweekslotArrow');
      upcomingDateList = [];
      availabiltyCandarId = [];
      displayedACI = [];
      List<DateTime> mergedList = [...dateTimeList, ...nextdateTimeList];
      int selectedIndex = mergedList.indexOf(selectedDate);
      int endIndex = mergedList.length;
      setState(() {
        if (endIndex > mergedList.length) {
          endIndex = mergedList.length;
        }

        upcomingDateList = mergedList.sublist(selectedIndex, endIndex);
        for (int i = selectedIndex; i < endIndex; i++) {
          isACI == false
              ? displayedACI.add(listACI[i - 1])
              : displayedACI.add(listACI[i]);
        }
        availabiltyCandarId = displayedACI;
      });

      print("Merged next arrow Date List: $upcomingDateList");
      print("Availability Calendar IDs next arrow: $availabiltyCandarId");
    }
    // else {
    //   setState(() {
    //     upcomingDates = nextdateTimeList;
    //     originalDateList = dateTimeList;
    //     List<String> listACI =
    //         widget.ACI.map((item) => item.toString()).toList();
    //     upcomingDateList = dateTimeList;
    //     for (int i = 1; i < upcomingDateList.length; i++) {
    //       isACI == false
    //           ? displayedACI.add(listACI[i - 1])
    //           : displayedACI.add(listACI[i]);
    //     }
    //     availabiltyCandarId = displayedACI;
    //     print("No loop 2");
    //     print(displayedACI);
    //     print(availabiltyCandarId);
    //     print(listACI);
    //   });
    // }
  }

  void generateUpcomingDatesandDays(DateTime selectedDate) {
    upcomingDateList = [];
    DateTime tempDate = DateTime.now(); // Start from today

    // Generate the upcoming dates for the next five days within the same month
    for (int i = 0; i < 5; i++) {
      // Check if the current date is within the same month as the selected date
      if (tempDate.month == selectedDate.month) {
        upcomingDateList.add(tempDate);
      }

      tempDate = tempDate.add(const Duration(days: 1));

      // Break if the next day is in the next month
      if (tempDate.month != selectedDate.month) {
        break;
      }
    }

    // Now, upcomingDateList contains the upcoming dates within the same month
    print("Upcoming Dates: " + upcomingDateList.toString());

    _dateController.text =
        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
  }

  void generateUpcomingDates(DateTime selectedDate) {
    upcomingDates = [];
    DateTime tempDate = selectedDate;

    // Move to the next week's starting day (7 days from the selected date)
    tempDate = tempDate.add(Duration(days: (7 - tempDate.weekday + 1) % 7));

    DateTime currentDate = DateTime.now();

    // Generate the upcoming dates for the next seven days within the same month
    for (int i = 0; i < 7; i++) {
      if (tempDate.isAfter(currentDate) &&
          tempDate.month == currentDate.month) {
        upcomingDates.add(tempDate);
      }

      tempDate = tempDate.add(const Duration(days: 1));

      // Break if the next day is in the next month
      if (tempDate.month != currentDate.month) {
        break;
      }
    }

    _dateController.text = '${DateFormat('dd/MM/yyyy').format(selectedDate)}';
  }

  Future<List<String>> fetchAvailableDates() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? jsonString = pref.getString("availableDates");

// Check if the jsonString is not null
    if (jsonString != null) {
      // Use json.decode to parse the jsonString
      dynamic decodedData = json.decode(jsonString);

      // Check if the decodedData is a List
      if (decodedData is List) {
        // Now you can use the data as a List
        List<String> availableDates = List<String>.from(decodedData);
        for (String dateTimeString in availableDates) {
          try {
            // Parse the date-time string to DateTime
            DateTime dateTime = DateTime.parse(dateTimeString);

            // Format the DateTime to get only the date part
            String dateOnly = DateFormat('yyyy-MM-dd').format(dateTime);

            // Add the date to the result list
            datesOnly.add(dateOnly);
          } catch (e) {
            // Handle parsing errors if necessary
          }
        }

        daysAndDates = availableDates;

        pref.setString("dateOnly", datesOnly.toString());
        pref.getString("dateOnly");
        List<DateTime?> dates = datesOnly.map((dateString) {
          try {
            return DateTime.parse(dateString);
          } catch (e) {
            return null;
          }
        }).toList();

        // Check if any dates were successfully parsed
        for (DateTime? date in dates) {
          if (date != null) {
            String dayName = DateFormat('EEEE').format(date);
            dayNames.add(dayName);
          }
        }

        return datesOnly;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  List<String> daysOnly = [];
  Future<List<String>> fetchAvailableDays() async {
    List<DateTime?> dates = datesOnly.map((dateString) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
      }
    }).toList();

    // Check if any dates were successfully parsed

    for (DateTime? date in dates) {
      if (date != null) {
        String dayName = DateFormat('EEEE').format(date);
        dayNames.add(dayName);
      }
    }

    return dayNames;
  }

  Future<String> getAvailabilityCalendar(String availabilityCalendar) async {
    availabilityCalendarid = availabilityCalendar;
    return availabilityCalendarid;
  }

  String appointmentId = '';

  bool isFirstList = true;

  void isFirst() {
    if (ispicked == false &&
        isNextWeek == false &&
        isNextWeekArrow == false &&
        isACI == false) {
      setState(() {
        isFirstList = true;
      });
      print("2" + isFirstList.toString());
    } else {
      setState(() {
        isFirstList = false;
        print("1" + isFirstList.toString());
      });
    }
  }

  void getAppID(String appID) async {
    // appointmentId = appID;
    SharedPreferences pref = await SharedPreferences.getInstance();
    appointmentId = pref.getString("ResultsappoinmentID").toString();
    print("Appointment ID" + appointmentId);
    print(appID);
  }

  Future<void> confirmAppointment(BuildContext context) async {
    final GlobalKey<State> _keyLoader = GlobalKey<State>();
    LoaderWidget _loader = LoaderWidget();
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? qid = await getQIDFromSharedPreferences();
    String studyId = pref.getString("resultsStudyID").toString();
    int? studyIdInt = int.tryParse(studyId);
    String visitTypeId = pref.getString("resultsVisitTypeID").toString();
    String appiontmentID = pref.getString("resultsAppID").toString();
    int? visitTypeIDInt = int.tryParse(visitTypeId);
    String appointmentTypeID =
        pref.getString("resultsAppointmentTypeID").toString();
    int? personGradeId = await getPersonGradeIdFromSharedPreferences();

    String? selectedSlot = pref.getString("selectDate");
    DateTime _selectedDate =
        selectedSlot != null ? DateTime.parse(selectedSlot) : DateTime.now();

    // Retrieve the token from SharedPreferences
    String? token = pref.getString('token');
    if (token == null) {
      // Handle the case where the token is not available
      // You might want to show an error message or navigate the user to the login screen
      return;
    }

    // Construct headers with the retrieved token
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token.replaceAll('"', '')}',
    };

    Map<String, dynamic> queryParams = {
      "QID": '$qid',
      "AppointmentTypeId": widget.appTypeID,
      "PersonGradeId": personGradeId.toString(),
      "AppoinmentId": appiontmentID,
      "StudyId": widget.studyId,
      "VisitTypeId": widget.visitTypeId,
      "AvailabilityCalenderId": availabilityCalendarid,
      "ShiftCode": 'shft',
      "language": 'langChange'.tr,
    };
    print("Query PArameter" + queryParams.toString());

    // Construct the API URL
    Uri apiUrl = Uri.parse(
        "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/BookResultAppointmentAPI?QID=${queryParams['QID']}&StudyId=${queryParams['StudyId']}&ShiftCode=${queryParams['ShiftCode']}&VisitTypeId=${queryParams['VisitTypeId']}&PersonGradeId=${queryParams['PersonGradeId']}&AvailabilityCalenderId=${queryParams['AvailabilityCalenderId']}&language=${queryParams['language']}&AppoinmentId=${queryParams['AppoinmentId']}&AppointmentTypeId=${queryParams['AppointmentTypeId']}");

    print("API URL results");
    print(apiUrl);
    print(jsonEncode(queryParams));

    try {
      Dialogs.showLoadingDialog(context, _keyLoader, _loader);
      // Make the HTTP POST request
      final response =
          await http.post(apiUrl, headers: headers, body: queryParams);

      // Process the response here

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        // Successful response, show a success dialog
        await showDialog(
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
                  json.decode(response.body)["Message"],
                  style:
                      const TextStyle(color: Color.fromARGB(255, 74, 74, 74)),
                ),
              ),
              actions: <Widget>[
                Divider(),
                TextButton(
                  onPressed: () async {
                    Navigator.pushNamed(context, '/appointments');
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
      } else {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        // Error response, show an error dialog
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorPopup(
                errorMessage: json.decode(response.body)["Message"]);
          },
        );
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      // Handle network errors or other exceptions
      print('Error: $e');
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorPopup(
              errorMessage: 'Network error or other exception occurred.');
        },
      );
    }
  }

  @override
  void initState() {
    // bookAppScreen = [];
    super.initState();

    getAppID(appointmentId);
    timeList = [];
    generateUpcomingDates(DateTime.now());
    _pageController = PageController(initialPage: 0);
    fetchApiResponseFromSharedPrefs();
    fetchAvailableDates().then((dates) {
      setState(() {
        datesOnly = dates;
      });
    });
    fetchAvailableDays().then((days) {
      setState(() {
        dayNames = days;
      });
    });
    fetchDateList(DateTime.now());
    fetchAvailabilityCalendar();
  }

  @override
  Widget build(BuildContext context) {
    // if (bookAppScreen.isEmpty) {
    //   // Return a loading indicator or handle the case appropriately
    //   return LoaderWidget(); // Replace with your loading widget
    // }
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.grey),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 60.0),
                child: Text(
                  'bookAnAppointment'.tr,
                  style: const TextStyle(
                      color: appbar, fontFamily: 'Impact', fontSize: 16),
                ),
              ),
            ],
          ),
          backgroundColor: textcolor,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          labelText:
                              '${DateFormat('dd/MM/yyyy').format(selectedDate)}',
                          labelStyle: const TextStyle(fontSize: 11),
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            size: 16,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      upcomingDates.length == 0
                          ? Container()
                          : IconButton(
                              onPressed: () {
                                //   _pageController.previousPage(
                                //     duration: const Duration(milliseconds: 300),
                                //     curve: Curves.easeInOut,
                                //   );
                                setState(() {
                                  selectedIndices = [];
                                  isNextWeekArrow = true;
                                  ispicked = false;
                                  isNextWeek = false;
                                  upcomingDateList = originalDateList;
                                  fetchDateList(originalDateList[0]);
                                });
                              },
                              icon: const Icon(Icons.arrow_back_ios_rounded),
                              color: primaryColor,
                              iconSize: 11,
                            ),
                      Text(
                        "nextWeek".tr,
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                      upcomingDates.length == 0
                          ? Container()
                          : IconButton(
                              onPressed: () {
                                // _pageController.nextPage(
                                //   duration: const Duration(milliseconds: 300),
                                //   curve: Curves.easeInOut,
                                // );
                                setState(() {
                                  selectedIndices = [];
                                  isNextWeekArrow = true;
                                  ispicked = false;
                                  isNextWeek = false;
                                  upcomingDateList = upcomingDates;
                                  fetchDateList(upcomingDateList[0]);
                                });
                              },
                              icon: const Icon(Icons.arrow_forward_ios_rounded),
                              color: primaryColor,
                              iconSize: 11,
                            )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "nextAvailableDates".tr,
                        style: const TextStyle(
                            color: appbar,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "swipeRightToViewMoreDates".tr,
                          style: const TextStyle(
                              color: primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.9, // or a fixed width
                        height: 40, // or any fixed height
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                height: 130,
                                width: 135.0 * upcomingDates.length.toDouble(),
                                child: ListView.builder(
                                  controller: ScrollController(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: upcomingDates.length,
                                  itemBuilder: (context, index) {
                                    return Center(
                                      child: Center(
                                        child: Row(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                side: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 201, 201, 201),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0),
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                    30, 0, 30, 0),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  selectedIndices = [];
                                                  isNextWeek = true;
                                                  ispicked = false;
                                                  isNextWeekArrow = false;
                                                  fetchDateList(
                                                      upcomingDates[index]);
                                                });
                                              },
                                              child: Text(
                                                '${DateFormat('dd/MM/yyyy').format(upcomingDates[index])}',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "swipeRightToViewMoreSlots".tr,
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'timeSlot'.tr,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            tList,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  width: 107.0 *
                                      upcomingDateList.length.toDouble() *
                                      2 // Use available width as the width
                                  ,
                                  height: 120,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: upcomingDateList.map((date) {
                                      int index =
                                          upcomingDateList.indexOf(date);

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${DateFormat('EEEE').format(date)}',
                                              style: const TextStyle(
                                                  fontSize: 11, color: appbar),
                                            ),
                                            Container(
                                              // margin: const EdgeInsets.all(8),
                                              child: Center(
                                                child: Text(
                                                  '${DateFormat('dd/MM/yyyy').format(date)}',
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: appbar,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Container(
                                              width: 80,
                                              margin: const EdgeInsets.only(
                                                  bottom:
                                                      8.0), // Add margin for spacing
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color:
                                                        appbar, // Choose your border color
                                                    width:
                                                        0.7, // Choose your border width
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            isACI == false &&
                                                    upcomingDateList[index] ==
                                                        originalDateList[0]
                                                ? Container()
                                                : ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  0.0),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          selectedIndices
                                                                  .contains(
                                                                      index)
                                                              ? primaryColor
                                                              : Colors.white,
                                                      side: const BorderSide(
                                                          color: primaryColor),
                                                      elevation: 0,
                                                    ),
                                                    onPressed: () async {
                                                      String? uD = DateFormat(
                                                              'dd/MM/yyyy')
                                                          .format(
                                                              upcomingDateList[
                                                                  0]);
                                                      String? od = DateFormat(
                                                              'dd/MM/yyyy')
                                                          .format(
                                                              originalDateList[
                                                                  0]);
                                                      print(isACI);
                                                      print(
                                                          upcomingDates.length);
                                                      print(availabiltyCandarId
                                                          .length);
                                                      print(uD.toString());
                                                      print(od.toString());
                                                      String check = '';
                                                      uD == od
                                                          ? check = "Ok"
                                                          : check = "Not Ok";

                                                      print(DateFormat(
                                                              'dd/MM/yyyy')
                                                          .format(
                                                              upcomingDateList[
                                                                  0]));
                                                      print(DateFormat(
                                                              'dd/MM/yyyy')
                                                          .format(
                                                              originalDateList[
                                                                  0]));
                                                      print(
                                                          "...................");
                                                      print(".........." +
                                                          index.toString());
                                                      // print(availabiltyCandarId[
                                                      //     0]);
                                                      print(DateFormat(
                                                              'dd/MM/yyyy')
                                                          .format(
                                                              DateTime.now())
                                                          .runtimeType);
                                                      // availabiltyCandarId[index];
                                                      // print("ACI" +
                                                      //     availabiltyCandarId[index]
                                                      //         .toString());

                                                      // fetchDateList(upcomingDateList[index]);
                                                      // fetchAvailabilityCalendar(
                                                      //     date);
                                                      // isACI == false &&
                                                      //             isFirstList ==
                                                      //                 true &&
                                                      //         check == "Ok"
                                                      //     ? checkAvailabilityCalendar =
                                                      //         availabiltyCandarId[
                                                      //                 index - 1]
                                                      //             .toString()
                                                      //     : checkAvailabilityCalendar =
                                                      //         availabiltyCandarId[
                                                      //                 index]
                                                      //             .toString();
                                                      // isFirst();
                                                      // isACI == false &&
                                                      //             isFirstList ==
                                                      //                 true &&
                                                      //         check == "Ok"
                                                      //     ? getAvailabilityCalendar(
                                                      //         availabiltyCandarId[
                                                      //             index - 1])
                                                      //     : getAvailabilityCalendar(
                                                      //         availabiltyCandarId[
                                                      //             index]);
                                                      isFirst();
                                                      isACI == false &&
                                                              isFirstList ==
                                                                  true
                                                          ? checkAvailabilityCalendar =
                                                              availabiltyCandarId[
                                                                      index - 1]
                                                                  .toString()
                                                          : isACI == false &&
                                                                  check == "Ok"
                                                              ? checkAvailabilityCalendar =
                                                                  availabiltyCandarId[
                                                                          index -
                                                                              1]
                                                                      .toString()
                                                              : checkAvailabilityCalendar =
                                                                  availabiltyCandarId[
                                                                          index]
                                                                      .toString();
                                                      isACI == false &&
                                                              isFirstList ==
                                                                  true
                                                          ? getAvailabilityCalendar(
                                                              availabiltyCandarId[
                                                                  index - 1])
                                                          : isACI == false &&
                                                                  check == "Ok"
                                                              ? getAvailabilityCalendar(
                                                                  availabiltyCandarId[
                                                                      index -
                                                                          1])
                                                              : getAvailabilityCalendar(
                                                                  availabiltyCandarId[
                                                                      index]);
                                                      if (selectedDates
                                                              .length ==
                                                          1) {
                                                        selectedDates[0] =
                                                            upcomingDateList[
                                                                    index]
                                                                .toString();
                                                      } else {
                                                        selectedDates.add(
                                                            upcomingDateList[
                                                                    index]
                                                                .toString());
                                                      }

                                                      SharedPreferences pref =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      pref.setString(
                                                          "selectedDateReschedule",
                                                          selectedDates
                                                              .toString());
                                                      String prefval = pref
                                                          .getString(
                                                              "selectedDateReschedule")
                                                          .toString();

                                                      setState(() {
                                                        // Reset the color of the last selected button
                                                        if (lastSelectedIndex !=
                                                            -1) {
                                                          selectedIndices.remove(
                                                              lastSelectedIndex);
                                                        }

                                                        // Update the color of the current button
                                                        if (selectedIndices
                                                            .contains(index)) {
                                                          selectedIndices
                                                              .remove(index);
                                                        } else {
                                                          selectedIndices
                                                              .add(index);
                                                        }

                                                        // Update the last selected index
                                                        lastSelectedIndex =
                                                            index;
                                                      });

                                                      // Print the selected date
                                                      print(
                                                          'Selected Date: ${upcomingDateList[index]}');
                                                      // print(
                                                      //     'Selected Date: ${availabiltyCandarId[index]}');
                                                    },
                                                    child: selectedIndices
                                                            .contains(index)
                                                        ? Text(
                                                            'available'.tr,
                                                            style: const TextStyle(
                                                                color:
                                                                    textcolor),
                                                          )
                                                        : Text(
                                                            'available'.tr,
                                                            style: const TextStyle(
                                                                color:
                                                                    primaryColor,
                                                                fontSize: 11),
                                                          ),
                                                  )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(width:50),
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
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                ),
                              ),
                              backgroundColor: primaryColor,
                              side: const BorderSide(color: primaryColor),
                              elevation: 0,
                            ),
                            onPressed: () {
                              checkAvailabilityCalendar == ""
                                  ? showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ErrorPopup(
                                            errorMessage: "selectSlot".tr);
                                      })
                                  : showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(
                                                  50.0), // Adjust the radius as needed
                                            ),
                                          ),
                                          content: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0),
                                            child: Text(
                                              "areYouSure".tr,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 74, 74, 74)),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: Text(
                                                    'cancelButton'.tr,
                                                    style: TextStyle(
                                                        color: secondaryColor),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    confirmAppointment(context);
                                                    // Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'confirm'.tr,
                                                    style: TextStyle(
                                                        color: secondaryColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                            },
                            child: Text(
                              'confirm'.tr,
                              style: TextStyle(color: textcolor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
