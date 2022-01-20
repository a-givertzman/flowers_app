import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Ксласс хранит в себе информацию о заказе
/// реализует 
///   - обновление заказа
///   - удаление заказа
class Order extends DataObject{
  // bool _valid = true;
  final String id;

  Order({
    required this.id, 
    required DataSet<Map>  remote,
  }) : super(remote: remote) {
    this['id'] = ValueString('');
    this['client/id'] = ValueString('');
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
  Future<void> remove() {
    return fetch(params: {
      
    },);
  }
  // bool valid() {
  //   //TODO Purchase valid method to be implemented
  //   return _valid;
  // }
}
