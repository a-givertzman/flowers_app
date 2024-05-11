import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/infrastructure/api/response.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

class PurchaseSetOrder extends DataObject {
  static const _debug = false;
  final String id;
  final String _userId;

  PurchaseSetOrder({
    required this.id, 
    required String userId,
    required DataSet<Map<String, dynamic>> remote,
  }) : 
    _userId = userId,
    super(remote: remote);
  Future<Response<Map<String, dynamic>>> send(
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
    return remote.fetchWith(
      params: {
        'keys': keys,
        'data': data,
      },
    )
      .then((response) {
        log(_debug, '[PurchaseSetOrder.sendOrder] response: ', response);
        return response;
      });
  }
}
