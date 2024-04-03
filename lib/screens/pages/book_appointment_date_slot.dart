import 'dart:async';
import 'dart:convert';

import 'package:QBB/constants.dart';
import 'package:QBB/screens/pages/appointments.dart';
import 'package:QBB/screens/pages/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import '../api/userid.dart';
import 'erorr_popup.dart';

class AppointmentBookingPage extends StatefulWidget {
  const AppointmentBookingPage({
    Key? key,
  }) : super(key: key);

  @override
  _AppointmentBookingPageState createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  String _selectedTimeSlot = '10:00 AM';
  List<String> availableTimeSlots = [];
  DateTime selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  List<String> availableDates = [];
  List<String> nextAvailableDates = [];

  @override
  void initState() {
    super.initState();
    fetchApiResponseFromSharedPrefs();
  }

  Future<void> fetchApiResponseFromSharedPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? apiResponseJson = pref.getString('apiResponse');

    if (apiResponseJson != null) {
      Map<String, dynamic> jsonResponse = json.decode(apiResponseJson);

      setState(() {
        availableDates = List<String>.from(jsonResponse['datelist']);
        nextAvailableDates =
            List<String>.from(jsonResponse['nextAvilableDateList']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'pageATitle'.tr,
          style: TextStyle(
              fontFamily: 'impact', color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText:
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            const SwipableDateRow(),
            const SizedBox(height: 10.0),
            const SizedBox(height: 30.0),
            Center(
              child: Text('swipeRightToViewMoreSlots'.tr),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(height: 200, child: SwipableFourColumnWidget()),
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
                        'cancel'.tr,
                        style: TextStyle(color: appbar),
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
                      ),
                      onPressed: _confirmAppointment,
                      child: Text('confirm'.tr),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    Future<String> selectedDateFromSlot() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String selectedDate = pref.getString("selectedDate").toString();
      pref.setString("selecetedDateFromCalendar", picked.toString());
      pref.getString("selecetedDateFromCalendar");
      return selectedDate;
    }

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
        availableTimeSlots = ['05:00 PM-06:00 PM'];
      });
    }
  }

  void _selectTimeSlot(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
  }

  String selectedSlot = '';
  DateTime parseDate = DateTime.now();

  void _confirmAppointment() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // String selectedSlot = pref.getString("selectDate").toString();
    // DateTime parsedDateTime;
    // selectedSlot == "null" ? "" : _selectedDate = DateTime.parse(selectedSlot);
    Timer.periodic(Duration(seconds: 1), (timer) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      selectedSlot = pref.getString("selectedDate").toString();
      // parseDate = DateTime.parse(selectedSlot);
    });

    String? qid = await getQIDFromSharedPreferences();
    String? studyId = pref.getString("selectedStudyId");
    String visitTypeId = pref.getString("selectedVisitTypeID").toString();
    String? availabiltyCalendarId = pref.getString("availabilityCalendarId");

    selectedSlot == "null" ? selectedDate : selectedDate = selectedDate;
    var lang = 'langChange'.tr;

    try {
      // Retrieve the token from SharedPreferences
      String? token = pref.getString('token');
      if (token == null) {
        // Handle the case where the token is not available
        return;
      }

      // Construct headers with the retrieved token
      Map<String, String> headers = {
        'Authorization': 'Bearer ${token.replaceAll('"', '')}',
      };

      Map<String, dynamic> queryParams = {
        "QID": '$qid',
        "StudyId": '$studyId',
        "ShiftCode": 'shft',
        "VisitTypeId": visitTypeId,
        "PersonGradeId": '4',
        "AvailabilityCalenderId": availabiltyCalendarId,
        "language": "$lang",
        "AppointmentTypeId": 1
      };

      // Construct the API URL
      Uri apiUrl = Uri.parse(
          "https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/BookAppointmentAPI?QID=${queryParams['QID']}&StudyId=${queryParams['StudyId']}&ShiftCode=${queryParams['ShiftCode']}&VisitTypeId=${queryParams['VisitTypeId']}&PersonGradeId=${queryParams['PersonGradeId']}&AvailabilityCalenderId=${queryParams['AvailabilityCalenderId']}&language=${queryParams['language']}&AppointmentTypeId=${queryParams['AppointmentTypeId']}");

      // print(apiUrl);
      // Make the HTTP POST request
      final response =
          await http.post(apiUrl, headers: headers, body: queryParams);
      print(queryParams);
      print(response.body);
      if (response.statusCode == 200) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(''),
                content: Text(json.decode(response.body)),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                                              context, '/appointments'); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      } else {
        showDialog(
            context: context, // Use the context of the current screen
            builder: (BuildContext context) {
              return ErrorPopup(
                  errorMessage: json.decode(response.body)["Message"]);
            });
      }
    } catch (e) {}
  }
}

class SwipableDateRow extends StatefulWidget {
  const SwipableDateRow({Key? key}) : super(key: key);

  @override
  _SwipableDateRowState createState() => _SwipableDateRowState();
}

class _SwipableDateRowState extends State<SwipableDateRow> {
  late PageController _pageController;
  late List<String> availableDates;
  late List<String> nextAvailableDates;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    availableDates = [];
    nextAvailableDates = [];
    fetchApiResponseFromSharedPrefs();
  }

  Future<void> fetchApiResponseFromSharedPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? apiResponseJson = pref.getString('apiResponse');

    if (apiResponseJson != null) {
      Map<String, dynamic> jsonResponse = json.decode(apiResponseJson);

      setState(() {
        availableDates = List<String>.from(jsonResponse['datelist']);
        nextAvailableDates =
            List<String>.from(jsonResponse['nextAvilableDateList']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  moveToAvailableDates();
                },
                icon: const Icon(Icons.arrow_back),
                color: appbar,
              ),
              const Center(
                child: Text(
                  'Next Available Dates',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () {
                  moveToNextAvailableDates();
                },
                icon: const Icon(Icons.arrow_forward),
                color: appbar,
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Center(
            child: Text(
              'Swipe right to view more details',
              style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 80.0,
            child: PageView.builder(
              controller: _pageController,
              itemCount: availableDates.length + nextAvailableDates.length,
              itemBuilder: (context, index) {
                String date = index < availableDates.length
                    ? availableDates[index]
                    : nextAvailableDates[index - availableDates.length];

                return Container(
                  width: 100.0, // Adjust the width as needed
                  height: 80.0, // Adjust the height as needed
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Center(
                      child: Text(
                        date,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void moveToNextAvailableDates() {
    _pageController.jumpToPage(availableDates.length);
  }

  void moveToAvailableDates() {
    _pageController.jumpToPage(0);
  }
}

class SwipableFourColumnWidget extends StatefulWidget {
  SwipableFourColumnWidget({Key? key}) : super(key: key);

  @override
  State<SwipableFourColumnWidget> createState() =>
      _SwipableFourColumnWidgetState();
}

class _SwipableFourColumnWidgetState extends State<SwipableFourColumnWidget> {
  List<String> daysAndDates = [];
  List<String> datesOnly = [];
  List<String> dayNames = [];
  List<String> selectedDates = [];

  // final List<String> availabilityStatus = [
  //   'Available',
  //   'Available',
  //   'Available',
  // ];

  late List<String> timeList;

  // late List<String> nextAvailableDates;

  @override
  void initState() {
    super.initState();
    // _pageController = PageController();
    timeList = [];
    // nextAvailableDates = [];
    fetchApiResponseFromSharedPrefs();
    fetchAvailableDates();
    fetchAvailableDays();
    pickedDate();
  }

  Future<void> fetchApiResponseFromSharedPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? apiResponseJson = pref.getString('apiResponse');

    if (apiResponseJson != null) {
      Map<String, dynamic> jsonResponse = json.decode(apiResponseJson);

      setState(() {
        timeList = List<String>.from(jsonResponse['timelist']);
        // nextAvailableDates =
        //     List<String>.from(jsonResponse['nextAvilableDateList']);
      });
    }
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

        // Use the 'availableDates' list as needed

        daysAndDates = availableDates;

        pref.setString("dateOnly", datesOnly.toString());
        pref.getString("dateOnly");
        // ==============================================================================
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

  String calendarPickedDate = '';
  DateTime? pickedDateParsed;

  Future<DateTime?> pickedDate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    calendarPickedDate = pref.getString("selecetedDateFromCalendar").toString();

    try {
      pickedDateParsed = calendarPickedDate != null
          ? DateTime.parse(calendarPickedDate)
          : null;
    } catch (e) {
      pickedDateParsed =
          null; // Handle the error by setting pickedDateParsed to null or provide a default value
    }

    return pickedDateParsed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'timeSlot'.tr,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                timeList.first,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16.0),
          // pickedDate().toString() == "null"
          //     ?
          Expanded(
            child: PageView.builder(
              itemCount: datesOnly.length,
              itemBuilder: (context, pageIndex) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayNames[pageIndex],
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      datesOnly[pageIndex],
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // Text(
                    //   'Available',
                    //   style: TextStyle(
                    //     fontSize: 14.0,
                    //     color: availabilityStatus[pageIndex] == 'Available'
                    //         ? Colors.green
                    //         : Colors.red,
                    //   ),
                    // ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: primaryColor),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        if (selectedDates.length == 1) {
                          selectedDates[0] = datesOnly[pageIndex];
                        } else {
                          selectedDates.add(datesOnly[pageIndex]);
                        }

                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setString(
                            "selectedData", selectedDates.toString());
                        String prefval =
                            pref.getString("selectedDate").toString();
                      },
                      child: Text(
                        'available'.tr,
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
          // : Expanded(
          //     child: PageView.builder(
          //       itemCount: 5,
          //       itemBuilder: (context, pageIndex) {
          //         return FutureBuilder<DateTime?>(
          //           future: pickedDate(),
          //           builder: (context, snapshot) {
          //             DateTime? currentDate = pickedDateParsed != null
          //                 ? pickedDateParsed
          //                 : null;
          //             DateTime? pickedDate = snapshot.data;

          //             if (pickedDate != null &&
          //                 currentDate!
          //                     .isAfter(pickedDate.add(Duration(days: 5)))) {
          //               // Skip dates that are more than 5 days ahead of the picked date
          //               return SizedBox
          //                   .shrink(); // Returns an empty SizedBox for dates beyond the limit
          //             }

          //             return Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   dayNames[pageIndex],
          //                   style: const TextStyle(
          //                     fontSize: 14.0,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 Text(
          //                   datesOnly[pageIndex],
          //                   style: const TextStyle(
          //                     fontSize: 14.0,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 const SizedBox(height: 8.0),
          //                 ElevatedButton(
          //                   style: ElevatedButton.styleFrom(
          //                     shape: const RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.only(
          //                         bottomLeft: Radius.circular(0.0),
          //                       ),
          //                     ),
          //                     backgroundColor: Colors.white,
          //                     side: const BorderSide(color: primaryColor),
          //                     elevation: 0,
          //                   ),
          //                   onPressed: () async {
          //                     if (selectedDates.length == 1) {
          //                       selectedDates[0] = datesOnly[pageIndex];
          //                     } else {
          //                       selectedDates.add(datesOnly[pageIndex]);
          //                     }
          //                     print("New selected Date");
          //                     print(selectedDates);
          //                     SharedPreferences pref =
          //                         await SharedPreferences.getInstance();
          //                     pref.setString(
          //                         "selectedData", selectedDates.toString());
          //                     pref.getString("selectedDate");
          //                     print("sleced date" +
          //                         pref
          //                             .getString("selectedDate")
          //                             .toString());
          //                   },
          //                   child: Text(
          //                     'available'.tr,
          //                     style: TextStyle(color: primaryColor),
          //                   ),
          //                 ),
          //               ],
          //             );
          //           },
          //         );
          //       },
          //     ),
          //   )
        ],
      ),
    );
  }
}
