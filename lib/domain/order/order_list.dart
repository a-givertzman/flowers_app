import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/domain/order/order.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
typedef OrderListSqlAccess = SqlAccess<Map<String, dynamic>, void>;
///
/// Класс реализует список элементов Order для OrderOverviewBody
/// Список заказов для отображения в личном кабинете 
class OrderList {
  static const _log = Log('OrderList');
  final OrderListSqlAccess _remote;
  final Map<String, Order> _orders = {};
  ///
  /// Список заказов для отображения в личном кабинете 
  OrderList({
    required OrderListSqlAccess remote,
  }):
    _remote = remote;
  
  ///
  /// Returns Order's as map
  Future<Result<Map<String, Order>, Failure>> refresh() => fetch();
  ///
  /// Returns Order's as map
  Future<Result<Map<String, Order>, Failure>> fetch() {
    _orders.clear();
    return _remote.fetch().then(
      (result) {
        switch (result) {
          case Ok(value :final result):
            _log.debug('.fetch | result: $result');
            if (result.isNotEmpty) {
              for (final row in result) {
                final purchase = Order.fromRow(row);
                _orders.putIfAbsent(purchase.id, () => purchase);
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
