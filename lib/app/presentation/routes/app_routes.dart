import 'package:flutter/material.dart';

import '../modules/splash/views/splash_view.dart';
import 'routes.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.splash: (_) => const SplashView(),
  };
}
