import 'dart:convert';

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
        return const JsonCodec().decode(_json);
      });
  }
}