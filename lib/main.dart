import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'app/data/http/http.dart';
import 'app/data/repositories_implementation/account_repository_impl.dart';
import 'app/data/repositories_implementation/authentication_repository_impl.dart';
import 'app/data/repositories_implementation/connectivity_repository_impl.dart';
import 'app/data/services/remote/authentication_api.dart';
import 'app/data/services/remote/internet_checker.dart';
import 'app/domain/repositories/account_repository.dart';
import 'app/domain/repositories/authentication_repository.dart';
import 'app/domain/repositories/connectivity_repository.dart';
import 'app/my_app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ConnectivityRepository>(
          create: (_) => ConnectivityRepositoryImpl(
            Connectivity(),
            InternetChecker(),
          ),
        ),
        Provider<AuthenticationRepository>(
          create: (_) => AuthenticationRepositoryImpl(
            const FlutterSecureStorage(),
            AuthenticationApi(
              Http(
                client: http.Client(),
                baseUrl: 'https://api.themoviedb.org/3',
                apikey: '9bbf7db647d6cd1cd3ab5cc8ec23c9c1',
              ),
            ),
          ),
        ),
        Provider<AccountRepository>(
          create: (_) => AccountRepositoryImpl(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
