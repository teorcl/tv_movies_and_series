import '../either.dart';
import '../enums.dart';
import '../models/user/user.dart';

abstract class AuthenticationRepository {
  Future<bool> get isSignedIn;
  Future<Either<SignInFailure, User>> signIn(String username, String password);
  Future<void> signOut();
}
