import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/infrastructure/api/response.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/presentation/core/dialogs/complete_dialog.dart';
import 'package:flowers_app/presentation/core/dialogs/failure_dialog.dart';
import 'package:flutter/material.dart';

/// Ксласс хранит в себе информацию о заказе
/// реализует 
///   - обновление заказа
///   - удаление заказа
class Order extends DataObject{
  static const _debug = false;
  final String id;
  Order({
    required this.id, 
    required DataSet<Map>  remote,
  }) : super(remote: remote) {
    this['id'] = ValueString('');
    this['client/id'] = ValueString('');
    this['product/id'] = ValueString('');
    this['product/group'] = ValueString('');
    this['product/name'] = ValueString('');
    this['product/picture'] = ValueString('');
    this['count'] = ValueString('');
    this['cost'] = ValueString('');                           // сколько оплатил
    this['paid'] = ValueString('');                           // сколько оплатил
    this['refounded'] = ValueString('');                      // сколько денег клиенту врнули
    this['distributed'] = ValueString('');                    // сколько товара получил
    this['purchase/id'] = ValueString('');
    this['purchase/name'] = ValueString('');
    this['purchase/details'] = ValueString('');
    this['purchase_content/id'] = ValueString('');
    this['purchase_content/sale_price'] = ValueString('');    // цена за единицу
    this['purchase_content/sale_currency'] = ValueString(''); // валюта
    this['purchase_content/shipping'] = ValueString('');      // доставка за единицу
    this['created'] = ValueString('');
    this['updated'] = ValueString('');
    this['deleted'] = ValueString('');
  }
  double cost() => double.parse('${this['cost']}');
  double shipping() => double.parse('${this['purchase_content/shipping']}') * double.parse('${this['count']}');
  Future<Response<Map<String, dynamic>>> remove(BuildContext context) {
    log(_debug, '[$Order.remove] loading...');
    final product = PurchaseProduct(
      userId: '${this['client/id']}',
      purchaseContentId: '${this['purchase_content/id']}',
      remote: dataSource.dataSet('purchase_product'),
    );
    product['product/id'] = this['product/id'];
    product['purchase/id'] = this['purchase/id'];
    // product['product/name'] = this['product/name'];
    return removeOrder(
      context,
      product,
    );
  }
}
  Future<Response<Map<String, dynamic>>> sendOrder(
    BuildContext context, 
    PurchaseProduct product,  
    int count,
  ) {
    return _sendOrder(
      context,
      product,
      count: count,
      successMessage: 'Заказ успешно отправлен организаторам, вы можете скорректировать его в личном кабинете в любое время до блокировки закупки.',
      errorMessage: 'В процессе размещение заказа возникла ошибка',
    );
  }
  Future<Response<Map<String, dynamic>>> removeOrder(
    BuildContext context, 
    PurchaseProduct product,  
  ) {
    return _sendOrder(
      context,
      product,
      count: 0,
      successMessage: 'Заказ успешно удален.',
      errorMessage: 'В процессе удаления заказа возникла ошибка',
    );
  }
  Future<Response<Map<String, dynamic>>> _sendOrder(
    BuildContext context, 
    PurchaseProduct product,  
    {
      required int count,
      required String successMessage,
      required String errorMessage,
    } 
  ) {
    const _debug = false;
    log(_debug, '[ProductCard._sendOrder] loading...');
    return product.setOrder(count: count)
      .then((response) {
        if (response.hasError()) {
          log(_debug, '[ProductCard._sendOrder] response.error: ', response.errorMessage());
          showFailureDialog( 
            context,
            title: const Text('Ошибка'),
            content: Text('''
  $errorMessage: ${response.errorMessage()}
  \nПроверьте интернет соединение или nопробуйте позже.
  \nПриносим извинения за неудобства.''',
              maxLines: 20,
              overflow: TextOverflow.clip,
            ),
          );
        } else if (response.hasData()) {
          showCompleteDialog( 
            context,
            title: const Text('Готово'),
            content: Text(
              successMessage,
              maxLines: 20,
              overflow: TextOverflow.clip,
            ),
          );
        }
        return response;
      });
  }
