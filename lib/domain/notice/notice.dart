import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/settings/setting.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class NoticeSqlParams {
  final String? id;
  final String? customerId;
  final String? purchaseId;
  final String? purchaseItemId;
  ///
  ///
  NoticeSqlParams({
    this.id,
    this.customerId,
    this.purchaseId,
    this.purchaseItemId,
  });
}
///
///
typedef NoticeSqlAccess = SqlAccess<Map<String, dynamic>, NoticeSqlParams>;
///
/// Contains an information about the Notice message
/// - [customerId] - Author of the [Notice]
/// - [purchaseId] - If notice refers to the whole Purchase, not to exact position
/// - [purchaseItemId] - If notice refers to single position of the Purchase, purchase_id - not required
/// - [title] - Title of the notice
/// - [body] - Text of the notice
class Notice {
  static const _log = Log('Notice');
  late String id = '';
  late String customerId = '';
  late String purchaseId = '';
  late String purchaseItemId = '';
  late String title = '';
  late String body = '';
  late String created = '';
  late String updated = '';
  late String deleted = '';  
  final NoticeSqlAccess? _remote;
  final Future<bool> _viewed;
  late bool _valid = false;
  ///
  ///
  Notice({
    NoticeSqlAccess? remote,
    required Future<bool> viewed,
  }) : 
    _viewed = viewed,
    _remote = remote ?? SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, params) {
        if (params?.id != null) {
          return Sql(sql: "select * from notice where id = ${params?.id};");
        } else if (params?.customerId != null && params?.purchaseId != null) {
          return Sql(sql: "select * from notice where customer_id = ${params?.customerId} and purchase_id = ${params?.purchaseId};");
        } else if (params?.customerId != null && params?.purchaseItemId != null) {
          return Sql(sql: "select * from notice where customer_id = ${params?.customerId} and purchase_item_id = ${params?.purchaseItemId};");
        } else if (params?.purchaseId != null) {
          return Sql(sql: "select * from notice where purchase_id = ${params?.purchaseId};");
        } else if (params?.purchaseItemId != null) {
          return Sql(sql: "select * from notice where purchase_item_id = ${params?.purchaseItemId};");
        }
        return Sql(sql: "select * from notice where id = ${params?.id};");
      },
      entryBuilder: (row) {
        return row;
      },
    );
  //
  //
  Notice.empty() :
    _viewed = Future.value(true),
    _remote = null;
  ///
  /// Returns true if [title] and [body] are empty
  bool get isEmpty => title.isEmpty && body.isEmpty;
  ///
  /// Returns true if Notice already viewed by the current user
  Future<bool> viewed() => _viewed;
  ///
  /// Returns true if notice sent by current user
  bool isSent() => false;
  ///
  /// Returns true if all field of the Purchase is Ok
  bool get isValid => _valid;
  ///
  /// Returns Notice parsed from database row Map<String, dynamic>
  Notice.fromRow(Map<String, dynamic> row):
    _viewed = Future.value(true),
    _remote = null
  {
    _fromRow(row);
  }
  ///
  ///
  Result<Notice, Failure> _fromRow(Map<String, dynamic> row) {
    final rowId = row['id'];
    if (rowId == null) {
      _valid = false;
      return Err(Failure(message: 'Notice._fromRow | Error: Notice invalid "id" in row: $row', stackTrace: StackTrace.current));
    } else {
      if ('$rowId'.isEmpty) {
        _valid = false;
        return Err(Failure(message: 'Notice._fromRow | Error: Notice invalid "id" in row: $row', stackTrace: StackTrace.current));
      }
      id = '${row['id']}';
      customerId = '${row['customer_id']}';
      purchaseId = '${row['purchase_id']}';
      purchaseItemId = '${row['purchase_item_id']}';
      title = '${row['title']}';
      body = '${row['body']}';
      created = '${row['created']}';
      updated = '${row['updated']}';
      deleted = '${row['deleted']}';
      _valid = true;
      return Ok(this);
    }    
  }
  ///
  /// Returns Notice by it database ID
  Future<Result<Notice, Failure>> fetch(NoticeSqlParams params) {
    final remote = _remote;
    if (remote != null) {
      return remote.fetch(params: params).then(
        (result) {
          switch (result) {
            case Ok(:final value):
              _log.debug('.fetch | result: $value');
              if (value.isNotEmpty) {
                final row = value.first;
                return _fromRow(row);
              } else {
                _valid = false;
                return Err(Failure(message: 'Notice.fetch | Error with params: $params', stackTrace: StackTrace.current));
              }
            case Err(:final error):
              _log.warning('.fetch | Error: $error');
              _valid = false;
              return Err(Failure(message: 'Notice.fetch | Error: $error', stackTrace: StackTrace.current));
          }
        },
        onError: (err) {
          _log.warning('.fetch | Error: $err');
          _valid = false;
          return Err(Failure(message: 'Notice.fetch | Error: $err', stackTrace: StackTrace.current));
        },
      );
    } else {
      _valid = false;
      return Future.value(Err(Failure(message: 'Notice.fetch | Error: _remote is not initilized', stackTrace: StackTrace.current)));
    }
  }  
}
