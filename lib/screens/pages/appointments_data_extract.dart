import 'package:get/get.dart';
import 'package:intl/intl.dart';

String timeExtract(Map<String, dynamic> appointment) {
  // Extract start and end time
  DateTime startTime = DateTime.parse(appointment['StartDate']);
  DateTime endTime = DateTime.parse(appointment['EndDate']);

  // Format the time
  String formattedStartTime = DateFormat('hh:mm').format(startTime);
  String formattedStartTimeAMPM = DateFormat('a', 'langChange'.tr).format(startTime);
  String formattedEndTime = DateFormat('hh:mm').format(endTime);
  String formattedEndTimeAMPM = DateFormat('a', 'langChange'.tr).format(endTime);

  // Return the formatted time
  return '$formattedStartTime $formattedStartTimeAMPM - $formattedEndTime $formattedEndTimeAMPM';
}

DateTime dateExtract(Map<String, dynamic> appointment) {
  String appointmentDateString = appointment['AppoimentDate'];

  // Parse the string to a DateTime object
  DateTime appointmentDate = DateTime.parse(appointmentDateString);

  // Return the extracted DateTime
  return appointmentDate;
}
