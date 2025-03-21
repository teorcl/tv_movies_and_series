import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/user/user.dart';
import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../../../../domain/repositories/connectivity_repository.dart';
import '../../../global/controllers/session_controller.dart';
import '../../../routes/routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
        '💧💧💧💧💧💧💧💧 Ahora si se va a ejecutar el _init(), ya se ha pintado el widget SplashView',
      );
      _init();
    });
    debugPrint('Ya finalizo el initState 🔥🔥🔥🔥🔥🔥🔥🔥');
  }

  Future<void> _init() async {
    final connectivityRepository =
        Provider.of<ConnectivityRepository>(context, listen: false);
    // final authenticationRepository =
    //       Provider.of<AuthenticationRepository>(context, listen: false);
    final authenticationRepository = context.read<AuthenticationRepository>();
    final accountRepository = context.read<AccountRepository>();
    final hasInternetConnection =
        await connectivityRepository.hasInternetConnection;
    final SessionController sessionController = context.read();

    if (!hasInternetConnection) {
      // Mostrar la vista de offline
      debugPrint('❌❌❌❌❌ No tiene conexión a internet? $hasInternetConnection');
      return _goTo(routeName: Routes.offline);
    }

    final isSignedIn = await authenticationRepository.isSignedIn;
    if (!isSignedIn) return _goTo(routeName: Routes.signIn);

    final userData = await accountRepository.getUserData();

    if (userData != null) {
      sessionController.setUser(userData);
      return _goTo(routeName: Routes.home);
    }

    return _goTo(routeName: Routes.signIn);
  }

  void _goTo({
    required String routeName,
  }) {
    Navigator.pushReplacementNamed(
      context,
      routeName,
    );
  }

  void _redirectUser(User? userData) {
    //*? Esta condición se debe entender como si logramos obtener los datos del usuario
    if (userData != null) {
      _goTo(routeName: Routes.home);
    } else {
      _goTo(routeName: Routes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
