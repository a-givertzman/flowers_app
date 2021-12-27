import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/infrastructure/api/api_handle_error.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/api/json_to.dart';
import 'package:flowers_app/infrastructure/api/response.dart';

class DataSet<T> {
  final ApiRequest _apiRequest;
  final ApiParams _params;
  const DataSet({
    required ApiRequest apiRequest,
    required ApiParams params,
  }):
    _apiRequest = apiRequest,
    _params = params;
  Future<Response<Map<String, dynamic>>> fetch() {
    log('[${DataSet<T>}.fetch]');
    return _fetch(_apiRequest, _params);
  }
  Future<Response<Map<String, dynamic>>> fetchWith({required Map params}) {
    log('[${DataSet<T>}.fetchWith]');
    final uParams = _params.updateWith(params);
    return _fetch(_apiRequest, uParams);
  }
  Future<Response<Map<String, dynamic>>> _fetch(ApiRequest apiRequest, ApiParams params) {
    log('[${DataSet<T>}._fetch]');
    return ApiHandleError<Map<String, dynamic>>(
      json: JsonTo<Map<String, dynamic>>(
        request: apiRequest,
      ),
    ).fetch(params: params);
  }
}
