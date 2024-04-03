import 'package:QBB/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorPopup extends StatelessWidget {
  final String errorMessage;

  const ErrorPopup({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.0), // Adjust the radius as needed
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Text(
          errorMessage,
          style: const TextStyle(color: Color.fromARGB(255, 74, 74, 74)),
        ),
      ),
      actions: <Widget>[
        Divider(),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            'ok'.tr,
            style: TextStyle(color: secondaryColor),
          ),
        ),
      ],
    );
  }
}
