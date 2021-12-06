import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/core/entities/value_object.dart';
import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

abstract class IDataObject {
  bool valid();
  IDataObject();
  DataSet get remote;
  dynamic fetch();
  ValueObject operator [](String key);
  void operator []=(String key, ValueObject value);
  IDataObject fromRow(Map<String, String> row);
}

class DataObject implements IDataObject {
  final Map<String, ValueObject> _map = {};
  final DataSet _remote;
  bool _valid = true;
  
  DataObject({
    required DataSet remote,
  }): _remote = remote;

  @override
  DataSet get remote => _remote;
  @override
  ValueObject operator [](String key) {
    if (_map.containsKey(key)) {
      final value = _map[key];
      if (value != null) {
        return value;
      }
    }
    throw Failure.dataObject(
      message: 'Ошибка в методе $runtimeType.operator [] нет свойства $key или оно null',
      stackTrace: StackTrace.current,
    );
  }
  void toDomain(String key, String value) {
    final valueObj = _map[key];
    if (valueObj != null) {
      valueObj.toDomain(value);
    }
  }
  @override
  void operator []=(String key, ValueObject value) {
    _map[key] = value;
  }
  @override
  Future<DataObject> fetch({Map params = const {}}) async {
    return _remote
      .fetchWith(params: params)
      .then(
        (response) {
          if (response.data().isNotEmpty) {
            final Map<String, dynamic> sqlMap = response.data();
            final sqlMapEntry = sqlMap.entries.first;
            final row = sqlMapEntry.value as Map<String, dynamic>;
            fromRow(row);
          }
          return this;
        }
      ).onError((error, stackTrace) {
        throw Failure.dataObject(
          message: 'Ошибка в методе fetch класса $runtimeType:\n$error',
          stackTrace: stackTrace,
        );
      });  
  }
  @override
  bool valid() {
    // TODO: implement valid
    return _valid;
  }
  @override
  DataObject fromRow(Map<String, dynamic> row) {
    _valid = true;
    try {
      row.forEach((key, value) {
        if (value != null) {
          toDomain(key, value as String);
        }
      });
    } catch (error) {
      log('Ошибка в методе $runtimeType.fromRow() \n$error');
      _valid = false;
      // throw Failure.dataObject(
      //   message: 'Ошибка в методе $classInst.parse() ${e.toString()}'
      // );
    }
    return this;
  }
}
