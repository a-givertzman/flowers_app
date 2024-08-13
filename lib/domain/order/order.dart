import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/domain/purchase/purchase_set_order.dart';
import 'package:flowers_app/presentation/core/dialogs/complete_dialog.dart';
import 'package:flowers_app/presentation/core/dialogs/failure_dialog.dart';
import 'package:flowers_app/settings/setting.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
/// Container provides SQL query parameters for the [OrderSqlAccess]
class OrderSqlParams {
  final String? id;
  final String? purchaseId;
  final String? purchaseContentId;
  final String? productId;
  final String? count;
  const OrderSqlParams({
    this.id,
    this.purchaseId,
    this.purchaseContentId,
    this.productId,
    this.count,
  });
}
///
///
typedef OrderId = String;
typedef OrderSqlAccess = SqlAccess<Map<String, dynamic>, OrderSqlParams>;
///
/// Ксласс хранит в себе информацию о заказе
/// реализует 
///   - обновление заказа
///   - удаление заказа
class Order {
  static const _log = Log('Order');
  late String id = '';
  late String client_id = '';
  late String product_id = '';
  late String product_group = '';
  late String product_name = '';
  late String product_picture = '';
  late String count = '';
  late String cost = '';                           // сколько оплатил
  late String paid = '';                           // сколько оплатил
  late String refounded = '';                      // сколько денег клиенту врнули
  late String distributed = '';                    // сколько товара получил
  late String purchase_id = '';
  late String purchase_name = '';
  late String purchase_details = '';
  late String purchase_content_id = '';
  late String purchase_content_sale_price = '';    // цена за единицу
  late String purchase_content_sale_currency = ''; // валюта
  late String purchase_content_shipping = '';      // доставка за единицу
  late String purchase_content_status = '';        // статус позиции
  late String created = '';
  late String updated = '';
  late String deleted = '';
  late OrderSqlAccess _remote;
  bool _valid = false;
  ///
  ///
  Order({
    required this.id,
    OrderSqlAccess? remote,
  }) :
    _remote = remote ?? _sqlAccess(id);
  ///
  ///
  static OrderSqlAccess _sqlAccess(String id) {
    return SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, params) {
        return Sql(sql: "select * from order where id = $id;");
      },
      entryBuilder: (row) {
        return row;
      },
    );
  }
  ///
  /// Returns Cost as double
  double getCost() => double.parse(cost);
  ///
  /// Returns Shipping as double
  double getShipping() => double.parse(purchase_content_shipping) * double.parse(count);
  ///
  /// Removing order from the database
  Future<Result<Map<String, dynamic>, Failure>> remove(BuildContext context) {
    _log.debug('Order.remove | loading...');
    // final product = PurchaseProduct(
    //   userId: client_id,
    //   purchaseContentId: purchase_content_id,
    //   remote: dataSource.dataSet('purchase_product'),
    // );
    // product.product_id = this.product_id;
    // product.purchase_id = this.purchase_id;
    // product['product/name'] = this['product/name'];
    return removeOrder(
      context,
    );
  }
  ///
  /// Returns Order parsed from database row Map<String, dynamic>
  Order.fromRow(Map<String, dynamic> row) {
    _fromRow(row);
  }
  ///
  /// Returns true if all field of the Order is Ok
  bool get valid => _valid;
  ///
  ///
  Result<Order, Failure> _fromRow(Map<String, dynamic> row) {
    final rowId = row['id'];
    if (rowId == null) {
      _valid = false;
      return Err(Failure(message: 'Purchase._fromRow | Error: Purchase invalid "id" in row: $row', stackTrace: StackTrace.current));
    } else {
      if ('$rowId'.isEmpty) {
        _valid = false;
        return Err(Failure(message: 'Purchase._fromRow | Error: Purchase invalid "id" in row: $row', stackTrace: StackTrace.current));
      }
      id = '${row['id']}';
      client_id = '${row['client_id']}';
      product_id = '${row['product_id']}';
      product_group = '${row['product_group']}';
      product_name = '${row['product_name']}';
      product_picture = '${row['product_picture']}';
      count = '${row['count']}';
      cost = '${row['cost']}';                           // сколько оплатил
      paid = '${row['paid']}';                           // сколько оплатил
      refounded = '${row['refounded']}';                      // сколько денег клиенту врнули
      distributed = '${row['distributed']}';                    // сколько товара получил
      purchase_id = '${row['purchase_id']}';
      purchase_name = '${row['purchase_name']}';
      purchase_details = '${row['purchase_details']}';
      purchase_content_id = '${row['purchase_content_id']}';
      purchase_content_sale_price = '${row['purchase_content_sale_price']}';    // цена за единицу
      purchase_content_sale_currency = '${row['purchase_content_sale_currency']}'; // валюта
      purchase_content_shipping = '${row['purchase_content_shipping']}';      // доставка за единицу
      purchase_content_status = '${row['purchase_content_status']}';        // статус позиции
      created = '${row['created']}';
      updated = '${row['updated']}';
      deleted = '${row['deleted']}';
      _remote = _sqlAccess(id);
      _valid = true;
      return Ok(this);
    }    
  }
  ///
  /// Returns Order by it database ID
  Future<Result<Order, Failure>> fetch(String id) {
    return _remote.fetch(params: OrderSqlParams(id: id)).then(
      (result) {
        switch (result) {
          case Ok(:final value):
            _log.debug('.fetch | result: $value');
            if (value.isNotEmpty) {
              final row = value.first;
              return _fromRow(row);
            } else {
              _valid = false;
              return Err(Failure(message: 'Order.fetch | Error: Order with id=$id is not found', stackTrace: StackTrace.current));
            }
          case Err(:final error):
            _log.warning('.fetch | Error: $error');
            _valid = false;
            return Err(Failure(message: 'Order.fetch | Error: $error', stackTrace: StackTrace.current));
        }
      },
      onError: (err) {
        _log.warning('.fetch | Error: $err');
        _valid = false;
        return Err(Failure(message: 'Order.fetch | Error: $err', stackTrace: StackTrace.current));
      },
    );
  }  
  ///
  ///
  Future<Result<Map<String, dynamic>, Failure>> sendOrder(
    BuildContext context, 
    int count,
  ) {
    return _sendOrder(
      context,
      count: count,
      successMessage: 'Заказ успешно отправлен организаторам, вы можете скорректировать его в личном кабинете в любое время до блокировки закупки.',
      errorMessage: 'В процессе размещение заказа возникла ошибка',
    );
  }
  ///
  ///
  Future<Result<Map<String, dynamic>, Failure>> removeOrder(
    BuildContext context, 
  ) {
    return _sendOrder(
      context,
      count: 0,
      successMessage: 'Заказ успешно удален.',
      errorMessage: 'В процессе удаления заказа возникла ошибка',
    );
  }
  ///
  ///
  Future<Result<Map<String, dynamic>, Failure>> _sendOrder(
    BuildContext context, {
      required int count,
      required String successMessage,
      required String errorMessage,
  }) {
    _log.debug('Order._sendOrder | loading...');
    return setOrder(count: count)
      .then((result) {
        switch (result) {
          case Ok(value: final _):
            showCompleteDialog( 
              context,
              title: const Text('Готово'),
              content: Text(
                successMessage,
                maxLines: 20,
                overflow: TextOverflow.clip,
              ),
            );
          case Err(:final error):
            _log.debug('Order._sendOrder | response.error: $error');
            showFailureDialog( 
              context,
              title: const Text('Ошибка'),
              content: Text('''
    error: $error
    \nПроверьте интернет соединение или nопробуйте позже.
    \nПриносим извинения за неудобства.''',
                maxLines: 20,
                overflow: TextOverflow.clip,
              ),
            );
        }
        return result;
      });
  }
  ///
  ///
  Future<Result<Map<String, dynamic>, Failure>> setOrder({required int count}) {
    return PurchaseSetOrder(
      // id: '0',
      userId: client_id,
      // DataSet<Map<String, dynamic>>(
      //   params: ApiParams({
      //     'tableName': 'order',
      //   }),
      //   apiRequest: ApiRequest(
      //     url: (count <= 0)
      //       ? 'https://u1489690.isp.regruhosting.ru/remove-order'
      //       : 'https://u1489690.isp.regruhosting.ru/add-order',
      //   ),
      // ),
    ).send('$count', purchase_content_id, product_id, purchase_id);
  }
}
