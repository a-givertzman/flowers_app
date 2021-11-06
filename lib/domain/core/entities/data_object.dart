import 'package:flowers_app/domain/core/entities/convert.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

abstract class IDataObject<K,V> {
  Map<String, dynamic> _map = {};
  bool valid();
  IDataObject();
  IDataObject.fromRow();
  fetch();
  V? operator [](Object? key);
  void operator []=(dynamic key, dynamic value);
}

class DataObject implements IDataObject {
  bool _valid = true;
  DataSet? remote;
  @override
  Map<String, dynamic> _map = {};

  DataObject fromRow(Map<dynamic, dynamic> r) {
    _valid = true;
    final convert = const Convert().toPresentation;
    try {
      // for (var i = 0; i < r.length; i++) {
      for (var key in r.keys) {
        this['$key'] = convert(r[key]);
      }
    } catch (e) {
      final classInst = this.runtimeType.toString();
      print('Ошибка при конвертации в классе $classInst:\n$e');
      _valid = false;
    }
    return this;
  }

  DataObject({this.remote});

  operator [](Object? key) {
    if (_map.containsKey(key)) {
      return _map[key];
    } else {
      final classInst = this.runtimeType.toString();
      throw UnimplementedError('В объекте {$classInst} нет свойства $key');
      // TODO: Implement not defined field
    }
  }
  @override
  void operator []=(key, value) {
    _map[key] = value;
  }
  @override
  Future<dynamic> fetch({params}) async {
    if (remote != null) {
      return await remote!
        .fetch(params: params)
        .then(
          (sqlMap) {
            for (var i = 0; i < sqlMap.length; i++) {
              this['$i'] = sqlMap[i];
            }
            return this;
          }
        ).catchError((e) {
          final classInst = this.runtimeType.toString();
          throw Exception((message) =>
            'Ошибка в методе fetch класса $classInst:\n$message\n$e'
          );
        });  
    } else {
      final classInst = this.runtimeType.toString();
      throw Exception((message) =>
        'Ошибка, remote is NULL в методе fetch класса $classInst:\n$message'
      );
    }
  }

  @override
  bool valid() {
    // TODO: implement valid
    return _valid;
  }
}