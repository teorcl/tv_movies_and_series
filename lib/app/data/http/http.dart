import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../domain/either.dart';

class Http {
  final Client _client;
  final String _baseUrl;
  final String _apikey;

  Http({
    // Recibo valores diferentes pero obligatorios que se asignan a las variables privadas
    required Client client,
    required String baseUrl,
    required String apikey,
  })  : _client = client,
        _baseUrl = baseUrl,
        _apikey = apikey;

  Future<Either<HttpFailure, String>> request(
    String path, {
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const {},
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> body = const {},
    bool useApiKey = true,
  }) async {
    try {
      if (useApiKey) {
        queryParameters = {
          ...queryParameters,
          'api_key': _apikey,
        };
      }
      Uri url = Uri.parse(
        path.startsWith('http') ? path : '$_baseUrl$path',
      );
      if (queryParameters.isNotEmpty) {
        url = url.replace(queryParameters: queryParameters);
      }
      headers = {
        ...headers,
        'Content-Type': 'application/json',
      };
      late final Response response;
      final bodyString = jsonEncode(body);
      switch (method) {
        case HttpMethod.get:
          response = await _client.get(
            url,
          );
        case HttpMethod.post:
          response = await _client.post(
            url,
            headers: headers,
            body: bodyString,
          );
        case HttpMethod.put:
          response = await _client.put(
            url,
            headers: headers,
            body: bodyString,
          );
        case HttpMethod.delete:
          response = await _client.delete(
            url,
            headers: headers,
            body: bodyString,
          );
        case HttpMethod.patch:
          response = await _client.patch(
            url,
            headers: headers,
            body: bodyString,
          );
      }
      final statusCode = response.statusCode;
      if (statusCode >= 200 && statusCode < 300) {
        return Either.right(response.body);
      }
      return Either.left(
        HttpFailure(
          statusCode: statusCode,
        ),
      );
    } catch (e) {
      if (e is SocketException || e is ClientException) {
        return Either.left(
          HttpFailure(
            exception: NetworkException(),
          ),
        );
      }
      return Either.left(
        HttpFailure(
          exception: e,
        ),
      );
    }
  }
}

class HttpFailure {
  final int? statusCode;
  final Object? exception;

  HttpFailure({
    this.statusCode,
    this.exception,
  });
}

class NetworkException {}

enum HttpMethod {
  get,
  post,
  put,
  delete,
  patch,
}
