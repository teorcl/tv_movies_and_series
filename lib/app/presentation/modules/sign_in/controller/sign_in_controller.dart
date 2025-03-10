import 'package:flutter/foundation.dart';

/// Esta clase representa a lo que yo suelo llamar el provider (gestoinador de estado)

class SignInController extends ChangeNotifier {
  String _userName = '';
  String _password = '';
  bool _fecthing = false;
  bool _mounted = true;

  String get username => _userName;
  String get password => _password;
  bool get fetching => _fecthing;
  bool get mounted => _mounted;

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

  @override
  void dispose() {
    print('Dispose SignInController');
    _mounted = false;
    super.dispose();
  }
}
