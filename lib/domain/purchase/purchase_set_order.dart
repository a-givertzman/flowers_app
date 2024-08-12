import 'package:flowers_app/domain/order/order.dart';
import 'package:flowers_app/infrastructure/api/response.dart';
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
    required OrderSqlAccess remote,
  }) : 
    _userId = userId,
    _remote = remote;
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
      'purchase/id',
      'client/id',
      'purchase_content/id',
      'product/id',
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
