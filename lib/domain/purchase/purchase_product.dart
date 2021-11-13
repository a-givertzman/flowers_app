import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/api/responce.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Класс реализует данные продукта, 
/// будет являеться элементом списка в составе закупки
class PurchaseProduct extends DataObject{
  // late String purchaseId;
  final String id;
  final String _userId;

  PurchaseProduct({
    required this.id,
    required userId,
    required remote,
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
  Future refresh() async {
    // _dispatch();
  }
  Future<Response> sendOrder(int count) async {
    return PurchaseOrder(
      id: '0',
      userId: _userId,
      remote: DataSet(
        params: ApiParams({
          'tableName': 'order',
        }),
        apiRequest: const ApiRequest(
          url: 'https://u1489690.isp.regruhosting.ru/set-data',
        ),
      ),
    ).sendOrder(count, id, '${this['product/id']}', '${this['purchase/id']}');
  }
}

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
        print(response);
        return response;
      });
      // .catchError((e) {
      //   final classInst = runtimeType.toString();
      //   throw Exception(
      //     'Ошибка в методе sendOrder класса $classInst:\n$e'
      //   );
      // });  
  }
}