import 'dart:async';
import 'dart:convert';

import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:http/http.dart' as http;

class ApiStream {
  final String url;
  final ApiParams params;
  final _streamController = StreamController<List>.broadcast();
  ApiStream({
    required this.url,
    required this.params
  }){
    _streamController.onListen = _dispatch;
  }
  Stream<List> getStream() {
    // print('[ApiStream.getStream] url $url');
    // print('[ApiStream.getStream] params');
    // print(params);
    // final stream = _fetchJsonFromUrl(url, params);
    // final stream = _fetchJson(url, params);
    print('[ApiStream.getStream] stream');
    // print(stream);
    return _streamController.stream;
  }

  
  void _dispatch() {
    print('[ApiStream._dispatch]');
    _fetchJson(url, params);
  }
  void _fetchJson(String url, ApiParams params) {
    print('[ApiStream._fetchJsonFromUrl]');
    final uri = Uri.parse(url);
    print('[ApiStream._fetchJsonFromUrl] uri');
    print(uri);
    final sendData = params.toMap();
    print('[ApiStream._fetchJsonFromUrl] sendData');
    print(sendData);
    final request = http
      .MultipartRequest(
        'POST', // *GET, POST, PUT, DELETE, etc.
        uri
      )..fields.addAll(sendData);
    request.send()
      .then(
        (response) {
          print('[ApiStream._fetchJsonFromUrl] response');
          print(response);
          return response.stream.bytesToString().then((snapshot) { 
            final dataObj = json.decode(snapshot);
            print('[ApiStream._fetchJsonFromUrl] dataObj');
            print(dataObj);
            // final errCount = dataObj['errCount'];
            // final errDump = dataObj['errDump'];
            final Map data = dataObj['data'];
            print('[ApiStream._fetchJsonFromUrl] data:');
            print(data);
            final List dataList = [];
            for (var key in data.keys) {
              dataList.add(data[key]);
            }
            print('[ApiStream._fetchJsonFromUrl] dataList:');
            print(dataList);
            //TODO ApiStream error handling to be implemented
            _streamController.add(dataList);
          });
      })
      .catchError((e) {
        print('[ApiStream._fetchJsonFromUrl] error');
        print(e);
        //TODO ApiStream Error handling to be implemented
        throw Exception(e);
      });
  }
}

  Stream<List> _fetchJson(String url, ApiParams params) async* {
    print('[ApiStream._fetchJsonFromUrl]');
    final uri = Uri.parse(url);
    print('[ApiStream._fetchJsonFromUrl] uri');
    print(uri);
    final sendData = params.toMap();
    print('[ApiStream._fetchJsonFromUrl] sendData');
    print(sendData);
    final request = http
      .MultipartRequest(
        'POST', // *GET, POST, PUT, DELETE, etc.
        uri
      )..fields.addAll(sendData);
    final data = await request.send()
      .then(
        (response) {
          print('[ApiStream._fetchJsonFromUrl] response');
          print(response);
          return response.stream.bytesToString().then((snapshot) { 
            final dataObj = json.decode(snapshot);
            print('[ApiStream._fetchJsonFromUrl] dataObj');
            print(dataObj);
            // final errCount = dataObj['errCount'];
            // final errDump = dataObj['errDump'];
            final Map data = dataObj['data'];
            print('[ApiStream._fetchJsonFromUrl] data:');
            print(data);
            final List dataList = [];
            for (var key in data.keys) {
              dataList.add(data[key]);
            }
            print('[ApiStream._fetchJsonFromUrl] dataList:');
            print(dataList);
            //TODO ApiStream error handling to be implemented
            return dataList;
          });
      })
      .catchError((e) {
        print('[ApiStream._fetchJsonFromUrl] error');
        print(e);
        //TODO ApiStream Error handling to be implemented
        throw Exception(e);
      });
    yield data;
  }



