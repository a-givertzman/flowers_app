import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/infrastructure/api/responce.dart';

class PurchaseOrder extends DataObject {
  final String id;
  final String _userId;

  PurchaseOrder({
    required this.id, 
    required userId,
    required remote,
  }) : 
    _userId = userId,
    super(remote: remote);
  Future<Response> sendOrder(int count, String purchaseContentId, String productId, String purchaseId) async {
    final keys = [
      'id',
      'purchase/id',
      'client/id',
      'purchase_content/id',
      'product/id'
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
    return remote.fetchWith(
      params: {
        'keys': keys,
        'data': data,
        // 'where': [{'operator': 'where', 'field': 'client/id', 'cond': '=', 'value': clientId}]
      }
    )
      .then((response) {
        print('[PurchaseOrder.sendOrder] response');
        print(response);
        return response;
      });
  }
}
