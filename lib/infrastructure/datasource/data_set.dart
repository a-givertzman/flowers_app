import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/infrastructure/api/api_handle_error.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/api/json_to.dart';
import 'package:flowers_app/infrastructure/api/response.dart';

class DataSet<T> {
  static const _debug = false;
  final ApiRequest _apiRequest;
  final ApiParams _params;
  late bool empty;
  DataSet({
    required ApiRequest apiRequest,
    required ApiParams params,
  }):
    _apiRequest = apiRequest,
    _params = params,
    empty = false;
  DataSet.empty():
    _apiRequest = const ApiRequest(url: ''),
    _params = const ApiParams.empty(),
    empty = true;
  /// Возвращает новый DataSet с прежним запросом ApiRequest и обновленными params
  /// Прежние параметры остануться и дополняться новыми 
  DataSet<T> withParams({required Map<String, dynamic> params}) {
    final uParams = _params.updateWith(params);
    return DataSet<T>(
      apiRequest: _apiRequest, 
      params: uParams,
    );
  }
  Future<Response<Map<String, dynamic>>> fetch() {
    log(_debug, '[${DataSet<T>}.fetch]');
    return _fetch(_apiRequest, _params);
  }
  Future<Response<Map<String, dynamic>>> fetchWith({required Map<String, dynamic> params}) {
    log(_debug, '[${DataSet<T>}.fetchWith]');
    final uParams = _params.updateWith(params);
    return _fetch(_apiRequest, uParams);
  }
  Future<Response<Map<String, dynamic>>> _fetch(ApiRequest apiRequest, ApiParams params) {
    log(_debug, '[${DataSet<T>}._fetch]');
    return ApiHandleError<Map<String, dynamic>>(
      json: JsonTo<Map<String, dynamic>>(
        request: apiRequest,
      ),
    ).fetch(params: params);
  }
}
