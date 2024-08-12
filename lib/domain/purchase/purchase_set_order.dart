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
  final String id;
  final String _userId;
  final OrderSqlAccess _remote;
  ///
  ///
  PurchaseSetOrder({
    required this.id, 
    required String userId,
    OrderSqlAccess? remote,
  }) : 
    _userId = userId,
    _remote = remote ?? SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, params) {
        return Sql(sql: """
          insert into order (id, purchase_id, client_id, purchase_content_id, product_id, count) 
            VALUES ($id, ${params?.purchaseId}, $userId, ${params?.purchaseContentId}, ${params?.productId})
            ON CONFLICT (id) DO UPDATE 
              SET count = ${params?.count};
        ;""",);
      },
      entryBuilder: (row) {
        return row;
      },
    );
  ///
  ///
  Future<Result<Map<String, dynamic>, Failure>> send(
    int count, 
    String purchaseContentId, 
    String productId, 
    String purchaseId,
  ) async {
    final keys = [
      'id',
      'purchase_id',
      'client_id',
      'purchase_content_id',
      'product_id',
      'count',
    ];
    final data = [{
      'id': id,
      'purchase/id': purchaseId,
      'client/id': _userId,
      'purchase_content/id': purchaseContentId,
      'product/id': productId,
      'count': count,
    }];
    return _remote.fetch(
      params: {
        'keys': keys,
        'data': data,
      },
    )
      .then((response) {
        _log.debug('[PurchaseSetOrder.sendOrder] response: $response');
        return response;
      });
  }
}
