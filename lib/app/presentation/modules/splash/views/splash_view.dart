import 'package:flutter/material.dart';

import '../../../../../main.dart';

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
    final connectivityRepository = Injector.of(context).connectivityRepository;
    final hasInternetConnection =
        await connectivityRepository.hasInternetConnection;

    if (hasInternetConnection) {
      // Comprobamos si existe una sesión activa
      debugPrint('✅✅✅✅✅ Tiene conexión a internet? $hasInternetConnection');
    } else {
      // Mostrar la vista de offline
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
