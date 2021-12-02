import 'dart:io';

import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

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
    print('[ApiRequest._fetchJsonFromUrl] uri: $uri');
    final sendData = params.toMap();
    print('[ApiRequest._fetchJsonFromUrl] sendData:');
    print(sendData);
    final multyPart = http.MultipartRequest(
      'POST', // *GET, POST, PUT, DELETE, etc.
      uri
    )
      ..fields.addAll(sendData);
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert,String host,int port) {
      print('[ApiRequest._fetchJsonFromUrl] CERTIFICATE_VERIFY_FAILED');
      return _getBaseUrl(url) == host;
    };
    return IOClient(httpClient)
      .send(multyPart)
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
      )
      .catchError((error) { 
        final classInst = runtimeType.toString();
        throw Failure.connection(
          message: 'Ошибка в методе $classInst._fetchFromUrl: ${error.toString()}'
        );
      });
  }
  String _getBaseUrl(String url){
    url = url.substring(url.indexOf('://')+3);
    url = url.substring(0,url.indexOf('/'));
    print('[ApiRequest._getBaseUrl] url: $url');
    return url;
  }
}




