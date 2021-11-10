import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/json.dart';
import 'package:flowers_app/infrastructure/api/responce.dart';

class ApiHandleError {
  final Json _json;
  ApiHandleError({
    required Json json,
  }):
    _json = json;
  Future<Response> fetch({required ApiParams params}) {
    print('[ApiRequest.fetch]');
    return _json
      .parse(params: params)
      .then((_parsed) {
        final int errCount = int.parse('${_parsed['errCount']}');
        final String errDump = _parsed['errDump'];
        final Map data = _parsed['data'];
        return Response(
          errCount: errCount, 
          errDamp: errDump, 
          data: data
        );
      });
  }
}