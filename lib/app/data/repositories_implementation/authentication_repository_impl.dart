import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/either.dart';
import '../../domain/enums.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../services/remote/authentication_api.dart';

const _key = 'sessionId';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final FlutterSecureStorage _secureStorage;
  final AuthenticationApi _authenticationApi;

  AuthenticationRepositoryImpl(
    this._secureStorage,
    this._authenticationApi,
  );

  @override
  Future<User?> getUserData() {
    return Future.value(User());
    //return Future.value(null);
  }

  //Con esto validamos si el usuario tiene una sesión activa en el dispositivo
  @override
  Future<bool> get isSignedIn async {
    final sesseionId = await _secureStorage.read(key: _key);
    return sesseionId != null;
  }

  @override
  Future<Either<SignInFailure, User>> signIn(
    String username,
    String password,
  ) async {
    final requestTokenResult = await _authenticationApi.createRequestToken();
    return requestTokenResult.when(
      (failure) => Either.left(failure),
      (requestToken) async {
        final loginResult = await _authenticationApi.createSessionWithLogin(
          username: username,
          password: password,
          requestToken: requestToken,
        );

        return loginResult.when(
          (failure) async {
            return Either.left(failure);
          },
          (newRequestToken) async {
            final sessionResult = await _authenticationApi.createSession(
              requestToken: newRequestToken,
            );
            return sessionResult.when(
              (failure) async {
                return Either.left(failure);
              },
              (sessionId) async {
                await _secureStorage.write(
                  key: _key,
                  value: sessionId,
                );
                return Either.right(User());
              },
            );
          },
        );
      },
    );
  }

  @override
  Future<void> signOut() {
    return _secureStorage.delete(key: _key);
  }

  /*
  @override
  Future<void> signOut() async{
    await _secureStorage.delete(key: _key);
  }
  */
}
