import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/infrastructure/api/response.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

class PurchaseGetOrdered extends DataObject {
  final String id;
  final String _userId;

  PurchaseGetOrdered({
    required this.id, 
    required String userId,
    required DataSet<Map<String, dynamic>> remote,
  }) : 
    _userId = userId,
    super(remote: remote);
  Future<Response<Map<String, dynamic>>> get(
    String purchaseId,
    String purchaseContentId, 
  ) async {
    return remote.fetchWith(
      params: {
        'purchase/id': purchaseId,
        'client/id': _userId,
        'purchase_content/id': purchaseContentId,
      },
    )
      .then((response) {
        log('[PurchaseGetOrder.sendOrder] response: ', response);
        return response;
      });
  }
}
