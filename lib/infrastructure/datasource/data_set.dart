import 'package:flowers_app/infrastructure/api/api_handle_error.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/api/json.dart';
import 'package:flowers_app/infrastructure/api/responce.dart';

class DataSet {
  final ApiRequest _apiRequest;
  final ApiParams _params;
  const DataSet({
    required apiRequest,
    required ApiParams params,
  }):
    _apiRequest = apiRequest,
    _params = params;
  Future<Response> fetch() {
    print('[DataSet.fetch]');
    return _fetch(_apiRequest, _params);
  }
  Future<Response> fetchWith({required Map params}) {
    print('[DataSet.fetch]');
    final uParams = _params.updateWith(params);
    return _fetch(_apiRequest, uParams);
  }
  Future<Response> _fetch(ApiRequest apiRequest, ApiParams params) {
    return ApiHandleError(
      json: Json(
        request: apiRequest
      )
    ).fetch(params: params);
  }
}