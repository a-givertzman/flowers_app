import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/json_to.dart';
import 'package:flowers_app/infrastructure/api/response.dart';

class ApiHandleError<T> {
  final JsonTo<Map<String, dynamic>> _json;
  ApiHandleError({
    required JsonTo<Map<String, dynamic>> json,
  }):
    _json = json;
  Future<Response<T>> fetch({required ApiParams params}) {
    log('[ApiHandleError.fetch]');
    return _json
      .parse(params: params)
      .then((_parsed) {
        final int errCount = int.parse('${_parsed['errCount']}');
        final String errDump = '${_parsed['errDump']}';
        final T data = _parsed['data'] as T;
        return Response<T>(
          errCount: errCount, 
          errDump: errDump, 
          data: data,
        );
      })
      .onError((error, stackTrace) {
        throw Failure.unexpected(
          message: 'Ошибка в методе $runtimeType.fetch() $error',
          stackTrace: stackTrace,
        );
      });
  }
}
