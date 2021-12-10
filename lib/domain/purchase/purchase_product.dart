import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/domain/purchase/purchase_set_order.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/api/response.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Класс реализует данные продукта, 
/// будет являеться элементом списка в составе закупки
class PurchaseProduct extends DataObject{
  final String _userId;
  final String _purchaseContentId;

  PurchaseProduct({
    required String userId,
    required String purchaseContentId,
    required DataSet<Map<String, dynamic>> remote,
  }) : 
    _userId = userId, 
    _purchaseContentId = purchaseContentId, 
    super(remote: remote)
  {
    this['client/id'] = ValueString(_userId);
    this['purchase/id'] = ValueString('');
    this['product/id'] = ValueString('');
    this['product/name'] = ValueString('');
    this['product/detales'] = ValueString('');
    this['product/picture'] = ValueString('');
    this['product/description'] = ValueString('');
    this['sale_price'] = ValueString('');
    this['sale_currency'] = ValueString('');
    this['ordered_count'] = ValueString('');
    this['remains'] = ValueString('');
  }
  Future<Response<Map<String, dynamic>>> setOrder(int count) async {
    return PurchaseSetOrder(
      id: '0',
      userId: _userId,
      remote: DataSet<Map<String, dynamic>>(
        params: ApiParams({
          'tableName': 'order',
        }),
        apiRequest: const ApiRequest(
          url: 'https://u1489690.isp.regruhosting.ru/add-order',
        ),
      ),
    ).send(count, _purchaseContentId, '${this['product/id']}', '${this['purchase/id']}');
  }
  Future<DataObject> refresh() {
    return super.fetch(
      params: {
        'client/id': _userId,
        'purchase/id': '${this['purchase/id']}',
        'purchase_content/id': _purchaseContentId,
      },
    );
  }
}
