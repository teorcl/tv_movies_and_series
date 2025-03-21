import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_state.freezed.dart';

@freezed
class SignInState with _$SignInState {
  const SignInState({
    required this.userName,
    required this.password,
    required this.fetching,
  });

  final String userName;
  final String password;
  final bool fetching;
}
