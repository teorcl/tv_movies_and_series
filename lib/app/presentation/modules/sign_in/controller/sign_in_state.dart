class SignInState {
  final String userName;
  final String password;
  final bool fetching;

  SignInState({
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
}
