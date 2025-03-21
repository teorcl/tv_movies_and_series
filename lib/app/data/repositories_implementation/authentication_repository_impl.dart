import '../../domain/either.dart';
import '../../domain/enums.dart';
import '../../domain/models/user/user.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../services/local/session_service.dart';
import '../services/remote/account_api.dart';
import '../services/remote/authentication_api.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationApi _authenticationApi;
  final SessionService _sessionService;
  final AccountApi _accountApi;

  AuthenticationRepositoryImpl(
    this._authenticationApi,
    this._sessionService,
    this._accountApi,
  );

  //Con esto validamos si el usuario tiene una sesión activa en el dispositivo
  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _sessionService.sessionId;

    return sessionId != null;
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
                await _sessionService.saveSessionId(sessionId);

                final user = await _accountApi.getAccount(sessionId);

                if (user == null) {
                  return Either.left(SignInFailure.unknown);
                }
                return Either.right(user);
              },
            );
          },
        );
      },
    );
  }

  @override
  Future<void> signOut() {
    return _sessionService.deleteSessionId();
  }

  /*
  @override
  Future<void> signOut() async{
    await _secureStorage.delete(key: _key);
  }
  */
}
