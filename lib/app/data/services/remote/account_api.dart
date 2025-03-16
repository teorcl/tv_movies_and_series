import '../../../domain/models/user.dart';
import '../../http/http.dart';

class AccountApi {
  final Http _http;

  AccountApi(this._http);

  //** Funcion que realiza la llamada a la api de THEMDV
  //*? Para obtener los datos del usuario necesitamos el session_id
  Future<User?> getAccount(String sessionId) async {
    final result = await _http.request<User>(
      '/account',
      queryParameters: {
        'session_id': sessionId,
      },
      onSuccess: (json) {
        //return User.fromJson(json); // Esto si fromJson es un factory de User
        return User(
          id: json['id'],
          username: json['username'],
        );
      },
    );

    return result.when(
      (_) => null,
      (user) => user,
    );
  }
}
