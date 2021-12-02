import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/json.dart';
import 'package:flowers_app/infrastructure/api/response.dart';

class ApiHandleError<T> {
  final JsonTo _json;
  ApiHandleError({
    required JsonTo json,
  }):
    _json = json;
  Future<Response<T>> fetch({required ApiParams params}) {
    print('[ApiHandleError.fetch]');
    return _json
      .parse(params: params)
      .then((_parsed) {
        final int errCount = int.parse('${_parsed['errCount']}');
        final String errDump = _parsed['errDump'];
        final T data = (_parsed['data'] is List)
          ? (_parsed['data'] as List)
            .asMap()
            .map((key, value) => MapEntry('$key', value)) as T
          : _parsed['data'];
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
        print('[$classInst.fetch] _data.type: ${_data.runtimeType}');
        if (_data.runtimeType.toString().startsWith('object')) {
          _data = {};
        } else if (_data.runtimeType.toString().startsWith('List')) {
          _data = [];
        } else if (_data.runtimeType.toString().startsWith('Map')) {
          _data = {};
        } else {
          _data = {};
        }
        return Response<T>(
          errCount: 1, 
          errDump: message, 
          data: _data,
        );
      });
  }
}
