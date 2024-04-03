import 'package:QBB/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsAndConditionsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0), // Adjust the radius as needed
        ),
      ),
      title: Text(
        'termsConditions'.tr,
        style: TextStyle(color: primaryColor),
      ),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: primaryColor,
            ), // Add a divider line
            SizedBox(height: 10), // Optional spacing
            Text(
              // Replace this with your actual terms and conditions content
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Pellentesque et sapien vel velit aliquam venenatis in ac massa. '
              'Curabitur euismod ultricies odio, eu ultrices justo vestibulum ut. '
              '...',
              style: TextStyle(fontSize: 12, color: primaryColor),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              style: ButtonStyle(
                side: MaterialStateProperty.resolveWith<BorderSide>(
                  (Set<MaterialState> states) {
                    return const BorderSide(
                      color: primaryColor, // Set the border color
                      width: 1.0, // Set the border width
                    );
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft:
                          Radius.circular(20.0), // Adjust the radius as needed
                    ),
                  ),
                ),
              ),
              child:  Text(
                'ok'.tr,
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
