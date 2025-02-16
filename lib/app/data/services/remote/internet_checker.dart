import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class InternetChecker {
  Future<bool> hasInternet() async {
    try {
      if (kIsWeb) {
        //LO QUE SEA QUE VAYA AQUI SOLO SE EJECUTARA SI LA APP ESTA CORRIENDO EN WEB
        final response = await get(Uri.parse('google.com'));
        return response.statusCode == 200;
      } else {
        final listInternetAddress = await InternetAddress.lookup('google.com');
        return listInternetAddress.isNotEmpty &&
            listInternetAddress.first.rawAddress.isNotEmpty;
      }
    } catch (e) {
      debugPrint('❌❌❌❌❌❌❌❌❌Error en la conexión a internet: $e');
      return false;
    }
  }
}
