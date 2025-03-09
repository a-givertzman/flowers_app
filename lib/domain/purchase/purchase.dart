import 'package:ext_rw/ext_rw.dart';
import 'package:flower_app/settings/setting.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
typedef PurchaseId = String;
typedef PurchaseSqlAccess = SqlAccess<Map<String, dynamic>, PurchaseId>;
///
/// Purchase record
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
  final PurchaseSqlAccess _remote;
  bool _valid = false;
  ///
  /// Purchase record
  Purchase({
    required this.id, 
    PurchaseSqlAccess?  remote,
  }) : _remote = remote ?? _sqlAccess();
  ///
  /// Returns Purchase parsed from database row Map<String, dynamic>
  Purchase.fromRow(Map<String, dynamic> row): _remote = _sqlAccess() {
    _fromRow(row);
  }
  ///
  ///
  static PurchaseSqlAccess _sqlAccess() {
    return SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, id) {
        return Sql(sql: "select * from purchase where id = $id;");
      },
      entryBuilder: (row) => row,
    );    
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
  /// Returns Purchase by it database ID
  Future<Result<Purchase, Failure>> fetch(String id) {
    return _remote.fetch(params: id).then(
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
  }
}
