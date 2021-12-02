import 'dart:convert';

import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';

class JsonTo<T> {
  final ApiRequest _request;
  const JsonTo({
    required ApiRequest request,
  }) :
    _request = request;
  Future<T> parse({required ApiParams params}) {
    // print('[Json.parse] params');
    // print(params);
    return _request
      .fetch(params: params)
      .then((_json) {
        print('[Json.parse] _json');
        print(_json);
        try {
          final T parsed = const JsonCodec().decode(_json);
          return parsed;
        } catch (e) {
          final classInst = runtimeType.toString();
          throw Failure.convertion(message: 'Ошибка в методе $classInst.parse() ${e.toString()}');
        }
      });
  }
}