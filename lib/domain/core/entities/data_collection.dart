import 'dart:async';

import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/responce.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Класс реализует список загрузку списка элементов
/// 
/// Бедет создан с id  и удаленным источником данных
/// при вызове метода fetch будет читать записи из источника
/// и формировать из каждой записи экземпляр класса PurchaseProduct
class DataCollection {
  final String id;
  final DataSet remote;
  final _streamController = StreamController<List<dynamic>>();
  final Function(dynamic) dataMaper;

  Stream<List<dynamic>> get dataStream {
    _streamController.onListen = _dispatch;
    return  _streamController.stream;
  }

  DataCollection({
    required this.id,
    required this.remote,
    required this.dataMaper,
  });

  Future refresh() async {
    _dispatch();
  }

  void _dispatch() async {
    print('[PurchaseContent._dispatch]');
    _streamController.sink.add(List.empty());
    fetch()
      .then(
        (data) {
          _streamController.sink.add(data);
        }
      )
      .catchError((e) {
        print('[PurchaseContent._dispatch handleError]');
        print(e);
        _streamController.addError(e);
      });
  }
  Future<dynamic> fetch() async {
    // _params = params;
    // print('params:');
    // print(_params);
    return await remote
      .fetch()
      .then(
        (response) {
          final sqlMap = response.data();
          List<dynamic> list = [];
          for (var key in sqlMap.keys) {
            final r = sqlMap[key];
            final p = dataMaper(r);
            // this['$i'] = p;
            list.add(p);
          }
          return list;
        }
      ).catchError((e) {
        final classInst = runtimeType.toString();
        throw Exception(
          'Ошибка в методе fetch класса $classInst:\n$e'
        );
      });  
  }
}
