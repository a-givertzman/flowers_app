import 'package:ext_rw/ext_rw.dart';
import 'package:flower_app/domain/purchase/purchase_item.dart';
import 'package:flower_app/settings/setting.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class PurchaseContentSqlParams {
  final String? customerId;
  final String? purchaseId;
  final String? purchaseItemId;
  PurchaseContentSqlParams({
    this.customerId,
    this.purchaseId,
    this.purchaseItemId,
  });
}
///
///
typedef PurchaseContentSqlAccess = SqlAccess<Map<String, dynamic>, PurchaseContentSqlParams>;
///
/// Класс реализует список элементов PurchaseItem
/// список позиций в составе закупки для каталога
class PurchaseContent {
  static const _log = Log('PurchaseContent');
  final PurchaseContentSqlAccess _remote;
  final String _purchaseId;
  final Map<String, PurchaseItem> _products = {};
  ///
  ///
  PurchaseContent({
    required String purchaseId,
    PurchaseContentSqlAccess? remote,
  }): 
    _purchaseId = purchaseId,
    _remote = remote ?? SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, params) {
        return Sql(sql: 'select * from purchase_item_view where purchase_id = ${params?.purchaseId};');
      },
      entryBuilder: (row) {
        return row;
      },
    );
  ///
  /// Returns PurchaseItem's as map
  Future<Result<Map<String, PurchaseItem>, Failure>> refresh() => fetch();
  ///
  /// Returns PurchaseItem's as map
  Future<Result<Map<String, PurchaseItem>, Failure>> fetch() {
    _products.clear();
    return _remote.fetch(params: PurchaseContentSqlParams(purchaseId: _purchaseId)).then(
      (result) {
        switch (result) {
          case Ok(value :final result):
            _log.debug('.fetch | result: $result');
            if (result.isNotEmpty) {
              for (final row in result) {
                final product = PurchaseItem.fromRow(row);
                _products.putIfAbsent(product.id, () => product);
              }
            }
              return Ok(_products);
          case Err(:final error):
            _log.warning('.fetch | Error: $error');
            return Err(Failure(message: 'OrderList.fetch | Error: $error', stackTrace: StackTrace.current));
        }
      },
      onError: (err) {
        _log.warning('.fetch | Error: $err');
        return Err(Failure(message: 'OrderList.fetch | Error: $err', stackTrace: StackTrace.current));
      },
    );
  }
}
