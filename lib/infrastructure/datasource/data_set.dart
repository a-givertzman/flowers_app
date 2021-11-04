import 'package:flowers_app/infrastructure/api/api_request.dart';

class DataSet {
  final String name;
  final ApiRequest apiRequest;
  const DataSet({
    required this.name,
    required this.apiRequest,
  });
  Future<List> getData() {
    print('[DataSet.getData]');
    //TODO DataSet error handling to be implemented
    return apiRequest.fetch();
  }
}