import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // Adjust width as needed
      height: 80,
      color:
          Colors.grey.withOpacity(0), // Set a transparent white background

      child: Center(
        child: Image.asset(
          'assets/images/loader.gif', // Replace with the actual path to your GIF asset
          width: 80, // Adjust width as needed
          height: 80, // Adjust height as needed
        ),
      ),
    );
  }
}
