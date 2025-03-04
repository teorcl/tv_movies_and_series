import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/user.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../../../../domain/repositories/connectivity_repository.dart';
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
    final authenticationRepository =
        Provider.of<AuthenticationRepository>(context, listen: false);
    final hasInternetConnection =
        await connectivityRepository.hasInternetConnection;

    if (hasInternetConnection) {
      // Comprobamos si existe una sesión activa
      debugPrint('✅✅✅✅✅ Tiene conexión a internet? $hasInternetConnection');
      final isSignedIn = await authenticationRepository.isSignedIn;
      if (isSignedIn) {
        final userData = await authenticationRepository.getUserData();
        if (mounted) {
          _redirectUser(userData);
        }
      } else if (mounted) {
        _goTo(routeName: Routes.signIn);
      }
    } else {
      // Mostrar la vista de offline
      debugPrint('❌❌❌❌❌ No tiene conexión a internet? $hasInternetConnection');
      _goTo(routeName: Routes.offline);
    }
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
