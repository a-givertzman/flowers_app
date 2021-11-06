import 'dart:convert';

import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:http/http.dart' as http;


class ApiRequest {
  final String url;
  const ApiRequest({
    required this.url,
  });
  Future<List> fetch({required ApiParams params}) {
    print('[ApiRequest.fetch]');
    return _fetchJsonFromUrl(url, params);
  }

  Future<List> _fetchJsonFromUrl(String url, ApiParams params) {
    print('[ApiRequest._fetchJsonFromUrl]');
    final uri = Uri.parse(url);
    // print('[ApiRequest._fetchJsonFromUrl] uri');
    print(uri);
    final sendData = params.getMap();
    // print('[ApiRequest._fetchJsonFromUrl] sendData');
    // print(sendData);
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
          return response.stream.bytesToString().then((snapshot) {
            // print('[ApiRequest._fetchJsonFromUrl] snapshot');
            // print(snapshot);
          // if (snapshot.statusCode >= 200 && response.statusCode < 400) {
            final dataObj = json.decode(snapshot);
            // print('[ApiRequest._fetchJsonFromUrl] dataObj');
            // print(dataObj);
            final errCount = dataObj['errCount'];
            final errDump = dataObj['errDump'];
            final Map data = dataObj['data'];
            // print('[ApiRequest._fetchJsonFromUrl] data:');
            // print(data);
            final List dataList = [];
            for (var key in data.keys) {
              dataList.add(data[key]);
            }
            // print('[ApiRequest._fetchJsonFromUrl] dataList:');
            // print(dataList);
            //TODO ApiRequest error handling to be implemented
            return dataList;
          // } else {
          //   throw Exception(
          //     '[ApiRequest._fetchJsonFromUrl] error\n${response.body}'
          //   );
          // }
          });
        }
      ).catchError((error) => 
        throw Failure.connection(message: error.toString())
      );
      // .catchError((e) {
      //   print('[ApiRequest._fetchJsonFromUrl] error');
      //   print(e);
      //   //TODO ApiRequest Error handling to be implemented
      //   throw ValueFailure(message: e.toString());
      // });
  }
}




