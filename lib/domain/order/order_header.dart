import 'package:flowers_app/domain/order/order.dart';

class OrderHeader {
  late String purchaseId;
  late String purchaseName;
  late double _total;
  OrderHeader({
    required Order order, 
    required double total,
  }) {
    purchaseId = '${order['purchase/id']}';
    purchaseName = '${order['purchase/name']}';
    _total = total;
  }
  double get total => _total;
  void addCost(double cost) {
    _total += cost;
  }
}
