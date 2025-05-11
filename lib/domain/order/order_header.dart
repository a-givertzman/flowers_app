import 'package:flower_app/domain/order/order.dart';

///
///
class OrderHeader {
  late String purchaseId;
  late String purchaseName;
  late double _total;
  late double _totalShipping;
  final String currency;
  ///
  ///
  OrderHeader({
    required Order order, 
    required double total,
    required double shipping,
  }) :
    purchaseId = order.purchaseId,
    purchaseName = order.purchase,
    _total = total,
    _totalShipping = shipping,
    currency = order.currency;
  ///
  ///
  double get total => _total;
  ///
  ///
  double get totalPrice => _total - _totalShipping;
  ///
  ///
  double get totalShipping => _totalShipping;
  ///
  /// Adding [cost] and [shipping] to the totals
  void addCost(double cost, double shipping) {
    _total += cost;
    _totalShipping += shipping;
  }
}
