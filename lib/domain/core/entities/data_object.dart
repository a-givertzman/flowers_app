import 'package:flowers_app/domain/core/entities/convert.dart_';
import 'package:flowers_app/domain/core/entities/value_object.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

abstract class IDataObject<K, V> {
  // late Map<String, V> _map;
  bool valid();
  IDataObject();
  IDataObject.fromRow();
  fetch();
  V? operator [](Object? key);
  void operator []=(K key, V value);
}

class DataObject implements IDataObject {
  bool _valid = true;
  DataSet remote;
  @override
  Map<String, ValueObject> _map = {};

  DataObject fromRow(Map<dynamic, dynamic> r) {
    _valid = true;
    final convert = const Convert().toPresentation;
    try {
      // for (var i = 0; i < r.length; i++) {
      for (var key in r.keys) {
        // this['$key'] = convert(r[key]);
        toDomain(key, r[key]);
      }
    } catch (e) {
      final classInst = runtimeType.toString();
      print('Ошибка при конвертации в классе $classInst:\n$e');
      _valid = false;
    }
    return this;
  }

  DataObject({required this.remote});

  operator [](Object? key) {
    if (_map.containsKey(key)) {
      return _map[key];
    } else {
      final classInst = runtimeType.toString();
      throw UnimplementedError('В объекте {$classInst} нет свойства $key');
      // TODO: Implement not defined field
    }
  }
  void toDomain(key, value) {
    _map[key]?.toDomain(value);
  }
  @override
  void operator []=(key, value) {
    _map[key] = value;
  }
  @override
  Future<dynamic> fetch({params}) async {
    return await remote
      .fetchWith(params: params)
      .then(
        (response) {
          final sqlMap = response.data();
          for (var i = 0; i < sqlMap.length; i++) {
            this['$i'] = sqlMap[i];
          }
          return this;
        }
      ).catchError((e) {
        final classInst = runtimeType.toString();
        throw Exception(
          'Ошибка в методе fetch класса $classInst:\n$e'
        );
      });  
  }

  @override
  bool valid() {
    // TODO: implement valid
    return _valid;
  }
}