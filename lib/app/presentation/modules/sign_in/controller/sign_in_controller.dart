import 'package:flutter/foundation.dart';

/// Esta clase representa a lo que yo suelo llamar el provider (gestoinador de estado)

class SignInController extends ChangeNotifier {
  String _userName = '';
  String _password = '';
  bool _fecthing = false;

  String get username => _userName;
  String get password => _password;
  bool get fetching => _fecthing;

  void onUserNameChanged(String text) {
    _userName = text.trim().toLowerCase();
  }

  void onPasswordChanged(String text) {
    _password = text.replaceAll(' ', '');
  }

  void onFetchingChanged(bool value) {
    _fecthing = value;
    notifyListeners();
  }
}
