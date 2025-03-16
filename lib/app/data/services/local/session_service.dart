import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _key = 'sessionId';

class SessionService {
  final FlutterSecureStorage _secureStorage;

  SessionService(this._secureStorage);

  Future<String?> get sessionId async {
    final sesseionId = await _secureStorage.read(key: _key);

    return sesseionId;
  }

  Future<void> saveSessionId(String sessionId) async {
    return _secureStorage.write(
      key: _key,
      value: sessionId,
    );
  }

  Future<void> deleteSessionId() async {
    return _secureStorage.delete(key: _key);
  }
}
