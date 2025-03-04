import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'app/data/http/http.dart';
import 'app/data/repositories_implementation/authentication_repository_impl.dart';
import 'app/data/repositories_implementation/connectivity_repository_impl.dart';
import 'app/data/services/remote/authentication_api.dart';
import 'app/data/services/remote/internet_checker.dart';
import 'app/domain/repositories/authentication_repository.dart';
import 'app/domain/repositories/connectivity_repository.dart';
import 'app/my_app.dart';

void main() {
  runApp(
    Provider<ConnectivityRepository>(
      create: (context) => ConnectivityRepositoryImpl(
        Connectivity(),
        InternetChecker(),
      ),
      child: Provider<AuthenticationRepository>(
        create: (context) => AuthenticationRepositoryImpl(
          const FlutterSecureStorage(),
          AuthenticationApi(
            Http(
              client: http.Client(),
              baseUrl: 'https://api.themoviedb.org/3',
              apikey: '9bbf7db647d6cd1cd3ab5cc8ec23c9c1',
            ),
          ),
        ),
        child: const MyApp(),
      ),
    ),
  );
}
