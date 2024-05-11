import 'package:flowers_app/domain/order/order.dart';

class OrderHeader {
  late String purchaseId;
  late String purchaseName;
  late double _total;
  late double _totalShipping;
  OrderHeader({
    required Order order, 
    required double total,
    required double shipping,
  }) {
    purchaseId = '${order['purchase/id']}';
    purchaseName = '${order['purchase/name']}';
    _total = total;
    _totalShipping = shipping;
  }
  double get total => _total;
  double get totalPrice => _total - _totalShipping;
  double get totalShipping => _totalShipping;
  void addCost(double cost, double shipping) {
    _total += cost;
    _totalShipping += shipping;
  }
}
