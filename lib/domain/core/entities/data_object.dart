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
  static const _debug = false;
  final Map<String, ValueObject> _map = {};
  final DataSet _remote;
  late bool isEmpty;
  bool _valid = true;
  DataObject({
    required DataSet remote,
  }):
    _remote = remote,
    isEmpty = false;
  /// Конструктор возвращает екземпляр класса 
  /// с пустым remote и без данных
  /// Поле empty = true
  DataObject.empty(): 
    _remote = DataSet.empty(),
    isEmpty = true;
  Map<String, ValueObject> asMap() => _map;
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
      message: "Ошибка в методе $runtimeType.operator [] нет свойства '$key' или оно null",
      stackTrace: StackTrace.current,
    );
  }
  void toDomain(String key, String value) {
    final valueObj = _map[key];
    if (valueObj != null) {
      valueObj.toDomain(value);
      _map[key] = valueObj.toDomain(value);
    }
  }
  @override
  void operator []=(String key, ValueObject value) {
    _map[key] = value;
  }
  @override
  Future<DataObject> fetch({Map<String, dynamic> params = const {}}) async {
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
        _valid = false;
        throw Failure.dataObject(
          message: 'Ошибка в методе fetch класса $runtimeType:\n$error',
          stackTrace: stackTrace,
        );
      });  
  }
  /// Возвращает true если объект был успешно прочитан из remote
  /// или успешно проинициализированн методом fromRow
  @override
  bool valid() {
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
      log(_debug, 'Ошибка в методе $runtimeType.fromRow() \n$error');
      _valid = false;
      // throw Failure.dataObject(
      //   message: 'Ошибка в методе $classInst.parse() ${e.toString()}'
      // );
    }
    return this;
  }
  @override
  String toString() {
    // ignore: no_runtimetype_tostring
    String str = '$runtimeType($DataObject) {';
    _map.forEach((key, value) {
      final _value = value.toString().isEmpty ? 'empty' : value;
      str += '\n\t$key: $_value,';
    });
    return '$str}';
  }
}
