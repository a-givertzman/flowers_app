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
    // print('[Json._fetch] params');
    // print(params);
    return _request
      .fetch(params: params)
      .then((_json) {
        try {
          final parsed = const JsonCodec().decode(_json);
          return parsed;
        } catch (e) {
          throw Failure.connection(message: e.toString());
        }
      });
  }
}