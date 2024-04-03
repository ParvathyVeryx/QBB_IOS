import 'package:flutter/material.dart';

// class TokenProvider extends ChangeNotifier {
//   String? _token;

//   String? get token => _token;

//   void setToken(String? token) {
//     _token = token;
//     notifyListeners();
//   }
// }
//

class TokenProvider extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  // Modify setToken to return the token
  String? setToken(String? token) {
    _token = token;
    notifyListeners();
    return _token;
  }
}
