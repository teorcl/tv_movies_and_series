import 'package:flutter/foundation.dart';

import 'sign_in_state.dart';

/// Esta clase representa a lo que yo suelo llamar el provider (gestoinador de estado)

class SignInController extends ChangeNotifier {
  SignInState _state = SignInState();

  bool _mounted = true;

  SignInState get state => _state;
  bool get mounted => _mounted;

  void onUserNameChanged(String text) {
    _state = _state.copyWith(userName: text.trim().toLowerCase());
  }

  void onPasswordChanged(String text) {
    _state = _state.copyWith(
      password: text.replaceAll(' ', ''),
    );
  }

  void onFetchingChanged(bool value) {
    _state = _state.copyWith(fetching: value);
    notifyListeners();
  }

  @override
  void dispose() {
    print('Dispose SignInController');
    _mounted = false;
    super.dispose();
  }
}
