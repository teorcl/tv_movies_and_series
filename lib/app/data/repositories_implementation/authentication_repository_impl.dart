import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/either.dart';
import '../../domain/enums.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/authentication_repository.dart';

const _key = 'sessionId';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final FlutterSecureStorage _secureStorage;

  AuthenticationRepositoryImpl(
    this._secureStorage,
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
    await Future.delayed(const Duration(seconds: 2));
    if (username != 'test') {
      return Either.left(SignInFailure.notFound);
    }
    if (password != '123456') {
      return Either.left(SignInFailure.unauthorized);
    }

    //Aqui se guarda la sesión del usuario en el dispositivo
    await _secureStorage.write(key: _key, value: 'sessionId');

    return Either.right(User());
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
