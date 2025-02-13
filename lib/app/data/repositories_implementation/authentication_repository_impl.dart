import '../../domain/models/user.dart';
import '../../domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  @override
  Future<User?> getUserData() {
    return Future.value(User());
    //return Future.value(null);
  }

  @override
  Future<bool> get isSignedIn {
    return Future.value(true);
    //return Future.value(false);
  }
}
