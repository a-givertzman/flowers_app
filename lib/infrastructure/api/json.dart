import 'dart:convert';

import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';

class Json {
  final ApiRequest _request;
  const Json({
    required ApiRequest request,
  }) :
    _request = request;
  Future<Map> parse({required ApiParams params}) {
    // print('[Json.parse] params');
    // print(params);
    return _request
      .fetch(params: params)
      .then((_json) {
        print('[Json.parse] _json');
        print(_json);
        try {
          final parsed = const JsonCodec().decode(_json);
          return parsed;
        } catch (e) {
          final message = 'Ошибка в методе Json.parse() ${e.toString()}';
          throw Failure.connection(message: message);
        }
      });
  }
}