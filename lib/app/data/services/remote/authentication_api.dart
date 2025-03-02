import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../domain/either.dart';
import '../../../domain/enums.dart';
import '../../http/http.dart';

class AuthenticationApi {
  final Http _http;

  AuthenticationApi(this._http);

  Either<SignInFailure, String> _handleFailure(HttpFailure failure) {
    debugPrint('❌❌❌ Error: $failure');

    if (failure.statusCode != null) {
      switch (failure.statusCode) {
        case 401:
          return Either.left(SignInFailure.unauthorized);
        case 404:
          return Either.left(SignInFailure.notFound);
        default:
          return Either.left(SignInFailure.unknown);
      }
    }

    if (failure.exception is NetworkException) {
      return Either.left(SignInFailure.network);
    }
    return Either.left(SignInFailure.unknown);
  }

  Future<Either<SignInFailure, String>> createRequestToken() async {
    final result = await _http.request(
      '/authentication/token/new',
      onSuccess: (responseBody) {
        final json = Map<String, dynamic>.from(
          jsonDecode(
            responseBody,
          ),
        );

        final requestToken = json['request_token'] as String;

        return requestToken;
      },
    );
    return result.when(
      _handleFailure,
      (requestToken) {
        return Either.right(requestToken);
      },
    );
  }

  Future<Either<SignInFailure, String>> createSessionWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final result = await _http.request(
      '/authentication/token/validate_with_login',
      onSuccess: (responseBody) {
        final json = Map<String, dynamic>.from(
          jsonDecode(
            responseBody,
          ),
        );

        final newRequestToken = json['request_token'] as String;

        return newRequestToken;
      },
      method: HttpMethod.post,
      body: {
        'username': username,
        'password': password,
        'request_token': requestToken,
      },
    );

    return result.when(
      _handleFailure,
      (requestToken) {
        return Either.right(requestToken);
      },
    );
  }

  Future<Either<SignInFailure, String>> createSession({
    required String requestToken,
  }) async {
    final result = await _http.request(
      '/authentication/session/new',
      method: HttpMethod.post,
      body: {
        'request_token': requestToken,
      },
      onSuccess: (responseBody) {
        final json = Map<String, dynamic>.from(
          jsonDecode(
            responseBody,
          ),
        );

        final sessionId = json['session_id'] as String;

        return sessionId;
      },
    );

    return result.when(
      _handleFailure,
      (sessionId) {
        return Either.right(sessionId);
      },
    );
  }
}
