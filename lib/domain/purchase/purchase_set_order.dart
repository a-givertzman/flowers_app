import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/domain/order/order.dart';
import 'package:flowers_app/settings/setting.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
class PurchaseSetOrder {
  static const _log = Log('PurchaseSetOrder');
  final OrderSqlAccess _remote;
  ///
  ///
  PurchaseSetOrder({
    required String customerId,
    OrderSqlAccess? remote,
  }) : 
    _remote = remote ?? SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, params) {
        return Sql(sql: 'select * from set_order($customerId, ${params?.purchaseContentId}, ${params?.count});');
      },
      entryBuilder: (row) {
        return row;
      },
    );
  ///
  /// Inserting the new Order or updating if already exists
  Future<Result<Map<String, dynamic>, Failure>> send(
    String count, 
    String purchaseContentId, 
  ) async {
    return _remote.fetch(
      params: OrderSqlParams(
        purchaseContentId: purchaseContentId,
        count: count,
      ),
    )
      .then((result) {
        _log.debug('PurchaseSetOrder.send | result: $result');
        switch (result) {
          case Ok<List<Map<String, dynamic>>, Failure>(:final value):
            return Ok(value.first);
          case Err<List<Map<String, dynamic>>, Failure>(: final error):
            return Err(Failure(message: 'PurchaseSetOrder.send | error: $error', stackTrace: StackTrace.current));
        }
      });
  }
}
