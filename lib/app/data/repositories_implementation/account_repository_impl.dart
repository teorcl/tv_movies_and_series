import '../../domain/models/user/user.dart';
import '../../domain/repositories/account_repository.dart';
import '../services/local/session_service.dart';
import '../services/remote/account_api.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountApi _accountApi;
  final SessionService _sessionService;

  AccountRepositoryImpl(
    this._accountApi,
    this._sessionService,
  );
  @override
  Future<User?> getUserData() async {
    // *? En este caso necesitamos el session_id, pero recordemos que se guarda en el secureStorage
    final sessionId = await _sessionService.sessionId;
    return _accountApi.getAccount(sessionId ?? '');
  }
}
