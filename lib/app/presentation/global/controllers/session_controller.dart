import '../../../domain/models/user.dart';
import '../../../domain/repositories/authentication_repository.dart';
import '../state_notifier.dart';

class SessionController extends StateNotifier<User?> {
  final AuthenticationRepository authenticationRepository;
  SessionController({
    required this.authenticationRepository,
  }) : super(null);

  // *? Aqui necesaitamos una funcion publica que nos permita guardar los datos del usuario en el estado
  void setUser(User user) {
    state = user; // Este state es el setter de la clase StateNotifier
  }

  // *? Cuando se llame al metodo anterior, se incocara el notifyListeners(), porque el estado inicial era null

  // *? Al cerrar sesion, simplemente ponemos el estado en null
  Future<void> signOut() async {
    await authenticationRepository.signOut();
    onlyUpdate(null);
    //state = null; // Este state es el setter de la clase StateNotifier
  }
}
