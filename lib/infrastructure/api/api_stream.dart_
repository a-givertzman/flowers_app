import 'dart:async';
import 'dart:convert';

import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:http/http.dart' as http;

class ApiStream {
  final String url;
  final ApiParams params;
  final _streamController = StreamController<List>.broadcast();
  ApiStream({
    required this.url,
    required this.params,
  }) {
    _streamController.onListen = _dispatch;
  }
  Stream<List> getStream() {
    // log('[ApiStream.getStream] url $url');
    // log('[ApiStream.getStream] params');
    // log(params);
    // final stream = _fetchJsonFromUrl(url, params);
    // final stream = _fetchJson(url, params);
    // log('[ApiStream.getStream] stream; ', stream);
    return _streamController.stream;
  }

  void _dispatch() {
    log('[ApiStream._dispatch]');
    _fetchJson(url, params);
  }
  void _fetchJson(String url, ApiParams params) {
    log('[ApiStream._fetchJsonFromUrl]');
    final uri = Uri.parse(url);
    log('[ApiStream._fetchJsonFromUrl] uri: ', uri);
    final sendData = params.toMap();
    log('[ApiStream._fetchJsonFromUrl] sendData: ', sendData);
    final request = http
      .MultipartRequest(
        'POST', // *GET, POST, PUT, DELETE, etc.
        uri,
      )..fields.addAll(sendData);
    request.send()
      .then(
        (response) {
          log('[ApiStream._fetchJsonFromUrl] response: ', response);
          return response.stream.bytesToString().then((snapshot) { 
            final dataObj = json.decode(snapshot);
            log('[ApiStream._fetchJsonFromUrl] dataObj: ', dataObj);
            final Map data = dataObj['data'] as Map;
            log('[ApiStream._fetchJsonFromUrl] data: ', data);
            final List dataList = [];
            for (final key in data.keys) {
              dataList.add(data[key]);
            }
            log('[ApiStream._fetchJsonFromUrl] dataList: ', dataList);
            //TODO ApiStream error handling to be implemented
            _streamController.add(dataList);
          });
      })
      .catchError((e) {
        log('[ApiStream._fetchJsonFromUrl] error: ', e);
        //TODO ApiStream Error handling to be implemented
        throw Exception(e);
      });
  }
}

  Stream<List> _fetchJson(String url, ApiParams params) async* {
    log('[ApiStream._fetchJsonFromUrl]');
    final uri = Uri.parse(url);
    log('[ApiStream._fetchJsonFromUrl] uri: ', uri);
    final sendData = params.toMap();
    log('[ApiStream._fetchJsonFromUrl] sendData: ', sendData);
    final request = http
      .MultipartRequest(
        'POST', // *GET, POST, PUT, DELETE, etc.
        uri,
      )..fields.addAll(sendData);
    final data = await request.send()
      .then(
        (response) {
          log('[ApiStream._fetchJsonFromUrl] response: ', response);
          return response.stream.bytesToString().then((snapshot) { 
            final dataObj = json.decode(snapshot);
            log('[ApiStream._fetchJsonFromUrl] dataObj: ', dataObj);
            final Map data = dataObj['data'] as Map;
            log('[ApiStream._fetchJsonFromUrl] data: ', data);
            final List dataList = [];
            for (final key in data.keys) {
              dataList.add(data[key]);
            }
            log('[ApiStream._fetchJsonFromUrl] dataList: ', dataList);
            //TODO ApiStream error handling to be implemented
            return dataList;
          });
      })
      .catchError((e) {
        log('[ApiStream._fetchJsonFromUrl] error: ', e);
        //TODO ApiStream Error handling to be implemented
        throw Exception(e);
      });
    yield data;
  }  
