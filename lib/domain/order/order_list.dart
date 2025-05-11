import 'package:ext_rw/ext_rw.dart';
import 'package:flower_app/domain/order/order.dart';
import 'package:flower_app/settings/setting.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
typedef OrderListSqlAccess = SqlAccess<Map<String, dynamic>, OrderListSqlParams>;
///
/// Container provides SQL query parameters for the [OrderListSqlAccess]
class OrderListSqlParams {
  /// customer_order.id
  final String? id;
  /// customer_order.customerId
  final String? customerId;
  /// customer_order.purchase_item_id
  final String? purchaseItemId;
  /// customer_order.count
  final String? count;
  ///
  /// Container provides SQL query parameters for the [OrderListSqlAccess]
  const OrderListSqlParams({
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
/// Класс реализует список элементов Order для OrderOverviewBody
/// Список заказов для отображения в личном кабинете 
class OrderList {
  static const _log = Log('OrderList');
  final OrderListSqlParams? params;
  final OrderListSqlAccess _remote;
  final Map<String, Order> _orders = {};
  ///
  /// Список заказов для отображения в личном кабинете 
  OrderList({
    this.params,
    OrderListSqlAccess? remote,
  }):
    _remote = remote ?? SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, params) {
        // return Sql(sql: "select * from customer_order_view;");
        if (params?.customerId != null) {
          return Sql(sql: """
            select 
              cord.id,
              cord.customer_id,
              cu.name as customer,
              cord.purchase_item_id,
              cord.count,
              cord.count * (pui.sale_price + pui.shipping) as cost,
              pui.shipping as shipping,
              cord.paid,
              cord.distributed,
              cord.to_refound,
              cord.refounded,
              cord.description,
              cord.created,
              cord.updated,
              cord.deleted,
              pui.status as status,
              pui.product as product,
              pui.sale_currency as currency,
              p.category as product_category,
              pui.picture as product_picture,
              pu.name as purchase
            from public.customer_order cord
              JOIN public.customer cu ON cord.customer_id = cu.id
              JOIN public.purchase_item_view pui ON cord.purchase_item_id = pui.id
              JOIN public.purchase pu ON pui.purchase_id = pu.id
              JOIN public.product_view p ON pui.product_id = p.id
            where cord.customer_id = ${params?.customerId};
          """);
        }
        return Sql(sql: """
          select 
            cord.id,
            cord.customer_id,
            cu.name as customer,
            cord.purchase_item_id,
            cord.count,
            cord.count * (pui.sale_price + pui.shipping) as cost,
            pui.shipping as shipping,
            cord.paid,
            cord.distributed,
            cord.to_refound,
            cord.refounded,
            cord.description,
            cord.created,
            cord.updated,
            cord.deleted,
            pui.status as status,
            pui.product as product,
            pui.sale_currency as currency,
            p.category as product_category,
            pui.picture as product_picture,
            pu.name as purchase
          from public.customer_order cord
            JOIN public.customer cu ON cord.customer_id = cu.id
            JOIN public.purchase_item_view pui ON cord.purchase_item_id = pui.id
            JOIN public.purchase pu ON pui.purchase_id = pu.id
            JOIN public.product_view p ON pui.product_id = p.id;
        """);
      },
      entryBuilder: (row) {
        return row;
      },
    );
  ///
  /// Returns Order's as map
  Future<Result<Map<String, Order>, Failure>> refresh() => fetch();
  ///
  /// Returns Order's as map
  Future<Result<Map<String, Order>, Failure>> fetch({OrderListSqlParams? params}) {
    _orders.clear();
    return _remote.fetch(params: params ?? this.params).then(
      (result) {
        switch (result) {
          case Ok(value :final result):
            _log.debug('.fetch | result: $result');
            if (result.isNotEmpty) {
              for (final row in result) {
                final order = Order.fromRow(row);
                _orders.putIfAbsent(order.id, () => order);
              }
            }
              return Ok(_orders);
          case Err(:final error):
            _log.warning('.fetch | Error: $error');
            return Err(Failure(message: 'OrderList.fetch | Error: $error', stackTrace: StackTrace.current));
        }
      },
      onError: (err) {
        _log.warning('.fetch | Error: $err');
        return Err(Failure(message: 'OrderList.fetch | Error: $err', stackTrace: StackTrace.current));
      },
    );
  }
}
