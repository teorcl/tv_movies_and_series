import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
}
