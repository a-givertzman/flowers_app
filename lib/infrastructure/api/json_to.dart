import 'dart:convert';

import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';

class JsonTo<T> {
  static const _debug = false;
  final ApiRequest _request;
  const JsonTo({
    required ApiRequest request,
  }) :
    _request = request;
  Future<T> parse({required ApiParams params}) {
    // log(_debug, '[Json.parse] params: ', params);
    return _request
      .fetch(params: params)
      .then((_json) {
        log(_debug, '[Json.parse] _json: ', _json);
        try {
          final T parsed = const JsonCodec().decode(_json) as T;
          return parsed;
        } catch (error) {
          throw Failure.convertion(
            message: 'Ошибка в методе $runtimeType.parse() $error',
            stackTrace: StackTrace.current,
          );
        }
      });
  }
}
