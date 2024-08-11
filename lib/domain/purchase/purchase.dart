import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
typedef PurchaseId = String;
typedef PurchaseSqlAccess = SqlAccess<Map<String, dynamic>, PurchaseId>;
///
///
class Purchase {
  static const _log = Log('Purchase');
  late String id = '';
  late String status = '';
  late String name = '';
  late String details = '';
  late String preview = '';
  late String description = '';
  late String picture = '';
  late String dateOfStart = '';
  late String dateOfEnd = '';
  late String created = '';
  late String updated = '';
  late String deleted = '';
  final PurchaseSqlAccess? _remote;
  bool _valid = false;
  ///
  ///
  Purchase({
    required this.id, 
    required PurchaseSqlAccess  remote,
  }) : _remote = remote {
    id = '';
    status = '';
    name = '';
    details = '';
    preview = '';
    description = '';
    picture = '';
    dateOfStart = '';
    dateOfEnd = '';
    created = '';
    updated = '';
    deleted = '';
  }
  ///
  ///
  Purchase.fromRow(Map<String, dynamic> row): _remote = null {
    _fromRow(row);
  }
  ///
  /// Returns true if all field of the Purchase is Ok
  bool get valid => _valid;
  ///
  ///
  Result<Purchase, Failure> _fromRow(Map<String, dynamic> row) {
    final rowId = row['id'];
    if (rowId == null) {
      _valid = false;
      return Err(Failure(message: 'Purchase._fromRow | Error: Purchase invalid "id" in row: $row', stackTrace: StackTrace.current));
    } else {
      if ('$rowId'.isEmpty) {
        _valid = false;
        return Err(Failure(message: 'Purchase._fromRow | Error: Purchase invalid "id" in row: $row', stackTrace: StackTrace.current));
      }
      id = '${row['id']}';
      status = '${row['status']}';
      name = '${row['name']}';
      details = '${row['details']}';
      preview = '${row['preview']}';
      description = '${row['description']}';
      picture = '${row['picture']}';
      dateOfStart = '${row['dateOfStart']}';
      dateOfEnd = '${row['dateOfEnd']}';
      created = '${row['created']}';
      updated = '${row['updated']}';
      deleted = '${row['deleted']}';
      _valid = true;
      return Ok(this);
    }    
  }
  ///
  ///
  Future<Result<Purchase, Failure>> fetch(String id) {
    final remote = _remote;
    if (remote != null) {
      return remote.fetch(params: id).then(
        (result) {
          switch (result) {
            case Ok(:final value):
              _log.debug('.fetch | result: $value');
              if (value.isNotEmpty) {
                final row = value.first;
                return _fromRow(row);
              } else {
                _valid = false;
                return Err(Failure(message: 'Purchase.fetch | Error: Purchase with id=$id is not found', stackTrace: StackTrace.current));
              }
            case Err(:final error):
              _log.warning('.fetch | Error: $error');
              _valid = false;
              return Err(Failure(message: 'Purchase.fetch | Error: $error', stackTrace: StackTrace.current));
          }
        },
        onError: (err) {
          _log.warning('.fetch | Error: $err');
          _valid = false;
          return Err(Failure(message: 'Purchase.fetch | Error: $err', stackTrace: StackTrace.current));
        },
      );
    } else {
      _valid = false;
      return Future.value(Err(Failure(message: 'Purchase.fetch | Error: _remote is not initilized', stackTrace: StackTrace.current)));
    }
  }
}
