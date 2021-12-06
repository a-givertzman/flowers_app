import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/domain/purchase/purchase_order.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/api/response.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Класс реализует данные продукта, 
/// будет являеться элементом списка в составе закупки
class PurchaseProduct extends DataObject{
  final String id;
  final String _userId;

  PurchaseProduct({
    required this.id,
    required String userId,
    required DataSet<Map> remote,
  }) : 
    _userId = userId, 
    super(remote: remote) 
  {
    this['purchase/id'] = ValueString('');
    this['product/id'] = ValueString('');
    this['product/name'] = ValueString('');
    this['product/detales'] = ValueString('');
    this['product/picture'] = ValueString('');
    this['product/description'] = ValueString('');
    this['sale_price'] = ValueString('');
    this['sale_currency'] = ValueString('');
    this['remains'] = ValueString('');
  }
  Future<Response<Map>> sendOrder(int count) async {
    return PurchaseOrder(
      id: '0',
      userId: _userId,
      remote: DataSet<Map>(
        params: ApiParams({
          'tableName': 'order',
        }),
        apiRequest: const ApiRequest(
          url: 'https://u1489690.isp.regruhosting.ru/add-order',
        ),
      ),
    ).sendOrder(count, id, '${this['product/id']}', '${this['purchase/id']}');
  }
}
