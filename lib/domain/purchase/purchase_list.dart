import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/settings/setting.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
typedef PurchaseListSqlAccess = SqlAccess<Map<String, dynamic>, void>;
///
/// Класс реализует список элементов Purchase для PurchaseOverview
/// Список закупок для отображения в катологе 
class PurchaseList {
  static const _log = Log('PurchaseList');
  final PurchaseListSqlAccess _remote;
  final Map<String, Purchase> _purchases = {};
  ///
  ///
  PurchaseList({
    PurchaseListSqlAccess? remote,
  }):
    _remote = remote ?? SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, _) {
        return Sql(sql: "select * from purchase;");
      },
      entryBuilder: (row) => row,
    );
  ///
  /// Returns Purchase's as map
  Future<Result<Map<String, Purchase>, Failure>> fetch() {
    _purchases.clear();
    return _remote.fetch().then(
      (result) {
        switch (result) {
          case Ok(value :final result):
            _log.debug('.fetch | result: $result');
            if (result.isNotEmpty) {
              for (final row in result) {
                final purchase = Purchase.fromRow(row);
                _purchases.putIfAbsent(purchase.id, () => purchase);
              }
            }
              return Ok(_purchases);
          case Err(:final error):
            _log.warning('.fetch | Error: $error');
            return Err(Failure(message: 'PurchaseList.fetch | Error: $error', stackTrace: StackTrace.current));
        }
      },
      onError: (err) {
        _log.warning('.fetch | Error: $err');
        return Err(Failure(message: 'PurchaseList.fetch | Error: $err', stackTrace: StackTrace.current));
      },
    );
  }
}
