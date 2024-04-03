import 'dart:convert';
import 'dart:io';

import 'package:QBB/screens/api/userid.dart';
import 'package:QBB/screens/pages/book_appointment_date_slot.dart';
import 'package:QBB/screens/pages/erorr_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../nirmal_api.dart/profile_api.dart';
import '../pages/loader.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

Future<void> downloadNewTest(
  BuildContext context,
  String base64Data,
  String filename,
) async {
  try {
    List<int> bytes;
    base64Data =
        "data:application/pdf;base64,JVBERi0xLjcKCjQgMCBvYmoKPDwKL0JpdHNQZXJDb21wb25lbnQgOAovQ29sb3JTcGFjZSAvRGV2aWNlUkdCCi9GaWx0ZXIgL0RDVERlY29kZQovSGVpZ2h0IDExNwovTGVuZ3RoIDQxNTIKL1N1YnR5cGUgL0ltYWdlCi9UeXBlIC9YT2JqZWN0Ci9XaWR0aCAxOTgKPj4Kc3RyZWFtCv/Y/+AAEEpGSUYAAQEBAGAAYAAA/9sAQwANCQoLCggNCwsLDw4NEBQhFRQSEhQoHR4YITAqMjEvKi4tNDtLQDQ4RzktLkJZQkdOUFRVVDM/XWNcUmJLU1RR/9sAQwEODw8UERQnFRUnUTYuNlFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFR/8AAEQgAdQDGAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXNXXNX";
    String encodedData =
        base64Data.substring('data:application/pdf;base64,'.length);
    print(encodedData);
    print(encodedData.length);
    encodedData = encodedData.replaceAll(RegExp('[^A-Za-z0-9+/=]'), '');

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    String pathOld = (await getExternalStorageDirectory())!.path;
    String path = await "/storage/emulated/0/Download";
    // String path = (await getApplicationDocumentsDirectory()).path;
    bytes = base64.decode(encodedData);
    File file = File("$path/Results_27-02.pdf");

    await file.writeAsBytes(bytes);

    // Show success message
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(
          errorMessage: "FILE DOWNLOADED TO PATH: ${file.path}",
        );
      },
    );

    print('FILE DOWNLOADED TO PATH: ${file.path}');
  } catch (error) {
    print('PDF Download failed: $error');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(
          errorMessage: "Failed to Download: $error",
        );
      },
    );
  }
}

// Future<void> downloadNew(
//     BuildContext context, String base64Data, String filename) async {
//   try {
//     String base64DataHardcoded =
//         "data:application/pdf;base64,JVBERi0xLjcKCjQgMCBvYmoKPDwKL0JpdHNQZXJDb21wb25lbnQgOAovQ29sb3JTcGFjZSAvRGV2aWNlUkdCCi9GaWx0ZXIgL0RDVERlY29kZQovSGVpZ2h0IDExNwovTGVuZ3RoIDQxNTIKL1N1YnR5cGUgL0ltYWdlCi9UeXBlIC9YT2JqZWN0Ci9XaWR0aCAxOTgKPj4Kc3RyZWFtCv/Y/+AAEEpGSUYAAQEBAGAAYAAA/9sAQwANCQoLCggNCwsLDw4NEBQhFRQSEhQoHR4YITAqMjEvKi4tNDtLQDQ4RzktLkJZQkdOUFRVVDM/XWNcUmJLU1RR/9sAQwEODw8UERQnFRUnUTYuNlFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFR/8AAEQgAdQDGAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NX";
//     int commaIndex = base64Data.indexOf(',');

//     // Extract the base64-encoded data after the comma
//     String encodedData = base64Data.substring(commaIndex + 1);
//     List<int> bytes = base64.decode(encodedData);

//     // Check and request write permission
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }
//     String path = (await getExternalStorageDirectory())!.path;

//     File file = File("$path/$filename");
//     await file.writeAsBytes(bytes);
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return ErrorPopup(
//             errorMessage: "FILE DOWNLOADED TO PATH: ${file.path}");
//       },
//     );

//     print('FILE DOWNLOADED TO PATH: ${file.path}');
//   } catch (error) {
//     print('PDF Download failed: $error');
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return ErrorPopup(errorMessage: "Failed to Download $error");
//       },
//     );
//   }
// }

Future<void> downloadNew(
  BuildContext context,
  String base64Data,
  String filename,
) async {
  try {
    List<int> bytes;
    // base64Data =
    //     "data:application/pdf;base64,JVBERi0xLjcKCjQgMCBvYmoKPDwKL0JpdHNQZXJDb21wb25lbnQgOAovQ29sb3JTcGFjZSAvRGV2aWNlUkdCCi9GaWx0ZXIgL0RDVERlY29kZQovSGVpZ2h0IDExNwovTGVuZ3RoIDQxNTIKL1N1YnR5cGUgL0ltYWdlCi9UeXBlIC9YT2JqZWN0Ci9XaWR0aCAxOTgKPj4Kc3RyZWFtCv/Y/+AAEEpGSUYAAQEBAGAAYAAA/9sAQwANCQoLCggNCwsLDw4NEBQhFRQSEhQoHR4YITAqMjEvKi4tNDtLQDQ4RzktLkJZQkdOUFRVVDM/XWNcUmJLU1RR/9sAQwEODw8UERQnFRUnUTYuNlFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFR/8AAEQgAdQDGAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXNXXNX";
    String encodedData =
        base64Data.substring('data:application/pdf;base64,'.length);
    print(encodedData);
    print(encodedData.length);
    encodedData = encodedData.replaceAll(RegExp('[^A-Za-z0-9+/=]'), '');

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    String pathOld = (await getExternalStorageDirectory())!.path;
    String path = await "/storage/emulated/0/Download";
    bytes = base64.decode(encodedData);
    File file = File("$path/$filename");

    await file.writeAsBytes(bytes);

    // Show success message
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(
          errorMessage: "File Downloaded at ${file.path}",
        );
      },
    );
  } catch (error) {
    print('PDF Download failed: $error');
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(
          errorMessage: "Failed to Download: $error",
        );
      },
    );
  }
}

Future<void> getresults(
  BuildContext context,
  String qid,
  String appointmentId,
  String language,
) async {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  LoaderWidget _loader = LoaderWidget();
  String? qid = await getQIDFromSharedPreferences();
  final TextEditingController _textFieldController = TextEditingController();

  int? personGradeId = await getPersonGradeIdFromSharedPreferences();

  const String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetOTPForResultDataAPI';

  final Map<String, dynamic> queryParams = {
    'QID': qid,
    'AppointmentID': appointmentId,
    'language': 'langChange'.tr,
  };

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');

  final Uri uri = Uri.parse(
      '$apiUrl?QID=${queryParams['QID']}&AppointmentID=${queryParams['AppointmentID']}&language=${queryParams['language']}');
  // SharedPreferences pref = await SharedPreferences.getInstance();
  // String? token = pref.getString('token');
  try {
    Dialogs.showLoadingDialog(context, _keyLoader, _loader);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      // Successful API call

      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // Save the API response in shared preferences

      // const String apiUrl =
      //     'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetOTPForResultDataAPI';

      // Now, navigate to the AppointmentBookingPage
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const AppointmentBookingPage(),
      //   ),
      // );
      print(response.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'pleaseEnterOTPToDownloadTheResult'.tr,
                style: TextStyle(fontSize: 12),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(50.0), // Adjust the radius as needed
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(
                      // Add your style properties here
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.0,
                    ),
                    contentPadding:
                        const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    // hintText: 'pleaseEnterOtp'.tr,
                    enabledBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 173, 173, 173)),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                Divider(),
                TextButton(
                  onPressed: () async {
                    String otp = _textFieldController.text.toString();
                    await getOTPForDownload(context, appointmentId, otp);
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text(
                    'submit'.tr,
                    style: TextStyle(color: secondaryColor),
                  ),
                ),
              ],
            );
          });
    } else {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      // Handle errors
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(
              errorMessage: json.decode(response.body)["Message"]);
        },
      );
    }
  } catch (error) {
    Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    // Handle network errors
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: 'Network Error');
      },
    );
  }
}

Future<void> getOTPForDownload(
    BuildContext context, String appointmentId, String otp) async {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  LoaderWidget _loader = LoaderWidget();
  // String qid = '';
  String language = 'langChange'.tr;
  String? qid = await getQIDFromSharedPreferences();

  int? personGradeId = await getPersonGradeIdFromSharedPreferences();

  const String apiUrl =
      'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetResultDataAPI';

  final Map<String, dynamic> queryParams = {
    'QID': qid,
    'OTP': otp,
    'AppointmentID': appointmentId,
    'language': 'langChange'.tr,
  };

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString('token');

  final Uri uri = Uri.parse(
      '$apiUrl?QID=${queryParams['QID']}&AppointmentID=${queryParams['AppointmentID']}&OTP=${queryParams['OTP']}&language=${queryParams['language']}');
  // SharedPreferences pref = await SharedPreferences.getInstance();
  // String? token = pref.getString('token');
  try {
    Dialogs.showLoadingDialog(context, _keyLoader, _loader);
    print(uri);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${token?.replaceAll('"', '')}',
        'Content-Type': 'application/json',
      },
    );
    // const String apiUrl =
    //       'https://participantportal-test.qatarbiobank.org.qa/QbbAPIS/api/GetOTPForResultDataAPI';

    if (response.statusCode == 200) {
      // Successful API call
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      print("Download Results");
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(response.body.toString());
      // Save the API response in shared preferences
      String base64DataURL = jsonResponse['Base64DataURL'];
      String filename = jsonResponse['filename'];
      print(base64DataURL);
      print(filename);

      await downloadNew(context, base64DataURL, filename);

// Use pdfViewer as needed, such as navigating to a new screen

      // await showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return ErrorPopup(
      //         errorMessage: json.decode(response.body)["Message"]);
      //   },
      // );
    } else {
      // Handle errors
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      print("Download Results no otp");
      print(response.statusCode);
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorPopup(
              errorMessage: json.decode(response.body)["Message"]);
        },
      );
    }
  } catch (error) {
    Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    print("Download Results Error");
    // Handle network errors
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorPopup(errorMessage: 'Network Error');
      },
    );
  }
}

Future<void> downloadAndOpenPDF(String base64Data, String filename) async {
  try {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;

    List<int> bytes = base64.decode(base64Data);

    String filePath = '$path/$filename';

    await File(filePath).writeAsBytes(bytes);

    // Open the downloaded PDF file
    await OpenFile.open(filePath, type: 'application/pdf');
  } catch (error) {
    print('Download failed: $error');
  }
}

Future<void> download(String fileName, String base64Data) async {
  try {
    String path = (await getExternalStorageDirectory())!.path;

    // Decode the Base64 data
    List<int> bytes = base64.decode(base64Data);

    final file = File('$path/$fileName');

    await file.writeAsBytes(bytes);

    // Open the downloaded file
    await _openFile(file);
  } catch (error) {
    print('Download failed: $error');
  }
}

Future<void> _openFile(File file) async {
  try {
    await OpenFile.open(file.path);
  } catch (error) {
    print('Error opening file: $error');
  }
}

Future<String> savePdfToTempFile(List<int> pdfBytes) async {
  // Save the PDF to a temporary file
  String tempFileName = 'downloaded_pdf.pdf';

  Directory tempDir = await getTemporaryDirectory();
  String tempFilePath = '${tempDir.path}/$tempFileName';

  File tempFile = File(tempFilePath);
  await tempFile.writeAsBytes(pdfBytes);

  return tempFilePath;
}

class Downloader {
  Future<void> download(String fileName, String filePath) async {
    try {
      String path = '';

      if (Platform.isIOS) {
        path = (await getApplicationDocumentsDirectory()).path;
      } else {
        path = (await getExternalStorageDirectory())!.path;
      }

      String url = Uri.encodeFull(filePath);
      http.Response response = await http.get(Uri.parse(url));

      File file = File('$path/$fileName');
      await file.writeAsBytes(response.bodyBytes);

      print('Download completed: ${file.path}');

      // Open the downloaded file
      await OpenFile.open(file.path, type: 'application/pdf');
    } catch (error) {
      print('Download failed: $error');
    }
  }
}

class PdfViewer extends StatefulWidget {
  final String base64Data;
  final String filename;

  PdfViewer({required this.base64Data, required this.filename});

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late String _filePath;

  @override
  void initState() {
    super.initState();
    _downloadAndDisplayPdf();
  }

  Future<void> _downloadAndDisplayPdf() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String path = appDocDir.path;

      List<int> bytes = base64.decode(widget.base64Data);

      String filePath = '$path/${widget.filename}.pdf';

      await File(filePath).writeAsBytes(bytes);

      setState(() {
        _filePath = filePath;
      });
    } catch (error) {
      print('PDF Download failed: $error');
    }
  }

  //You can download a single file

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PDFView(
      filePath: _filePath,
      enableSwipe: true,
      swipeHorizontal: false,
    ));
  }
}
