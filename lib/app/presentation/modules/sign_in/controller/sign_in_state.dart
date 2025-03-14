import 'package:equatable/equatable.dart';

class SignInState extends Equatable {
  final String userName;
  final String password;
  final bool fetching;

  const SignInState({
    this.userName = '',
    this.password = '',
    this.fetching = false,
  });

  SignInState copyWith({
    String? userName,
    String? password,
    bool? fetching,
  }) {
    return SignInState(
      userName: userName ?? this.userName,
      password: password ?? this.password,
      fetching: fetching ?? this.fetching,
    );
  }

  @override
  List<Object?> get props => [
        userName,
        password,
        fetching,
      ];
}
