import 'package:ext_rw/ext_rw.dart';
import 'package:flower_app/domain/purchase/purchase_set_order.dart';
import 'package:flower_app/domain/purchase/purchase_status.dart';
import 'package:flower_app/presentation/core/dialogs/complete_dialog.dart';
import 'package:flower_app/presentation/core/dialogs/failure_dialog.dart';
import 'package:flower_app/settings/setting.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
/// Container provides SQL query parameters for the [OrderSqlAccess]
class OrderSqlParams {
  /// customer_order.id
  final String? id;
  /// customer_order.customerId
  final String? customerId;
  /// customer_order.purchase_item_id
  final String? purchaseItemId;
  /// customer_order.count
  final String? count;
  const OrderSqlParams({
    this.id,
    this.customerId,
    this.purchaseItemId,
    this.count,
  });
  //
  @override
  String toString() {
    return 'OrderSqlParams { customer_order.id: $id, customer_order.customerId: $customerId, customer_order.purchase_item_id: $purchaseItemId, count: $count }';
  }
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
  late String customerId = '';
  late String productId = '';
  late String productGroup = '';
  late String productName = '';
  late String productPicture = '';
  /// количество единиц товара в заказе пользователя 
  late int count = 0;
  late String cost = '';                           // сколько оплатил
  late String paid = '';                           // сколько оплатил
  late String toRefounded = '';                   // сколько денег клиенту нужно вернуть
  late String refounded = '';                      // сколько денег клиенту вернули
  late String distributed = '';                    // сколько товара получил
  late String description = '';
  late String purchaseId = '';
  late String purchaseName = '';
  late String purchaseDetails = '';
  late String purchaseItemId = '';
  late String purchaseItemSalePrice = '';    // цена за единицу
  late String purchaseItemSaleCurrency = ''; // валюта
  late String purchaseItemShipping = '';      // доставка за единицу
  late PurchaseStatus purchaseItemStatus = PurchaseStatus.notCampled();        // статус позиции
  late String created = '';
  late String updated = '';
  late String deleted = '';
  late OrderSqlAccess _remote;
  bool _valid = false;
  ///
  ///
  Order({
    this.id = '',
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
        if (params?.customerId != null && params?.purchaseItemId != null) {
          _log.debug(".sqlBuilder | Selecting by customer_id: ${params?.customerId} and purchase_item_id: ${params?.purchaseItemId}");
          return Sql(sql: """
            SELECT cord.id,
              cord.customer_id,
              cord.purchase_item_id,
              cord.count,
              cord.paid,
              cord.distributed,
              cord.to_refound,
              cord.refounded,
              cord.description,
              cord.created,
              cord.updated,
              cord.deleted,
              cu.name AS customer,
              p.name AS product,
              pu.name AS purchase
            FROM customer_order cord
              JOIN customer cu ON cord.customer_id = cu.id
              JOIN purchase_item puc ON cord.purchase_item_id = puc.id
              JOIN purchase pu ON puc.purchase_id = pu.id
              JOIN product p ON puc.product_id = p.id
            where cord.customer_id = ${params?.customerId} 
            and cord.purchase_item_id = ${params?.purchaseItemId};
          """,);
        }
        final selfId = (params?.id != null)
          ? params?.id
          : id;
        _log.debug(".sqlBuilder | Selecting by order id: $selfId");
        return Sql(sql: """
          SELECT cord.id,
            cord.customer_id,
            cord.purchase_item_id,
            cord.count,
            cord.paid,
            cord.distributed,
            cord.to_refound,
            cord.refounded,
            cord.description,
            cord.created,
            cord.updated,
            cord.deleted,
            cu.name AS customer,
            p.name AS product,
            pu.name AS purchase
          FROM customer_order cord
            JOIN customer cu ON cord.customer_id = cu.id
            JOIN purchase_item puc ON cord.purchase_item_id = puc.id
            JOIN purchase pu ON puc.purchase_id = pu.id
            JOIN product p ON puc.product_id = p.id
          where cord.id = $selfId; 
        """,);
      },
      entryBuilder: (row) {
        return row;
      },
    );
  }
  ///
  /// Returns [count] as Ok(int) if parsed else Err()
  int _parseInt(String value) {
    final count = int.tryParse(value);
    if (count != null) {
      return count;
    }
    _log.warning(".parseInt | Error parsing '$value'");
    return 0;
  }
  ///
  /// Returns Cost as double
  double getCost() => double.parse(cost);
  ///
  /// Returns Shipping as double
  double getShipping() => double.parse(purchaseItemShipping) * count;
  ///
  /// Removing order from the database
  Future<Result<Map<String, dynamic>, Failure>> remove(BuildContext context) {
    _log.debug('Order.remove | loading...');
    // final product = PurchaseItem(
    //   userId: customer_id,
    //   purchaseItemId: purchase_item_id,
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
  /// Returns Order parsed from database row `Map<String, dynamic>`
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
      customerId = '${row['customer_id']}';
      productId = '${row['product_id']}';
      productGroup = '${row['product_group']}';
      productName = '${row['product_name']}';
      productPicture = '${row['product_picture']}';
      count = _parseInt('${row['count']}');
      cost = '${row['cost']}';                                  // сколько оплатил
      paid = '${row['paid']}';                                  // сколько оплатил
      toRefounded = '${row['to_refounded']}';                  // сколько денег клиенту нужно вернуть
      refounded = '${row['refounded']}';                        // сколько денег клиенту вернули
      distributed = '${row['distributed']}';                    // сколько товара получил
      description = '${row['description']}';
      purchaseId = '${row['purchase_id']}';
      purchaseName = '${row['purchase_name']}';
      purchaseDetails = '${row['purchase_details']}';
      purchaseItemId = '${row['purchase_item_id']}';
      purchaseItemSalePrice = '${row['purchase_item_sale_price']}';        // цена за единицу
      purchaseItemSaleCurrency = '${row['purchase_item_sale_currency']}';  // валюта
      purchaseItemShipping = '${row['purchase_item_shipping']}';            // доставка за единицу
      purchaseItemStatus = PurchaseStatus(status: '${row['purchase_item_status']}');                // статус позиции
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
  Future<Result<Order, Failure>> fetch({OrderSqlParams? params}) {
    return _remote.fetch(params: params).then(
      (result) {
        switch (result) {
          case Ok(:final value):
            _log.debug('.fetch | result: $value');
            if (value.isNotEmpty) {
              final row = value.first;
              return _fromRow(row);
            } else {
              _valid = false;
              return Err(Failure(message: 'Order.fetch | Error: Order by params: $params is not found', stackTrace: StackTrace.current));
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
      customerId: customerId,
    ).send('$count', purchaseItemId);
  }
}
