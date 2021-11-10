import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:http/http.dart' as http;

/// Класс реализует http запрос на url
/// с параметрами params
/// Возвращает строку json
class ApiRequest {
  final String url;
  const ApiRequest({
    required this.url,
  });
  Future<String> fetch({required ApiParams params}) {
    print('[ApiRequest.fetch]');
    return _fetchJsonFromUrl(url, params);
  }

  Future<String> _fetchJsonFromUrl(String url, ApiParams params) {
    print('[ApiRequest._fetchJsonFromUrl]');
    final uri = Uri.parse(url);
    // print('[ApiRequest._fetchJsonFromUrl] uri');
    print(uri);
    final sendData = params.toMap();
    print('[ApiRequest._fetchJsonFromUrl] sendData');
    print(sendData);
    final request = http.MultipartRequest(
      'POST', // *GET, POST, PUT, DELETE, etc.
      uri
    )
      ..fields.addAll(sendData);
    return request.send()
      .then(
        (response) {
          // print('[ApiRequest._fetchJsonFromUrl] response');
          // print(response);
          return response.stream.bytesToString().then((jsonsSnapshot) {
            // print('[ApiRequest._fetchJsonFromUrl] snapshot');
            // print(snapshot);
            return jsonsSnapshot;
          });
        }
      ).catchError((error) => 
        //TODO ApiRequest error handling to be implemented
        throw Failure.connection(message: error.toString())
      );
  }
}




