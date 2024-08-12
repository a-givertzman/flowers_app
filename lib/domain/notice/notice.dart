import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
typedef NoticeId = String;
typedef NoticeSqlAccess = SqlAccess<Map<String, dynamic>, NoticeId>;
///
/// Contains an information about the Notice message
class Notice {
  static const _log = Log('Notice');
  late String id = '';
  late String purchaseId = '';
  late String purchaseContentId = '';
  late String message = '';
  late String created = '';
  late String updated = '';
  late String deleted = '';  
  final NoticeSqlAccess? _remote;
  final Future<bool> _viewed;
  late bool _valid = false;
  ///
  ///
  Notice({
    required NoticeSqlAccess remote,
    required Future<bool> viewed,
  }) : 
    _viewed = viewed,
    _remote = remote;
  //
  //
  Notice.empty() :
    _viewed = Future.value(true),
    _remote = null;
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
      purchaseId = '${row['purchase_id']}';
      purchaseContentId = '${row['purchase_content_id']}';
      message = '${row['message']}';
      created = '${row['created']}';
      updated = '${row['updated']}';
      deleted = '${row['deleted']}';
      _valid = true;
      return Ok(this);
    }    
  }
  ///
  /// Returns Notice by it database ID
  Future<Result<Notice, Failure>> fetch(String id) {
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
                return Err(Failure(message: 'Notice.fetch | Error: Notice with id=$id is not found', stackTrace: StackTrace.current));
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
