// ignore_for_file: no_runtimetype_tostring

import 'dart:async';

import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/infrastructure/api/response.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Класс реализует список загрузку списка элементов
/// 
/// Бедет создан с id  и удаленным источником данных
/// при вызове метода fetch будет читать записи из источника
/// и формировать из каждой записи экземпляр класса PurchaseProduct
class DataCollection<T> {
  final DataSet<Map<String, dynamic>> remote;
  final _streamController = StreamController<List<T>>();
  final DataObject Function(Map<String, dynamic>) dataMaper;

  Stream<List<T>> get dataStream {
    _streamController.onListen = _dispatch;
    return  _streamController.stream;
  }

  DataCollection({
    required this.remote,
    required this.dataMaper,
  });

  Future<void> refresh() {
    return _dispatch();
  }

  Future<void> _dispatch() {
    log('[$runtimeType($DataCollection)._dispatch]');
    // _streamController.sink.add(List.empty());
    return fetch()
      .then(
        (data) {
          final List<T> _data = [];
          for (final element in data) { 
            _data.add(element);
          }
          _streamController.sink.add(_data);
        }
      )
      .catchError((e) {
        log('[$runtimeType($DataCollection)._dispatch handleError]', e);
        _streamController.addError(e as Object);
      });
  }
  Future<List<T>> fetchWith({required Map<String, dynamic> params}) {
    log('[$runtimeType($DataCollection).fetchWith]');
    return remote
      .fetchWith(params: params)
      .then((response) => _fetchOnSuccess(response))
      .onError((error, stackTrace) => _fetchOnFailure(error, stackTrace));  
  }
  Future<List<T>> fetch() {
    log('[$runtimeType($DataCollection).fetch]');
    return remote
      .fetch()
      .then((response) => _fetchOnSuccess(response))
      .onError((error, stackTrace) => _fetchOnFailure(error, stackTrace));  
  }
  List<T> _fetchOnSuccess(Response<Map<String, dynamic>> response) {
    if (response.hasError()) {
      throw Failure(
        message: response.errorMessage(),
        stackTrace: StackTrace.empty,
      );
    }
    final sqlList = response.data();
    final List<T> list = [];
    sqlList.forEach((key, row) {
      final p = dataMaper(row as Map<String, dynamic>) as T;
      list.add(p);
    });
    // for (final row in sqlList) {
    //   final p = dataMaper(row);
    //   list.add(p);
    // }
    return list;
  }
  Future<List<T>> _fetchOnFailure(Object? error, StackTrace stackTrace) {
    throw Failure.dataCollection(
      message: 'Ошибка в методе fetchWith класса $runtimeType($DataCollection):\n$error',
      stackTrace: stackTrace,
    );
  }
}
