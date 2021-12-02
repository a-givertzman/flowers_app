import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/json.dart';
import 'package:flowers_app/infrastructure/api/responce.dart';

class ApiHandleError<T> {
  final JsonTo _json;
  ApiHandleError({
    required JsonTo json,
  }):
    _json = json;
  Future<Response<T>> fetch({required ApiParams params}) {
    print('[ApiRequest.fetch]');
    return _json
      .parse(params: params)
      .then((_parsed) {
        final int errCount = int.parse('${_parsed['errCount']}');
        final String errDump = _parsed['errDump'];
        final T data = _parsed['data'];
        return Response<T>(
          errCount: errCount, 
          errDump: errDump, 
          data: data
        );
      })
      .onError((e, stackTrace) {
        final classInst = runtimeType.toString();
        final message = 'Ошибка в методе $classInst.fetch() ${e.toString()}';
        dynamic _data;
        if (T.runtimeType == 'object') {
          _data = {};
        } else if (T.runtimeType == 'List') {
          _data = [];
        }
        return Response<T>(
          errCount: 1, 
          errDump: message, 
          data: _data,
        );
      });
  }
}
