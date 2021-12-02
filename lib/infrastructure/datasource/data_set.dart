import 'package:flowers_app/infrastructure/api/api_handle_error.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/api/json.dart';
import 'package:flowers_app/infrastructure/api/responce.dart';

class DataSet<T> {
  final ApiRequest _apiRequest;
  final ApiParams _params;
  const DataSet({
    required apiRequest,
    required ApiParams params,
  }):
    _apiRequest = apiRequest,
    _params = params;
  Future<Response<T>> fetch() {
    print('[DataSet.fetch]');
    return _fetch(_apiRequest, _params);
  }
  Future<Response<T>> fetchWith({required Map params}) {
    print('[DataSet.fetchWith]');
    final uParams = _params.updateWith(params);
    return _fetch(_apiRequest, uParams);
  }
  Future<Response<T>> _fetch(ApiRequest apiRequest, ApiParams params) {
    print('[DataSet._fetch]');
    return ApiHandleError<T>(
      json: JsonTo<T>(
        request: apiRequest
      )
    ).fetch(params: params);
  }
}