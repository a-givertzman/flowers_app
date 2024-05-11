import 'dart:io';

import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// Класс реализует http запрос на url
/// с параметрами params
/// Возвращает строку json
class ApiRequest {
  static const _debug = false;
  final String url;
  const ApiRequest({
    required this.url,
  });
  Future<String> fetch({required ApiParams params}) {
    log(_debug, '[ApiRequest.fetch]');
    return _fetchJsonFromUrl(url, params);
  }

  Future<String> _fetchJsonFromUrl(String url, ApiParams params) {
    log(_debug, '[ApiRequest._fetchJsonFromUrl]');
    final uri = Uri.parse(url);
    log(_debug, '[ApiRequest._fetchJsonFromUrl] uri: $uri');
    final sendData = params.toMap();
    log(_debug, '[ApiRequest._fetchJsonFromUrl] sendData: ', sendData);
    final multyPart = http.MultipartRequest(
      'POST', // *GET, POST, PUT, DELETE, etc.
      uri,
    )
      ..fields.addAll(sendData);
    final HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert,String host,int port) {
      log(_debug, '[ApiRequest._fetchJsonFromUrl] CERTIFICATE_VERIFY_FAILED');
      return _getBaseUrl(url) == host;
    };
    return IOClient(httpClient)
      .send(multyPart)
      .then(
        (response) {
          // log(_debug, '[ApiRequest._fetchJsonFromUrl] response: ', response);
          return response.stream.bytesToString().then((jsonsSnapshot) {
            // log(_debug, '[ApiRequest._fetchJsonFromUrl] snapshot: ', snapshot);
            return jsonsSnapshot;
          });
        }
      )
      .onError((error, stackTrace) { 
        throw Failure.connection(
          message: 'Ошибка в методе $runtimeType._fetchFromUrl: $error',
          stackTrace: stackTrace,
        );
      });
  }
  String _getBaseUrl(String url){
    var resUrl = url.substring(url.indexOf('://')+3);
    resUrl = resUrl.substring(0,resUrl.indexOf('/'));
    log(_debug, '[ApiRequest._getBaseUrl] url: $resUrl');
    return resUrl;
  }
}
