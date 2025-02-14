import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/repositories/connectivity_repository.dart';

class ConnectivityRepositoryImpl implements ConnectivityRepository {
  final Connectivity _connectivity;

  ConnectivityRepositoryImpl(this._connectivity);

  @override
  Future<bool> get hasInternetConnection async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }

    return _hasInternet();
  }

  Future<bool> _hasInternet() async {
    try {
      final listInternetAddress = await InternetAddress.lookup('google.com');
      return listInternetAddress.isNotEmpty &&
          listInternetAddress.first.rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
