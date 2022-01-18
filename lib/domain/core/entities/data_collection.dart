// ignore_for_file: no_runtimetype_tostring

import 'dart:async';

import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Класс реализует список загрузку списка элементов
/// 
/// Бедет создан с id  и удаленным источником данных
/// при вызове метода fetch будет читать записи из источника
/// и формировать из каждой записи экземпляр класса PurchaseProduct
class DataCollection<T> {
  // final String id;
  final DataSet<Map<String, dynamic>> remote;
  final _streamController = StreamController<List<T>>();
  final DataObject Function(Map<String, dynamic>) dataMaper;

  Stream<List<T>> get dataStream {
    _streamController.onListen = _dispatch;
    return  _streamController.stream;
  }

  DataCollection({
    // required this.id,
    required this.remote,
    required this.dataMaper,
  });

  Future refresh() async {
    _dispatch();
  }

  void _dispatch() {
    log('[$runtimeType($DataCollection)._dispatch]');
    // _streamController.sink.add(List.empty());
    fetch()
      .then(
        (data) {
          final List<T> _data = [];
          for (final element in data as List) { 
            _data.add(element as T);
          }
          _streamController.sink.add(_data);
        }
      )
      .catchError((e) {
        log('[$runtimeType($DataCollection)._dispatch handleError]', e);
        _streamController.addError(e as Object);
      });
  }
  Future<dynamic> fetch() async {
    log('[$runtimeType($DataCollection).fetch]');
    return remote
      .fetch()
      .then(
        (response) {
          if (response.hasError()) {
            return Failure(
              message: response.errorMessage(),
              stackTrace: StackTrace.empty,
            );
          }
          final sqlList = response.data();
          final List<dynamic> list = [];
          sqlList.forEach((key, row) {
            final p = dataMaper(row as Map<String, dynamic>);
            list.add(p);
          });
          // for (final row in sqlList) {
          //   final p = dataMaper(row);
          //   list.add(p);
          // }
          return list;
        }
      ).onError((error, stackTrace) {
        throw Failure.dataCollection(
          message: 'Ошибка в методе fetch класса $runtimeType($DataCollection):\n$error',
          stackTrace: stackTrace,
        );
      });  
  }
}
