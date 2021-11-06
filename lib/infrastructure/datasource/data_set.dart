import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';

class DataSet {
  final String name;
  final ApiRequest apiRequest;
  final ApiParams params;
  DataSet({
    required this.name,
    required this.apiRequest,
    required this.params,
  });
  DataSet withParams(ApiParams params) {
    this.params.update(params);
    return this;
  }
  Future<List> fetch({ApiParams? params}) {
    print('[DataSet.fetch]');
    //TODO DataSet error handling to be implemented
    if (params != null) {
      return apiRequest.fetch(params: params);
    }
    return apiRequest.fetch(params: this.params);
  }
}