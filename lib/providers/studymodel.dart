import 'package:flutter/material.dart';

class Study {
  final int Id;
  final String studyCode;
  final String studyName;
  final String studyDescription;

  Study({
    required this.Id,
    required this.studyCode,
    required this.studyName,
    required this.studyDescription,
  });
}

class StudyProvider extends ChangeNotifier {
  List<Study> _studies = [];

  List<Study> get studies => _studies;

  void setStudies(List<Study> studies) {
    _studies = studies;
    notifyListeners();

    // Debug statements to check the values
    for (var study in _studies) {}
  }
}
