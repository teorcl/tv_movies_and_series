import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../../../domain/either.dart';
import '../../../domain/enums.dart';

class AuthenticationApi {
  final Client _client;
  final _baseUrl = 'https://api.themoviedb.org/3';
  final _apikey = '9bbf7db647d6cd1cd3ab5cc8ec23c9c1';

  AuthenticationApi(this._client);

  Future<String?> createRequestToken() async {
    try {
      final response = await _client.get(
        Uri.parse(
          '$_baseUrl/authentication/token/new?api_key=$_apikey',
        ),
      );

      if (response.statusCode == 200) {
        final json = Map<String, dynamic>.from(
          jsonDecode(
            response.body,
          ),
        );

        return json['request_token'];
      }
      return null;
    } catch (e) {
      debugPrint('❌❌❌ Error: $e');
      return null;
    }
  }

  Future<Either<SignInFailure, String>> createSessionWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(
          '$_baseUrl/authentication/token/validate_with_login?api_key=$_apikey',
        ),
        body: jsonEncode(
          {
            'username': username,
            'password': password,
            'request_token': requestToken,
          },
        ),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      switch (response.statusCode) {
        case 200:
          final json = Map<String, dynamic>.from(
            jsonDecode(
              response.body,
            ),
          );

          return Either.right(json['request_token']);
        case 401:
          return Either.left(SignInFailure.unauthorized);
        case 404:
          return Either.left(SignInFailure.notFound);
        default:
          return Either.left(SignInFailure.unknown);
      }
    } catch (e) {
      debugPrint('❌❌❌ Error: $e');
      if (e is SocketException) {
        return Either.left(SignInFailure.network);
      }
      return Either.left(SignInFailure.unknown);
    }
  }

  Future<Either<SignInFailure, String>> createSession({
    required String requestToken,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(
          '$_baseUrl/authentication/session/new?api_key=$_apikey',
        ),
        body: jsonEncode(
          {
            'request_token': requestToken,
          },
        ),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = Map<String, dynamic>.from(
          jsonDecode(
            response.body,
          ),
        );

        final sessionId = json['session_id'] as String;
        return Either.right(sessionId);
      }
      return Either.left(SignInFailure.unknown);
    } catch (e) {
      debugPrint('❌❌❌ Error: $e');
      if (e is SocketException) {
        return Either.left(SignInFailure.network);
      }
      return Either.left(SignInFailure.unknown);
    }
  }
}
